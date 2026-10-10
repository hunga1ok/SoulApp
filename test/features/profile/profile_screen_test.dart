import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/profile/profile_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('shows sign out and resets session when confirmed', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.vi),
      );

      // Open profile from avatar button
      await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);

      // Tap Sign out row
      await tester.scrollUntilVisible(find.text('Đăng xuất'), 100);
      await tester.tap(find.text('Đăng xuất'));
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('Đăng xuất khỏi Soul?'), findsOneWidget);

      // Confirm sign out
      await tester.tap(find.widgetWithText(SoulButton, 'Đăng xuất'));
      await tester.pumpAndSettle();

      // Should be redirected to language gate screen!
      expect(find.byType(DropdownButton<SoulLocale>), findsOneWidget);
    });

    testWidgets('allows viewing and updating reminder times', (tester) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.vi),
      );

      // Open profile
      await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
      await tester.pumpAndSettle();

      // Tap 'Giờ gửi thông báo'
      expect(find.text('Giờ gửi thông báo'), findsOneWidget);
      await tester.tap(find.text('Giờ gửi thông báo'));
      await tester.pumpAndSettle();

      // Reminder settings screen
      expect(
        find.text(
          'Soul sẽ gửi lời nhắc nhẹ nhàng vào những thời điểm bạn chọn.',
        ),
        findsOneWidget,
      );
      expect(find.text('Nhắc nhở buổi sáng'), findsOneWidget);
      expect(find.text('Nhìn lại buổi tối'), findsOneWidget);
      expect(find.text('Lưu thay đổi'), findsOneWidget);

      // Tap save
      await tester.tap(find.text('Lưu thay đổi'));
      await tester.pumpAndSettle();

      // Back on profile screen
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('switching language in Profile updates AppLocalizations', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.vi),
      );

      await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
      await tester.pumpAndSettle();

      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(find.byType(DropdownButton<SoulLocale>), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<SoulLocale>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('한국어').last);
      await tester.pumpAndSettle();

      expect(find.text('프로필 & 설정'), findsOneWidget);
      expect(find.text('이름 수정'), findsOneWidget);
      expect(find.text('언어'), findsOneWidget);
    });

    testWidgets(
      'opens HomeWidgetScreen and syncs widget mode and theme to preferences',
      (tester) async {
        final db = testDatabase();
        final prefs = await pumpSoulApp(
          tester,
          database: db,
          preferences: onboardedPreferences(SoulLocale.vi),
        );

        await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
        await tester.pumpAndSettle();

        expect(find.text('Widget màn hình chính'), findsOneWidget);
        await tester.tap(find.text('Widget màn hình chính'));
        await tester.pumpAndSettle();

        expect(find.text('Nội dung hiển thị trên Widget'), findsOneWidget);
        expect(find.text('Góc nhỏ'), findsOneWidget);
        expect(find.text('Âm thanh & Tần số'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Thực hành biết ơn'),
          120,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.tap(find.text('Thực hành biết ơn'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Giấy Kem Ấm'),
          120,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.tap(find.text('Giấy Kem Ấm'));
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.text('Cập nhật dữ liệu Widget'),
          200,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.tap(find.text('Cập nhật dữ liệu Widget'));
        await tester.pumpAndSettle();

        expect(prefs.getString('widget_mode'), 'gratitude');
        expect(prefs.getString('widget_theme'), 'paper');
        expect(prefs.getString('widget_body'), isNotEmpty);
      },
    );

    testWidgets(
      'Setting row with trailing widget (Plans & Billing) aligns chevron to right edge',
      (tester) async {
        await pumpSoulApp(
          tester,
          preferences: onboardedPreferences(SoulLocale.vi),
        );

        // Navigate to profile
        await tester.tap(find.byTooltip('Hồ sơ & cài đặt'));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);

        final billingRowFinder = find.widgetWithText(
          InkWell,
          'Gói & Thanh toán',
        );
        final editNameRowFinder = find.widgetWithText(
          InkWell,
          'Đổi tên xưng hô',
        );

        expect(billingRowFinder, findsOneWidget);
        expect(editNameRowFinder, findsOneWidget);

        // Find chevron icon inside billing row and inside edit name row
        final billingChevron = find.descendant(
          of: billingRowFinder,
          matching: find.byIcon(Icons.chevron_right),
        );
        final editNameChevron = find.descendant(
          of: editNameRowFinder,
          matching: find.byIcon(Icons.chevron_right),
        );

        expect(billingChevron, findsOneWidget);
        expect(editNameChevron, findsOneWidget);

        final billingChevronRight = tester.getTopRight(billingChevron).dx;
        final editNameChevronRight = tester.getTopRight(editNameChevron).dx;

        // Both chevrons MUST have the exact same right alignment (not indented inward)
        expect(
          billingChevronRight,
          equals(editNameChevronRight),
          reason:
              'Billing row chevron must align to the far right, matching other setting rows',
        );
      },
    );
  });
}
