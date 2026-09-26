import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'api_exception.dart';

/// Localized, user-facing copy for an error thrown by a controller.
String errorMessage(AppLocalizations l10n, Object? error) {
  if (error is! ApiException) return l10n.somethingWentWrong;
  return switch (error.code) {
    ApiErrorCode.network => l10n.errorNetwork,
    ApiErrorCode.unauthorized => l10n.errorSessionEnded,
    ApiErrorCode.forbidden => l10n.errorForbidden,
    ApiErrorCode.validationFailed => l10n.errorValidation,
    ApiErrorCode.rateLimited => l10n.errorRateLimited,
    ApiErrorCode.serviceUnavailable => l10n.errorServiceUnavailable,
    _ => l10n.somethingWentWrong,
  };
}

/// Shows [error] as a localized snack bar.
void showErrorSnackBar(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(errorMessage(l10n, error))));
}
