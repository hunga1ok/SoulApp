import 'package:drift/native.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/data/local/soul_database.dart';
import 'package:soul_app/data/repositories/journey_repository.dart';
import 'package:soul_app/data/repositories/reminder_repository.dart';

import '../helpers/soul_test_harness.dart';

void main() {
  group('JourneyRepository', () {
    test('starts Day 1 on the local date and is idempotent', () async {
      final database = testDatabase();
      final repository = JourneyRepository(
        database,
        now: () => DateTime(2026, 9, 26, 23, 30),
      );

      final first = await repository.startJourney(
        locale: SoulLocale.vi,
        timezone: testTimezone,
      );
      final second = await repository.startJourney(
        locale: SoulLocale.en,
        timezone: 'UTC',
      );

      expect(second.id, first.id);
      expect(first.startedOn, '2026-09-26');
      expect(first.locale, 'vi');
      expect(await database.select(database.userJourneys).get(), hasLength(1));
    });

    test('the database allows only one active run per journey', () async {
      final database = testDatabase();
      final run = await JourneyRepository(
        database,
      ).startJourney(locale: SoulLocale.en, timezone: testTimezone);

      await expectLater(
        database
            .into(database.userJourneys)
            .insert(run.copyWith(id: 'second-active-run')),
        throwsA(isA<SqliteException>()),
      );
      await database
          .into(database.userJourneys)
          .insert(run.copyWith(id: 'restarted-run', status: 'restarted'));
      expect(await database.select(database.userJourneys).get(), hasLength(2));
    });
  });

  group('ReminderRepository', () {
    test('returns the prototype defaults before anything is saved', () async {
      final choices = await ReminderRepository(testDatabase()).load();

      expect(
        choices[ReminderKind.morning]!.time,
        const TimeOfDay(hour: 7, minute: 0),
      );
      expect(
        choices[ReminderKind.evening]!.time,
        const TimeOfDay(hour: 21, minute: 30),
      );
    });

    test('saving again replaces the previous choice', () async {
      final repository = ReminderRepository(testDatabase());
      await repository.save(defaultReminders, timezone: testTimezone);
      await repository.save({
        ReminderKind.morning: const ReminderChoice(
          enabled: false,
          time: TimeOfDay(hour: 6, minute: 15),
        ),
        ReminderKind.evening: defaultReminders[ReminderKind.evening]!,
      }, timezone: testTimezone);

      final choices = await repository.load();
      expect(choices[ReminderKind.morning]!.enabled, isFalse);
      expect(
        choices[ReminderKind.morning]!.time,
        const TimeOfDay(hour: 6, minute: 15),
      );
      expect(choices[ReminderKind.evening]!.enabled, isTrue);
    });

    test('an enabled reminder must have a time', () async {
      final database = testDatabase();

      await expectLater(
        database
            .into(database.reminderPreferences)
            .insert(
              ReminderPreferencesCompanion.insert(
                kind: 'morning',
                enabled: true,
                timezone: testTimezone,
                updatedAt: DateTime(2026, 9, 26),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });
  });
}
