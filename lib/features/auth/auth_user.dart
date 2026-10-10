import 'dart:convert';

enum AuthProvider { guest, google, apple, email }

class AuthUser {
  const AuthUser({
    required this.id,
    required this.provider,
    required this.createdAt,
    this.email,
    this.displayName,
    this.avatarUrl,
  });

  final String id;
  final AuthProvider provider;
  final DateTime createdAt;
  final String? email;
  final String? displayName;
  final String? avatarUrl;

  bool get isGuest => provider == AuthProvider.guest;

  String get providerTitle => switch (provider) {
    AuthProvider.guest => 'Khách (Guest)',
    AuthProvider.google => 'Google',
    AuthProvider.apple => 'Apple',
    AuthProvider.email => 'Email',
  };

  AuthUser copyWith({
    String? id,
    AuthProvider? provider,
    DateTime? createdAt,
    String? email,
    String? displayName,
    String? avatarUrl,
  }) {
    return AuthUser(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provider': provider.name,
      'createdAt': createdAt.toIso8601String(),
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id'] as String,
      provider: AuthProvider.values.firstWhere(
        (p) => p.name == map['provider'],
        orElse: () => AuthProvider.guest,
      ),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AuthUser.fromJson(String source) =>
      AuthUser.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
