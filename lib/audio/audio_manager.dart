import '../ui/settings/game_settings.dart';

/// Centralized audio manager for billiards sound effects.
///
/// Uses in-memory tracking only — actual playback requires audio files
/// in assets/audio/. Until real .mp3/.wav files are added, all play
/// calls are no-ops logged to console in debug mode.
class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }

  bool get _enabled => GameSettings.instance.soundEnabled;
  double get _volume => GameSettings.instance.volume;

  void playCueHit({double power = 0.5}) {
    if (!_enabled) return;
    _log('cue_hit (power=${power.toStringAsFixed(2)}, vol=$_volume)');
  }

  void playBallCollision({double speed = 1.0}) {
    if (!_enabled) return;
    final vol = (_volume * (speed / 5.0).clamp(0.2, 1.0));
    _log('ball_collision (vol=${vol.toStringAsFixed(2)})');
  }

  void playBallPocketed() {
    if (!_enabled) return;
    _log('ball_pocketed (vol=$_volume)');
  }

  void playCushionHit({double speed = 1.0}) {
    if (!_enabled) return;
    _log('cushion_hit (vol=$_volume)');
  }

  void playFoul() {
    if (!_enabled) return;
    _log('foul (vol=$_volume)');
  }

  void _log(String event) {
    assert(() {
      // ignore: avoid_print
      print('[AudioManager] $event');
      return true;
    }());
  }
}
