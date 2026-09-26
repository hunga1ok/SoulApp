import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/soul_database.dart';

enum ReminderKind { morning, evening }

/// A reminder choice; [time] is wall-clock time in the device timezone.
class ReminderChoice {
  const ReminderChoice({required this.enabled, required this.time});

  final bool enabled;
  final TimeOfDay time;

  ReminderChoice copyWith({bool? enabled, TimeOfDay? time}) =>
      ReminderChoice(enabled: enabled ?? this.enabled, time: time ?? this.time);
}

/// Onboarding defaults from the approved prototype.
const defaultReminders = {
  ReminderKind.morning: ReminderChoice(
    enabled: true,
    time: TimeOfDay(hour: 7, minute: 0),
  ),
  ReminderKind.evening: ReminderChoice(
    enabled: true,
    time: TimeOfDay(hour: 21, minute: 30),
  ),
};

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(soulDatabaseProvider));
});

class ReminderRepository {
  ReminderRepository(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final SoulDatabase _database;
  final DateTime Function() _now;

  Future<Map<ReminderKind, ReminderChoice>> load() async {
    final rows = await _database.select(_database.reminderPreferences).get();
    final choices = {...defaultReminders};
    for (final row in rows) {
      final kind = ReminderKind.values.asNameMap()[row.kind];
      if (kind == null) continue;
      final minute = row.minuteOfDay;
      choices[kind] = ReminderChoice(
        enabled: row.enabled,
        time:
            minute == null
                ? defaultReminders[kind]!.time
                : TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
      );
    }
    return choices;
  }

  /// Saves every choice with the device [timezone]; saving again replaces it.
  Future<void> save(
    Map<ReminderKind, ReminderChoice> choices, {
    required String timezone,
  }) {
    final now = _now();
    return _database.batch((batch) {
      batch.insertAllOnConflictUpdate(_database.reminderPreferences, [
        for (final MapEntry(key: kind, value: choice) in choices.entries)
          ReminderPreferencesCompanion.insert(
            kind: kind.name,
            enabled: choice.enabled,
            minuteOfDay: Value(choice.time.hour * 60 + choice.time.minute),
            timezone: timezone,
            updatedAt: now,
          ),
      ]);
    });
  }
}
