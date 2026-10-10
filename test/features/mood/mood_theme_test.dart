import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/features/mood/mood_theme_button.dart';
import 'package:soul_app/features/mood/mood_theme_switcher_sheet.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('Mood & Theme feature', () {
    testWidgets('default mood is peaceful and can be changed in AppState', (
      tester,
    ) async {
      final prefs = await pumpSoulApp(
        tester,
        preferences: onboardedPreferences(SoulLocale.vi),
      );

      // App bar has mood theme button next to sound button
      expect(find.byType(MoodThemeButton), findsOneWidget);
      expect(find.text('🕊️'), findsAtLeastNWidgets(1));

      // Open mood theme switcher sheet by tapping the top button
      await tester.tap(find.byType(MoodThemeButton));
      await tester.pumpAndSettle();

      expect(find.byType(MoodThemeSwitcherSheet), findsOneWidget);
      expect(find.text('Không gian cảm xúc & Giao diện'), findsOneWidget);

      // Choose "Biết ơn 🌸"
      await tester.tap(find.text('Biết ơn 🌸'));
      await tester.pumpAndSettle();

      // Sheet is closed and feedback toast appears
      expect(find.byType(MoodThemeSwitcherSheet), findsNothing);
      expect(
        find.textContaining(
          'Soul đã chuyển không gian sang sắc màu Biết ơn 🌸',
        ),
        findsOneWidget,
      );
      expect(prefs.getString('selected_mood_theme'), 'grateful');

      // Top button now shows 🌸
      expect(find.text('🌸'), findsAtLeastNWidgets(1));
    });

    testWidgets(
      'Home screen places home widget above small action and mood chips update theme',
      (tester) async {
        final prefs = await pumpSoulApp(
          tester,
          preferences: onboardedPreferences(SoulLocale.vi),
        );

        expect(find.byType(TodayScreen), findsOneWidget);

        // Find positions of "Widget màn hình chính" and "Một hành động nhỏ"
        final widgetFinder = find.text('Widget màn hình chính');
        final actionFinder = find.text('Một hành động nhỏ');

        await tester.scrollUntilVisible(widgetFinder, 200);
        await tester.pumpAndSettle();

        expect(widgetFinder, findsOneWidget);
        expect(actionFinder, findsOneWidget);

        final widgetTop = tester.getTopLeft(widgetFinder).dy;
        final actionTop = tester.getTopLeft(actionFinder).dy;

        // Widget màn hình chính MUST be placed ABOVE Một hành động nhỏ
        expect(
          widgetTop,
          lessThan(actionTop),
          reason: 'Widget màn hình chính must be above Một hành động nhỏ',
        );

        // Tap on "Năng lượng ☀️" chip in TodayScreen
        await tester.scrollUntilVisible(find.text('Năng lượng ☀️'), -200);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Năng lượng ☀️'));
        await tester.pumpAndSettle();

        expect(prefs.getString('selected_mood_theme'), 'energized');
        expect(
          find.textContaining(
            'Soul đã chuyển không gian sang sắc màu Năng lượng ☀️',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('mood theme in English locale localized properly', (
      tester,
    ) async {
      await pumpSoulApp(
        tester,
        preferences: onboardedPreferences(SoulLocale.en),
      );

      await tester.tap(find.byType(MoodThemeButton));
      await tester.pumpAndSettle();

      expect(find.text('Mood & Ambiance'), findsOneWidget);
      expect(find.text('Grateful 🌸'), findsOneWidget);

      await tester.tap(find.text('Grateful 🌸'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Soul tuned the ambiance to Grateful 🌸'),
        findsOneWidget,
      );
    });
  });
}
