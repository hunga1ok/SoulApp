import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/errors/api_exception.dart';
import 'package:soul_app/data/api/api_client.dart';
import 'package:soul_app/data/local/credential_store.dart';
import 'package:soul_app/data/repositories/profile_repository.dart';

import '../../helpers/fake_soul_backend.dart';

void main() {
  late FakeSoulBackend backend;
  late CredentialStore credentials;
  late ApiClient client;
  late ProfileRepository profile;
  late int sessionEndedCalls;

  /// Signs the client in with the backend's current session.
  Future<void> startSignedIn() async {
    backend = FakeSoulBackend.signedIn();
    FlutterSecureStorage.setMockInitialValues({...backend.storedCredentials});
    credentials = const CredentialStore(FlutterSecureStorage());
    client = ApiClient(fakeDio(backend), credentials);
    sessionEndedCalls = 0;
    client.onSessionEnded = () => sessionEndedCalls++;
    profile = ProfileRepository(client.dio);
    expect(await client.refreshAccessToken(), isNotNull);
    backend.requests.clear();
  }

  setUp(startSignedIn);

  test('attaches the access token as a Bearer header', () async {
    final me = await profile.fetchMe();

    expect(me.profile.preferredName, 'An');
    expect(backend.requests, ['GET /me']);
  });

  test('concurrent 401s share one refresh and each request retries once, '
      'and requests sent during the refresh wait for it', () async {
    backend.expireAccessToken();
    backend.refreshGate = Completer<void>();

    final first = List.generate(3, (_) => profile.fetchMe());
    // Let the three 401s arrive and the single refresh start.
    await pumpEventQueue();
    expect(backend.refreshCount, 1);
    expect(client.pendingRefresh, isNotNull);

    final queued = profile.fetchMe();
    await pumpEventQueue();
    backend.refreshGate!.complete();

    final results = await Future.wait([...first, queued]);
    expect(results, hasLength(4));
    expect(backend.refreshCount, 1);
    // 3 rejected + 3 retried + 1 queued request that never saw a 401.
    expect(backend.countOf('GET /me'), 7);
    expect(await credentials.readRefreshToken(), backend.currentRefreshToken);
    expect(sessionEndedCalls, 0);
  });

  test('a 401 that arrives after another request refreshed reuses the new '
      'token without a second refresh', () async {
    backend.expireAccessToken();
    // A request sent with the stale token whose 401 only arrives later.
    final release = backend.holdNext('GET /me');
    final delayed = profile.fetchMe();
    await pumpEventQueue();

    await profile.fetchMe();
    expect(backend.refreshCount, 1);

    release.complete();
    await delayed;
    expect(backend.refreshCount, 1);
    expect(backend.countOf('GET /me'), 4);
  });

  test('retries the original request only once', () async {
    backend.failNext('GET /me', status: 401, code: 'UNAUTHORIZED', times: 5);

    await expectLater(
      profile.fetchMe(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          ApiErrorCode.unauthorized,
        ),
      ),
    );
    expect(backend.countOf('GET /me'), 2);
    expect(backend.refreshCount, 1);
  });

  test('a rejected refresh clears credentials and ends the session without '
      'looping', () async {
    backend.revokeSessions();

    await expectLater(
      Future.wait([profile.fetchMe(), profile.fetchMe()]),
      throwsA(isA<ApiException>()),
    );
    expect(backend.refreshCount, 1);
    expect(sessionEndedCalls, 1);
    expect(client.accessToken, isNull);
    expect(await credentials.readRefreshToken(), isNull);

    // Later calls fail fast: no stored token means no further refresh.
    await expectLater(profile.fetchMe(), throwsA(isA<ApiException>()));
    expect(backend.refreshCount, 1);
    expect(sessionEndedCalls, 1);
  });

  test('a transient refresh failure keeps the credentials', () async {
    backend.expireAccessToken();
    backend.failNext('POST /auth/refresh');
    final storedToken = await credentials.readRefreshToken();

    await expectLater(
      profile.fetchMe(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.code,
          'code',
          ApiErrorCode.serviceUnavailable,
        ),
      ),
    );
    expect(await credentials.readRefreshToken(), storedToken);
    expect(sessionEndedCalls, 0);

    // The next call refreshes successfully with the kept token.
    await profile.fetchMe();
    expect(backend.refreshCount, 2);
  });

  test('always stores the rotated refresh token', () async {
    final before = await credentials.readRefreshToken();

    await client.refreshAccessToken();

    final after = await credentials.readRefreshToken();
    expect(after, isNot(before));
    expect(after, backend.currentRefreshToken);
  });
}
