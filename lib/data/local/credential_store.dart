import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final credentialStoreProvider = Provider<CredentialStore>(
  (ref) => CredentialStore(ref.watch(secureStorageProvider)),
);

/// Secrets that must survive restarts. Backed only by platform secure
/// storage (Keychain/Keystore) — never by SharedPreferences.
class CredentialStore {
  const CredentialStore(this._storage);

  static const _refreshTokenKey = 'refresh_token';
  static const _developmentSubjectKey = 'development_login_subject';

  final FlutterSecureStorage _storage;

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> writeRefreshToken(String value) =>
      _storage.write(key: _refreshTokenKey, value: value);

  Future<void> deleteRefreshToken() => _storage.delete(key: _refreshTokenKey);

  /// DEVELOPMENT BOUNDARY: a stable, random per-install subject for the
  /// backend's `POST /auth/dev` login. Generated once and kept across
  /// sign-outs so the same development user is reused. Remove with the
  /// development login once Google Sign-In (OB-002) ships.
  Future<String> readOrCreateDevelopmentSubject() async {
    final existing = await _storage.read(key: _developmentSubjectKey);
    if (existing != null) return existing;
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final subject =
        'dev-${List.generate(32, (_) => alphabet[random.nextInt(alphabet.length)]).join()}';
    await _storage.write(key: _developmentSubjectKey, value: subject);
    return subject;
  }
}
