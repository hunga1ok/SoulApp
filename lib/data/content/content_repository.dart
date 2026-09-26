import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/soul_locale.dart';

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

/// Reads the read-only content bundled in `assets/content/`.
class ContentRepository {
  ContentRepository(this._bundle);

  final AssetBundle _bundle;

  Future<List<Intention>> intentions(SoulLocale locale) async {
    final json =
        jsonDecode(await _bundle.loadString('assets/content/intentions.json'))
            as Map<String, dynamic>;
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
