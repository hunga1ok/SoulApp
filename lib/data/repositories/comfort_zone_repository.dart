import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_state.dart';

class ComfortZonePreferencesState {
  const ComfortZonePreferencesState({
    required this.favoriteSceneIds,
    this.lastVisitedSceneId,
  });

  final Set<String> favoriteSceneIds;
  final String? lastVisitedSceneId;

  bool isFavorite(String sceneId) => favoriteSceneIds.contains(sceneId);
}

class ComfortZonePreferencesNotifier
    extends StateNotifier<ComfortZonePreferencesState> {
  ComfortZonePreferencesNotifier(this._preferences)
    : super(
        ComfortZonePreferencesState(
          favoriteSceneIds: Set.unmodifiable(
            (_preferences.getStringList(_favoritesKey) ?? const <String>[])
                .toSet(),
          ),
          lastVisitedSceneId: _preferences.getString(_lastVisitedKey),
        ),
      );

  static const _favoritesKey = 'soul_comfort_zone_favorites';
  static const _lastVisitedKey = 'soul_comfort_zone_last_visited';

  final SharedPreferences _preferences;

  Future<void> toggleFavorite(String sceneId) async {
    final next = Set<String>.from(state.favoriteSceneIds);
    if (!next.remove(sceneId)) {
      next.add(sceneId);
    }
    state = ComfortZonePreferencesState(
      favoriteSceneIds: Set.unmodifiable(next),
      lastVisitedSceneId: state.lastVisitedSceneId,
    );
    await _preferences.setStringList(_favoritesKey, next.toList());
  }

  Future<void> markVisited(String sceneId) async {
    if (state.lastVisitedSceneId == sceneId) return;
    state = ComfortZonePreferencesState(
      favoriteSceneIds: state.favoriteSceneIds,
      lastVisitedSceneId: sceneId,
    );
    await _preferences.setString(_lastVisitedKey, sceneId);
  }
}

final comfortZonePreferencesProvider = StateNotifierProvider<
  ComfortZonePreferencesNotifier,
  ComfortZonePreferencesState
>((ref) {
  final prefs = ref.watch(preferencesProvider);
  return ComfortZonePreferencesNotifier(prefs);
});
