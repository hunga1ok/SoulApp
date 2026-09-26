import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/errors/api_exception.dart';
import 'package:soul_app/data/api/api_error_mapping.dart';

DioException _withResponse(int status, Object? data) {
  final options = RequestOptions(path: '/me');
  return DioException.badResponse(
    statusCode: status,
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: status, data: data),
  );
}

Map<String, Object?> _envelope(String code) => {
  'error': {
    'code': code,
    'messageKey': 'errors.x',
    'message': 'dev hint, never show',
    'requestId': 'req-1',
    'details': null,
  },
};

void main() {
  test('maps every documented envelope code', () {
    const codes = {
      'UNAUTHORIZED': ApiErrorCode.unauthorized,
      'FORBIDDEN': ApiErrorCode.forbidden,
      'NOT_FOUND': ApiErrorCode.notFound,
      'CONFLICT': ApiErrorCode.conflict,
      'VALIDATION_FAILED': ApiErrorCode.validationFailed,
      'RATE_LIMITED': ApiErrorCode.rateLimited,
      'SERVICE_UNAVAILABLE': ApiErrorCode.serviceUnavailable,
      'INTERNAL_ERROR': ApiErrorCode.internalError,
      'SOMETHING_NEW': ApiErrorCode.unknown,
    };
    for (final MapEntry(key: code, value: expected) in codes.entries) {
      final error = apiExceptionFrom(_withResponse(400, _envelope(code)));
      expect(error.code, expected, reason: code);
      expect(error.statusCode, 400);
      expect(error.requestId, 'req-1');
      // The developer message is never carried towards the UI.
      expect(error.toString(), isNot(contains('dev hint')));
    }
  });

  test('falls back to the HTTP status without an envelope', () {
    expect(
      apiExceptionFrom(_withResponse(429, 'Too Many Requests')).code,
      ApiErrorCode.rateLimited,
    );
    expect(
      apiExceptionFrom(_withResponse(502, null)).code,
      ApiErrorCode.internalError,
    );
    expect(
      apiExceptionFrom(_withResponse(418, {'unexpected': true})).code,
      ApiErrorCode.unknown,
    );
  });

  test('a failure without a response is a network error', () {
    final options = RequestOptions(path: '/me');
    expect(
      apiExceptionFrom(
        DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        ),
      ).code,
      ApiErrorCode.network,
    );
    expect(
      apiExceptionFrom(
        DioException.connectionTimeout(
          requestOptions: options,
          timeout: const Duration(seconds: 10),
        ),
      ).code,
      ApiErrorCode.network,
    );
  });

  test('keeps an ApiException raised inside the interceptor chain', () {
    const inner = ApiException(ApiErrorCode.serviceUnavailable);
    final wrapped = _withResponse(401, null).copyWith(error: inner);
    expect(apiExceptionFrom(wrapped), same(inner));
  });
}
