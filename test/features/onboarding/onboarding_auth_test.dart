import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/onboarding/onboarding_auth_screen.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('OnboardingAuthScreen Flow', () {
    testWidgets(
      'user reaches OnboardingAuthScreen from welcome slides and can switch modes or continue as guest',
      (tester) async {
        await pumpSoulApp(tester, deviceLocales: const [Locale('vi', 'VN')]);

        expect(find.byType(LanguageGateScreen), findsOneWidget);
        expect(find.text('Đăng ký · Đăng nhập tài khoản'), findsOneWidget);

        // Tap Tiếp tục
        await tester.tap(find.widgetWithText(SoulButton, 'Tiếp tục'));
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeIntroScreen), findsOneWidget);

        // Slide 1 -> 2
        await tester.tap(find.widgetWithText(SoulButton, 'Tiếp tục'));
        await tester.pumpAndSettle();

        // Slide 2 -> 3
        await tester.tap(find.widgetWithText(SoulButton, 'Tiếp tục'));
        await tester.pumpAndSettle();

        // Slide 3 -> Tap Bắt đầu hành trình
        await tester.tap(find.widgetWithText(SoulButton, 'Bắt đầu hành trình'));
        await tester.pumpAndSettle();

        // Now on OnboardingAuthScreen
        expect(find.byType(OnboardingAuthScreen), findsOneWidget);
        expect(find.text('Tạo tài khoản Soul'), findsOneWidget);
        expect(find.text('Đăng ký'), findsOneWidget);
        expect(find.text('Đăng nhập'), findsOneWidget);
        expect(find.text('Đăng ký với Google'), findsOneWidget);
        expect(find.text('Đăng ký với Apple'), findsOneWidget);
        expect(find.text('Đăng ký bằng Email'), findsOneWidget);

        // Switch to Đăng nhập
        await tester.tap(find.text('Đăng nhập'));
        await tester.pumpAndSettle();

        expect(find.text('Chào mừng trở lại'), findsOneWidget);
        expect(find.text('Tiếp tục với Google'), findsOneWidget);
        expect(find.text('Tiếp tục với Apple'), findsOneWidget);
        expect(find.text('Đăng nhập bằng Email'), findsOneWidget);

        // Switch back to Đăng ký
        await tester.tap(find.text('Đăng ký'));
        await tester.pumpAndSettle();

        // Test email form validations
        await tester.tap(find.text('Đăng ký bằng Email'));
        await tester.pumpAndSettle();

        // Tap submit with empty fields
        await tester.tap(find.widgetWithText(SoulButton, 'Tạo tài khoản'));
        await tester.pumpAndSettle();
        expect(
          find.text('Vui lòng nhập địa chỉ email hợp lệ.'),
          findsOneWidget,
        );

        // Short password
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.at(0), 'soul@example.com');
        await tester.enterText(textFields.at(1), '123');
        await tester.tap(find.widgetWithText(SoulButton, 'Tạo tài khoản'));
        await tester.pumpAndSettle();
        expect(
          find.text('Mật khẩu phải có tối thiểu 6 ký tự.'),
          findsOneWidget,
        );

        // Mismatched confirmation password
        await tester.enterText(textFields.at(1), '123456');
        await tester.enterText(textFields.at(2), '654321');
        await tester.tap(find.widgetWithText(SoulButton, 'Tạo tài khoản'));
        await tester.pumpAndSettle();
        expect(find.text('Mật khẩu xác nhận không khớp.'), findsOneWidget);

        // Tap Continue as Guest
        await tester.tap(find.text('Để sau, tiếp tục với tư cách Khách'));
        await tester.pumpAndSettle();

        // Land on PreferredNameScreen
        expect(find.byType(PreferredNameScreen), findsOneWidget);
        expect(find.text('Bạn muốn Soul gọi bạn là gì?'), findsOneWidget);
      },
    );

    testWidgets(
      'top-right skip on WelcomeIntroScreen directly continues as guest to preferred name',
      (tester) async {
        await pumpSoulApp(tester, deviceLocales: const [Locale('vi', 'VN')]);

        await tester.tap(find.widgetWithText(SoulButton, 'Tiếp tục'));
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeIntroScreen), findsOneWidget);

        // Tap Bỏ qua
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        expect(find.byType(PreferredNameScreen), findsOneWidget);
      },
    );

    testWidgets(
      'in English locale, OnboardingAuthScreen shows English strings with no Vietnamese',
      (tester) async {
        await pumpSoulApp(tester, deviceLocales: const [Locale('en', 'US')]);

        // Dropdown default English -> tap Continue
        await tester.tap(find.widgetWithText(SoulButton, 'Continue'));
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeIntroScreen), findsOneWidget);

        // Slide 1 -> 2 -> 3
        await tester.tap(find.widgetWithText(SoulButton, 'Continue'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(SoulButton, 'Continue'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(SoulButton, 'Begin Journey'));
        await tester.pumpAndSettle();

        // OnboardingAuthScreen in English
        expect(find.byType(OnboardingAuthScreen), findsOneWidget);
        expect(find.text('Create your Soul account'), findsOneWidget);
        expect(find.text('Sign Up'), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);
        expect(find.text('Sign up with Google'), findsOneWidget);
        expect(find.text('Sign up with Apple'), findsOneWidget);
        expect(find.text('Sign up with Email'), findsOneWidget);
        expect(find.text('Maybe later (continue as guest)'), findsOneWidget);

        // No Vietnamese text
        expect(find.textContaining('Đăng ký'), findsNothing);
        expect(find.textContaining('Đăng nhập'), findsNothing);
        expect(find.textContaining('Tạo tài khoản'), findsNothing);
      },
    );
  });
}
