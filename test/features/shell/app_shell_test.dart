import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/features/explore/explore_screen.dart';
import 'package:soul_app/features/journal/journal_screen.dart';
import 'package:soul_app/features/profile/profile_screen.dart';
import 'package:soul_app/features/today/today_screen.dart';
import 'package:soul_app/features/vision/vision_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  const cases = [
    (
      locale: SoulLocale.vi,
      tabs: ['Hôm nay', 'Tầm nhìn', 'Nhật ký', 'Khám phá'],
      profile: 'Hồ sơ & cài đặt',
      back: 'Quay lại',
    ),
    (
      locale: SoulLocale.en,
      tabs: ['Today', 'Vision', 'Journal', 'Explore'],
      profile: 'Profile & settings',
      back: 'Back',
    ),
  ];

  for (final c in cases) {
    testWidgets('${c.locale.name}: four tabs navigate to their screens', (
      tester,
    ) async {
      await pumpSoulApp(tester, preferences: onboardedPreferences(c.locale));

      expect(find.byType(TodayScreen), findsOneWidget);
      for (final label in c.tabs) {
        expect(find.text(label), findsOneWidget);
      }

      final screens = [VisionScreen, JournalScreen, ExploreScreen, TodayScreen];
      final labels = [c.tabs[1], c.tabs[2], c.tabs[3], c.tabs[0]];
      for (var i = 0; i < screens.length; i++) {
        await tester.tap(find.text(labels[i]));
        await tester.pumpAndSettle();
        expect(find.byType(screens[i]), findsOneWidget);
      }
    });

    testWidgets('${c.locale.name}: avatar opens profile and back returns', (
      tester,
    ) async {
      await pumpSoulApp(tester, preferences: onboardedPreferences(c.locale));

      await tester.tap(find.byTooltip(c.profile));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      await tester.tap(find.byTooltip(c.back));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsNothing);
      expect(find.byType(TodayScreen), findsOneWidget);
    });
  }
}
