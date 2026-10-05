import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_state.dart';

class VisionAudioSelection {
  const VisionAudioSelection({
    required this.id,
    required this.title,
    required this.path,
    required this.isAsset,
  });

  final String id;
  final String title;
  final String path;
  final bool isAsset;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'path': path,
    'isAsset': isAsset,
  };

  factory VisionAudioSelection.fromJson(Map<String, dynamic> json) =>
      VisionAudioSelection(
        id: json['id'] as String,
        title: json['title'] as String,
        path: json['path'] as String,
        isAsset: json['isAsset'] as bool? ?? false,
      );
}

final visionAudioSelectionsProvider =
    FutureProvider.family<List<VisionAudioSelection>, String>(
      (ref, visionId) =>
          ref.watch(visionAudioRepositoryProvider).forVision(visionId),
    );

final visionAudioRepositoryProvider = Provider<VisionAudioRepository>((ref) {
  return VisionAudioRepository(ref.watch(preferencesProvider));
});

/// Private, local sound choices attached to one vision.
class VisionAudioRepository {
  VisionAudioRepository(this._preferences);

  static const _key = 'vision_audio_selections_v1';
  final SharedPreferences _preferences;

  Future<Map<String, List<VisionAudioSelection>>> _all() async {
    final raw = _preferences.getString(_key);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return {
      for (final entry in decoded.entries)
        entry.key:
            (entry.value as List)
                .cast<Map<String, dynamic>>()
                .map(VisionAudioSelection.fromJson)
                .toList(),
    };
  }

  Future<List<VisionAudioSelection>> forVision(String visionId) async =>
      (await _all())[visionId] ?? const [];

  Future<void> add(
    String visionId, {
    required String title,
    required String path,
    required bool isAsset,
  }) async {
    final all = await _all();
    final items = <VisionAudioSelection>[...(all[visionId] ?? const [])];
    if (items.any((item) => item.path == path)) return;
    items.add(
      VisionAudioSelection(
        id: const Uuid().v4(),
        title: title,
        path: path,
        isAsset: isAsset,
      ),
    );
    all[visionId] = items;
    await _save(all);
  }

  Future<void> remove(String visionId, String selectionId) async {
    final all = await _all();
    final items = <VisionAudioSelection>[...(all[visionId] ?? const [])]
      ..removeWhere((item) => item.id == selectionId);
    if (items.isEmpty) {
      all.remove(visionId);
    } else {
      all[visionId] = items;
    }
    await _save(all);
  }

  Future<void> _save(Map<String, List<VisionAudioSelection>> all) =>
      _preferences.setString(
        _key,
        jsonEncode({
          for (final entry in all.entries)
            entry.key: [for (final item in entry.value) item.toJson()],
        }),
      );
}
