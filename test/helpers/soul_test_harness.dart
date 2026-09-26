import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_app/app/app.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/config/app_environment.dart';
import 'package:soul_app/core/design_system/soul_theme.dart';
import 'package:soul_app/data/api/api_client.dart';
import 'package:soul_app/l10n/app_localizations.dart';

import 'fake_soul_backend.dart';

export 'fake_soul_backend.dart';

/// Smallest supported phone used for overflow checks.
const smallPhone = Size(320, 568);

/// Representative modern phone.
const standardPhone = Size(390, 844);

/// Preferences of a returning user; pair with [FakeSoulBackend.signedIn].
Map<String, Object> onboardedPreferences(SoulLocale locale) => {
  'selected_locale': locale.name,
};

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
/// preferences, phone size, text scale and device locales. [backend] fakes
/// SoulApi; its stored credentials seed the mocked secure storage, so a
/// [FakeSoulBackend.signedIn] backend restores a session on start.
Future<SharedPreferences> pumpSoulApp(
  WidgetTester tester, {
  Map<String, Object> preferences = const {},
  FakeSoulBackend? backend,
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
  final api = backend ?? FakeSoulBackend();
  FlutterSecureStorage.setMockInitialValues({...api.storedCredentials});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        preferencesProvider.overrideWithValue(prefs),
        dioProvider.overrideWithValue(fakeDio(api)),
      ],
      child: SoulApp(configuration: AppConfiguration.fromDartDefines()),
    ),
  );
  await tester.pumpAndSettle();
  return prefs;
}
