import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_environment.dart';
import '../../core/errors/api_exception.dart';
import '../local/credential_store.dart';
import '../models/session.dart';
import 'api_error_mapping.dart';
import 'auth_interceptor.dart';

/// Raw HTTP client for SoulApi. Tests override this with a fake adapter.
final dioProvider = Provider<Dio>((ref) {
  final configuration = ref.watch(appConfigurationProvider);
  return Dio(
    BaseOptions(
      baseUrl: configuration.apiBaseUrl.toString(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider), ref.watch(credentialStoreProvider));
});

/// Owns the application session tokens and the authenticated [dio].
///
/// The access token lives only in memory; the rotating refresh token only in
/// [CredentialStore]. [refreshAccessToken] is single-flight: every caller
/// that needs a refresh while one is running awaits the same request, because
/// the server revokes the whole session family when a refresh token is
/// presented twice.
class ApiClient {
  ApiClient(this.dio, this._credentials) {
    dio.interceptors.add(AuthInterceptor(this));
  }

  final Dio dio;
  final CredentialStore _credentials;
  String? _accessToken;
  Future<String?>? _refreshing;

  /// Called after the server rejected the refresh token and the local
  /// credentials were cleared.
  void Function()? onSessionEnded;

  String? get accessToken => _accessToken;

  /// The refresh in progress, if any. New requests wait for it.
  Future<String?>? get pendingRefresh => _refreshing;

  Future<void> startSession(Session session) async {
    await _credentials.writeRefreshToken(session.refreshToken);
    _accessToken = session.accessToken;
  }

  Future<void> clearSession() async {
    _accessToken = null;
    await _credentials.deleteRefreshToken();
  }

  /// Rotates the refresh token and returns the new access token, or `null`
  /// when there is no session (nothing stored or rejected by the server).
  /// Transient failures (network, 5xx, 429) throw [ApiException] and keep
  /// the stored credentials so a later retry can still restore the session.
  Future<String?> refreshAccessToken() {
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<String?> _refresh() async {
    final refreshToken = await _credentials.readRefreshToken();
    if (refreshToken == null) {
      _accessToken = null;
      return null;
    }
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {AuthInterceptor.skipAuth: true}),
      );
      final session = Session.fromJson(response.data!);
      await startSession(session);
      return session.accessToken;
    } on DioException catch (exception) {
      final error = apiExceptionFrom(exception);
      if (error.code == ApiErrorCode.unauthorized ||
          error.code == ApiErrorCode.forbidden) {
        await clearSession();
        onSessionEnded?.call();
        return null;
      }
      throw error;
    }
  }
}
