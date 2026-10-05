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

final todayGratitudeEntriesProvider =
    FutureProvider.autoDispose<List<GratitudeEntryRow>>((ref) {
      return ref.watch(gratitudeRepositoryProvider).getEntriesForDay(1);
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
