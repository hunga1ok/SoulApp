import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../local/soul_database.dart';

class GratitudeDraftItem {
  GratitudeDraftItem({
    this.gratitudeText = '',
    this.reasonText = '',
    this.thankYouTaps = 0,
  });

  String gratitudeText;
  String reasonText;
  int thankYouTaps;

  bool get isFilled => gratitudeText.trim().isNotEmpty;

  bool get isComplete => isFilled && thankYouTaps >= 1;
}

final gratitudeRepositoryProvider = Provider<GratitudeRepository>((ref) {
  return GratitudeRepository(ref.watch(soulDatabaseProvider));
});

final currentJourneyDayProvider = FutureProvider.autoDispose<int>((ref) async {
  return ref.watch(gratitudeRepositoryProvider).getCurrentJourneyDay();
});

final todayGratitudeEntriesProvider =
    FutureProvider.autoDispose<List<GratitudeEntryRow>>((ref) async {
      final repo = ref.watch(gratitudeRepositoryProvider);
      final currentDay = await ref.watch(currentJourneyDayProvider.future);
      return repo.getEntriesForDay(currentDay);
    });

final recentGratitudeEntriesProvider =
    FutureProvider.autoDispose<List<GratitudeEntryRow>>((ref) {
      return ref.watch(gratitudeRepositoryProvider).getRecentEntries();
    });

class GratitudeRepository {
  GratitudeRepository(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final SoulDatabase _database;
  final DateTime Function() _now;

  /// Determines the current day (1..28) in the active gratitude journey.
  /// If today already has entries, returns today's journey day.
  /// Otherwise advances to the next day after the last completed day.
  /// After completing Day 28, the cycle loops back to Day 1.
  Future<int> getCurrentJourneyDay() async {
    final allEntries =
        await (_database.select(_database.gratitudeEntries)
              ..where((row) => row.journeyDay.isNotNull())
              ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
            .get();

    if (allEntries.isEmpty) {
      return 1;
    }

    final now = _now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEntries =
        allEntries.where((e) => e.createdAt.isAfter(todayStart)).toList();

    if (todayEntries.isNotEmpty && todayEntries.first.journeyDay != null) {
      return todayEntries.first.journeyDay!;
    }

    final lastDay = allEntries.first.journeyDay ?? 1;
    if (lastDay >= 28) {
      // Loop back to Day 1 after Day 28 is completed!
      return 1;
    }
    return lastDay + 1;
  }

  Future<List<GratitudeEntryRow>> getRecentEntries({int limit = 50}) {
    return (_database.select(_database.gratitudeEntries)
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<List<GratitudeEntryRow>> getEntriesForDay(int journeyDay) {
    return (_database.select(_database.gratitudeEntries)
          ..where((row) => row.journeyDay.equals(journeyDay))
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();
  }

  Future<bool> hasCompletedDay(int journeyDay) async {
    final entries = await getEntriesForDay(journeyDay);
    return entries.isNotEmpty;
  }

  Future<void> addSingleEntry({
    required String gratitudeText,
    String? reasonText,
    int? journeyDay,
    String? userJourneyId,
  }) async {
    final row = GratitudeEntryRow(
      id: const Uuid().v4(),
      userJourneyId: userJourneyId,
      journeyDay: journeyDay,
      gratitudeText: gratitudeText.trim(),
      reasonText: reasonText?.trim() ?? '',
      createdAt: _now(),
    );
    await _database.into(_database.gratitudeEntries).insert(row);
  }

  Future<void> updateSingleEntry({
    required String id,
    required String gratitudeText,
    String? reasonText,
  }) async {
    await (_database.update(_database.gratitudeEntries)
      ..where((row) => row.id.equals(id))).write(
      GratitudeEntriesCompanion(
        gratitudeText: Value(gratitudeText.trim()),
        reasonText: Value(reasonText?.trim() ?? ''),
      ),
    );
  }

  Future<void> deleteEntry(String id) async {
    await (_database.delete(_database.gratitudeEntries)
      ..where((row) => row.id.equals(id))).go();
  }

  Future<void> saveEntries({
    required int journeyDay,
    String? userJourneyId,
    required List<GratitudeDraftItem> items,
  }) {
    return _database.transaction(() async {
      final now = _now();
      for (final item in items) {
        if (item.gratitudeText.trim().isEmpty) {
          continue;
        }
        final row = GratitudeEntryRow(
          id: const Uuid().v4(),
          userJourneyId: userJourneyId,
          journeyDay: journeyDay,
          gratitudeText: item.gratitudeText.trim(),
          reasonText: item.reasonText.trim(),
          createdAt: now,
        );
        await _database.into(_database.gratitudeEntries).insert(row);
      }
    });
  }
}
