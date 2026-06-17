import 'package:flame/extensions.dart';

import '../billiards_game.dart';

/// Converts touch points into cue-ball aim direction with smoothing.
class AimController {
  AimController(this.game);

  final BilliardsGame game;

  Vector2? _prevDirection;

  static const double _deadZone = 4.0;
  static const double _smoothing = 0.35;

  void updateFromCanvasPoint(Vector2 canvasPoint) {
    if (!game.canAim || game.cueBall == null) return;

    final worldPoint = game.inputToWorld(canvasPoint);
    final delta = worldPoint - game.cueBall!.body.position;
    if (delta.length < _deadZone) return;

    final newDir = delta.normalized();

    if (_prevDirection == null) {
      _prevDirection = newDir.clone();
      game.setAimDirection(newDir);
      return;
    }

    // Lerp to smooth out jitter
    final smoothed = _prevDirection! * (1 - _smoothing) + newDir * _smoothing;
    if (smoothed.length2 > 0.001) {
      final result = smoothed.normalized();
      _prevDirection = result.clone();
      game.setAimDirection(result);
    }
  }

  void reset() {
    _prevDirection = null;
  }
}
