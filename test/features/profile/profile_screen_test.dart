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
      await tester.tap(find.text('Đăng xuất'));
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('Đăng xuất khỏi Soul?'), findsOneWidget);

      // Confirm sign out
      await tester.tap(find.widgetWithText(SoulButton, 'Đăng xuất'));
      await tester.pumpAndSettle();

      // Should be redirected to language gate screen!
      expect(find.text('Tiếng Việt'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
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
  });
}
