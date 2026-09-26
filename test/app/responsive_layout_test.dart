import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';
import 'package:soul_app/features/profile/profile_screen.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../helpers/soul_test_harness.dart';

const _viewports = [
  (size: smallPhone, textScale: 1.0),
  (size: smallPhone, textScale: 2.0),
  (size: standardPhone, textScale: 2.0),
  (size: Size(568, 320), textScale: 1.0), // small phone, landscape
];

String _describe(({Size size, double textScale}) v) =>
    '${v.size.width.toInt()}x${v.size.height.toInt()} @${v.textScale}x';

void main() {
  for (final locale in SoulLocale.values) {
    for (final viewport in _viewports) {
      final name = '${locale.name} ${_describe(viewport)}';

      testWidgets('$name: language gate does not overflow', (tester) async {
        await pumpSoulApp(
          tester,
          size: viewport.size,
          textScale: viewport.textScale,
          deviceLocales: [Locale(locale.name)],
        );
        expect(find.byType(LanguageGateScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$name: preferred name does not overflow with keyboard', (
        tester,
      ) async {
        await pumpSoulApp(
          tester,
          size: viewport.size,
          textScale: viewport.textScale,
          preferences: {'selected_locale': locale.name},
        );
        expect(find.byType(PreferredNameScreen), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Keyboard covering ~45% of the screen height.
        tester.view.viewInsets = FakeViewPadding(
          bottom: viewport.size.height * 0.45,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // The save action stays reachable above the keyboard by scrolling.
        await tester.enterText(find.byType(TextField), 'An');
        await tester.ensureVisible(find.byType(SoulButton));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(SoulButton));
        await tester.pumpAndSettle();
        expect(find.byType(PreferredNameScreen), findsNothing);
      });

      testWidgets('$name: shell tabs and profile do not overflow', (
        tester,
      ) async {
        await pumpSoulApp(
          tester,
          size: viewport.size,
          textScale: viewport.textScale,
          preferences: onboardedPreferences(locale),
        );
        expect(tester.takeException(), isNull);

        for (final icon in const [
          Icons.auto_awesome_outlined,
          Icons.menu_book_outlined,
          Icons.explore_outlined,
          Icons.wb_sunny_outlined,
        ]) {
          await tester.tap(
            find.descendant(
              of: find.byType(NavigationBar),
              matching: find.byIcon(icon),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        await tester.tap(find.byType(CircleAvatar));
        await tester.pumpAndSettle();
        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    final screens = <String, (Type, Map<String, Object>)>{
      'language gate': (LanguageGateScreen, const {}),
      'preferred name': (PreferredNameScreen, {'selected_locale': locale.name}),
      'shell': (TodayScreen, onboardedPreferences(locale)),
    };
    for (final MapEntry(key: screenName, value: (screen, preferences))
        in screens.entries) {
      testWidgets('${locale.name}: $screenName meets tap-target and label '
          'guidelines', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpSoulApp(
          tester,
          preferences: preferences,
          deviceLocales: [Locale(locale.name)],
        );
        expect(find.byType(screen), findsOneWidget);

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });
    }
  }
}
