import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/data/content/audio_catalog.dart';
import 'package:soul_app/data/content/comfort_zone_catalog.dart';
import 'package:soul_app/data/repositories/comfort_zone_repository.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('ComfortZoneCatalog', () {
    late Map<String, Object?> rawComfortZoneJson;
    late Map<String, Object?> rawAudioJson;

    setUpAll(() {
      rawComfortZoneJson =
          jsonDecode(
                File('assets/content/comfort_zone.json').readAsStringSync(),
              )
              as Map<String, Object?>;
      rawAudioJson =
          jsonDecode(
                File('assets/content/audio_manifest.json').readAsStringSync(),
              )
              as Map<String, Object?>;
    });

    test('parses 4 categories and 28 scenes in Vietnamese and English', () {
      for (final locale in SoulLocale.values) {
        final catalog = ComfortZoneCatalog.fromJson(rawComfortZoneJson, locale);

        expect(catalog.categories, hasLength(4));
        expect(catalog.scenes, hasLength(28));

        expect(
          catalog.scenesForCategory('cozy_indoor').map((s) => s.numberBadge),
          ['01', '02', '03', '04', '05', '06', '07', '08', '26', '27'],
        );
        expect(
          catalog.scenesForCategory('nature_escape').map((s) => s.numberBadge),
          ['09', '10', '11', '12', '13', '14', '15'],
        );
        expect(
          catalog
              .scenesForCategory('little_companions')
              .map((s) => s.numberBadge),
          ['16', '17', '18', '19', '20'],
        );
        expect(
          catalog.scenesForCategory('dreamy_moments').map((s) => s.numberBadge),
          ['21', '22', '23', '24', '25', '28'],
        );

        for (final scene in catalog.scenes) {
          expect(scene.localizedTitle, isNotEmpty);
          expect(scene.bilingualSubheader, isNotEmpty);
          expect(scene.description, isNotEmpty);
          expect(scene.affirmation, isNotEmpty);
          expect(scene.soundIds, isNotEmpty);
          expect(scene.soundIds, contains(scene.primarySoundId));
        }
      }
    });

    test('maps every scene to published soundtracks and guided audio', () {
      final audioCatalog = AudioCatalog.fromJson(rawAudioJson);

      for (final locale in SoulLocale.values) {
        final comfortCatalog = ComfortZoneCatalog.fromJson(
          rawComfortZoneJson,
          locale,
        );

        for (final scene in comfortCatalog.scenes) {
          for (final soundId in scene.soundIds) {
            final track = audioCatalog.asset(soundId);
            expect(
              track,
              isNotNull,
              reason: 'Scene ${scene.id} references missing sound $soundId',
            );
            expect(track!.delivery, AudioDelivery.published);
            expect(track.pathFor(locale), isNotNull);
          }

          final guided = audioCatalog.asset(scene.guidedAudioId);
          expect(
            guided,
            isNotNull,
            reason:
                'Scene ${scene.id} references missing guided audio ${scene.guidedAudioId}',
          );
          expect(guided!.delivery, AudioDelivery.published);
          expect(guided.pathFor(locale), isNotNull);
        }
      }
    });
  });

  group('ComfortZonePreferencesNotifier', () {
    test('persists favorite scene IDs and last visited scene ID', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final notifier = ComfortZonePreferencesNotifier(prefs);

      expect(notifier.state.favoriteSceneIds, isEmpty);
      expect(notifier.state.lastVisitedSceneId, isNull);

      await notifier.toggleFavorite('cz_01');
      expect(notifier.state.isFavorite('cz_01'), isTrue);

      await notifier.markVisited('cz_03');
      expect(notifier.state.lastVisitedSceneId, 'cz_03');

      final reloaded = ComfortZonePreferencesNotifier(prefs);
      expect(reloaded.state.isFavorite('cz_01'), isTrue);
      expect(reloaded.state.lastVisitedSceneId, 'cz_03');

      await reloaded.toggleFavorite('cz_01');
      expect(reloaded.state.isFavorite('cz_01'), isFalse);
    });
  });

  group('Comfort Zone UI flow', () {
    testWidgets(
      'navigates from Explore to Comfort Zone hub and room in Vietnamese',
      (tester) async {
        await pumpSoulApp(
          tester,
          preferences: onboardedPreferences(SoulLocale.vi),
        );

        await tester.tap(find.text('Khám phá'));
        await tester.pumpAndSettle();

        expect(find.text('Comfort Zone'), findsOneWidget);
        await tester.tap(find.text('Comfort Zone'));
        await tester.pumpAndSettle();

        expect(find.text('A Little World Where You Feel Safe'), findsOneWidget);
        expect(
          find.text('Lazy Morning — Buổi sáng lười biếng'),
          findsOneWidget,
        );

        // Open scene 01 (Lazy Morning)
        await tester.tap(find.text('Lazy Morning — Buổi sáng lười biếng'));
        await tester.pumpAndSettle();

        expect(find.byType(DropdownButton<String>), findsOneWidget);

        // Toggle breathing guide
        await tester.tap(find.byIcon(Icons.air_rounded));
        await tester.pumpAndSettle();
        expect(find.text('Hít vào nhẹ nhàng...'), findsOneWidget);

        // Switch to next scene (02 - The Book Room)
        await tester.tap(find.byIcon(Icons.skip_next_rounded));
        await tester.pumpAndSettle();
        expect(
          find.text('The Book Room — Căn phòng của những cuốn sách'),
          findsOneWidget,
        );

        // Toggle Zen mode (hide UI)
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'supports English locale, category & favorite filters, and back navigation',
      (tester) async {
        await pumpSoulApp(
          tester,
          preferences: onboardedPreferences(SoulLocale.en),
          textScale: 1.2,
        );

        await tester.tap(find.text('Explore'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Comfort Zone'));
        await tester.pumpAndSettle();

        expect(find.text('A Little World Where You Feel Safe'), findsOneWidget);
        expect(find.text('All (28)'), findsOneWidget);

        // Toggle favorite on scene 01 (Lazy Morning)
        await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
        await tester.pumpAndSettle();

        // Filter by Favorites chip
        final favChip = find.textContaining('Favorites (1)');
        await tester.ensureVisible(favChip);
        await tester.pumpAndSettle();
        await tester.tap(favChip);
        await tester.pumpAndSettle();
        expect(find.text('Lazy Morning'), findsOneWidget);

        // Open scene 01 room and navigate back
        await tester.tap(find.text('Lazy Morning'));
        await tester.pumpAndSettle();
        expect(find.byType(DropdownButton<String>), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();
        expect(find.text('All (28)'), findsOneWidget);
      },
    );
  });
}
