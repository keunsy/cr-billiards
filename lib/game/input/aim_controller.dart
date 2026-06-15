import 'package:flame/extensions.dart';

import '../billiards_game.dart';

/// Converts touch points into cue-ball aim direction.
class AimController {
  AimController(this.game);

  final BilliardsGame game;

  void updateFromCanvasPoint(Vector2 canvasPoint) {
    if (!game.canAim || game.cueBall == null) return;

    final worldPoint = game.inputToWorld(canvasPoint);
    final delta = worldPoint - game.cueBall!.body.position;
    if (delta.length2 > 0.5) {
      game.setAimDirection(delta);
    }
  }
}
