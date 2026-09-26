import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import 'session_controller.dart';

final signInControllerProvider =
    NotifierProvider.autoDispose<SignInController, AsyncValue<void>>(
      SignInController.new,
    );

/// Sign-in button state: idle, in progress, or failed with an `ApiException`.
class SignInController extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// DEVELOPMENT BOUNDARY: debug-build login until OB-002 adds Google.
  Future<void> signInForDevelopment() async {
    if (state.isLoading) return;
    final locale = ref.read(appStateProvider).locale ?? SoulLocale.en;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(sessionControllerProvider.notifier)
          .signInForDevelopment(locale),
    );
  }
}
