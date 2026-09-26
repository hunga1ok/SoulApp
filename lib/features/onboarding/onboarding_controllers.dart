import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/platform/device_services.dart';
import '../../data/repositories/journey_repository.dart';
import '../../data/repositories/reminder_repository.dart';

final reminderStepProvider = NotifierProvider.autoDispose<
  ReminderStepController,
  Map<ReminderKind, ReminderChoice>
>(ReminderStepController.new);

/// Reminder choices on the onboarding step; nothing is saved until the user
/// continues or skips.
class ReminderStepController
    extends AutoDisposeNotifier<Map<ReminderKind, ReminderChoice>> {
  @override
  Map<ReminderKind, ReminderChoice> build() => {...defaultReminders};

  void setEnabled(ReminderKind kind, bool enabled) =>
      state = {...state, kind: state[kind]!.copyWith(enabled: enabled)};

  void setTime(ReminderKind kind, TimeOfDay time) =>
      state = {...state, kind: state[kind]!.copyWith(time: time)};

  /// Saves the choices; asks for notification permission only when at least
  /// one reminder is on. A denied permission never blocks onboarding.
  Future<void> confirm() => _finish(state);

  /// Saves every reminder as off without asking for permission.
  Future<void> skip() => _finish({
    for (final MapEntry(key: kind, value: choice) in state.entries)
      kind: choice.copyWith(enabled: false),
  });

  Future<void> _finish(Map<ReminderKind, ReminderChoice> choices) async {
    final timezone = await ref.read(deviceTimezoneProvider).current();
    await ref
        .read(reminderRepositoryProvider)
        .save(choices, timezone: timezone);
    if (choices.values.any((choice) => choice.enabled)) {
      await ref.read(notificationPermissionsProvider).request();
    }
    await ref.read(appStateProvider).markRemindersDecided();
  }
}

final journeyStartProvider =
    NotifierProvider.autoDispose<JourneyStartController, AsyncValue<void>>(
      JourneyStartController.new,
    );

/// Starts Day 1 and completes onboarding: idle, starting, or failed.
class JourneyStartController extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> start() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final appState = ref.read(appStateProvider);
      await ref
          .read(journeyRepositoryProvider)
          .startJourney(
            locale: appState.locale ?? SoulLocale.en,
            timezone: await ref.read(deviceTimezoneProvider).current(),
          );
      // The router guard moves on to Today once this is set.
      await appState.markOnboardingCompleted();
    });
  }
}
