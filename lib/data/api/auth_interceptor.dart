import 'package:dio/dio.dart';

import '../../core/errors/api_exception.dart';
import 'api_client.dart';

/// Attaches `Authorization: Bearer` and recovers from one 401 per request.
///
/// On a 401 the request is retried exactly once: with the current access
/// token if another request already refreshed it, otherwise after the shared
/// refresh from [ApiClient.refreshAccessToken]. When the refresh reports that
/// the session ended, the original 401 is passed on and no retry happens.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._client);

  /// `RequestOptions.extra` flag for auth endpoints that must not carry or
  /// refresh an access token.
  static const skipAuth = 'soul.skipAuth';
  static const _retried = 'soul.retried';

  final ApiClient _client;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[skipAuth] == true) return handler.next(options);
    final pending = _client.pendingRefresh;
    if (pending != null) {
      try {
        await pending;
      } on ApiException {
        // The request still goes out; its own 401 handling decides.
      }
    }
    final token = _client.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        options.extra[skipAuth] == true ||
        options.extra[_retried] == true) {
      return handler.next(err);
    }

    final String? token;
    try {
      final current = _client.accessToken;
      final sent = options.headers['Authorization'];
      token =
          current != null && sent != 'Bearer $current'
              ? current
              : await _client.refreshAccessToken();
    } on ApiException catch (error) {
      return handler.next(err.copyWith(error: error));
    }
    if (token == null) return handler.next(err);

    try {
      final response = await _client.dio.fetch<dynamic>(
        options.copyWith(extra: {...options.extra, _retried: true}),
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
