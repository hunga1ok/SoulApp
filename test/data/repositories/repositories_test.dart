import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/errors/api_exception.dart';
import 'package:soul_app/core/localization/soul_locale.dart';
import 'package:soul_app/data/api/api_client.dart';
import 'package:soul_app/data/local/credential_store.dart';
import 'package:soul_app/data/repositories/auth_repository.dart';
import 'package:soul_app/data/repositories/profile_repository.dart';

import '../../helpers/fake_soul_backend.dart';

void main() {
  late FakeSoulBackend backend;
  late CredentialStore credentials;
  late ApiClient client;
  late AuthRepository auth;
  late ProfileRepository profile;

  setUp(() {
    backend = FakeSoulBackend();
    FlutterSecureStorage.setMockInitialValues({});
    credentials = const CredentialStore(FlutterSecureStorage());
    client = ApiClient(fakeDio(backend), credentials);
    auth = AuthRepository(client, credentials);
    profile = ProfileRepository(client.dio);
  });

  group('AuthRepository', () {
    test('development login sends a stable per-install subject and the '
        'chosen locale, and stores the refresh token securely', () async {
      final me = await auth.signInForDevelopment(locale: SoulLocale.vi);
      await auth.signOut();
      await auth.signInForDevelopment(locale: SoulLocale.vi);

      expect(me.profile.preferredName, isNull);
      expect(me.googleDisplayName, 'Minh Anh');
      final [first, second] = backend.devLogins;
      expect(first['subject'], matches(RegExp(r'^[A-Za-z0-9_-]{8,64}$')));
      expect(second['subject'], first['subject']);
      expect(first['locale'], 'vi');
      expect(first.containsKey('name'), isFalse);
      expect(await credentials.readRefreshToken(), backend.currentRefreshToken);
    });

    test('maps the error envelope of a disabled development login', () async {
      backend.devLoginEnabled = false;

      await expectLater(
        auth.signInForDevelopment(locale: SoulLocale.en),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', ApiErrorCode.notFound)
              .having((e) => e.requestId, 'requestId', 'req-404'),
        ),
      );
      expect(await credentials.readRefreshToken(), isNull);
    });

    test('maps rate limiting on auth endpoints', () async {
      backend.failNext('POST /auth/dev', status: 429, code: 'RATE_LIMITED');

      await expectLater(
        auth.signInForDevelopment(locale: SoulLocale.en),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiErrorCode.rateLimited,
          ),
        ),
      );
    });

    test('sign-out revokes the session and clears credentials even when the '
        'server call fails', () async {
      await auth.signInForDevelopment(locale: SoulLocale.en);
      await auth.signOut();
      expect(backend.countOf('POST /auth/logout'), 1);
      expect(backend.currentRefreshToken, isNull);
      expect(await credentials.readRefreshToken(), isNull);

      await auth.signInForDevelopment(locale: SoulLocale.en);
      backend.offline = true;
      await auth.signOut();
      expect(client.accessToken, isNull);
      expect(await credentials.readRefreshToken(), isNull);
    });
  });

  group('ProfileRepository', () {
    setUp(() => auth.signInForDevelopment(locale: SoulLocale.en));

    test('PATCH sends only the changed fields and maps the response', () async {
      final me = await profile.updateProfile(preferredName: 'An');
      await profile.updateProfile(locale: SoulLocale.vi, audioEnabled: false);

      expect(me.profile.preferredName, 'An');
      expect(backend.profilePatches, [
        {'preferredName': 'An'},
        {'locale': 'vi', 'audioEnabled': false},
      ]);
      final fetched = await profile.fetchMe();
      expect(fetched.profile.locale, SoulLocale.vi);
      expect(fetched.profile.audioEnabled, isFalse);
    });

    test('maps validation and network failures', () async {
      backend.failNext(
        'PATCH /me/profile',
        status: 400,
        code: 'VALIDATION_FAILED',
      );
      await expectLater(
        profile.updateProfile(preferredName: 'x'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiErrorCode.validationFailed,
          ),
        ),
      );

      backend.offline = true;
      await expectLater(
        profile.fetchMe(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.code,
            'code',
            ApiErrorCode.network,
          ),
        ),
      );
    });
  });
}
