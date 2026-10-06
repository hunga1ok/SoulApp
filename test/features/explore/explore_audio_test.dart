import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/audio/audio_playback_controller.dart';
import 'package:soul_app/core/design_system/components/soul_mini_player.dart';
import 'package:soul_app/features/explore/explore_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  testWidgets('ExploreScreen audio tab displays Soul Audio and sub-filters', (
    tester,
  ) async {
    await pumpSoulApp(tester, preferences: onboardedPreferences(SoulLocale.vi));

    // Navigate to Explore tab
    await tester.tap(find.text('Khám phá'));
    await tester.pumpAndSettle();
    expect(find.byType(ExploreScreen), findsOneWidget);

    // Tap Soul Audio tab chip
    await tester.tap(find.text('Âm thanh Soul'));
    await tester.pumpAndSettle();

    // Verify sub-category filter chips exist (both main tab and sub-filter have "Tất cả")
    expect(find.text('Tất cả'), findsNWidgets(2));
    expect(find.text('Nhạc & Tần số'), findsOneWidget);
    expect(find.text('Thiên nhiên & Thư giãn'), findsOneWidget);
    expect(find.text('Bài dẫn thiền'), findsOneWidget);

    // Verify first track appears
    expect(find.text('Mưa bên cửa sổ'), findsOneWidget);

    // Filter to Music & Frequencies
    await tester.tap(find.text('Nhạc & Tần số'));
    await tester.pumpAndSettle();

    expect(find.text('Piano ấm áp'), findsOneWidget);
    expect(find.text('Mưa bên cửa sổ'), findsNothing);

    // Filter to Nature & Ambience
    await tester.ensureVisible(find.text('Thiên nhiên & Thư giãn'));
    await tester.tap(find.text('Thiên nhiên & Thư giãn'));
    await tester.pumpAndSettle();

    expect(find.text('Mưa bên cửa sổ'), findsOneWidget);
    expect(find.text('Piano ấm áp'), findsNothing);

    // Filter to Guided Meditations
    await tester.ensureVisible(find.text('Bài dẫn thiền'));
    await tester.tap(find.text('Bài dẫn thiền'));
    await tester.pumpAndSettle();

    expect(find.text('1 phút tái tạo'), findsOneWidget);
    expect(find.text('Mưa bên cửa sổ'), findsNothing);
  });

  testWidgets('MiniPlayer displays and controls active audio on shell', (
    tester,
  ) async {
    await pumpSoulApp(tester, preferences: onboardedPreferences(SoulLocale.vi));

    final element = tester.element(find.byType(SoulMiniPlayer));
    final container = ProviderScope.containerOf(element);
    final audio = container.read(audioPlaybackProvider);

    // Initially, no track is loaded, mini player is hidden
    expect(find.byType(SoulMiniPlayer), findsOneWidget);
    expect(find.text('Piano ấm áp'), findsNothing);

    // Set active track for testing
    audio.setTrackForTesting(
      path: 'assets/audio/music/so-11-warm-felt-piano.m4a',
      title: 'Piano ấm áp',
      subtitle: 'Nhạc tĩnh lặng & Tần số',
    );
    await tester.pumpAndSettle();

    // MiniPlayer is now visible with track details
    expect(find.text('Piano ấm áp'), findsOneWidget);
    expect(find.text('Nhạc tĩnh lặng & Tần số'), findsOneWidget);

    // Tap stop button to dismiss
    final stopButton = find.byTooltip('Dừng');
    expect(stopButton, findsOneWidget);
    await tester.tap(stopButton);
    await tester.pumpAndSettle();

    // Track is cleared
    expect(audio.hasTrack, isFalse);
    expect(find.text('Piano ấm áp'), findsNothing);
  });
}
