import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/soul_locale.dart';
import '../api/api_client.dart';
import '../api/api_error_mapping.dart';
import '../models/me.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider).dio);
});

/// The signed-in user's profile. Every method throws `ApiException` on
/// failure.
class ProfileRepository {
  const ProfileRepository(this._dio);

  final Dio _dio;

  Future<Me> fetchMe() {
    return guardApi(() async {
      final response = await _dio.get<Map<String, dynamic>>('/me');
      return Me.fromJson(response.data!);
    });
  }

  /// Sends only the provided fields.
  Future<Me> updateProfile({
    String? preferredName,
    SoulLocale? locale,
    bool? audioEnabled,
  }) {
    return guardApi(() async {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/me/profile',
        data: {
          if (preferredName != null) 'preferredName': preferredName,
          if (locale != null) 'locale': locale.name,
          if (audioEnabled != null) 'audioEnabled': audioEnabled,
        },
      );
      return Me.fromJson(response.data!);
    });
  }
}
