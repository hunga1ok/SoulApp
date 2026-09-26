import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';

/// Maximum preferred-name length in Unicode code points (API contract).
const preferredNameMaxLength = 50;

enum PreferredNameIssue { empty, tooLong }

/// Validates the trimmed name: 1 to [preferredNameMaxLength] code points.
PreferredNameIssue? validatePreferredName(String raw) {
  final name = raw.trim();
  if (name.isEmpty) return PreferredNameIssue.empty;
  if (name.runes.length > preferredNameMaxLength) {
    return PreferredNameIssue.tooLong;
  }
  return null;
}

final preferredNameControllerProvider =
    NotifierProvider.autoDispose<PreferredNameController, AsyncValue<void>>(
      PreferredNameController.new,
    );

/// Save state of the preferred-name form: idle, saving, or failed with an
/// `ApiException` that the screen shows with a retry.
class PreferredNameController extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Returns `true` once the name is saved to the profile.
  Future<bool> save(String raw) async {
    if (state.isLoading || validatePreferredName(raw) != null) return false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(sessionControllerProvider.notifier)
          .updatePreferredName(raw.trim()),
    );
    return !state.hasError;
  }
}
