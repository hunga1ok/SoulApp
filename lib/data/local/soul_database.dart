import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'soul_database.steps.dart';

part 'soul_database.g.dart';

/// On-device database for private user data. Tables are sync-ready:
/// client-generated UUIDs, timestamps and status changes instead of hard
/// deletes, mirroring `docs/data-backend-spec.md`.
@DriftDatabase(
  tables: [
    UserJourneys,
    ReminderPreferences,
    Visions,
    VisionFeelings,
    VisionAnswers,
  ],
)
class SoulDatabase extends _$SoulDatabase {
  SoulDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'soul'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.createTable(schema.visions);
        await m.createTable(schema.visionFeelings);
        await m.createTable(schema.visionAnswers);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
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

/// A user's Vision. Archiving keeps the row; nothing is hard-deleted.
@DataClassName('VisionRow')
class Visions extends Table {
  TextColumn get id => text()();
  TextColumn get categoryCode => text()();
  TextColumn get statement => text().withLength(min: 1, max: 500)();

  /// Image path relative to the app support directory.
  TextColumn get imagePath => text().nullable()();

  /// Locale of the statement and answers when written.
  TextColumn get locale => text()();

  /// `active` or `archived`.
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One to three feelings per Vision, in the order the user chose them.
@DataClassName('VisionFeelingRow')
class VisionFeelings extends Table {
  TextColumn get visionId =>
      text().references(Visions, #id, onDelete: KeyAction.cascade)();
  TextColumn get feelingCode => text()();
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {visionId, feelingCode};

  @override
  List<Set<Column>> get uniqueKeys => [
    {visionId, position},
  ];

  @override
  List<String> get customConstraints => ['CHECK (position BETWEEN 1 AND 3)'];
}

/// Answer to a guided question: chosen suggestion codes and/or own text.
@DataClassName('VisionAnswerRow')
class VisionAnswers extends Table {
  TextColumn get visionId =>
      text().references(Visions, #id, onDelete: KeyAction.cascade)();
  TextColumn get questionCode => text()();

  /// JSON array of suggested-answer value codes.
  TextColumn get valueCodes => text()();
  TextColumn get customText => text().nullable()();

  @override
  Set<Column> get primaryKey => {visionId, questionCode};
}
