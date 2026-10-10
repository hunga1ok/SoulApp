import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import 'content_repository.dart';

class ComfortZoneCategory {
  const ComfortZoneCategory({
    required this.id,
    required this.number,
    required this.code,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final String id;
  final int number;
  final String code;
  final String icon;
  final String title;
  final String subtitle;
  final String description;
}

class ComfortZoneScene {
  const ComfortZoneScene({
    required this.id,
    required this.number,
    required this.categoryId,
    required this.titleEn,
    required this.titleVi,
    required this.localizedTitle,
    required this.bilingualSubheader,
    required this.description,
    required this.affirmation,
    required this.animationType,
    required this.primarySoundId,
    required this.soundIds,
    required this.guidedAudioId,
    required this.palette,
  });

  final String id;
  final int number;
  final String categoryId;
  final String titleEn;
  final String titleVi;
  final String localizedTitle;
  final String bilingualSubheader;
  final String description;
  final String affirmation;
  final String animationType;
  final String primarySoundId;
  final List<String> soundIds;
  final String guidedAudioId;
  final List<Color> palette;

  String get numberBadge => number.toString().padLeft(2, '0');

  Color get skyTop => palette.isNotEmpty ? palette[0] : const Color(0xFF3E5C76);
  Color get skyBottom =>
      palette.length > 1 ? palette[1] : const Color(0xFF9DB4C0);
  Color get accentColor =>
      palette.length > 2 ? palette[2] : const Color(0xFFD4A373);
}

Color _parseHexColor(String hex) {
  final cleaned = hex.replaceAll('#', '').trim();
  if (cleaned.length == 6) {
    return Color(int.parse('FF$cleaned', radix: 16));
  }
  if (cleaned.length == 8) {
    return Color(int.parse(cleaned, radix: 16));
  }
  return const Color(0xFF593C54);
}

class ComfortZoneCatalog {
  const ComfortZoneCatalog({required this.categories, required this.scenes});

  final List<ComfortZoneCategory> categories;
  final List<ComfortZoneScene> scenes;

  ComfortZoneCategory? category(String id) {
    for (final c in categories) {
      if (c.id == id || c.code == id) return c;
    }
    return null;
  }

  ComfortZoneScene? scene(String id) {
    for (final s in scenes) {
      if (s.id == id) return s;
    }
    return null;
  }

  List<ComfortZoneScene> scenesForCategory(String categoryId) {
    return [
      for (final s in scenes)
        if (s.categoryId == categoryId) s,
    ];
  }

  factory ComfortZoneCatalog.fromJson(
    Map<String, dynamic> json,
    SoulLocale locale,
  ) {
    final lang = locale.name;
    final isVi = locale == SoulLocale.vi;
    final categoriesJson =
        (json['categories'] as List).cast<Map<String, dynamic>>();
    final scenesJson = (json['scenes'] as List).cast<Map<String, dynamic>>();

    final categories = <ComfortZoneCategory>[];
    for (final cj in categoriesJson) {
      final titleMap = cj['title'] as Map<String, dynamic>;
      final subtitleMap = cj['subtitle'] as Map<String, dynamic>;
      final descMap = cj['description'] as Map<String, dynamic>;
      categories.add(
        ComfortZoneCategory(
          id: cj['id'] as String,
          number: cj['number'] as int,
          code: cj['code'] as String,
          icon: cj['icon'] as String,
          title:
              (titleMap[lang] ?? titleMap['en'] ?? titleMap['vi'] ?? '')
                  as String,
          subtitle:
              (subtitleMap[lang] ??
                      subtitleMap['en'] ??
                      subtitleMap['vi'] ??
                      '')
                  as String,
          description:
              (descMap[lang] ?? descMap['en'] ?? descMap['vi'] ?? '') as String,
        ),
      );
    }

    final scenes = <ComfortZoneScene>[];
    for (final sj in scenesJson) {
      final titleEn = sj['titleEn'] as String;
      final titleVi = sj['titleVi'] as String;
      final titleMap = sj['title'] as Map<String, dynamic>?;
      final resolvedTitle =
          (titleMap?[lang] as String?) ?? (isVi ? titleVi : titleEn);
      final descMap = sj['description'] as Map<String, dynamic>;
      final affirmMap = sj['affirmation'] as Map<String, dynamic>;
      final paletteHex = (sj['palette'] as List).cast<String>();

      scenes.add(
        ComfortZoneScene(
          id: sj['id'] as String,
          number: sj['number'] as int,
          categoryId: sj['categoryId'] as String,
          titleEn: titleEn,
          titleVi: titleVi,
          localizedTitle: resolvedTitle,
          bilingualSubheader:
              locale == SoulLocale.en ? titleEn : '$titleEn — $resolvedTitle',
          description:
              (descMap[lang] ?? descMap['en'] ?? descMap['vi'] ?? '') as String,
          affirmation:
              (affirmMap[lang] ?? affirmMap['en'] ?? affirmMap['vi'] ?? '')
                  as String,
          animationType: sj['animationType'] as String,
          primarySoundId: sj['primarySoundId'] as String,
          soundIds: List.unmodifiable((sj['soundIds'] as List).cast<String>()),
          guidedAudioId: sj['guidedAudioId'] as String,
          palette: List.unmodifiable(paletteHex.map(_parseHexColor)),
        ),
      );
    }

    return ComfortZoneCatalog(
      categories: List.unmodifiable(categories),
      scenes: List.unmodifiable(scenes),
    );
  }
}

final comfortZoneCatalogProvider = FutureProvider<ComfortZoneCatalog>((ref) {
  final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
  return ref.watch(contentRepositoryProvider).comfortZoneCatalog(locale);
});
