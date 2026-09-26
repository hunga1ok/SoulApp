import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/data/local/soul_database.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../../helpers/soul_test_harness.dart';

Map<String, Object> _afterName(SoulLocale locale) => {
  'selected_locale': locale.name,
  'preferred_name': 'An',
};

void main() {
  const cases = [
    (
      locale: SoulLocale.vi,
      title: 'Điều gì đưa bạn đến đây?',
      intention: 'Nuôi dưỡng lòng biết ơn',
      chooseOne: 'Chọn ít nhất một điều nhé.',
      next: 'Tiếp tục',
      evening: 'Buổi tối',
      ready: 'Hành trình 28 ngày đã sẵn sàng.',
      begin: 'Bắt đầu Ngày 1',
      welcome: 'Chào An',
    ),
    (
      locale: SoulLocale.en,
      title: 'What brings you here today?',
      intention: 'Nurture gratitude',
      chooseOne: 'Choose at least one.',
      next: 'Continue',
      evening: 'Evening',
      ready: 'Your 28-day journey is ready.',
      begin: 'Begin Day 1',
      welcome: 'Welcome, An',
    ),
  ];

  for (final c in cases) {
    testWidgets('${c.locale.name}: intention, reminders and journey start '
        'lead to Today and are saved on the device', (tester) async {
      final database = testDatabase();
      final permissions = FakeNotificationPermissions();
      final prefs = await pumpSoulApp(
        tester,
        preferences: _afterName(c.locale),
        database: database,
        permissions: permissions,
      );

      // Intention: at least one is required.
      expect(find.text(c.title), findsOneWidget);
      expect(find.text(c.chooseOne), findsOneWidget);
      expect(
        tester
            .widget<SoulButton>(find.widgetWithText(SoulButton, c.next))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text(c.intention));
      await tester.pump();
      expect(find.text(c.chooseOne), findsNothing);
      await tester.tap(find.text(c.next));
      await tester.pumpAndSettle();
      expect(prefs.getStringList('onboarding_intentions'), [
        'NURTURE_GRATITUDE',
      ]);

      // Reminders: turn the evening one off, keep the morning default.
      expect(find.byType(ReminderScreen), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.ancestor(
            of: find.text(c.evening),
            matching: find.byType(Row),
          ),
          matching: find.byType(Switch),
        ),
      );
      await tester.pump();
      await tester.tap(find.text(c.next));
      await tester.pumpAndSettle();

      final reminders =
          await database.select(database.reminderPreferences).get();
      final byKind = {for (final row in reminders) row.kind: row};
      expect(byKind['morning']!.enabled, isTrue);
      expect(byKind['morning']!.minuteOfDay, 7 * 60);
      expect(byKind['evening']!.enabled, isFalse);
      expect(byKind['morning']!.timezone, testTimezone);
      expect(permissions.requests, 1);

      // Journey ready: Day 1 starts and onboarding never shows again.
      expect(find.text(c.ready), findsOneWidget);
      await tester.tap(find.text(c.begin));
      await tester.pumpAndSettle();

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.text(c.welcome), findsOneWidget);
      expect(prefs.getBool('onboarding_completed'), isTrue);
      final journeys = await database.select(database.userJourneys).get();
      expect(journeys, hasLength(1));
      expect(journeys.single.status, 'active');
      expect(journeys.single.locale, c.locale.name);
      expect(journeys.single.timezone, testTimezone);
    });
  }

  testWidgets('skipping reminders saves them off and never asks for '
      'permission', (tester) async {
    final database = testDatabase();
    final permissions = FakeNotificationPermissions();
    await pumpSoulApp(
      tester,
      preferences: {
        ..._afterName(SoulLocale.en),
        'onboarding_intentions': ['FIND_PEACE'],
      },
      database: database,
      permissions: permissions,
    );

    await tester.tap(find.text('Skip for now'));
    await tester.pumpAndSettle();

    final reminders = await database.select(database.reminderPreferences).get();
    expect(reminders, hasLength(2));
    expect(reminders.every((row) => !row.enabled), isTrue);
    expect(permissions.requests, 0);
    expect(find.byType(JourneyReadyScreen), findsOneWidget);
  });

  testWidgets('a denied permission does not block onboarding', (tester) async {
    await pumpSoulApp(
      tester,
      preferences: {
        ..._afterName(SoulLocale.en),
        'onboarding_intentions': ['FIND_PEACE'],
      },
      permissions: FakeNotificationPermissions(granted: false),
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(JourneyReadyScreen), findsOneWidget);
  });

  testWidgets('a relaunch without intentions resumes at the intention '
      'step', (tester) async {
    await pumpSoulApp(tester, preferences: _afterName(SoulLocale.en));

    expect(find.byType(IntentionScreen), findsOneWidget);
  });

  testWidgets('a relaunch after the reminder step resumes at journey ready', (
    tester,
  ) async {
    await pumpSoulApp(
      tester,
      preferences: {
        ..._afterName(SoulLocale.en),
        'onboarding_intentions': ['FIND_PEACE'],
        'onboarding_reminders_decided': true,
      },
    );

    expect(find.byType(JourneyReadyScreen), findsOneWidget);
  });

  testWidgets('a relaunch after the journey started but before onboarding '
      'was marked complete does not start a second run', (tester) async {
    final database = testDatabase();
    final preferences = {
      ..._afterName(SoulLocale.en),
      'onboarding_intentions': ['FIND_PEACE'],
      'onboarding_reminders_decided': true,
    };
    await database
        .into(database.userJourneys)
        .insert(
          UserJourneyRow(
            id: 'existing-run',
            journeyCode: 'GRATITUDE_28',
            locale: 'en',
            status: 'active',
            startedOn: '2026-09-25',
            timezone: testTimezone,
            createdAt: DateTime(2026, 9, 25),
            updatedAt: DateTime(2026, 9, 25),
          ),
        );
    await pumpSoulApp(tester, preferences: preferences, database: database);

    await tester.tap(find.text('Begin Day 1'));
    await tester.pumpAndSettle();

    expect(find.byType(TodayScreen), findsOneWidget);
    final journeys = await database.select(database.userJourneys).get();
    expect(journeys.single.id, 'existing-run');
  });

  final steps = {
    'intention': _afterName(SoulLocale.vi),
    'reminders': {
      ..._afterName(SoulLocale.vi),
      'onboarding_intentions': ['FIND_PEACE'],
    },
    'journey ready': {
      ..._afterName(SoulLocale.vi),
      'onboarding_intentions': ['FIND_PEACE'],
      'onboarding_reminders_decided': true,
    },
  };
  for (final MapEntry(key: step, value: preferences) in steps.entries) {
    testWidgets('$step step does not overflow at 200% text on a small phone', (
      tester,
    ) async {
      await pumpSoulApp(
        tester,
        preferences: preferences,
        size: smallPhone,
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
