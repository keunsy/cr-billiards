import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/painting.dart';

import '../table_constants.dart';

typedef BallContactCallback = void Function(Ball self, Object other);

class Ball extends BodyComponent with ContactCallbacks {
  Ball({
    required this.number,
    required Vector2 position,
    this.onContact,
  }) : _initialPosition = position.clone();

  final int number;
  final Vector2 _initialPosition;
  BallContactCallback? onContact;

  bool isPocketed = false;
  bool isVisible = true;
  bool isDragging = false;

  bool get isCueBall => number == 0;
  bool get is8Ball => number == 8;
  bool get isSolid => number >= 1 && number <= 7;
  bool get isStripe => number >= 9 && number <= 15;

  static const Map<int, Color> _colors = {
    0: Color(0xFFF5F5F0),
    1: Color(0xFFF9D923),
    2: Color(0xFF1565C0),
    3: Color(0xFFD32F2F),
    4: Color(0xFF7B1FA2),
    5: Color(0xFFFF8F00),
    6: Color(0xFF2E7D32),
    7: Color(0xFF880E4F),
    8: Color(0xFF1A1A1A),
    9: Color(0xFFF9D923),
    10: Color(0xFF1565C0),
    11: Color(0xFFD32F2F),
    12: Color(0xFF7B1FA2),
    13: Color(0xFFFF8F00),
    14: Color(0xFF2E7D32),
    15: Color(0xFF880E4F),
  };

  Color get ballColor => _colors[number] ?? const Color(0xFFCCCCCC);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = TableConstants.ballRadius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.85
      ..friction = 0.12
      ..density = 0.35
      ..userData = this;

    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = _initialPosition
      ..linearDamping = 0.4
      ..angularDamping = 0.3
      ..bullet = true;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void pocket() {
    isPocketed = true;
    isVisible = false;
    isDragging = false;
    body.setTransform(Vector2(-1000, -1000), 0);
    body.linearVelocity = Vector2.zero();
    body.angularVelocity = 0;
    body.setActive(false);
  }

  void restoreForPlacement(Vector2 position) {
    isPocketed = false;
    isVisible = true;
    body.setActive(true);
    setPosition(position);
  }

  void setPosition(Vector2 position) {
    body.setTransform(position, body.angle);
    body.linearVelocity = Vector2.zero();
    body.angularVelocity = 0;
  }

  void reposition(Vector2 position) {
    isPocketed = false;
    isVisible = true;
    isDragging = false;
    body.setActive(true);
    setPosition(position);
  }

  void setDragging(bool dragging) {
    isDragging = dragging;
    if (dragging) {
      body.linearVelocity = Vector2.zero();
      body.angularVelocity = 0;
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    onContact?.call(this, other);
  }

  bool get isMoving {
    if (isPocketed || !body.isActive) return false;
    return body.linearVelocity.length > 0.1 || body.angularVelocity.abs() > 0.1;
  }

  @override
  void render(Canvas canvas) {
    if (!isVisible || (isPocketed && !isDragging)) return;

    const center = Offset.zero;
    const r = TableConstants.ballRadius;
    final alpha = isDragging ? 0.55 : 1.0;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0.5, 0.8), width: r * 2.1, height: r * 1.6),
      Paint()..color = const Color(0x44000000),
    );

    // Rotate canvas by body angle to simulate rolling
    canvas.save();
    canvas.rotate(body.angle);

    if (isStripe) {
      _renderStripe(canvas, center, r, alpha);
    } else {
      _renderSolid(canvas, center, r, alpha);
    }

    if (number > 0) {
      _renderNumber(canvas, center, r);
    }

    canvas.restore();

    // Edge outline (drawn without rotation for cleaner look)
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = const Color(0x55000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.18,
    );

    // 3D highlight (drawn without rotation so light stays fixed)
    _renderHighlight(canvas, r);
  }

  void _renderSolid(Canvas canvas, Offset center, double r, double alpha) {
    final baseColor = ballColor.withValues(alpha: alpha);

    // Radial gradient for 3D sphere effect
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.0,
          colors: [
            _lighten(baseColor, 0.35),
            baseColor,
            _darken(baseColor, 0.35),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    if (isCueBall) {
      // Subtle edge ring for cue ball
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = const Color(0x22000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.15,
      );
    }
  }

  void _renderStripe(Canvas canvas, Offset center, double r, double alpha) {
    final baseColor = ballColor.withValues(alpha: alpha);

    // White base with 3D gradient
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.0,
          colors: [
            const Color(0xFFFFFFFF),
            const Color(0xFFF0F0F0),
            const Color(0xFFD0D0D0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    // Color stripe band
    canvas.save();
    canvas.clipRect(Rect.fromCenter(center: center, width: r * 2.2, height: r * 1.0));
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: [
            _lighten(baseColor, 0.2),
            baseColor,
            _darken(baseColor, 0.25),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
    canvas.restore();

    // Thin edge ring
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = _darken(baseColor, 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.1,
    );
  }

  void _renderNumber(Canvas canvas, Offset center, double r) {
    final circleRadius = r * 0.42;

    if (!is8Ball) {
      canvas.drawCircle(
        center,
        circleRadius,
        Paint()..color = const Color(0xFFFFFFFF),
      );
      canvas.drawCircle(
        center,
        circleRadius,
        Paint()
          ..color = const Color(0x22000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.08,
      );
    }

    final textColor = is8Ball ? const Color(0xFFFFFFFF) : const Color(0xFF111111);
    final fontSize = number >= 10 ? r * 0.7 : r * 0.85;
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _renderHighlight(Canvas canvas, double r) {
    // Primary specular highlight
    canvas.drawCircle(
      Offset(-r * 0.3, -r * 0.3),
      r * 0.22,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0x88FFFFFF),
            const Color(0x00FFFFFF),
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(-r * 0.3, -r * 0.3),
          radius: r * 0.22,
        )),
    );

    // Subtle secondary highlight
    canvas.drawCircle(
      Offset(r * 0.15, r * 0.2),
      r * 0.12,
      Paint()..color = const Color(0x11FFFFFF),
    );

    // Rim light at bottom edge
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: r),
      math.pi * 0.1,
      math.pi * 0.8,
      false,
      Paint()
        ..color = const Color(0x18FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.2,
    );
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}
