import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_app/app/app.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/soul_theme.dart';
import 'package:soul_app/core/platform/device_services.dart';
import 'package:soul_app/core/platform/image_picking.dart';
import 'package:soul_app/data/content/content_repository.dart';
import 'package:soul_app/data/local/image_store.dart';
import 'package:soul_app/data/local/soul_database.dart';
import 'package:soul_app/data/repositories/reminder_repository.dart';
import 'package:soul_app/l10n/app_localizations.dart';

/// Smallest supported phone used for overflow checks.
const smallPhone = Size(320, 568);

/// Representative modern phone.
const standardPhone = Size(390, 844);

/// Preferences of a returning user who finished onboarding as "An".
Map<String, Object> onboardedPreferences(SoulLocale locale) => {
  'selected_locale': locale.name,
  'preferred_name': 'An',
  'onboarding_intentions': ['NURTURE_GRATITUDE'],
  'onboarding_reminders_decided': true,
  'onboarding_completed': true,
  'subscription_plan': 'yearly',
};

const testTimezone = 'Asia/Ho_Chi_Minh';

class FakeDeviceTimezone implements DeviceTimezone {
  const FakeDeviceTimezone();

  @override
  Future<String> current() async => testTimezone;
}

/// Records permission requests and answers with [granted].
class FakeNotificationPermissions implements NotificationPermissions {
  FakeNotificationPermissions({this.granted = true});

  bool granted;
  var requests = 0;
  final samples = <({String title, String body, SoulLocale locale})>[];
  final scheduledLocales = <SoulLocale>[];

  @override
  Future<bool> request() async {
    requests++;
    return granted;
  }

  @override
  Future<bool> showSampleNotification({
    required String title,
    required String body,
    SoulLocale locale = SoulLocale.en,
  }) async {
    samples.add((title: title, body: body, locale: locale));
    return granted;
  }

  @override
  Future<void> scheduleDailyReminders({
    required Map<ReminderKind, ReminderChoice> choices,
    required SoulLocale locale,
    String? preferredName,
  }) async {
    scheduledLocales.add(locale);
  }
}

/// Returns [path] for every pick, or `null` as if the user cancelled.
class FakeImagePicking implements ImagePicking {
  FakeImagePicking([this.path]);

  String? path;
  final picks = <bool>[];

  @override
  Future<String?> pick({required bool fromCamera}) async {
    picks.add(fromCamera);
    return path;
  }
}

/// A fresh, uncached bundle per test (`rootBundle` caches futures across
/// tests) that decodes on the test's own zone: the default bundle decodes
/// large files in an isolate, which never completes under fake async.
class _TestAssetBundle extends PlatformAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      utf8.decode((await load(key)).buffer.asUint8List());
}

/// A fresh in-memory database, closed after the test.
SoulDatabase testDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final database = SoulDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  return database;
}

/// Configures the test view as a phone of [size] logical pixels with the
/// given text scale and device locales. Resets automatically after the test.
void configurePhone(
  WidgetTester tester, {
  Size size = standardPhone,
  double textScale = 1,
  List<Locale>? deviceLocales,
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  if (deviceLocales != null) {
    tester.platformDispatcher.localesTestValue = deviceLocales;
  }
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);
}

Future<SharedPreferences> _mockPreferences(Map<String, Object> values) {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

/// Pumps a single widget inside a Soul-themed, localized [MaterialApp] with a
/// [ProviderScope] backed by mocked [SharedPreferences].
Future<SharedPreferences> pumpSoulWidget(
  WidgetTester tester,
  Widget child, {
  SoulLocale locale = SoulLocale.en,
  Size size = standardPhone,
  double textScale = 1,
  Map<String, Object> preferences = const {},
  bool settle = true,
}) async {
  configurePhone(tester, size: size, textScale: textScale);
  final prefs = await _mockPreferences(preferences);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [preferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        theme: soulTheme,
        debugShowCheckedModeBanner: false,
        locale: Locale(locale.name),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      ),
    ),
  );
  // Endless animations (e.g. indeterminate progress) never settle.
  settle ? await tester.pumpAndSettle() : await tester.pump();
  return prefs;
}

/// Pumps the whole app (router, guards, shell) with the given stored
/// preferences, phone size, text scale and device locales. The database is
/// in memory and platform services are faked unless passed in.
Future<SharedPreferences> pumpSoulApp(
  WidgetTester tester, {
  Map<String, Object> preferences = const {},
  SoulDatabase? database,
  FakeNotificationPermissions? permissions,
  FakeImagePicking? imagePicking,
  ImageStore? imageStore,
  Size size = standardPhone,
  double textScale = 1,
  List<Locale> deviceLocales = const [Locale('en', 'US')],
}) async {
  configurePhone(
    tester,
    size: size,
    textScale: textScale,
    deviceLocales: deviceLocales,
  );
  final prefs = await _mockPreferences(preferences);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        preferencesProvider.overrideWithValue(prefs),
        soulDatabaseProvider.overrideWithValue(database ?? testDatabase()),
        contentRepositoryProvider.overrideWithValue(
          ContentRepository(_TestAssetBundle()),
        ),
        deviceTimezoneProvider.overrideWithValue(const FakeDeviceTimezone()),
        notificationPermissionsProvider.overrideWithValue(
          permissions ?? FakeNotificationPermissions(),
        ),
        imagePickingProvider.overrideWithValue(
          imagePicking ?? FakeImagePicking(),
        ),
        imageStoreProvider.overrideWithValue(
          imageStore ?? ImageStore(() async => Directory.systemTemp),
        ),
      ],
      child: const SoulApp(),
    ),
  );
  await tester.pumpAndSettle();
  return prefs;
}
