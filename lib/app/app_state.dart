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

/// Device-local, non-sensitive state: the locale cached for startup. The
/// signed-in user's profile lives in `sessionControllerProvider`.
class AppState extends ChangeNotifier {
  AppState(this._preferences) : _locale = _readLocale(_preferences);

  static const _localeKey = 'selected_locale';

  final SharedPreferences _preferences;
  SoulLocale? _locale;

  SoulLocale? get locale => _locale;

  static SoulLocale? _readLocale(SharedPreferences preferences) {
    return SoulLocale.tryParse(preferences.getString(_localeKey));
  }

  Future<void> selectLocale(SoulLocale value) async {
    if (_locale == value) return;
    _locale = value;
    await _preferences.setString(_localeKey, value.name);
    notifyListeners();
  }
}
