import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';
import 'package:soul_app/features/onboarding/preferred_name_validation.dart';
import 'package:soul_app/features/profile/profile_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('validatePreferredName', () {
    test('trims and accepts 1 to 40 code points', () {
      expect(validatePreferredName('   '), PreferredNameIssue.empty);
      expect(validatePreferredName(''), PreferredNameIssue.empty);
      expect(validatePreferredName('  An  '), isNull);
      expect(validatePreferredName('Ngọc Ánh'), isNull);
      expect(validatePreferredName('a' * 40), isNull);
      expect(validatePreferredName(' ${'a' * 40} '), isNull);
      expect(validatePreferredName('a' * 41), PreferredNameIssue.tooLong);
    });
  });

  const cases = [
    (
      locale: SoulLocale.vi,
      language: 'Tiếng Việt',
      question: 'Bạn muốn Soul gọi bạn là gì?',
      save: 'Lưu và tiếp tục',
      tooLong: 'Tên tối đa 40 ký tự thôi nhé.',
    ),
    (
      locale: SoulLocale.en,
      language: 'English',
      question: 'What should Soul call you?',
      save: 'Save and continue',
      tooLong: 'Please keep it to 40 characters or fewer.',
    ),
  ];

  SoulButton buttonWithLabel(WidgetTester tester, String label) =>
      tester.widget<SoulButton>(find.widgetWithText(SoulButton, label));

  for (final c in cases) {
    testWidgets('${c.locale.name}: the language choice leads to the name '
        'question, which validates and saves the trimmed name on the '
        'device', (tester) async {
      final prefs = await pumpSoulApp(tester);

      await tester.tap(find.byType(DropdownButton<SoulLocale>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(c.language).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SoulButton));
      await tester.pumpAndSettle();

      if (find.byType(WelcomeIntroScreen).evaluate().isNotEmpty) {
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
      }

      expect(find.byType(PreferredNameScreen), findsOneWidget);
      expect(find.text(c.question), findsOneWidget);
      expect(find.widgetWithText(TextField, ''), findsOneWidget);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();
      expect(buttonWithLabel(tester, c.save).onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'a' * 41);
      await tester.pump();
      expect(find.text(c.tooLong), findsOneWidget);
      expect(buttonWithLabel(tester, c.save).onPressed, isNull);

      await tester.enterText(find.byType(TextField), '  An  ');
      await tester.pump();
      expect(find.text(c.tooLong), findsNothing);
      await tester.tap(find.text(c.save));
      await tester.pumpAndSettle();

      expect(prefs.getString('preferred_name'), 'An');
      expect(find.byType(IntentionScreen), findsOneWidget);
    });
  }

  testWidgets('a relaunch before the name is saved resumes at the name '
      'question', (tester) async {
    await pumpSoulApp(tester, preferences: {'selected_locale': 'en'});

    expect(find.byType(PreferredNameScreen), findsOneWidget);
  });

  testWidgets('the name can be edited later from Profile', (tester) async {
    final prefs = await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
    );

    await tester.tap(find.byTooltip('Profile & settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit preferred name'));
    await tester.pumpAndSettle();

    expect(find.byType(PreferredNameScreen), findsOneWidget);
    expect(find.widgetWithText(TextField, 'An'), findsOneWidget);

    await tester.enterText(find.byType(TextField), ' Bình ');
    await tester.tap(find.widgetWithText(SoulButton, 'Save'));
    await tester.pumpAndSettle();

    expect(prefs.getString('preferred_name'), 'Bình');
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Bình'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Bình'), findsOneWidget);
  });
}
