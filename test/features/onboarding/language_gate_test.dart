import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/onboarding/language_suggestion.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';

import '../../helpers/soul_test_harness.dart';

SoulButtonVariant _variantOf(WidgetTester tester, String label) {
  return tester
      .widget<SoulButton>(find.widgetWithText(SoulButton, label))
      .variant;
}

void main() {
  group('suggestLocale', () {
    test('uses the first supported device language', () {
      expect(suggestLocale(const [Locale('vi', 'VN')]), SoulLocale.vi);
      expect(suggestLocale(const [Locale('en', 'GB')]), SoulLocale.en);
      expect(
        suggestLocale(const [Locale('fr'), Locale('en'), Locale('vi')]),
        SoulLocale.en,
      );
    });

    test('returns no suggestion for unsupported languages', () {
      expect(suggestLocale(const [Locale('fr'), Locale('ja')]), isNull);
      expect(suggestLocale(const []), isNull);
    });
  });

  group('LanguageGateScreen', () {
    testWidgets('is the first route and shows endonyms, not codes', (
      tester,
    ) async {
      await pumpSoulApp(tester);

      expect(find.byType(LanguageGateScreen), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('VI'), findsNothing);
      expect(find.text('EN'), findsNothing);
    });

    const cases = [
      (
        device: Locale('vi', 'VN'),
        suggested: 'Tiếng Việt',
        other: 'English',
        tap: 'English',
        stored: 'en',
      ),
      (
        device: Locale('en', 'US'),
        suggested: 'English',
        other: 'Tiếng Việt',
        tap: 'Tiếng Việt',
        stored: 'vi',
      ),
      (
        device: Locale('vi', 'VN'),
        suggested: 'Tiếng Việt',
        other: 'English',
        tap: 'Tiếng Việt',
        stored: 'vi',
      ),
      (
        device: Locale('en', 'US'),
        suggested: 'English',
        other: 'Tiếng Việt',
        tap: 'English',
        stored: 'en',
      ),
    ];

    for (final c in cases) {
      testWidgets(
        'device ${c.device} highlights ${c.suggested}; tapping ${c.tap} '
        'commits ${c.stored}',
        (tester) async {
          final prefs = await pumpSoulApp(tester, deviceLocales: [c.device]);

          expect(_variantOf(tester, c.suggested), SoulButtonVariant.primary);
          expect(_variantOf(tester, c.other), SoulButtonVariant.secondary);
          // The suggestion alone never finalizes the locale.
          expect(prefs.getString('selected_locale'), isNull);

          await tester.tap(find.text(c.tap));
          await tester.pumpAndSettle();

          expect(prefs.getString('selected_locale'), c.stored);
          expect(find.byType(PreferredNameScreen), findsOneWidget);
        },
      );
    }

    testWidgets('unsupported device language highlights nothing', (
      tester,
    ) async {
      final prefs = await pumpSoulApp(
        tester,
        deviceLocales: const [Locale('fr', 'FR')],
      );

      expect(_variantOf(tester, 'Tiếng Việt'), SoulButtonVariant.secondary);
      expect(_variantOf(tester, 'English'), SoulButtonVariant.secondary);
      expect(prefs.getString('selected_locale'), isNull);
    });
  });
}
