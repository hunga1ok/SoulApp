import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/payment/paywall_gate_screen.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('PaywallGateScreen & Subscription Router Guard', () {
    testWidgets(
      'unsubscribed user who completed onboarding is blocked by PaywallGateScreen',
      (tester) async {
        final preferences = {
          'selected_locale': 'vi',
          'preferred_name': 'An',
          'onboarding_intentions': ['NURTURE_GRATITUDE'],
          'onboarding_reminders_decided': true,
          'onboarding_completed': true,
          'subscription_plan': 'free',
        };

        await pumpSoulApp(tester, preferences: preferences);

        // Paywall gate is visible, Today screen is blocked!
        expect(find.byType(PaywallGateScreen), findsOneWidget);
        expect(find.byType(TodayScreen), findsNothing);

        // User requested headline in Vietnamese
        expect(
          find.text('Tiếp tục nuôi dưỡng tâm hồn cùng Soul'),
          findsOneWidget,
        );
        expect(find.text('Gói Năm'), findsOneWidget);
        expect(find.text(r'$20 / năm'), findsOneWidget);
        expect(find.text('Gói Tháng'), findsOneWidget);
        expect(find.text(r'$2 / tháng'), findsOneWidget);
        expect(find.text('Gói Trọn Đời'), findsOneWidget);
        expect(find.text(r'$50 / trọn đời'), findsOneWidget);
        expect(
          find.text('28 không gian Góc nhỏ & âm thanh tần số chữa lành'),
          findsOneWidget,
        );
        expect(find.text('Tiếp tục hành trình'), findsOneWidget);
        expect(find.text('Đăng xuất'), findsOneWidget);
      },
    );

    testWidgets('in English, shows pure English copy with 0 Vietnamese text', (
      tester,
    ) async {
      final preferences = {
        'selected_locale': 'en',
        'preferred_name': 'An',
        'onboarding_intentions': ['NURTURE_GRATITUDE'],
        'onboarding_reminders_decided': true,
        'onboarding_completed': true,
        'subscription_plan': 'free',
      };

      await pumpSoulApp(tester, preferences: preferences);

      expect(find.byType(PaywallGateScreen), findsOneWidget);
      expect(
        find.text('Continue Nurturing Your Soul with Soul'),
        findsOneWidget,
      );
      expect(find.text('Yearly Plan'), findsOneWidget);
      expect(find.text(r'$20 / year'), findsOneWidget);
      expect(find.text('Monthly Plan'), findsOneWidget);
      expect(find.text(r'$2 / month'), findsOneWidget);
      expect(find.text('Lifetime Plan'), findsOneWidget);
      expect(find.text(r'$50 / lifetime'), findsOneWidget);
      expect(
        find.text('All 28 Little Corner sanctuaries & healing frequency audio'),
        findsOneWidget,
      );
      expect(find.text('Continue Journey'), findsOneWidget);
      expect(find.text('Restore Purchases on this device'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);

      // Verify Comfort Zone and Vietnamese text are absent
      expect(find.textContaining('Comfort Zone'), findsNothing);
      expect(find.text('Tiếp tục nuôi dưỡng tâm hồn cùng Soul'), findsNothing);
      expect(find.text('Gói Năm'), findsNothing);
      expect(find.text('Gói Tháng'), findsNothing);
      expect(find.text('Gói Trọn Đời'), findsNothing);
      expect(find.text('Tiếp tục hành trình'), findsNothing);
    });

    testWidgets(
      'tapping Continue Journey purchases plan and unlocks Today screen',
      (tester) async {
        final preferences = {
          'selected_locale': 'vi',
          'preferred_name': 'An',
          'onboarding_intentions': ['NURTURE_GRATITUDE'],
          'onboarding_reminders_decided': true,
          'onboarding_completed': true,
          'subscription_plan': 'free',
        };

        await pumpSoulApp(tester, preferences: preferences);

        expect(find.byType(PaywallGateScreen), findsOneWidget);

        // Scroll to CTA and tap
        await tester.ensureVisible(
          find.widgetWithText(SoulButton, 'Tiếp tục hành trình'),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(SoulButton, 'Tiếp tục hành trình'),
        );
        await tester.pumpAndSettle();

        // Paywall is dismissed, Today screen is unlocked!
        expect(find.byType(PaywallGateScreen), findsNothing);
        expect(find.byType(TodayScreen), findsOneWidget);
      },
    );
  });
}
