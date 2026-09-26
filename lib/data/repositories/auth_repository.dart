import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/soul_locale.dart';
import '../api/api_client.dart';
import '../api/api_error_mapping.dart';
import '../api/auth_interceptor.dart';
import '../local/credential_store.dart';
import '../models/me.dart';
import '../models/session.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(credentialStoreProvider),
  );
});

/// Application sessions: sign-in, restore on start and sign-out.
/// Every method throws `ApiException` on failure.
class AuthRepository {
  const AuthRepository(this._client, this._credentials);

  final ApiClient _client;
  final CredentialStore _credentials;

  static Options get _skipAuth =>
      Options(extra: {AuthInterceptor.skipAuth: true});

  /// DEVELOPMENT BOUNDARY — debug builds only, until Google Sign-In (OB-002,
  /// blocked on EXT-004) replaces it. Signs in through the backend's
  /// `POST /auth/dev`, which only local/dev servers enable, using a stable
  /// random subject stored in secure storage for this install.
  Future<Me> signInForDevelopment({required SoulLocale locale}) async {
    if (!kDebugMode) {
      throw StateError('Development login is only available in debug builds.');
    }
    final subject = await _credentials.readOrCreateDevelopmentSubject();
    return guardApi(() async {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/auth/dev',
        data: {'subject': subject, 'locale': locale.name},
        options: _skipAuth,
      );
      final session = Session.fromJson(response.data!);
      await _client.startSession(session);
      return session.me;
    });
  }

  /// Restores the stored session. Returns `false` when there is none or the
  /// server rejected it; throws `ApiException` on transient failures.
  Future<bool> restoreSession() async {
    return await _client.refreshAccessToken() != null;
  }

  /// Revokes the session on the server when possible and always clears the
  /// local credentials.
  Future<void> signOut() async {
    final refreshToken = await _credentials.readRefreshToken();
    try {
      if (refreshToken != null) {
        await _client.dio.post<void>(
          '/auth/logout',
          data: {'refreshToken': refreshToken},
          options: _skipAuth,
        );
      }
    } on DioException {
      // Best effort: the server session expires on its own.
    } finally {
      await _client.clearSession();
    }
  }
}
