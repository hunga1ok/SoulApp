import '../../core/localization/soul_locale.dart';

/// The signed-in user as returned by `GET /v1/me`.
class Me {
  const Me({
    required this.id,
    required this.role,
    required this.email,
    required this.googleDisplayName,
    required this.profile,
  });

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      id: json['id'] as String,
      role: json['role'] as String,
      email: json['email'] as String?,
      googleDisplayName: json['googleDisplayName'] as String?,
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );
  }

  final String id;
  final String role;
  final String? email;

  /// Google account name. Only ever a suggestion for [Profile.preferredName].
  final String? googleDisplayName;
  final Profile profile;

  Me copyWith({Profile? profile}) {
    return Me(
      id: id,
      role: role,
      email: email,
      googleDisplayName: googleDisplayName,
      profile: profile ?? this.profile,
    );
  }
}

class Profile {
  const Profile({
    required this.preferredName,
    required this.locale,
    required this.audioEnabled,
    required this.timezone,
    required this.onboardingCompletedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final locale = SoulLocale.tryParse(json['locale'] as String?);
    if (locale == null) {
      throw FormatException('Unsupported profile locale', json['locale']);
    }
    final completedAt = json['onboardingCompletedAt'] as String?;
    return Profile(
      preferredName: json['preferredName'] as String?,
      locale: locale,
      audioEnabled: json['audioEnabled'] as bool,
      timezone: json['timezone'] as String,
      onboardingCompletedAt:
          completedAt == null ? null : DateTime.parse(completedAt),
    );
  }

  final String? preferredName;
  final SoulLocale locale;
  final bool audioEnabled;
  final String timezone;
  final DateTime? onboardingCompletedAt;

  bool get hasPreferredName => preferredName?.trim().isNotEmpty ?? false;

  Profile copyWith({SoulLocale? locale, bool? audioEnabled}) {
    return Profile(
      preferredName: preferredName,
      locale: locale ?? this.locale,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      timezone: timezone,
      onboardingCompletedAt: onboardingCompletedAt,
    );
  }
}
