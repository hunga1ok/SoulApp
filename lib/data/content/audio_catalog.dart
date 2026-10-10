import '../../core/localization/soul_locale.dart';

/// Delivery state is deliberately separate from the audio recommendation.
/// An item cannot be played until its final file and rights review are both
/// complete and it is marked [published].
enum AudioDelivery { pendingAsset, published }

AudioDelivery _deliveryFromJson(String value) => switch (value) {
  'published' => AudioDelivery.published,
  _ => AudioDelivery.pendingAsset,
};

class SoulAudioAsset {
  const SoulAudioAsset({
    required this.id,
    required this.type,
    required this.delivery,
    this.assetPath,
    this.frequency,
    this.localePaths = const {},
    this.titles = const {},
    this.subtitles = const {},
  });

  final String id;
  final String type;
  final AudioDelivery delivery;
  final String? assetPath;
  final String? frequency;
  final Map<SoulLocale, String> localePaths;
  final Map<SoulLocale, String> titles;
  final Map<SoulLocale, String> subtitles;

  String titleFor(SoulLocale locale) =>
      titles[locale] ?? titles[SoulLocale.en] ?? titles[SoulLocale.vi] ?? id;

  /// Title combined with frequency tag (e.g. "Bình yên vững vàng · 396 Hz")
  /// for compact selectors like dropdowns and pills.
  String displayLabelFor(SoulLocale locale) {
    final base = titleFor(locale);
    final freq = frequency;
    if (freq == null || freq.isEmpty || isGuided) return base;
    return '$base · $freq';
  }

  /// Detailed frequency & healing purpose subtitle for audio lists and player.
  String subtitleFor(SoulLocale locale) {
    final custom =
        subtitles[locale] ??
        subtitles[SoulLocale.en] ??
        subtitles[SoulLocale.vi];
    if (custom != null && custom.isNotEmpty) return custom;
    if (isGuided) {
      return switch (locale) {
        SoulLocale.vi => 'Bài dẫn thiền định • Nền tần số 432 Hz',
        SoulLocale.en => 'Guided Meditation • 432 Hz Background',
        SoulLocale.ko => '가이드 명상 • 432 Hz 배경 주파수',
        SoulLocale.ja => 'ガイド付き瞑想 • 432 Hz 背景周波数',
        SoulLocale.fr => 'Méditation guidée • Fond fréquentiel 432 Hz',
        SoulLocale.zh => '引导冥想 • 432 Hz 背景频率',
      };
    }
    if (frequency != null && frequency!.isNotEmpty) {
      return frequency!;
    }
    return switch (locale) {
      SoulLocale.vi => 'Âm thanh tự nhiên & Thư giãn',
      SoulLocale.en => 'Nature & Ambience',
      SoulLocale.ko => '자연의 소리 & 휴식',
      SoulLocale.ja => '自然音＆アンビエンス',
      SoulLocale.fr => 'Sons de la nature & Ambiance',
      SoulLocale.zh => '自然之声与舒缓氛围',
    };
  }

  bool get isGuided => localePaths.isNotEmpty;

  /// Guided voice resolves to the selected app language (falling back to en/vi
  /// if a specific localized recording is not bundled). Music and ambience are
  /// language-neutral and use [assetPath].
  String? pathFor(SoulLocale locale) =>
      isGuided
          ? (localePaths[locale] ??
              localePaths[SoulLocale.en] ??
              localePaths[SoulLocale.vi])
          : assetPath;
}

class VisionAudioBundle {
  const VisionAudioBundle({
    required this.categoryCode,
    required this.guidedAudioId,
    required this.affirmationCollectionId,
    required this.soundIds,
  });

  final String categoryCode;
  final String guidedAudioId;
  final String affirmationCollectionId;
  final List<String> soundIds;
}

/// Catalog authored from the owned-audio manifest. Category determines the
/// order: the app does not expose a user-controlled sound selector for Vision.
class AudioCatalog {
  const AudioCatalog({required this.assets, required this.visionBundles});

  factory AudioCatalog.fromJson(Map<String, dynamic> json) {
    final assets = [
      for (final raw in (json['assets'] as List).cast<Map<String, dynamic>>())
        SoulAudioAsset(
          id: raw['id'] as String,
          type: raw['type'] as String,
          delivery: _deliveryFromJson(raw['delivery'] as String),
          assetPath: raw['assetPath'] as String?,
          frequency: raw['frequency'] as String?,
          titles: {
            for (final entry
                in (raw['titles'] as Map<String, dynamic>? ?? {}).entries)
              SoulLocale.values.byName(entry.key): entry.value as String,
          },
          subtitles: {
            for (final entry
                in (raw['subtitles'] as Map<String, dynamic>? ?? {}).entries)
              SoulLocale.values.byName(entry.key): entry.value as String,
          },
          localePaths: {
            for (final entry
                in (raw['localePaths'] as Map<String, dynamic>? ?? {}).entries)
              SoulLocale.values.byName(entry.key): entry.value as String,
          },
        ),
    ];
    return AudioCatalog(
      assets: assets,
      visionBundles: [
        for (final raw
            in (json['visionBundles'] as List).cast<Map<String, dynamic>>())
          VisionAudioBundle(
            categoryCode: raw['categoryCode'] as String,
            guidedAudioId: raw['guidedAudioId'] as String,
            affirmationCollectionId: raw['affirmationCollectionId'] as String,
            soundIds: (raw['soundIds'] as List).cast<String>(),
          ),
      ],
    );
  }

  final List<SoulAudioAsset> assets;
  final List<VisionAudioBundle> visionBundles;

  SoulAudioAsset? asset(String id) =>
      assets.where((item) => item.id == id).firstOrNull;

  VisionAudioBundle? bundleFor(String categoryCode) =>
      visionBundles
          .where((item) => item.categoryCode == categoryCode)
          .firstOrNull;

  /// Returns the category-owned order. Pending assets stay visible to internal
  /// production tooling but are never eligible for playback.
  List<SoulAudioAsset> playableSoundsFor(String categoryCode) {
    final bundle = bundleFor(categoryCode);
    if (bundle == null) return const [];
    return [
      for (final id in bundle.soundIds)
        if (asset(id) case final item?
            when item.delivery == AudioDelivery.published)
          item,
    ];
  }

  SoulAudioAsset? playableGuidedFor(String categoryCode, SoulLocale locale) {
    final bundle = bundleFor(categoryCode);
    final item = bundle == null ? null : asset(bundle.guidedAudioId);
    if (item?.delivery != AudioDelivery.published ||
        item?.pathFor(locale) == null) {
      return null;
    }
    return item;
  }
}
