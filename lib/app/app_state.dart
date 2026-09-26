import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SoulLocale { vi, en }

final preferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be provided at bootstrap.');
});

final appStateProvider = ChangeNotifierProvider<AppState>((ref) {
  return AppState(ref.watch(preferencesProvider));
});

class AppState extends ChangeNotifier {
  AppState(this._preferences)
    : _locale = _readLocale(_preferences),
      _preferredName = _preferences.getString(_nameKey),
      _soundEnabled = _preferences.getBool(_soundKey) ?? true,
      _isAuthenticated = _preferences.getBool(_authenticatedKey) ?? false;

  static const _localeKey = 'selected_locale';
  static const _nameKey = 'preferred_name';
  static const _soundKey = 'sound_enabled';
  static const _authenticatedKey = 'local_authenticated';

  final SharedPreferences _preferences;
  SoulLocale? _locale;
  String? _preferredName;
  bool _soundEnabled;
  bool _isAuthenticated;

  SoulLocale? get locale => _locale;
  String? get preferredName => _preferredName;
  bool get soundEnabled => _soundEnabled;
  bool get isAuthenticated => _isAuthenticated;
  bool get hasCompletedName => (_preferredName?.trim().isNotEmpty ?? false);

  static SoulLocale? _readLocale(SharedPreferences preferences) {
    return switch (preferences.getString(_localeKey)) {
      'vi' => SoulLocale.vi,
      'en' => SoulLocale.en,
      _ => null,
    };
  }

  Future<void> selectLocale(SoulLocale value) async {
    _locale = value;
    await _preferences.setString(_localeKey, value.name);
    notifyListeners();
  }

  /// Temporary development boundary until Google OIDC is configured.
  /// Release authentication will replace this with backend-verified sessions.
  Future<void> completeDevelopmentSignIn() async {
    _isAuthenticated = true;
    await _preferences.setBool(_authenticatedKey, true);
    notifyListeners();
  }

  Future<void> savePreferredName(String value) async {
    _preferredName = value.trim();
    await _preferences.setString(_nameKey, _preferredName!);
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    await _preferences.setBool(_soundKey, _soundEnabled);
    notifyListeners();
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _preferredName = null;
    await _preferences.remove(_authenticatedKey);
    await _preferences.remove(_nameKey);
    notifyListeners();
  }
}
