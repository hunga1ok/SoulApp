import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/features/profile/profile_screen.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../helpers/soul_test_harness.dart';

void main() {
  testWidgets('a returning user opens straight to Today', (tester) async {
    await pumpSoulApp(tester, preferences: onboardedPreferences(SoulLocale.vi));

    expect(find.byType(TodayScreen), findsOneWidget);
    expect(find.text('Chào An'), findsOneWidget);
  });

  testWidgets('the sound toggle is saved on the device', (tester) async {
    final prefs = await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
    );

    await tester.tap(find.byTooltip('Sound on'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Sound off'), findsOneWidget);
    expect(prefs.getBool('sound_enabled'), isFalse);
  });

  testWidgets('a language change from Profile applies immediately and is '
      'saved on the device', (tester) async {
    final prefs = await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
    );

    await tester.tap(find.byTooltip('Profile & settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vietnamese'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Hồ sơ & cài đặt'), findsOneWidget);
    expect(prefs.getString('selected_locale'), 'vi');
  });
}
