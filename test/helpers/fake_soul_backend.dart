import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:soul_app/core/localization/soul_locale.dart';

/// In-memory SoulApi for tests, plugged into Dio as its HTTP adapter. It
/// follows the v1 auth contract: rotating refresh tokens (a reused token
/// revokes the session family), Bearer-protected `/me`, and the error
/// envelope for every failure. No real network is used.
class FakeSoulBackend implements HttpClientAdapter {
  FakeSoulBackend({Map<String, dynamic>? user}) : _user = user;

  /// A user with a stored session (refresh token available to the app).
  factory FakeSoulBackend.signedIn({
    SoulLocale locale = SoulLocale.en,
    String? preferredName = 'An',
    String? googleDisplayName = 'An Nguyen',
    bool audioEnabled = true,
  }) {
    final backend = FakeSoulBackend(
      user: _userJson(
        locale: locale,
        preferredName: preferredName,
        googleDisplayName: googleDisplayName,
        audioEnabled: audioEnabled,
      ),
    );
    backend._issueTokens();
    return backend;
  }

  static const baseUrl = 'http://soul.test/v1';

  Map<String, dynamic>? _user;
  var _generation = 0;
  String? _accessToken;
  String? _refreshToken;
  final _usedRefreshTokens = <String>{};

  /// Name the dev login assigns to a new user as `googleDisplayName`.
  String? newUserDisplayName = 'Minh Anh';
  bool devLoginEnabled = true;

  /// While `true`, every request fails as if the device were offline.
  bool offline = false;

  /// While set, `POST /auth/refresh` waits for it before answering.
  Completer<void>? refreshGate;

  /// Every request as `METHOD /path`, in arrival order.
  final requests = <String>[];

  /// Bodies of `PATCH /me/profile`.
  final profilePatches = <Map<String, dynamic>>[];

  /// Bodies of `POST /auth/dev`.
  final devLogins = <Map<String, dynamic>>[];

  final _failures = <String, List<(int, String)>>{};
  final _holds = <String, Completer<void>>{};

  Map<String, dynamic>? get user => _user;
  Map<String, dynamic>? get profile =>
      _user?['profile'] as Map<String, dynamic>?;
  String? get currentRefreshToken => _refreshToken;
  int get refreshCount => countOf('POST /auth/refresh');
  int countOf(String request) => requests.where((r) => r == request).length;

  /// Values for `FlutterSecureStorage.setMockInitialValues`.
  Map<String, String> get storedCredentials => {
    if (_refreshToken != null) 'refresh_token': _refreshToken!,
  };

  /// Makes the app's in-memory access token stale, as after expiry.
  void expireAccessToken() => _accessToken = 'access-expired-$_generation';

  /// Revokes every session, e.g. after token theft detection.
  void revokeSessions() {
    _accessToken = null;
    _refreshToken = null;
  }

  /// Answers the next [times] `METHOD /path` requests with an error envelope.
  void failNext(
    String request, {
    int status = 503,
    String code = 'SERVICE_UNAVAILABLE',
    int times = 1,
  }) {
    _failures
        .putIfAbsent(request, () => [])
        .addAll(List.filled(times, (status, code)));
  }

  /// Holds the next `METHOD /path` request until the returned completer
  /// completes; it is then answered as if it arrived at that moment.
  Completer<void> holdNext(String request) =>
      _holds[request] = Completer<void>();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path.replaceFirst('/v1', '');
    final request = '${options.method} $path';
    requests.add(request);
    final hold = _holds.remove(request);
    if (hold != null) await hold.future;
    if (offline) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline (fake)',
      );
    }
    final failures = _failures[request];
    if (failures != null && failures.isNotEmpty) {
      final (status, code) = failures.removeAt(0);
      return _error(status, code);
    }
    final body = (options.data as Map?)?.cast<String, dynamic>() ?? {};
    switch (request) {
      case 'POST /auth/dev':
        if (!devLoginEnabled) return _error(404, 'NOT_FOUND');
        devLogins.add(body);
        _user ??= _userJson(
          locale: SoulLocale.tryParse(body['locale'] as String?)!,
          preferredName: null,
          googleDisplayName: newUserDisplayName,
          audioEnabled: true,
        );
        return _session();
      case 'POST /auth/refresh':
        await refreshGate?.future;
        final token = body['refreshToken'];
        if (token != null && token == _refreshToken) return _session();
        if (_usedRefreshTokens.contains(token)) revokeSessions();
        return _error(401, 'UNAUTHORIZED');
      case 'POST /auth/logout':
        if (body['refreshToken'] == _refreshToken) revokeSessions();
        return ResponseBody.fromString('', 204);
      case 'GET /me':
        if (!_authorized(options)) return _error(401, 'UNAUTHORIZED');
        return _json(200, _user);
      case 'PATCH /me/profile':
        if (!_authorized(options)) return _error(401, 'UNAUTHORIZED');
        profilePatches.add(body);
        profile!.addAll(body);
        return _json(200, _user);
    }
    return _error(404, 'NOT_FOUND');
  }

  @override
  void close({bool force = false}) {}

  bool _authorized(RequestOptions options) =>
      _accessToken != null &&
      options.headers['Authorization'] == 'Bearer $_accessToken';

  void _issueTokens() {
    if (_refreshToken != null) _usedRefreshTokens.add(_refreshToken!);
    _generation++;
    _accessToken = 'access-$_generation';
    _refreshToken = 'refresh-$_generation';
  }

  ResponseBody _session() {
    _issueTokens();
    return _json(200, {
      'accessToken': _accessToken,
      'accessTokenExpiresAt': '2026-09-26T10:15:00.000Z',
      'refreshToken': _refreshToken,
      'refreshTokenExpiresAt': '2026-10-26T10:00:00.000Z',
      'me': _user,
    });
  }

  static ResponseBody _json(int status, Object? body) {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  static ResponseBody _error(int status, String code) {
    return _json(status, {
      'error': {
        'code': code,
        'messageKey': 'errors.${code.toLowerCase()}',
        'message': 'Developer hint that must never reach the UI',
        'requestId': 'req-$status',
        'details': null,
      },
    });
  }

  static Map<String, dynamic> _userJson({
    required SoulLocale locale,
    required String? preferredName,
    required String? googleDisplayName,
    required bool audioEnabled,
  }) {
    return {
      'id': '6f1c1f5e-2d7e-4c55-9d7b-8a2f3f0b9c11',
      'role': 'user',
      'email': 'an@example.com',
      'googleDisplayName': googleDisplayName,
      'profile': {
        'preferredName': preferredName,
        'locale': locale.name,
        'audioEnabled': audioEnabled,
        'timezone': 'Asia/Ho_Chi_Minh',
        'onboardingCompletedAt': null,
      },
    };
  }
}

/// A Dio pointed at [backend], as the app's `dioProvider` would build it.
Dio fakeDio(FakeSoulBackend backend) {
  return Dio(BaseOptions(baseUrl: FakeSoulBackend.baseUrl))
    ..httpClientAdapter = backend;
}
