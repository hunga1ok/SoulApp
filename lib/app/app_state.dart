import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/localization/soul_locale.dart';

export '../core/localization/soul_locale.dart';

final preferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be provided at bootstrap.');
});

final appStateProvider = ChangeNotifierProvider<AppState>((ref) {
  return AppState(ref.watch(preferencesProvider));
});

/// Device-local profile and settings. Soul is app-only for now: nothing here
/// is synchronized to a server.
class AppState extends ChangeNotifier {
  AppState(this._preferences)
    : _locale = SoulLocale.tryParse(_preferences.getString(_localeKey)),
      _preferredName = _preferences.getString(_nameKey),
      _soundEnabled = _preferences.getBool(_soundKey) ?? true;

  static const _localeKey = 'selected_locale';
  static const _nameKey = 'preferred_name';
  static const _soundKey = 'sound_enabled';

  final SharedPreferences _preferences;
  SoulLocale? _locale;
  String? _preferredName;
  bool _soundEnabled;

  SoulLocale? get locale => _locale;
  String? get preferredName => _preferredName;
  bool get hasPreferredName => _preferredName?.trim().isNotEmpty ?? false;
  bool get soundEnabled => _soundEnabled;

  Future<void> selectLocale(SoulLocale value) async {
    if (_locale == value) return;
    _locale = value;
    await _preferences.setString(_localeKey, value.name);
    notifyListeners();
  }

  /// Saves an already validated preferred name.
  Future<void> savePreferredName(String value) async {
    _preferredName = value.trim();
    await _preferences.setString(_nameKey, _preferredName!);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    if (_soundEnabled == enabled) return;
    _soundEnabled = enabled;
    await _preferences.setBool(_soundKey, enabled);
    notifyListeners();
  }
}
