import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_state.dart';

enum HomeWidgetMode { comfortZone, sound, vision, gratitude, card }

enum HomeWidgetTheme { plum, paper, rose }

class HomeWidgetPayload {
  const HomeWidgetPayload({
    required this.badge,
    required this.title,
    required this.body,
    required this.footer,
    required this.theme,
    this.musicTrack,
    this.frequency,
  });

  final String badge;
  final String title;
  final String body;
  final String footer;
  final HomeWidgetTheme theme;
  final String? musicTrack;
  final String? frequency;
}

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  return HomeWidgetService(ref.watch(preferencesProvider));
});

class HomeWidgetService {
  HomeWidgetService(this._preferences);

  static const _channel = MethodChannel('com.manifest.soul/home_widget');
  static const _modeKey = 'widget_mode';
  static const _themeKey = 'widget_theme';
  static const _sceneIdKey = 'widget_scene_id';
  static const _soundIdKey = 'widget_sound_id';
  static const _badgeKey = 'widget_badge';
  static const _titleKey = 'widget_title';
  static const _bodyKey = 'widget_body';
  static const _footerKey = 'widget_footer';
  static const _musicTrackKey = 'widget_music_track';
  static const _frequencyKey = 'widget_frequency';

  final SharedPreferences _preferences;

  HomeWidgetMode get mode {
    final raw = _preferences.getString(_modeKey);
    return HomeWidgetMode.values.asNameMap()[raw] ?? HomeWidgetMode.comfortZone;
  }

  HomeWidgetTheme get theme {
    final raw = _preferences.getString(_themeKey);
    return HomeWidgetTheme.values.asNameMap()[raw] ?? HomeWidgetTheme.plum;
  }

  String? get sceneId => _preferences.getString(_sceneIdKey);

  String? get soundId => _preferences.getString(_soundIdKey);

  Future<void> setMode(HomeWidgetMode value) async {
    await _preferences.setString(_modeKey, value.name);
  }

  Future<void> setTheme(HomeWidgetTheme value) async {
    await _preferences.setString(_themeKey, value.name);
  }

  Future<void> setSceneId(String value) async {
    await _preferences.setString(_sceneIdKey, value);
  }

  Future<void> setSoundId(String value) async {
    await _preferences.setString(_soundIdKey, value);
  }

  Future<void> syncPayload(HomeWidgetPayload payload) async {
    await _preferences.setString(_badgeKey, payload.badge);
    await _preferences.setString(_titleKey, payload.title);
    await _preferences.setString(_bodyKey, payload.body);
    await _preferences.setString(_footerKey, payload.footer);
    await _preferences.setString(_themeKey, payload.theme.name);
    if (payload.musicTrack != null) {
      await _preferences.setString(_musicTrackKey, payload.musicTrack!);
    } else {
      await _preferences.remove(_musicTrackKey);
    }
    if (payload.frequency != null) {
      await _preferences.setString(_frequencyKey, payload.frequency!);
    } else {
      await _preferences.remove(_frequencyKey);
    }
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<bool>('updateWidget');
    } on MissingPluginException {
      // Safe fallback in unit tests or unsupported desktop/web platforms.
    } on PlatformException {
      // Safe fallback when launcher does not expose AppWidgetManager.
    }
  }

  Future<bool> requestPinWidget(HomeWidgetPayload payload) async {
    await syncPayload(payload);
    if (defaultTargetPlatform != TargetPlatform.android) return false;
    try {
      final pinned = await _channel.invokeMethod<bool>('requestPinWidget');
      return pinned ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
