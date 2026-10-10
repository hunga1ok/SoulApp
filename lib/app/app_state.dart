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
      _soundEnabled = _preferences.getBool(_soundKey) ?? true,
      _intentions = _preferences.getStringList(_intentionsKey) ?? const [],
      _remindersDecided = _preferences.getBool(_remindersDecidedKey) ?? false,
      _subscriptionPlan = _preferences.getString(_subscriptionPlanKey),
      _onboardingCompleted =
          _preferences.getBool(_onboardingCompletedKey) ?? false;

  static const _localeKey = 'selected_locale';
  static const _nameKey = 'preferred_name';
  static const _soundKey = 'sound_enabled';
  static const _intentionsKey = 'onboarding_intentions';
  static const _remindersDecidedKey = 'onboarding_reminders_decided';
  static const _subscriptionPlanKey = 'subscription_plan';
  static const _onboardingCompletedKey = 'onboarding_completed';

  final SharedPreferences _preferences;
  SoulLocale? _locale;
  String? _preferredName;
  bool _soundEnabled;
  List<String> _intentions;
  bool _remindersDecided;
  String? _subscriptionPlan;
  bool _onboardingCompleted;

  SoulLocale? get locale => _locale;
  String? get preferredName => _preferredName;
  bool get hasPreferredName => _preferredName?.trim().isNotEmpty ?? false;
  bool get soundEnabled => _soundEnabled;

  /// Intention codes chosen during onboarding.
  List<String> get intentions => _intentions;

  /// The reminder step was answered, either with times or skipped.
  bool get remindersDecided => _remindersDecided;

  /// Selected commitment plan ('monthly', 'yearly', or 'lifetime').
  String? get subscriptionPlan => _subscriptionPlan;

  /// Set once the journey has started; onboarding is never shown again.
  bool get onboardingCompleted => _onboardingCompleted;

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

  Future<void> saveIntentions(List<String> codes) async {
    _intentions = List.unmodifiable(codes);
    await _preferences.setStringList(_intentionsKey, _intentions);
    notifyListeners();
  }

  Future<void> markRemindersDecided() async {
    _remindersDecided = true;
    await _preferences.setBool(_remindersDecidedKey, true);
    notifyListeners();
  }

  Future<void> saveSubscriptionPlan(String plan) async {
    _subscriptionPlan = plan;
    await _preferences.setString(_subscriptionPlanKey, plan);
    notifyListeners();
  }

  Future<void> markOnboardingCompleted() async {
    _onboardingCompleted = true;
    await _preferences.setBool(_onboardingCompletedKey, true);
    notifyListeners();
  }

  Future<void> resetAll() async {
    _locale = null;
    _preferredName = null;
    _soundEnabled = true;
    _intentions = const [];
    _remindersDecided = false;
    _subscriptionPlan = null;
    _onboardingCompleted = false;
    await _preferences.clear();
    notifyListeners();
  }
}
