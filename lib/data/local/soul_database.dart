import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'soul_database.g.dart';

/// On-device database for private user data. Tables are sync-ready:
/// client-generated UUIDs, timestamps and status changes instead of hard
/// deletes, mirroring `docs/data-backend-spec.md`.
@DriftDatabase(tables: [UserJourneys, ReminderPreferences])
class SoulDatabase extends _$SoulDatabase {
  SoulDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'soul'));

  @override
  int get schemaVersion => 1;
}

final soulDatabaseProvider = Provider<SoulDatabase>((ref) {
  final database = SoulDatabase();
  ref.onDispose(database.close);
  return database;
});

/// One run of a journey. Restarting keeps the previous run as history, so at
/// most one run per journey is `active`.
@DataClassName('UserJourneyRow')
@TableIndex.sql(
  "CREATE UNIQUE INDEX user_journeys_one_active "
  "ON user_journeys (journey_code) WHERE status = 'active'",
)
class UserJourneys extends Table {
  TextColumn get id => text()();
  TextColumn get journeyCode => text()();
  TextColumn get locale => text()();

  /// `active`, `completed` or `restarted`.
  TextColumn get status => text()();

  /// Local calendar date (`yyyy-MM-dd`) of Day 1 in [timezone].
  TextColumn get startedOn => text()();

  /// IANA timezone the run was started in.
  TextColumn get timezone => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Reminder choice per kind. Times are wall-clock minutes in [timezone].
@DataClassName('ReminderPreferenceRow')
class ReminderPreferences extends Table {
  /// `morning` or `evening`.
  TextColumn get kind => text()();
  BoolColumn get enabled => boolean()();

  /// Minutes after local midnight; required while [enabled].
  IntColumn get minuteOfDay => integer().nullable()();
  TextColumn get timezone => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {kind};

  @override
  List<String> get customConstraints => [
    'CHECK (NOT enabled OR minute_of_day IS NOT NULL)',
  ];
}
