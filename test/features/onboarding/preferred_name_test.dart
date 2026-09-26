import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  const cases = [
    (
      locale: SoulLocale.vi,
      question: 'Bạn muốn được gọi với tên là gì?',
      save: 'Lưu và tiếp tục',
      welcome: 'Chào An',
    ),
    (
      locale: SoulLocale.en,
      question: 'What would you like Soul to call you?',
      save: 'Save and continue',
      welcome: 'Welcome, An',
    ),
  ];

  for (final c in cases) {
    testWidgets('${c.locale.name}: empty names are rejected and names are '
        'trimmed', (tester) async {
      final prefs = await pumpSoulApp(
        tester,
        preferences: {
          'selected_locale': c.locale.name,
          'local_authenticated': true,
        },
      );

      expect(find.byType(PreferredNameScreen), findsOneWidget);
      expect(find.text(c.question), findsOneWidget);

      SoulButton saveButton() =>
          tester.widget<SoulButton>(find.widgetWithText(SoulButton, c.save));

      expect(saveButton().onPressed, isNull);

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();
      expect(saveButton().onPressed, isNull);

      await tester.enterText(find.byType(TextField), '  An  ');
      await tester.pump();
      expect(saveButton().onPressed, isNotNull);

      await tester.tap(find.text(c.save));
      await tester.pumpAndSettle();

      expect(prefs.getString('preferred_name'), 'An');
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.text(c.welcome), findsOneWidget);
    });
  }
}
