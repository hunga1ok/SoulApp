import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/errors/api_exception.dart';
import 'package:soul_app/data/api/api_client.dart';
import 'package:soul_app/data/local/credential_store.dart';
import 'package:soul_app/features/auth/session_controller.dart';

import '../../helpers/fake_soul_backend.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeSoulBackend backend;

  Future<ProviderContainer> start(
    FakeSoulBackend fake, {
    Map<String, Object> preferences = const {},
  }) async {
    backend = fake;
    SharedPreferences.setMockInitialValues(preferences);
    FlutterSecureStorage.setMockInitialValues({...fake.storedCredentials});
    final container = ProviderContainer(
      overrides: [
        preferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        ),
        dioProvider.overrideWithValue(fakeDio(fake)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  SessionController controller(ProviderContainer c) =>
      c.read(sessionControllerProvider.notifier);

  Future<String?> storedRefreshToken(ProviderContainer c) =>
      c.read(credentialStoreProvider).readRefreshToken();

  group('restore on start', () {
    test('without a stored token the user is signed out and no request is '
        'made', () async {
      final c = await start(FakeSoulBackend());

      expect(await c.read(sessionControllerProvider.future), isNull);
      expect(backend.requests, isEmpty);
    });

    test('refreshes, then loads /me and caches the profile locale', () async {
      final c = await start(
        FakeSoulBackend.signedIn(locale: SoulLocale.vi),
        preferences: {'selected_locale': 'en'},
      );

      expect(c.read(sessionControllerProvider).isLoading, isTrue);
      final me = await c.read(sessionControllerProvider.future);

      expect(me?.profile.preferredName, 'An');
      expect(backend.requests, ['POST /auth/refresh', 'GET /me']);
      expect(c.read(appStateProvider).locale, SoulLocale.vi);
      expect(await storedRefreshToken(c), backend.currentRefreshToken);
    });

    test('a rejected token signs out and clears the credentials', () async {
      final fake = FakeSoulBackend.signedIn();
      final c = await start(fake);
      fake.revokeSessions();

      expect(await c.read(sessionControllerProvider.future), isNull);
      expect(await storedRefreshToken(c), isNull);
    });

    test(
      'a network failure is a retryable error that keeps the token',
      () async {
        final fake = FakeSoulBackend.signedIn()..offline = true;
        final c = await start(fake);
        final token = fake.currentRefreshToken;

        await expectLater(
          c.read(sessionControllerProvider.future),
          throwsA(
            isA<ApiException>().having(
              (e) => e.code,
              'code',
              ApiErrorCode.network,
            ),
          ),
        );
        expect(await storedRefreshToken(c), token);

        fake.offline = false;
        controller(c).retryRestore();
        expect((await c.read(sessionControllerProvider.future))?.id, isNotNull);
      },
    );

    test('a server-ended session later moves the app to signed out', () async {
      final c = await start(FakeSoulBackend.signedIn());
      await c.read(sessionControllerProvider.future);

      backend
        ..expireAccessToken()
        ..revokeSessions();
      await expectLater(
        controller(c).updateAudioEnabled(false),
        throwsA(isA<ApiException>()),
      );

      expect(c.read(sessionControllerProvider).value, isNull);
    });
  });

  group('sign-in', () {
    test('sends the gate locale and keeps it over a different stored '
        'profile locale', () async {
      final c = await start(
        FakeSoulBackend(),
        preferences: {'selected_locale': 'vi'},
      );
      await c.read(sessionControllerProvider.future);

      await controller(c).signInForDevelopment(SoulLocale.vi);
      expect(backend.devLogins.single['locale'], 'vi');
      expect(backend.profilePatches, isEmpty);

      await controller(c).signOut();
      expect(c.read(sessionControllerProvider).value, isNull);

      await controller(c).signInForDevelopment(SoulLocale.en);
      expect(backend.profilePatches, [
        {'locale': 'en'},
      ]);
      expect(
        c.read(sessionControllerProvider).value?.profile.locale,
        SoulLocale.en,
      );
    });
  });

  group('optimistic profile preferences', () {
    late ProviderContainer c;

    setUp(() async {
      c = await start(
        FakeSoulBackend.signedIn(locale: SoulLocale.en),
        preferences: {'selected_locale': 'en'},
      );
      await c.read(sessionControllerProvider.future);
    });

    test('locale switches immediately and is saved', () async {
      final future = controller(c).updateLocale(SoulLocale.vi);
      expect(c.read(appStateProvider).locale, SoulLocale.vi);
      expect(
        c.read(sessionControllerProvider).value?.profile.locale,
        SoulLocale.vi,
      );

      await future;
      expect(backend.profilePatches, [
        {'locale': 'vi'},
      ]);
      expect(backend.profile?['locale'], 'vi');
    });

    test('locale reverts when the save fails', () async {
      backend.failNext('PATCH /me/profile');

      await expectLater(
        controller(c).updateLocale(SoulLocale.vi),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiErrorCode.serviceUnavailable,
          ),
        ),
      );
      expect(c.read(appStateProvider).locale, SoulLocale.en);
      expect(
        c.read(sessionControllerProvider).value?.profile.locale,
        SoulLocale.en,
      );
    });

    test(
      'sound switches immediately and reverts when the save fails',
      () async {
        backend.failNext(
          'PATCH /me/profile',
          status: 429,
          code: 'RATE_LIMITED',
        );

        final future = controller(c).updateAudioEnabled(false);
        expect(
          c.read(sessionControllerProvider).value?.profile.audioEnabled,
          false,
        );
        await expectLater(future, throwsA(isA<ApiException>()));
        expect(
          c.read(sessionControllerProvider).value?.profile.audioEnabled,
          true,
        );

        await controller(c).updateAudioEnabled(false);
        expect(backend.profile?['audioEnabled'], false);
        expect(
          c.read(sessionControllerProvider).value?.profile.audioEnabled,
          false,
        );
      },
    );
  });
}
