import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build-time configuration, provided at bootstrap.
final appConfigurationProvider = Provider<AppConfiguration>((ref) {
  throw UnimplementedError('AppConfiguration must be provided at bootstrap.');
});

enum AppEnvironment { development, staging, production }

class AppConfiguration {
  const AppConfiguration._({
    required this.environment,
    required this.apiBaseUrl,
    required this.googleWebClientId,
    required this.oauthRedirectScheme,
  });

  factory AppConfiguration.fromDartDefines() {
    const rawEnvironment = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const rawApiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:3000/v1',
    );
    const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
    const oauthRedirectScheme = String.fromEnvironment('OAUTH_REDIRECT_SCHEME');

    final environment = switch (rawEnvironment) {
      'development' => AppEnvironment.development,
      'staging' => AppEnvironment.staging,
      'production' => AppEnvironment.production,
      _ =>
        throw ArgumentError.value(
          rawEnvironment,
          'APP_ENV',
          'Must be development, staging, or production.',
        ),
    };
    final apiBaseUrl = Uri.parse(rawApiBaseUrl);

    if (!apiBaseUrl.hasScheme || !apiBaseUrl.hasAuthority) {
      throw ArgumentError.value(
        rawApiBaseUrl,
        'API_BASE_URL',
        'Must be an absolute URL.',
      );
    }
    if (environment == AppEnvironment.production &&
        apiBaseUrl.scheme != 'https') {
      throw ArgumentError.value(
        rawApiBaseUrl,
        'API_BASE_URL',
        'Production must use HTTPS.',
      );
    }
    if (!kReleaseMode && environment == AppEnvironment.production) {
      throw StateError(
        'A debug/profile build must not connect to the production environment.',
      );
    }

    return AppConfiguration._(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      googleWebClientId: googleWebClientId,
      oauthRedirectScheme: oauthRedirectScheme,
    );
  }

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final String googleWebClientId;
  final String oauthRedirectScheme;
}
