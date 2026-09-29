import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/localization/soul_locale.dart';
import 'package:soul_app/data/content/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Vision audio mapping follows the owned-content manifest', () async {
    final catalog = await ContentRepository(rootBundle).audioCatalog();

    expect(catalog.visionBundles, hasLength(9));
    expect(catalog.bundleFor('PEACE')!.soundIds, ['SO-14', 'SO-09', 'SO-10']);
    expect(catalog.bundleFor('LOVE')!.guidedAudioId, 'GA-23');
  });

  test('guided tracks retain separate Vietnamese and English paths', () async {
    final catalog = await ContentRepository(rootBundle).audioCatalog();
    final guided = catalog.asset('GA-31')!;

    expect(guided.pathFor(SoulLocale.vi), contains('/vi/'));
    expect(guided.pathFor(SoulLocale.en), contains('/en/'));
    expect(guided.pathFor(SoulLocale.vi), isNot(guided.pathFor(SoulLocale.en)));
  });

  test('unreviewed files are excluded from playback', () async {
    final catalog = await ContentRepository(rootBundle).audioCatalog();

    expect(catalog.playableSoundsFor('PEACE'), isEmpty);
    expect(catalog.playableGuidedFor('PEACE', SoulLocale.vi), isNull);
  });
}
