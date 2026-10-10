import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/onboarding/language_suggestion.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('suggestLocale', () {
    test('uses the first supported device language', () {
      expect(suggestLocale(const [Locale('vi', 'VN')]), SoulLocale.vi);
      expect(suggestLocale(const [Locale('en', 'GB')]), SoulLocale.en);
      expect(suggestLocale(const [Locale('ko', 'KR')]), SoulLocale.ko);
      expect(suggestLocale(const [Locale('ja', 'JP')]), SoulLocale.ja);
      expect(suggestLocale(const [Locale('fr', 'FR')]), SoulLocale.fr);
      expect(suggestLocale(const [Locale('zh', 'CN')]), SoulLocale.zh);
      expect(
        suggestLocale(const [Locale('es'), Locale('en'), Locale('vi')]),
        SoulLocale.en,
      );
    });

    test('returns no suggestion for unsupported languages', () {
      expect(suggestLocale(const [Locale('es'), Locale('de')]), isNull);
      expect(suggestLocale(const []), isNull);
    });
  });

  group('LanguageGateScreen', () {
    testWidgets('is the first route and shows a dropdown with endonyms', (
      tester,
    ) async {
      await pumpSoulApp(tester);

      expect(find.byType(LanguageGateScreen), findsOneWidget);
      expect(find.byType(DropdownButton<SoulLocale>), findsOneWidget);
      await tester.tap(find.byType(DropdownButton<SoulLocale>));
      await tester.pumpAndSettle();
      expect(find.text('Tiếng Việt'), findsWidgets);
      expect(find.text('English'), findsWidgets);
      expect(find.text('한국어'), findsWidgets);
      expect(find.text('日本語'), findsWidgets);
      expect(find.text('Français'), findsWidgets);
      expect(find.text('中文'), findsWidgets);
      expect(find.text('VI'), findsNothing);
      expect(find.text('EN'), findsNothing);
    });

    const cases = [
      (
        device: Locale('vi', 'VN'),
        suggested: SoulLocale.vi,
        selectLabel: 'English',
        continueLabel: 'Continue',
        stored: 'en',
      ),
      (
        device: Locale('en', 'US'),
        suggested: SoulLocale.en,
        selectLabel: 'Tiếng Việt',
        continueLabel: 'Tiếp tục',
        stored: 'vi',
      ),
      (
        device: Locale('ko', 'KR'),
        suggested: SoulLocale.ko,
        selectLabel: '한국어',
        continueLabel: '계속하기',
        stored: 'ko',
      ),
      (
        device: Locale('ja', 'JP'),
        suggested: SoulLocale.ja,
        selectLabel: '日本語',
        continueLabel: '続ける',
        stored: 'ja',
      ),
      (
        device: Locale('fr', 'FR'),
        suggested: SoulLocale.fr,
        selectLabel: 'Français',
        continueLabel: 'Continuer',
        stored: 'fr',
      ),
      (
        device: Locale('zh', 'CN'),
        suggested: SoulLocale.zh,
        selectLabel: '中文',
        continueLabel: '继续',
        stored: 'zh',
      ),
    ];

    for (final c in cases) {
      testWidgets(
        'device ${c.device} pre-selects ${c.suggested.name}; choosing ${c.selectLabel} '
        'and tapping ${c.continueLabel} commits ${c.stored}',
        (tester) async {
          final prefs = await pumpSoulApp(tester, deviceLocales: [c.device]);

          final dropdown = tester.widget<DropdownButton<SoulLocale>>(
            find.byType(DropdownButton<SoulLocale>),
          );
          expect(dropdown.value, c.suggested);
          // The suggestion alone never finalizes the locale.
          expect(prefs.getString('selected_locale'), isNull);

          await tester.tap(find.byType(DropdownButton<SoulLocale>));
          await tester.pumpAndSettle();
          await tester.tap(find.text(c.selectLabel).last);
          await tester.pumpAndSettle();

          await tester.tap(find.widgetWithText(SoulButton, c.continueLabel));
          await tester.pumpAndSettle();

          expect(prefs.getString('selected_locale'), c.stored);
          expect(find.byType(WelcomeIntroScreen), findsOneWidget);
        },
      );
    }

    testWidgets(
      'unsupported device language defaults dropdown without saving',
      (tester) async {
        final prefs = await pumpSoulApp(
          tester,
          deviceLocales: const [Locale('es', 'ES')],
        );

        expect(find.byType(DropdownButton<SoulLocale>), findsOneWidget);
        expect(prefs.getString('selected_locale'), isNull);
      },
    );
  });
}
