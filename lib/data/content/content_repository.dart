import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/soul_locale.dart';
import 'audio_catalog.dart';
import 'card_catalog.dart';
import 'vision_catalog.dart';

/// A localized onboarding intention from the content bundle.
class Intention {
  const Intention({required this.code, required this.label});

  final String code;
  final String label;
}

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository(rootBundle);
});

final intentionsProvider = FutureProvider.family<List<Intention>, SoulLocale>((
  ref,
  locale,
) {
  return ref.watch(contentRepositoryProvider).intentions(locale);
});

final audioCatalogProvider = FutureProvider<AudioCatalog>((ref) {
  return ref.watch(contentRepositoryProvider).audioCatalog();
});

/// Reads the read-only content bundled in `assets/content/`.
class ContentRepository {
  ContentRepository(this._bundle);

  final AssetBundle _bundle;

  Future<Map<String, dynamic>> _load(String name) async =>
      jsonDecode(await _bundle.loadString('assets/content/$name'))
          as Map<String, dynamic>;

  Future<VisionCatalog> visionCatalog(SoulLocale locale) async =>
      VisionCatalog.fromJson(await _load('vision.json'), locale);

  Future<AudioCatalog> audioCatalog() async =>
      AudioCatalog.fromJson(await _load('audio_manifest.json'));

  Future<CardCatalog> cardCatalog(SoulLocale locale) async =>
      CardCatalog.fromJson(await _load('card_decks.json'), locale);

  Future<List<Intention>> intentions(SoulLocale locale) async {
    final json = await _load('intentions.json');
    final items =
        (json['intentions'] as List).cast<Map<String, dynamic>>()..sort(
          (a, b) => (a['sortOrder'] as int).compareTo(b['sortOrder'] as int),
        );
    return [
      for (final item in items)
        Intention(
          code: item['code'] as String,
          label:
              (item['text'] as Map<String, dynamic>)[locale.name]['label']
                  as String,
        ),
    ];
  }
}
