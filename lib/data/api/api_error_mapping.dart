import 'package:dio/dio.dart';

import '../../core/errors/api_exception.dart';

/// Maps a Dio failure to a typed [ApiException] using the SoulApi error
/// envelope `{"error": {"code", "messageKey", "message", "requestId"}}`.
ApiException apiExceptionFrom(DioException exception) {
  final inner = exception.error;
  if (inner is ApiException) return inner;

  final response = exception.response;
  if (response == null) return const ApiException(ApiErrorCode.network);

  final status = response.statusCode;
  final body = response.data;
  final envelope = body is Map ? body['error'] : null;
  if (envelope is Map) {
    final requestId = envelope['requestId'];
    return ApiException(
      ApiErrorCode.fromServer(envelope['code']),
      statusCode: status,
      requestId: requestId is String ? requestId : null,
    );
  }
  final code = switch (status) {
    401 => ApiErrorCode.unauthorized,
    403 => ApiErrorCode.forbidden,
    404 => ApiErrorCode.notFound,
    429 => ApiErrorCode.rateLimited,
    503 => ApiErrorCode.serviceUnavailable,
    final int s when s >= 500 => ApiErrorCode.internalError,
    _ => ApiErrorCode.unknown,
  };
  return ApiException(code, statusCode: status);
}

/// Runs [call] and rethrows any Dio failure as an [ApiException].
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (exception) {
    throw apiExceptionFrom(exception);
  }
}
