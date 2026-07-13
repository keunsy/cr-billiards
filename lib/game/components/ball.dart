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
      ..linearDamping = 0.35
      ..angularDamping = 0.3
      ..bullet = true;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  bool _pendingDeactivation = false;
  double _travelPhase = 0; // accumulated rolling phase in radians
  Vector2 _lastPos = Vector2.zero();

  void pocket() {
    isPocketed = true;
    isVisible = false;
    isDragging = false;
    body.setTransform(Vector2(-1000, -1000), 0);
    body.linearVelocity = Vector2.zero();
    body.angularVelocity = 0;
    // Defer body deactivation to avoid mutating the world during collision iteration
    _pendingDeactivation = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_pendingDeactivation) {
      _pendingDeactivation = false;
      body.setActive(false);
    }
    if (body.isActive && !isPocketed) {
      // Force-stop very slow balls to avoid long tail-end drifting
      final speed = body.linearVelocity.length;
      if (speed > 0 && speed < 0.25) {
        body.linearVelocity = Vector2.zero();
        body.angularVelocity = 0;
      } else if (body.angularVelocity.abs() > 0 && body.angularVelocity.abs() < 0.2) {
        body.angularVelocity = 0;
      }

      // Accumulate rolling phase based on distance traveled
      final pos = body.position;
      final dist = (pos - _lastPos).length;
      if (dist > 0.01) {
        _travelPhase += dist / TableConstants.ballRadius;
      }
      _lastPos.setFrom(pos);
    }
  }

  void restoreForPlacement(Vector2 position) {
    _pendingDeactivation = false;
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
    _pendingDeactivation = false;
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
    return body.linearVelocity.length > 0.3 || body.angularVelocity.abs() > 0.3;
  }

  @override
  void render(Canvas canvas) {
    if (!isVisible || (isPocketed && !isDragging)) return;

    const center = Offset.zero;
    const r = TableConstants.ballRadius;
    final alpha = isDragging ? 0.55 : 1.0;

    // Ground shadow (soft elliptical)
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0.4, 0.7), width: r * 2.2, height: r * 1.2),
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0x55000000), Color(0x00000000)],
        ).createShader(
          Rect.fromCenter(center: const Offset(0.4, 0.7), width: r * 2.2, height: r * 1.2),
        ),
    );

    // Draw ball body (no rotation — gradient stays fixed for 3D look)
    if (isStripe) {
      _renderStripe(canvas, center, r, alpha);
    } else {
      _renderSolid(canvas, center, r, alpha);
    }

    // Number circle with rolling effect: offset along travel direction
    if (number > 0) {
      canvas.save();
      final vel = body.linearVelocity;
      final speed = vel.length;
      // Use travel direction for offset; fall back to body angle when still
      double dirAngle;
      if (speed > 0.3) {
        dirAngle = math.atan2(vel.y, vel.x);
      } else {
        dirAngle = 0;
      }
      // sin(_travelPhase) oscillates the number position along travel direction
      final phase = math.sin(_travelPhase);
      final offsetMag = r * 0.35 * phase;
      final numOffset = Offset(math.cos(dirAngle) * offsetMag, math.sin(dirAngle) * offsetMag);
      // cos(_travelPhase) < 0 means number is on the "back side" — scale down
      final visibility = math.cos(_travelPhase);
      if (visibility > -0.3) {
        final scale = 0.5 + 0.5 * visibility.clamp(0.0, 1.0);
        canvas.translate(numOffset.dx, numOffset.dy);
        canvas.scale(scale, scale);
        _renderNumber(canvas, center, r);
      }
      canvas.restore();
    }

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

    // Main body: tighter radial gradient for more 3D pop
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.35),
          radius: 0.85,
          colors: [
            _lighten(baseColor, 0.45),
            _lighten(baseColor, 0.15),
            baseColor,
            _darken(baseColor, 0.25),
            _darken(baseColor, 0.5),
          ],
          stops: const [0.0, 0.25, 0.50, 0.78, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    if (isCueBall) {
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

    // White base with tighter 3D gradient
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.35),
          radius: 0.85,
          colors: const [
            Color(0xFFFFFFFF),
            Color(0xFFF5F5F5),
            Color(0xFFE8E8E8),
            Color(0xFFCCCCCC),
            Color(0xFFAAAAAA),
          ],
          stops: const [0.0, 0.25, 0.50, 0.78, 1.0],
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
          center: const Alignment(-0.3, -0.35),
          radius: 0.85,
          colors: [
            _lighten(baseColor, 0.3),
            _lighten(baseColor, 0.1),
            baseColor,
            _darken(baseColor, 0.2),
            _darken(baseColor, 0.45),
          ],
          stops: const [0.0, 0.25, 0.50, 0.78, 1.0],
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
    // Primary specular highlight — bigger and brighter
    final hlCenter = Offset(-r * 0.28, -r * 0.32);
    canvas.drawCircle(
      hlCenter,
      r * 0.30,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xBBFFFFFF), Color(0x00FFFFFF)],
        ).createShader(Rect.fromCircle(center: hlCenter, radius: r * 0.30)),
    );

    // Sharp specular dot
    canvas.drawCircle(
      Offset(-r * 0.22, -r * 0.25),
      r * 0.08,
      Paint()..color = const Color(0xCCFFFFFF),
    );

    // Subtle secondary highlight
    canvas.drawCircle(
      Offset(r * 0.15, r * 0.2),
      r * 0.10,
      Paint()..color = const Color(0x15FFFFFF),
    );

    // Rim light at bottom edge (environment reflection)
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: r * 0.95),
      math.pi * 0.05,
      math.pi * 0.9,
      false,
      Paint()
        ..color = const Color(0x22FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.25,
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
