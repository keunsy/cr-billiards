import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../ui/settings/game_settings.dart';

class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  bool _initialized = false;
  bool _initFailed = false;
  AudioPool? _cueHitPool;
  AudioPool? _ballCollisionPool;
  AudioPool? _cushionHitPool;

  final Map<String, int> _lastPlayTime = {};
  static const int _collisionThrottleMs = 120;
  static const int _defaultThrottleMs = 80;

  int _activePoolPlays = 0;
  static const int _maxConcurrentPlays = 4;

  Future<void> init() async {
    if (_initialized || _initFailed) return;
    _initialized = true;
    try {
      _cueHitPool = await FlameAudio.createPool(
        'cue_hit.wav',
        minPlayers: 1,
        maxPlayers: 2,
      );
      _ballCollisionPool = await FlameAudio.createPool(
        'ball_collision.wav',
        minPlayers: 1,
        maxPlayers: 3,
      );
      _cushionHitPool = await FlameAudio.createPool(
        'cushion_hit.wav',
        minPlayers: 1,
        maxPlayers: 2,
      );
    } catch (e) {
      _initFailed = true;
      _initialized = false;
      debugPrint('[AudioManager] Failed to init audio pools: $e');
    }
  }

  bool get _enabled => _initialized && !_initFailed && GameSettings.instance.soundEnabled;
  double get _volume => GameSettings.instance.volume;

  bool _throttle(String key, {int? intervalMs}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _lastPlayTime[key] ?? 0;
    if (now - last < (intervalMs ?? _defaultThrottleMs)) return true;
    _lastPlayTime[key] = now;
    return false;
  }

  void _safePoolStart(AudioPool? pool, double volume) {
    if (pool == null || _activePoolPlays >= _maxConcurrentPlays) return;
    _activePoolPlays++;
    pool.start(volume: volume).then((_) {
      _activePoolPlays--;
    }).catchError((e) {
      _activePoolPlays--;
      debugPrint('[AudioManager] pool play error: $e');
    });
  }

  void playCueHit({double power = 0.5}) {
    if (!_enabled || _throttle('cue')) return;
    final vol = (_volume * (0.5 + power * 0.5)).clamp(0.0, 1.0);
    _safePoolStart(_cueHitPool, vol);
  }

  void playBallCollision({double speed = 1.0}) {
    if (!_enabled || _throttle('ball', intervalMs: _collisionThrottleMs)) return;
    final vol = (_volume * (speed / 5.0).clamp(0.2, 1.0)).clamp(0.0, 1.0);
    _safePoolStart(_ballCollisionPool, vol);
  }

  void playBallPocketed() {
    if (!_enabled || _throttle('pocket')) return;
    FlameAudio.play('ball_pocketed.wav', volume: _volume).then((_) {}).catchError((e) {
      debugPrint('[AudioManager] pocket sound error: $e');
    });
  }

  void playCushionHit({double speed = 1.0}) {
    if (!_enabled || _throttle('cushion', intervalMs: _collisionThrottleMs)) return;
    final vol = (_volume * (speed / 4.0).clamp(0.3, 1.0)).clamp(0.0, 1.0);
    _safePoolStart(_cushionHitPool, vol);
  }

  void playFoul() {
    if (!_enabled || _throttle('foul')) return;
    FlameAudio.play('foul.wav', volume: _volume).then((_) {}).catchError((e) {
      debugPrint('[AudioManager] foul sound error: $e');
    });
  }
}
