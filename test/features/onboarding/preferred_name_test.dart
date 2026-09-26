import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';
import 'package:soul_app/features/onboarding/preferred_name_controller.dart';
import 'package:soul_app/features/profile/profile_screen.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('validatePreferredName', () {
    test('trims and accepts 1 to 50 code points', () {
      expect(validatePreferredName('   '), PreferredNameIssue.empty);
      expect(validatePreferredName(''), PreferredNameIssue.empty);
      expect(validatePreferredName('  An  '), isNull);
      expect(validatePreferredName('Ngọc Ánh'), isNull);
      expect(validatePreferredName('a' * 50), isNull);
      expect(validatePreferredName(' ${'a' * 50} '), isNull);
      expect(validatePreferredName('a' * 51), PreferredNameIssue.tooLong);
    });
  });

  const cases = [
    (
      locale: SoulLocale.vi,
      google: 'Tiếp tục với Google',
      question: 'Bạn muốn được gọi với tên là gì?',
      save: 'Lưu và tiếp tục',
      tooLong: 'Tên tối đa 50 ký tự thôi nhé.',
      error: 'Soul đang tạm gián đoạn. Bạn thử lại sau ít phút nhé.',
      retry: 'Thử lại',
      welcome: 'Chào An',
    ),
    (
      locale: SoulLocale.en,
      google: 'Continue with Google',
      question: 'What would you like Soul to call you?',
      save: 'Save and continue',
      tooLong: 'Please keep it to 50 characters or fewer.',
      error: 'Soul is briefly unavailable. Please try again soon.',
      retry: 'Try again',
      welcome: 'Welcome, An',
    ),
  ];

  SoulButton buttonWithLabel(WidgetTester tester, String label) =>
      tester.widget<SoulButton>(find.widgetWithText(SoulButton, label));

  for (final c in cases) {
    testWidgets('${c.locale.name}: first sign-in asks for a name, suggests the '
        'Google name without saving it, validates and saves the trimmed '
        'name', (tester) async {
      final backend = FakeSoulBackend();
      await pumpSoulApp(
        tester,
        preferences: {'selected_locale': c.locale.name},
        backend: backend,
      );

      await tester.tap(find.text(c.google));
      await tester.pumpAndSettle();

      expect(backend.devLogins.single['locale'], c.locale.name);
      expect(find.byType(PreferredNameScreen), findsOneWidget);
      expect(find.text(c.question), findsOneWidget);
      // The Google name is only a suggestion: prefilled, never saved.
      expect(find.widgetWithText(TextField, 'Minh Anh'), findsOneWidget);
      expect(backend.profilePatches, isEmpty);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();
      expect(buttonWithLabel(tester, c.save).onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'a' * 51);
      await tester.pump();
      expect(find.text(c.tooLong), findsOneWidget);
      expect(buttonWithLabel(tester, c.save).onPressed, isNull);

      await tester.enterText(find.byType(TextField), '  An  ');
      await tester.pump();
      expect(find.text(c.tooLong), findsNothing);
      await tester.tap(find.text(c.save));
      await tester.pumpAndSettle();

      expect(backend.profilePatches, [
        {'preferredName': 'An'},
      ]);
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.text(c.welcome), findsOneWidget);
    });

    testWidgets('${c.locale.name}: a failed save shows a localized error and '
        'can be retried', (tester) async {
      final backend = FakeSoulBackend.signedIn(
        locale: c.locale,
        preferredName: null,
      );
      await pumpSoulApp(
        tester,
        preferences: {'selected_locale': c.locale.name},
        backend: backend,
      );
      expect(find.byType(PreferredNameScreen), findsOneWidget);
      expect(find.widgetWithText(TextField, 'An Nguyen'), findsOneWidget);

      backend.failNext('PATCH /me/profile');
      await tester.enterText(find.byType(TextField), 'An');
      await tester.tap(find.text(c.save));
      await tester.pumpAndSettle();

      expect(find.text(c.error), findsOneWidget);
      expect(find.byType(PreferredNameScreen), findsOneWidget);
      expect(backend.profile?['preferredName'], isNull);

      await tester.tap(find.widgetWithText(SoulButton, c.retry));
      await tester.pumpAndSettle();

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.text(c.welcome), findsOneWidget);
    });
  }

  testWidgets('the name can be edited later from Profile', (tester) async {
    final backend = FakeSoulBackend.signedIn();
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      backend: backend,
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

    expect(backend.profilePatches, [
      {'preferredName': 'Bình'},
    ]);
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Bình'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Bình'), findsOneWidget);
  });
}
