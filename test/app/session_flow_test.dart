import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/features/auth/session_restore_screen.dart';
import 'package:soul_app/features/onboarding/onboarding_screens.dart';
import 'package:soul_app/features/profile/profile_screen.dart';
import 'package:soul_app/features/today/today_screen.dart';

import '../helpers/soul_test_harness.dart';

void main() {
  testWidgets('a stored session is restored on start and routes to Today', (
    tester,
  ) async {
    final backend = FakeSoulBackend.signedIn();
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      backend: backend,
    );

    expect(find.byType(TodayScreen), findsOneWidget);
    expect(backend.requests, ['POST /auth/refresh', 'GET /me']);
  });

  testWidgets('a restored user without a preferred name goes to the name '
      'screen', (tester) async {
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      backend: FakeSoulBackend.signedIn(preferredName: null),
    );

    expect(find.byType(PreferredNameScreen), findsOneWidget);
  });

  testWidgets('the profile locale wins over the cached one after restore', (
    tester,
  ) async {
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      backend: FakeSoulBackend.signedIn(locale: SoulLocale.vi),
    );

    expect(find.text('Chào An'), findsOneWidget);
  });

  testWidgets('a restore that cannot reach the server offers a retry', (
    tester,
  ) async {
    final backend = FakeSoulBackend.signedIn()..offline = true;
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      backend: backend,
    );

    expect(find.byType(SessionRestoreScreen), findsOneWidget);
    expect(
      find.text(
        "Soul can't connect right now. Check your connection and try again.",
      ),
      findsOneWidget,
    );

    backend.offline = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.byType(TodayScreen), findsOneWidget);
  });

  testWidgets('a revoked session on start returns to sign-in', (tester) async {
    final backend = FakeSoulBackend.signedIn();
    FlutterSecureStorage.setMockInitialValues({...backend.storedCredentials});
    backend.revokeSessions();
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      backend: backend,
    );

    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('sign-out revokes the session and returns to sign-in', (
    tester,
  ) async {
    final backend = FakeSoulBackend.signedIn();
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      backend: backend,
    );

    await tester.tap(find.byTooltip('Profile & settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
    expect(backend.countOf('POST /auth/logout'), 1);
    expect(backend.currentRefreshToken, isNull);
  });

  testWidgets('a failed sign-in shows a localized error', (tester) async {
    final backend =
        FakeSoulBackend()
          ..failNext('POST /auth/dev', status: 429, code: 'RATE_LIMITED');
    await pumpSoulApp(
      tester,
      preferences: {'selected_locale': 'vi'},
      backend: backend,
    );

    await tester.tap(find.text('Tiếp tục với Google'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
    expect(
      find.text('Bạn đã thử quá nhiều lần. Chờ một chút rồi thử lại nhé.'),
      findsOneWidget,
    );
  });

  group('optimistic preferences', () {
    testWidgets('sound reverts with a localized message when saving fails', (
      tester,
    ) async {
      final backend = FakeSoulBackend.signedIn();
      await pumpSoulApp(
        tester,
        preferences: onboardedPreferences(SoulLocale.en),
        backend: backend,
      );

      backend.failNext('PATCH /me/profile');
      await tester.tap(find.byTooltip('Sound on'));
      await tester.pumpAndSettle();

      expect(
        find.text('Soul is briefly unavailable. Please try again soon.'),
        findsOneWidget,
      );
      expect(find.byTooltip('Sound on'), findsOneWidget);

      await tester.tap(find.byTooltip('Sound on'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Sound off'), findsOneWidget);
      expect(backend.profile?['audioEnabled'], isFalse);
    });

    testWidgets('language changes immediately, is saved, and reverts when '
        'saving fails', (tester) async {
      final backend = FakeSoulBackend.signedIn();
      await pumpSoulApp(
        tester,
        preferences: onboardedPreferences(SoulLocale.en),
        backend: backend,
      );
      await tester.tap(find.byTooltip('Profile & settings'));
      await tester.pumpAndSettle();

      backend.failNext('PATCH /me/profile');
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vietnamese'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Profile & settings'), findsOneWidget);

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vietnamese'));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Hồ sơ & cài đặt'), findsOneWidget);
      expect(backend.profile?['locale'], 'vi');
    });
  });
}
