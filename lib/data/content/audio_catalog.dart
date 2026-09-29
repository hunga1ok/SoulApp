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
    this.localePaths = const {},
  });

  final String id;
  final String type;
  final AudioDelivery delivery;
  final String? assetPath;
  final Map<SoulLocale, String> localePaths;

  bool get isGuided => localePaths.isNotEmpty;

  /// Guided voice can only resolve to the selected app language. Music and
  /// ambience are language-neutral and use [assetPath].
  String? pathFor(SoulLocale locale) =>
      isGuided ? localePaths[locale] : assetPath;
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
