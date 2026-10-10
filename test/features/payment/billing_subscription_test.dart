import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/features/payment/billing_subscription_screen.dart';
import 'package:soul_app/features/payment/payment_controller.dart';
import 'package:soul_app/features/profile/profile_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('Billing & Subscription Management', () {
    testWidgets(
      'navigating from Profile to BillingSubscriptionScreen shows plan details',
      (tester) async {
        final db = testDatabase();
        await pumpSoulApp(
          tester,
          database: db,
          preferences: {
            ...onboardedPreferences(SoulLocale.vi),
            'subscription_plan': 'yearly',
          },
        );

        // Open profile
        await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);

        // Find "Gói đăng ký & Thanh toán" setting row
        expect(find.text('Gói đăng ký & Thanh toán'), findsOneWidget);
        await tester.tap(find.text('Gói đăng ký & Thanh toán'));
        await tester.pumpAndSettle();

        // Should be on BillingSubscriptionScreen
        expect(find.byType(BillingSubscriptionScreen), findsOneWidget);
        expect(find.textContaining('Soul Premium'), findsAtLeastNWidgets(1));
        expect(find.text('Hủy tự động gia hạn gói'), findsOneWidget);
      },
    );

    testWidgets(
      'cancelling auto-renewal updates status and shows resume button',
      (tester) async {
        final db = testDatabase();
        await pumpSoulApp(
          tester,
          database: db,
          preferences: {
            ...onboardedPreferences(SoulLocale.vi),
            'subscription_plan': 'yearly',
          },
        );

        // Start 7-day trial
        final container = ProviderScope.containerOf(
          tester.element(find.byType(SoulApp)),
        );
        final controller = container.read(paymentControllerProvider.notifier);
        await controller.startTrial('yearly');
        await tester.pumpAndSettle();

        // Open profile
        await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
        await tester.pumpAndSettle();

        // Open billing screen
        await tester.tap(find.text('Gói đăng ký & Thanh toán'));
        await tester.pumpAndSettle();

        expect(find.text('DÙNG THỬ 7 NGÀY'), findsOneWidget);
        expect(find.text('Hủy tự động gia hạn gói'), findsOneWidget);

        // Tap Cancel button
        await tester.tap(find.text('Hủy tự động gia hạn gói'));
        await tester.pumpAndSettle();

        // Confirm dialog appears
        expect(find.text('Hủy tự động gia hạn gói?'), findsOneWidget);
        await tester.tap(find.text('Xác nhận hủy'));
        await tester.pumpAndSettle();

        // Now auto-renew is cancelled!
        expect(find.text('ĐÃ HỦY GIA HẠN'), findsOneWidget);
        expect(find.text('Kích hoạt lại gia hạn'), findsOneWidget);
        expect(find.text('Bật lại'), findsOneWidget);

        // Tap resume button
        await tester.tap(find.text('Bật lại'));
        await tester.pumpAndSettle();

        // Now it's active again!
        expect(find.text('Hủy tự động gia hạn gói'), findsOneWidget);
      },
    );

    testWidgets('switching plan changes subscription state', (tester) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: {
          ...onboardedPreferences(SoulLocale.vi),
          'subscription_plan': 'monthly',
        },
      );

      // Open profile
      await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
      await tester.pumpAndSettle();

      // Open billing screen
      await tester.tap(find.text('Gói đăng ký & Thanh toán'));
      await tester.pumpAndSettle();

      // Find switch to Yearly Plan
      expect(find.text('Gói Năm · Tiết kiệm 17%'), findsOneWidget);
      await tester.tap(find.widgetWithText(OutlinedButton, 'Chọn').first);
      await tester.pumpAndSettle();

      // Confirm dialog appears
      expect(find.textContaining('Chuyển sang Gói Năm'), findsOneWidget);
      await tester.tap(find.text('Chuyển gói'));
      await tester.pumpAndSettle();

      // Should show yearly plan
      expect(find.textContaining('Gói Năm'), findsAtLeastNWidgets(1));
    });

    testWidgets(
      'in English locale, shows English plan titles and prices with no mixed Vietnamese',
      (tester) async {
        final db = testDatabase();
        await pumpSoulApp(
          tester,
          database: db,
          preferences: {
            ...onboardedPreferences(SoulLocale.en),
            'subscription_plan': 'yearly',
          },
        );

        // Open profile
        await tester.tap(find.byTooltip('Profile & settings'));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);

        // Verify Membership card has English title: 'Soul Premium (Yearly Plan)'
        expect(find.text('Soul Premium (Yearly Plan)'), findsOneWidget);
        // Make sure no Vietnamese 'Gói Năm' exists
        expect(find.textContaining('Gói Năm'), findsNothing);

        // Verify Subscription & Billing row in English
        expect(find.text('Subscription & Billing'), findsOneWidget);
        expect(find.text('Yearly Plan'), findsAtLeastNWidgets(1));

        // Tap Subscription & Billing row
        await tester.tap(find.text('Subscription & Billing'));
        await tester.pumpAndSettle();

        expect(find.byType(BillingSubscriptionScreen), findsOneWidget);
        expect(find.text('Subscription & Billing'), findsOneWidget);
        expect(find.text('Cancel Auto-Renewal'), findsOneWidget);
        expect(find.text(r'$20 / year'), findsOneWidget);
        expect(find.text('Flexible Monthly Plan'), findsOneWidget);
        expect(find.text(r'$2 / month'), findsOneWidget);
        expect(find.text('Lifetime Access (Forever)'), findsOneWidget);
        expect(find.text(r'$50 / lifetime'), findsOneWidget);
        expect(find.text('Restore Purchases on this device'), findsOneWidget);

        // Zero Vietnamese text on screen
        expect(find.textContaining('Gói'), findsNothing);
        expect(find.textContaining('tháng'), findsNothing);
        expect(find.textContaining('năm'), findsNothing);
      },
    );

    testWidgets('in Korean locale, shows Korean plan titles and prices', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: {
          ...onboardedPreferences(SoulLocale.ko),
          'subscription_plan': 'yearly',
        },
      );

      // Open profile
      await tester.tap(find.byTooltip('프로필 & 설정'));
      await tester.pumpAndSettle();

      // Verify Membership card has Korean title: 'Soul Premium (연간 플랜)'
      expect(find.text('Soul Premium (연간 플랜)'), findsOneWidget);
      expect(find.textContaining('Gói Năm'), findsNothing);

      // Verify Subscription & Billing row in Korean
      expect(find.text('구독 및 결제 관리'), findsOneWidget);
      expect(find.text('연간 플랜'), findsAtLeastNWidgets(1));

      // Tap into billing
      await tester.tap(find.text('구독 및 결제 관리'));
      await tester.pumpAndSettle();

      expect(find.byType(BillingSubscriptionScreen), findsOneWidget);
      expect(find.text('구독 및 결제 관리'), findsOneWidget);
      expect(find.text(r'$20 / 년'), findsOneWidget);
      expect(find.text('구독 자동 갱신 취소'), findsOneWidget);
      expect(find.textContaining('Gói'), findsNothing);
    });

    testWidgets('lifetime plan hides cancel auto-renewal button', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: {
          ...onboardedPreferences(SoulLocale.en),
          'subscription_plan': 'lifetime',
        },
      );

      // Open profile
      await tester.tap(find.byTooltip('Profile & settings'));
      await tester.pumpAndSettle();

      expect(find.text('Soul Premium (Lifetime Plan)'), findsOneWidget);
      expect(find.text('Lifetime Access · Unlimited'), findsOneWidget);

      await tester.tap(find.text('Subscription & Billing'));
      await tester.pumpAndSettle();

      // Lifetime should not show cancel button
      expect(find.text('Cancel Auto-Renewal'), findsNothing);
      expect(find.text('LIFETIME'), findsOneWidget);
    });
  });
}
