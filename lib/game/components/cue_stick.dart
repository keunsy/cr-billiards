import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../table_constants.dart';

enum CueStickState { hidden, aiming, pullingBack, striking }

class CueStick extends Component {
  CueStick();

  CueStickState state = CueStickState.hidden;
  Vector2 cueBallPosition = Vector2.zero();
  double aimAngle = 0;
  double pullBack = 0;
  double strikeProgress = 0;

  static const double stickLength = 55;
  static const double stickWidth = 0.9;
  static const double tipGap = TableConstants.ballRadius + 1.5;

  void showAiming(Vector2 cuePos, double angleRad) {
    state = CueStickState.aiming;
    cueBallPosition = cuePos.clone();
    aimAngle = angleRad;
    pullBack = 0;
  }

  void hide() {
    state = CueStickState.hidden;
  }

  Future<void> animateStrike(double powerRatio) async {
    if (state == CueStickState.hidden) return;
    state = CueStickState.pullingBack;
    pullBack = 8 + powerRatio * 18;

    await Future<void>.delayed(const Duration(milliseconds: 120));

    state = CueStickState.striking;
    strikeProgress = 0;

    const steps = 8;
    for (var i = 0; i <= steps; i++) {
      strikeProgress = i / steps;
      pullBack = (8 + powerRatio * 18) * (1 - strikeProgress);
      await Future<void>.delayed(const Duration(milliseconds: 12));
    }

    hide();
  }

  @override
  void render(Canvas canvas) {
    if (state == CueStickState.hidden) return;

    canvas.save();
    canvas.translate(cueBallPosition.x, cueBallPosition.y);
    canvas.rotate(aimAngle);

    final backOffset = tipGap + pullBack;
    final tipX = -backOffset;
    final buttX = tipX - stickLength;

    final shaftPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFF8E1),
          const Color(0xFFD7CCC8),
          const Color(0xFF8D6E63),
        ],
      ).createShader(Rect.fromLTWH(buttX, -stickWidth, stickLength, stickWidth * 2));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(buttX, -stickWidth, stickLength, stickWidth * 2),
        const Radius.circular(0.3),
      ),
      shaftPaint,
    );

    canvas.drawCircle(
      Offset(tipX, 0),
      stickWidth * 0.55,
      Paint()..color = const Color(0xFF1565C0),
    );

    canvas.restore();
  }
}
