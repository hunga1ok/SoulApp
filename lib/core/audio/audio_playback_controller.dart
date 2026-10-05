import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// One player for the whole app. Every screen delegates playback here so mute
/// and pause behavior stay consistent.
final audioPlaybackProvider = ChangeNotifierProvider<AudioPlaybackController>(
  (ref) => AudioPlaybackController(),
);

class AudioPlaybackController extends ChangeNotifier {
  AudioPlayer? _player;
  String? _assetPath;
  bool _isPlaying = false;

  String? get assetPath => _assetPath;
  bool get isPlaying => _isPlaying;

  Future<AudioPlayer> _ensurePlayer() async {
    if (_player != null) return _player!;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    final player = AudioPlayer();
    player.playerStateStream.listen((state) {
      final playing =
          state.playing && state.processingState != ProcessingState.completed;
      if (playing != _isPlaying) {
        _isPlaying = playing;
        notifyListeners();
      }
    });
    _player = player;
    return player;
  }

  Future<void> toggleAsset(String path) async {
    final player = await _ensurePlayer();
    if (_assetPath == path && player.playing) {
      await player.pause();
      return;
    }
    if (_assetPath != path) {
      await player.setAsset(path);
      _assetPath = path;
    } else if (player.processingState == ProcessingState.completed) {
      await player.seek(Duration.zero);
    }
    // play() completes when playback stops, not when it starts.
    player.play();
  }

  Future<void> toggleFile(String path) async {
    final player = await _ensurePlayer();
    if (_assetPath == path && player.playing) {
      await player.pause();
      return;
    }
    if (_assetPath != path) {
      await player.setFilePath(path);
      _assetPath = path;
    } else if (player.processingState == ProcessingState.completed) {
      await player.seek(Duration.zero);
    }
    player.play();
  }

  Future<void> stop() async {
    await _player?.stop();
    _assetPath = null;
    _isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }
}
