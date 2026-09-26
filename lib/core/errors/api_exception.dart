/// Stable error codes from the SoulApi error envelope, plus [network] for
/// failures where no server response arrived.
enum ApiErrorCode {
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validationFailed,
  rateLimited,
  serviceUnavailable,
  internalError,
  network,
  unknown;

  static ApiErrorCode fromServer(Object? code) {
    return switch (code) {
      'UNAUTHORIZED' => unauthorized,
      'FORBIDDEN' => forbidden,
      'NOT_FOUND' => notFound,
      'CONFLICT' => conflict,
      'VALIDATION_FAILED' => validationFailed,
      'RATE_LIMITED' => rateLimited,
      'SERVICE_UNAVAILABLE' => serviceUnavailable,
      'INTERNAL_ERROR' => internalError,
      _ => unknown,
    };
  }
}

/// A failed API call. Carries only the machine-readable [code]; the server's
/// developer `message` is intentionally dropped so it can never reach the UI.
/// Widgets map [code] to localized copy.
class ApiException implements Exception {
  const ApiException(this.code, {this.statusCode, this.requestId});

  final ApiErrorCode code;
  final int? statusCode;

  /// Correlation ID from the envelope, useful for support and logs.
  final String? requestId;

  @override
  String toString() =>
      'ApiException($code, status: $statusCode, requestId: $requestId)';
}
