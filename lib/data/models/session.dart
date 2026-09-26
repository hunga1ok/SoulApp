import 'me.dart';

/// Application session issued by `/v1/auth/*`.
class Session {
  const Session({
    required this.accessToken,
    required this.refreshToken,
    required this.me,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      me: Me.fromJson(json['me'] as Map<String, dynamic>),
    );
  }

  final String accessToken;
  final String refreshToken;
  final Me me;
}
