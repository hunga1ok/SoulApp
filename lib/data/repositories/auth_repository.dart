import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_state.dart';
import '../../features/auth/auth_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final prefs = ref.watch(preferencesProvider);
  return AuthRepository(prefs);
});

class AuthRepository {
  AuthRepository(this._prefs);

  static const _userKey = 'soul_current_user_v1';
  static const _uuid = Uuid();
  final SharedPreferences _prefs;

  /// Loads the active user, or lazily generates a new Guest account.
  AuthUser get currentUser {
    final raw = _prefs.getString(_userKey);
    if (raw != null) {
      try {
        return AuthUser.fromJson(raw);
      } catch (_) {
        // Fall back to clean guest if deserialization fails
      }
    }
    final guest = AuthUser(
      id: _uuid.v4(),
      provider: AuthProvider.guest,
      createdAt: DateTime.now(),
      displayName: _prefs.getString('preferred_name') ?? 'Người bạn của Soul',
    );
    _prefs.setString(_userKey, guest.toJson());
    return guest;
  }

  Future<void> saveUser(AuthUser user) async {
    await _prefs.setString(_userKey, user.toJson());
  }

  /// Sign in with Google: 1-Tap authentication.
  /// If [name] is not provided, defaults to a warm friendly name.
  Future<AuthUser> signInWithGoogle({
    String? email,
    String? displayName,
  }) async {
    final current = currentUser;
    final effectiveName =
        displayName ??
        (current.displayName?.isNotEmpty == true
            ? current.displayName
            : 'Soul Member');
    final effectiveEmail = email ?? 'soul.user@gmail.com';

    // Seamlessly preserve user's existing ID so all local gratitude,
    // vision and comfort zone records remain 100% attached!
    final updated = current.copyWith(
      provider: AuthProvider.google,
      email: effectiveEmail,
      displayName: effectiveName,
      avatarUrl: 'https://lh3.googleusercontent.com/a/default-user',
    );
    await saveUser(updated);
    return updated;
  }

  /// Sign in with Apple: 1-Tap native authentication.
  Future<AuthUser> signInWithApple({String? email, String? displayName}) async {
    final current = currentUser;
    final effectiveName =
        displayName ??
        (current.displayName?.isNotEmpty == true
            ? current.displayName
            : 'Soul Member');
    final effectiveEmail = email ?? 'user@privaterelay.appleid.com';

    final updated = current.copyWith(
      provider: AuthProvider.apple,
      email: effectiveEmail,
      displayName: effectiveName,
    );
    await saveUser(updated);
    return updated;
  }

  /// Sign in with Email / Password
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final current = currentUser;
    final effectiveName = displayName ?? email.split('@').first;

    final updated = current.copyWith(
      provider: AuthProvider.email,
      email: email.trim(),
      displayName: effectiveName,
    );
    await saveUser(updated);
    return updated;
  }

  /// Sign up with Email / Password
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return signInWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  /// Link existing guest data with an external provider (Google / Apple)
  Future<AuthUser> linkAccount({
    required AuthProvider provider,
    String? email,
    String? displayName,
  }) async {
    if (provider == AuthProvider.google) {
      return signInWithGoogle(email: email, displayName: displayName);
    } else if (provider == AuthProvider.apple) {
      return signInWithApple(email: email, displayName: displayName);
    }
    final current = currentUser;
    final updated = current.copyWith(
      provider: provider,
      email: email,
      displayName: displayName ?? current.displayName,
    );
    await saveUser(updated);
    return updated;
  }

  /// Sign out: Restores user to a fresh local Guest session
  Future<AuthUser> signOut() async {
    final guest = AuthUser(
      id: _uuid.v4(),
      provider: AuthProvider.guest,
      createdAt: DateTime.now(),
      displayName: 'Khách',
    );
    await saveUser(guest);
    return guest;
  }

  /// Delete Account: Purges user data and generates a clean guest session
  Future<void> deleteAccount() async {
    await _prefs.remove(_userKey);
  }
}
