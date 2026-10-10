import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/localization/soul_locale.dart';
import 'package:soul_app/data/content/audio_catalog.dart';
import 'package:soul_app/data/content/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Vision audio mapping follows the owned-content manifest', () async {
    final catalog = await ContentRepository(rootBundle).audioCatalog();

    expect(catalog.visionBundles, hasLength(9));
    expect(catalog.bundleFor('PEACE')!.soundIds, ['SO-14', 'SO-09', 'SO-10']);
    expect(catalog.bundleFor('LOVE')!.guidedAudioId, 'GA-23');
  });

  test(
    'guided tracks retain separate native paths for all 6 locales',
    () async {
      final catalog = await ContentRepository(rootBundle).audioCatalog();
      for (final asset in catalog.assets.where((a) => a.isGuided)) {
        for (final locale in SoulLocale.values) {
          expect(
            asset.pathFor(locale),
            contains('/${locale.name}/'),
            reason: '${asset.id} should have native path for ${locale.name}',
          );
        }
      }
    },
  );

  test('unreviewed files are excluded from playback', () {
    const unreviewed = AudioCatalog(
      assets: [
        SoulAudioAsset(
          id: 'TEST-SOUND',
          type: 'music',
          delivery: AudioDelivery.pendingAsset,
          assetPath: 'assets/audio/music/test.m4a',
        ),
        SoulAudioAsset(
          id: 'TEST-GUIDED',
          type: 'guided',
          delivery: AudioDelivery.pendingAsset,
          localePaths: {
            SoulLocale.vi: 'assets/audio/guided/vi/test.m4a',
            SoulLocale.en: 'assets/audio/guided/en/test.m4a',
          },
        ),
      ],
      visionBundles: [
        VisionAudioBundle(
          categoryCode: 'TEST_CAT',
          guidedAudioId: 'TEST-GUIDED',
          affirmationCollectionId: 'AF-TEST',
          soundIds: ['TEST-SOUND'],
        ),
      ],
    );

    expect(unreviewed.playableSoundsFor('TEST_CAT'), isEmpty);
    expect(unreviewed.playableGuidedFor('TEST_CAT', SoulLocale.vi), isNull);
  });
}
