// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:soul_app/data/local/soul_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = SoulDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v1 to v2 keeps journeys and reminders', () async {
    const journeyV1 = v1.UserJourneysData(
      id: 'run-1',
      journeyCode: 'GRATITUDE_28',
      locale: 'vi',
      status: 'active',
      startedOn: '2026-09-26',
      timezone: 'Asia/Ho_Chi_Minh',
      createdAt: 1790000000,
      updatedAt: 1790000000,
    );
    const reminderV1 = v1.ReminderPreferencesData(
      kind: 'morning',
      enabled: 1,
      minuteOfDay: 420,
      timezone: 'Asia/Ho_Chi_Minh',
      updatedAt: 1790000000,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: SoulDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.userJourneys, [journeyV1]);
        batch.insertAll(oldDb.reminderPreferences, [reminderV1]);
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.userJourneys).get(), [
          v2.UserJourneysData.fromJson(journeyV1.toJson()),
        ]);
        expect(await newDb.select(newDb.reminderPreferences).get(), [
          v2.ReminderPreferencesData.fromJson(reminderV1.toJson()),
        ]);
        expect(await newDb.select(newDb.visions).get(), isEmpty);
      },
    );
  });

  test(
    'migration from v2 to v3 keeps all data and adds gratitude_entries',
    () async {
      const journeyV2 = v2.UserJourneysData(
        id: 'run-1',
        journeyCode: 'GRATITUDE_28',
        locale: 'vi',
        status: 'active',
        startedOn: '2026-09-26',
        timezone: 'Asia/Ho_Chi_Minh',
        createdAt: 1790000000,
        updatedAt: 1790000000,
      );
      const reminderV2 = v2.ReminderPreferencesData(
        kind: 'morning',
        enabled: 1,
        minuteOfDay: 420,
        timezone: 'Asia/Ho_Chi_Minh',
        updatedAt: 1790000000,
      );
      const visionV2 = v2.VisionsData(
        id: 'vis-1',
        categoryCode: 'LOVE',
        statement: 'I attract loving relationships.',
        locale: 'en',
        status: 'active',
        createdAt: 1790000000,
        updatedAt: 1790000000,
      );

      await verifier.testWithDataIntegrity(
        oldVersion: 2,
        newVersion: 3,
        createOld: v2.DatabaseAtV2.new,
        createNew: v3.DatabaseAtV3.new,
        openTestedDatabase: SoulDatabase.new,
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.userJourneys, [journeyV2]);
          batch.insertAll(oldDb.reminderPreferences, [reminderV2]);
          batch.insertAll(oldDb.visions, [visionV2]);
        },
        validateItems: (newDb) async {
          expect(await newDb.select(newDb.userJourneys).get(), [
            v3.UserJourneysData.fromJson(journeyV2.toJson()),
          ]);
          expect(await newDb.select(newDb.reminderPreferences).get(), [
            v3.ReminderPreferencesData.fromJson(reminderV2.toJson()),
          ]);
          expect(await newDb.select(newDb.visions).get(), [
            v3.VisionsData.fromJson(visionV2.toJson()),
          ]);
          expect(await newDb.select(newDb.gratitudeEntries).get(), isEmpty);
        },
      );
    },
  );
}
