import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/errors/api_exception.dart';
import '../../data/api/api_client.dart';
import '../../data/models/me.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';

final sessionControllerProvider = AsyncNotifierProvider<SessionController, Me?>(
  SessionController.new,
);

/// The application session. Router guards derive from this state:
/// loading/error = restoring on start, `null` = signed out, [Me] = signed in.
class SessionController extends AsyncNotifier<Me?> {
  AuthRepository get _auth => ref.read(authRepositoryProvider);
  ProfileRepository get _profile => ref.read(profileRepositoryProvider);
  AppState get _appState => ref.read(appStateProvider);

  /// Restores a stored session: refresh, then `GET /me` to decide routing.
  @override
  Future<Me?> build() async {
    ref.read(apiClientProvider).onSessionEnded = _onSessionEnded;
    if (!await _auth.restoreSession()) return null;
    final Me me;
    try {
      me = await _profile.fetchMe();
    } on ApiException catch (error) {
      if (error.code == ApiErrorCode.unauthorized) return null;
      rethrow;
    }
    // The profile is the source of truth; the device only caches the locale.
    await _appState.selectLocale(me.profile.locale);
    return me;
  }

  void _onSessionEnded() {
    if (state.valueOrNull != null) state = const AsyncData(null);
  }

  /// Retries a restore that failed for a transient reason.
  void retryRestore() => ref.invalidateSelf();

  /// DEVELOPMENT BOUNDARY — see [AuthRepository.signInForDevelopment].
  /// The locale chosen on the gate is sent at login and, being an explicit
  /// choice on this device, also wins over a different stored profile locale.
  Future<void> signInForDevelopment(SoulLocale locale) async {
    var me = await _auth.signInForDevelopment(locale: locale);
    if (me.profile.locale != locale) {
      try {
        me = await _profile.updateProfile(locale: locale);
      } on ApiException {
        // Best effort: the local choice stays active for this session.
      }
    }
    state = AsyncData(me);
  }

  /// Saves an already validated preferred name.
  Future<void> updatePreferredName(String name) async {
    state = AsyncData(await _profile.updateProfile(preferredName: name.trim()));
  }

  /// Optimistically switches the locale, then persists it to the profile.
  /// On failure the previous locale is restored and the error rethrown.
  Future<void> updateLocale(SoulLocale locale) async {
    final me = state.valueOrNull;
    if (me == null || me.profile.locale == locale) return;
    final previous = me.profile.locale;
    _replaceProfile((profile) => profile.copyWith(locale: locale));
    await _appState.selectLocale(locale);
    try {
      state = AsyncData(await _profile.updateProfile(locale: locale));
    } on ApiException {
      _replaceProfile((profile) => profile.copyWith(locale: previous));
      await _appState.selectLocale(previous);
      rethrow;
    }
  }

  /// Optimistically toggles audio, then persists it to the profile.
  /// On failure the previous value is restored and the error rethrown.
  Future<void> updateAudioEnabled(bool enabled) async {
    final me = state.valueOrNull;
    if (me == null || me.profile.audioEnabled == enabled) return;
    _replaceProfile((profile) => profile.copyWith(audioEnabled: enabled));
    try {
      state = AsyncData(await _profile.updateProfile(audioEnabled: enabled));
    } on ApiException {
      _replaceProfile((profile) => profile.copyWith(audioEnabled: !enabled));
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncData(null);
  }

  void _replaceProfile(Profile Function(Profile) change) {
    final me = state.valueOrNull;
    if (me != null) state = AsyncData(me.copyWith(profile: change(me.profile)));
  }
}
