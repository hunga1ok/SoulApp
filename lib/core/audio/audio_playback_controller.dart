import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// One player for the whole app. Every screen delegates playback here so mute
/// and pause behavior stay consistent across all features.
final audioPlaybackProvider = ChangeNotifierProvider<AudioPlaybackController>(
  (ref) => AudioPlaybackController(),
);

class AudioPlaybackController extends ChangeNotifier {
  static bool _sessionCachePurged = false;

  AudioPlayer? _player;
  String? _assetPath;
  String? _currentTitle;
  String? _currentSubtitle;
  bool _isAsset = true;
  bool _isPlaying = false;
  bool _isLooping = true;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  String? get assetPath => _assetPath;
  String? get currentTitle => _currentTitle;
  String? get currentSubtitle => _currentSubtitle;
  bool get isAsset => _isAsset;
  bool get isPlaying => _isPlaying;
  bool get isLooping => _isLooping;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get hasTrack => _assetPath != null;

  bool isCurrentTrack(String path) => _assetPath == path && _isPlaying;

  @visibleForTesting
  void setTrackForTesting({
    required String path,
    required String title,
    String? subtitle,
    bool isPlaying = true,
    Duration position = Duration.zero,
    Duration duration = const Duration(minutes: 3),
  }) {
    _assetPath = path;
    _currentTitle = title;
    _currentSubtitle = subtitle;
    _isPlaying = isPlaying;
    _position = position;
    _duration = duration;
    notifyListeners();
  }

  Future<AudioPlayer> _ensurePlayer() async {
    if (_player != null) return _player!;
    if (!_sessionCachePurged) {
      _sessionCachePurged = true;
      try {
        await AudioPlayer.clearAssetCache();
      } catch (_) {}
    }
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    final player = AudioPlayer();

    _playerStateSub = player.playerStateStream.listen((state) {
      final playing =
          state.playing && state.processingState != ProcessingState.completed;
      if (playing != _isPlaying) {
        _isPlaying = playing;
        notifyListeners();
      }
    });

    _positionSub = player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _durationSub = player.durationStream.listen((dur) {
      if (dur != null) {
        _duration = dur;
        notifyListeners();
      }
    });

    _player = player;
    return player;
  }

  Future<void> _safeSetAsset(AudioPlayer player, String path) async {
    // Evict any stale cached version of this asset so just_audio is forced to
    // extract the freshest audio binary directly from the application bundle.
    if (!kIsWeb) {
      try {
        final tempDir = await getTemporaryDirectory();
        final segments = Uri.parse(path).pathSegments;
        final cached = File(
          p.joinAll([tempDir.path, 'just_audio_cache', 'assets', ...segments]),
        );
        if (await cached.exists()) {
          await cached.delete();
        }
      } catch (e) {
        debugPrint('AudioPlaybackController: Cache evict note: $e');
      }
    }

    try {
      await player.setAsset(path);
    } catch (e) {
      debugPrint(
        'AudioPlaybackController: Failed to load asset "$path": $e. Clearing cache and retrying...',
      );
      try {
        await AudioPlayer.clearAssetCache();
      } catch (_) {}
      await player.setAsset(path);
    }
  }

  Future<void> playTrack({
    required String path,
    required String title,
    String? subtitle,
    bool isAsset = true,
    bool loop = true,
  }) async {
    try {
      final player = await _ensurePlayer();
      _isLooping = loop;
      await player.setLoopMode(loop ? LoopMode.one : LoopMode.off);

      if (_assetPath == path && player.playing) {
        await player.pause();
        return;
      }

      _currentTitle = title;
      _currentSubtitle = subtitle;
      _isAsset = isAsset;

      if (_assetPath != path) {
        _assetPath = path;
        if (isAsset) {
          await _safeSetAsset(player, path);
        } else {
          await player.setFilePath(path);
        }
      } else if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      notifyListeners();
      await player.play();
    } catch (e) {
      debugPrint('AudioPlaybackController.playTrack error: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> toggleAsset(
    String path, {
    String? title,
    String? subtitle,
    bool loop = true,
  }) async {
    try {
      final player = await _ensurePlayer();
      if (_assetPath == path && player.playing) {
        await player.pause();
        return;
      }

      _isAsset = true;
      _isLooping = loop;
      await player.setLoopMode(loop ? LoopMode.one : LoopMode.off);

      if (title != null) _currentTitle = title;
      if (subtitle != null) _currentSubtitle = subtitle;

      if (_assetPath != path) {
        await _safeSetAsset(player, path);
        _assetPath = path;
      } else if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      notifyListeners();
      await player.play();
    } catch (e) {
      debugPrint('AudioPlaybackController.toggleAsset error: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> toggleFile(
    String path, {
    String? title,
    String? subtitle,
    bool loop = false,
  }) async {
    try {
      final player = await _ensurePlayer();
      if (_assetPath == path && player.playing) {
        await player.pause();
        return;
      }

      _isAsset = false;
      _isLooping = loop;
      await player.setLoopMode(loop ? LoopMode.one : LoopMode.off);

      if (title != null) _currentTitle = title;
      if (subtitle != null) _currentSubtitle = subtitle;

      if (_assetPath != path) {
        await player.setFilePath(path);
        _assetPath = path;
      } else if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      notifyListeners();
      await player.play();
    } catch (e) {
      debugPrint('AudioPlaybackController.toggleFile error: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    if (_player == null) return;
    try {
      await _player!.pause();
    } catch (e) {
      debugPrint('AudioPlaybackController.pause error: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_player == null || _assetPath == null) return;
    try {
      if (_player!.playing) {
        await _player!.pause();
      } else {
        if (_player!.processingState == ProcessingState.completed) {
          await _player!.seek(Duration.zero);
        }
        await _player!.play();
      }
    } catch (e) {
      debugPrint('AudioPlaybackController.togglePlayPause error: $e');
    }
  }

  Future<void> seek(Duration position) async {
    if (_player == null) return;
    await _player!.seek(position);
  }

  Future<void> seekRelative(Duration delta) async {
    if (_player == null) return;
    final target = _position + delta;
    if (target < Duration.zero) {
      await _player!.seek(Duration.zero);
    } else if (target > _duration) {
      await _player!.seek(_duration);
    } else {
      await _player!.seek(target);
    }
  }

  Future<void> toggleLoop() async {
    if (_player == null) return;
    _isLooping = !_isLooping;
    await _player!.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  Future<void> stop() async {
    await _player?.stop();
    _assetPath = null;
    _currentTitle = null;
    _currentSubtitle = null;
    _isPlaying = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _player?.dispose();
    super.dispose();
  }
}
