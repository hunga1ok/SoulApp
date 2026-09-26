import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/localization/soul_locale.dart';
import '../local/soul_database.dart';

/// Stable code of the 28-day gratitude journey in the content bundle.
const gratitudeJourneyCode = 'GRATITUDE_28';

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  return JourneyRepository(ref.watch(soulDatabaseProvider));
});

class JourneyRepository {
  JourneyRepository(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final SoulDatabase _database;
  final DateTime Function() _now;

  Future<UserJourneyRow?> activeJourney() {
    return (_database.select(_database.userJourneys)..where(
      (row) =>
          row.journeyCode.equals(gratitudeJourneyCode) &
          row.status.equals('active'),
    )).getSingleOrNull();
  }

  /// Starts Day 1 today, or returns the run that is already active, so a
  /// repeated tap or a relaunch never creates a second run.
  Future<UserJourneyRow> startJourney({
    required SoulLocale locale,
    required String timezone,
  }) {
    return _database.transaction(() async {
      final existing = await activeJourney();
      if (existing != null) return existing;

      final now = _now();
      final row = UserJourneyRow(
        id: const Uuid().v4(),
        journeyCode: gratitudeJourneyCode,
        locale: locale.name,
        status: 'active',
        startedOn: _localDate(now),
        timezone: timezone,
        createdAt: now,
        updatedAt: now,
      );
      await _database.into(_database.userJourneys).insert(row);
      return row;
    });
  }

  static String _localDate(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${time.year}-${two(time.month)}-${two(time.day)}';
  }
}
