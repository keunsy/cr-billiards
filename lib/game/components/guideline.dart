import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../table_constants.dart';
import 'ball.dart';

class Guideline extends Component {
  Guideline({required this.balls});

  final List<Ball> balls;

  bool enabled = true;
  bool showAngle = true;
  bool showObjectPath = true;
  bool showDeflection = true;
  bool showTriangle = true;
  Vector2? cueBallPosition;
  Vector2 aimDirection = Vector2(1, 0);

  @override
  void render(Canvas canvas) {
    if (!enabled || cueBallPosition == null) return;

    final origin = cueBallPosition!;
    final dir = aimDirection.normalized();
    if (dir.length2 < 0.001) return;

    final hit = _raycastBall(origin, dir);
    if (hit == null) {
      _drawDottedLine(canvas, origin, origin + dir * 100, const Color(0xFF66BB6A));
      return;
    }

    final ghostCenter = hit.contactPoint; // cue ball ghost position at impact
    final objectBall = hit.ball;
    final objectCenter = objectBall.body.position;

    // --- 1. Cue ball aim line (green dotted) ---
    _drawDottedLine(canvas, origin, ghostCenter, const Color(0xFF66BB6A));

    // --- 2. Ghost ball outline (faint) ---
    canvas.drawCircle(
      Offset(ghostCenter.x, ghostCenter.y),
      TableConstants.ballRadius,
      Paint()
        ..color = const Color(0x33FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.25,
    );

    // --- 3. Object ball predicted path (yellow dotted) ---
    final objectDir = (objectCenter - ghostCenter).normalized();
    if (objectDir.length2 < 0.001) return;

    if (showObjectPath) {
      final objectPathEnd = _clampToTable(objectCenter, objectDir);
      _drawDottedLine(canvas, objectCenter, objectPathEnd, const Color(0xFFFFEB3B));
      _drawPocketHint(canvas, objectCenter, objectDir, objectPathEnd);
    }

    // --- 4. Cut point on object ball surface ---
    final cutPointOnBall = objectCenter + (ghostCenter - objectCenter).normalized() * TableConstants.ballRadius;
    _drawCutPoint(canvas, cutPointOnBall);

    // --- 5. Cut angle calculation ---
    final centerLine = (objectCenter - ghostCenter).normalized();
    final cutAngle = _angleBetween(dir, centerLine);
    final cutColor = _cutAngleColor(cutAngle);

    if (showAngle && cutAngle > 0.5) {
      _drawAngleArc(canvas, ghostCenter, dir, centerLine, cutAngle, cutColor);
      _drawAngleLabel(canvas, ghostCenter, cutAngle, cutColor);
    }

    // --- 5b. Right triangle: cue ball perpendicular to object-pocket line ---
    if (showTriangle && cutAngle > 3.0 && cutAngle < 85.0) {
      _drawPocketTriangle(canvas, origin, objectCenter);
    }

    // --- 6. Cue ball deflection path after impact ---
    if (showDeflection && cutAngle > 1.0) {
      final deflection = _cueBallDeflection(dir, centerLine);
      if (deflection != null) {
        final deflLen = 30.0 + cutAngle * 0.3;
        _drawDottedLine(
          canvas,
          ghostCenter,
          ghostCenter + deflection * deflLen,
          const Color(0x9900BFFF),
        );

        if (showAngle && cutAngle > 5.0) {
          final deflAngle = _angleBetween(dir, deflection);
          final labelPos = ghostCenter + deflection * 10;
          _drawDeflectionLabel(canvas, labelPos, deflAngle);
        }
      }
    }
  }

  _BallHit? _raycastBall(Vector2 origin, Vector2 dir) {
    Ball? closestBall;
    double closestT = double.infinity;
    Vector2? closestContact;

    final hitRadius = TableConstants.ballRadius * 2;

    for (final ball in balls) {
      if (ball.isPocketed || ball.isCueBall || !ball.isVisible) continue;

      final center = ball.body.position;
      final oc = origin - center;
      final a = dir.dot(dir);
      final b = 2 * oc.dot(dir);
      final c = oc.dot(oc) - hitRadius * hitRadius;
      final disc = b * b - 4 * a * c;
      if (disc < 0) continue;

      final t = (-b - math.sqrt(disc)) / (2 * a);
      if (t > 0.1 && t < closestT) {
        closestT = t;
        closestBall = ball;
        closestContact = origin + dir * t;
      }
    }

    if (closestBall == null || closestContact == null) return null;
    return _BallHit(ball: closestBall, contactPoint: closestContact);
  }

  double _angleBetween(Vector2 a, Vector2 b) {
    final na = a.normalized();
    final nb = b.normalized();
    if (na.length2 < 0.001 || nb.length2 < 0.001) return 0;
    final dot = na.dot(nb).clamp(-1.0, 1.0);
    return math.acos(dot) * 180 / math.pi;
  }

  Vector2? _cueBallDeflection(Vector2 aimDir, Vector2 centerLine) {
    final tangent = Vector2(-centerLine.y, centerLine.x);
    if (aimDir.dot(tangent) < 0) {
      tangent.negate();
    }
    return tangent.normalized();
  }

  void _drawCutPoint(Canvas canvas, Vector2 point) {
    // Bright dot on target ball showing where cue ball will make contact
    canvas.drawCircle(
      Offset(point.x, point.y),
      0.6,
      Paint()..color = const Color(0xFFFF5722),
    );
    canvas.drawCircle(
      Offset(point.x, point.y),
      0.6,
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.2,
    );
  }

  void _drawAngleArc(Canvas canvas, Vector2 center, Vector2 dir1, Vector2 dir2, double angleDeg, Color color) {
    final angle1 = math.atan2(dir1.y, dir1.x);
    final angle2 = math.atan2(dir2.y, dir2.x);
    var sweep = angle2 - angle1;
    if (sweep > math.pi) sweep -= 2 * math.pi;
    if (sweep < -math.pi) sweep += 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.x, center.y), radius: 6),
      angle1,
      sweep,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.3,
    );
  }

  void _drawAngleLabel(Canvas canvas, Vector2 near, double angle, Color color) {
    final label = '${angle.round()}°';
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 3.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(near.x + 3, near.y - 5));
  }

  void _drawDeflectionLabel(Canvas canvas, Vector2 pos, double angle) {
    final label = '${angle.round()}°';
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0x9900BFFF),
          fontSize: 3.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(pos.x + 1.5, pos.y - 2));
  }

  /// Extend object-ball path until it hits a table edge.
  Vector2 _clampToTable(Vector2 from, Vector2 dir) {
    const hw = TableConstants.halfLength;
    const hh = TableConstants.halfWidth;
    const r = TableConstants.ballRadius;

    var tMin = double.infinity;
    if (dir.x.abs() > 0.0001) {
      final tRight = ((hw - r) - from.x) / dir.x;
      final tLeft = (-(hw - r) - from.x) / dir.x;
      if (tRight > 0.1) tMin = math.min(tMin, tRight);
      if (tLeft > 0.1) tMin = math.min(tMin, tLeft);
    }
    if (dir.y.abs() > 0.0001) {
      final tBottom = ((hh - r) - from.y) / dir.y;
      final tTop = (-(hh - r) - from.y) / dir.y;
      if (tBottom > 0.1) tMin = math.min(tMin, tBottom);
      if (tTop > 0.1) tMin = math.min(tMin, tTop);
    }

    if (tMin == double.infinity) tMin = 70;
    return from + dir * tMin;
  }

  /// Draw a subtle green ring when path end is near a pocket.
  void _drawPocketHint(Canvas canvas, Vector2 from, Vector2 dir, Vector2 end) {
    for (final pocket in TableConstants.pocketCenters) {
      final dist = (end - pocket).length;
      if (dist < TableConstants.cornerPocketRadius + 2) {
        canvas.drawCircle(
          Offset(pocket.x, pocket.y),
          TableConstants.cornerPocketRadius * 0.8,
          Paint()
            ..color = const Color(0x6600FF00)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
        return;
      }
    }
  }

  /// Draw a right triangle from the cue ball perpendicular to the
  /// object-ball→pocket line. This shows the geometric relationship
  /// for aiming: the player adjusts the "short side" (perpendicular offset)
  /// to pocket the ball.
  ///
  /// A = object ball, B = nearest pocket, C = cue ball
  /// D = foot of perpendicular from C onto line AB
  /// Triangle: A-D-C with right angle at D.
  void _drawPocketTriangle(Canvas canvas, Vector2 cueBall, Vector2 objectBall) {
    // Find nearest pocket to object ball along its projected path
    Vector2? bestPocket;
    var bestDist = double.infinity;
    for (final p in TableConstants.pocketCenters) {
      final d = (objectBall - p).length;
      if (d < bestDist) {
        bestDist = d;
        bestPocket = p;
      }
    }
    if (bestPocket == null) return;

    // Line direction: object ball → pocket
    final lineDir = (bestPocket - objectBall);
    final lineLen = lineDir.length;
    if (lineLen < 1.0) return;
    final lineUnit = lineDir / lineLen;

    // Project cueBall onto line (object → pocket)
    final ac = cueBall - objectBall;
    final projLen = ac.dot(lineUnit);
    final foot = objectBall + lineUnit * projLen; // D: perpendicular foot

    // Perpendicular distance (short side)
    final perpDist = (cueBall - foot).length;
    if (perpDist < 0.5) return; // too small to draw

    // Triangle: A(objectBall) → D(foot) → C(cueBall)
    final triPaint = Paint()
      ..color = const Color(0x44FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;

    // AD: along object→pocket line (long side)
    canvas.drawLine(
      Offset(objectBall.x, objectBall.y),
      Offset(foot.x, foot.y),
      triPaint,
    );
    // DC: perpendicular (short side)
    canvas.drawLine(
      Offset(foot.x, foot.y),
      Offset(cueBall.x, cueBall.y),
      triPaint,
    );
    // AC: hypotenuse (cue ball → object ball)
    canvas.drawLine(
      Offset(objectBall.x, objectBall.y),
      Offset(cueBall.x, cueBall.y),
      triPaint,
    );

    // Right angle marker at D
    if (perpDist > 2.0 && projLen.abs() > 2.0) {
      final dToA = (objectBall - foot).normalized() * 1.5;
      final dToC = (cueBall - foot).normalized() * 1.5;
      final sq1 = foot + dToA;
      final sq2 = foot + dToA + dToC;
      final sq3 = foot + dToC;
      canvas.drawLine(Offset(sq1.x, sq1.y), Offset(sq2.x, sq2.y), triPaint);
      canvas.drawLine(Offset(sq2.x, sq2.y), Offset(sq3.x, sq3.y), triPaint);
    }

    // Ratios relative to short side (perpendicular)
    final adjLen = projLen.abs(); // AD length
    final hypLen = ac.length;     // AC length
    if (perpDist < 0.1) return;

    final hypRatio = hypLen / perpDist;
    final adjRatio = adjLen / perpDist;

    // Labels at midpoints
    final midAdj = (objectBall + foot) * 0.5;
    final midPerp = (foot + cueBall) * 0.5;
    final midHyp = (objectBall + cueBall) * 0.5;

    _drawTriLabel(canvas, midAdj, '长${adjRatio.toStringAsFixed(1)}', const Color(0xBBFFEB3B));
    _drawTriLabel(canvas, midPerp, '短1.0', const Color(0xBB00BFFF));
    _drawTriLabel(canvas, midHyp, '斜${hypRatio.toStringAsFixed(1)}', const Color(0xBB66BB6A));
  }

  void _drawTriLabel(Canvas canvas, Vector2 pos, String text, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 2.5, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(pos.x + 0.5, pos.y - 1.5));
  }

  Color _cutAngleColor(double degrees) {
    if (degrees <= 20) return const Color(0xFF66BB6A);
    if (degrees <= 45) return const Color(0xFFFFEB3B);
    return const Color(0xFFE53935);
  }

  void _drawDottedLine(Canvas canvas, Vector2 from, Vector2 to, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.35
      ..style = PaintingStyle.stroke;

    const dash = 2.0;
    const gap = 1.5;
    final delta = to - from;
    final len = delta.length;
    if (len < 0.01) return;
    final step = delta / len;
    var traveled = 0.0;
    while (traveled < len) {
      final segEnd = math.min(traveled + dash, len);
      canvas.drawLine(
        Offset(from.x + step.x * traveled, from.y + step.y * traveled),
        Offset(from.x + step.x * segEnd, from.y + step.y * segEnd),
        paint,
      );
      traveled += dash + gap;
    }
  }
}

class _BallHit {
  _BallHit({required this.ball, required this.contactPoint});
  final Ball ball;
  final Vector2 contactPoint;
}
