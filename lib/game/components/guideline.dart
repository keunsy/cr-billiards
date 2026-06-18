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
  Vector2 spinOffset = Vector2.zero();
  double power = 0.5;

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
    }

    // --- 5b. Right triangle from contact point T ---
    if (showTriangle && cutAngle > 3.0 && cutAngle < 85.0) {
      final contactPoint = (objectCenter + ghostCenter) * 0.5;
      _drawPocketTriangle(canvas, origin, objectCenter, ghostCenter, contactPoint, objectDir,
          cutAngle: showAngle ? cutAngle : null, cutColor: cutColor);
    }

    // --- 5c. Cut-point mark on object ball (standard G-vertex cut angle) ---
    if (cutAngle > 1.0) {
      _drawCutMark(canvas, objectCenter, ghostCenter);
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
          // Separation angle: between object ball path and cue ball deflection
          final sepAngle = _angleBetween(objectDir, deflection);
          final labelPos = ghostCenter + deflection * 10;
          _drawDeflectionLabel(canvas, labelPos, sepAngle);
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
    final tangentDir = tangent.normalized();
    final aimNorm = aimDir.normalized();

    // followFactor: >0 = topspin (high), <0 = backspin (low), 0 = center
    final followFactor = -spinOffset.y;

    // Power effect on separation angle:
    // Low power: ball transitions to rolling before impact → separation < 90°
    //   (rolling collision pushes cue ball more toward aim direction)
    // High power: pure sliding collision → separation ≈ 90°
    // powerRoll: 0 at max power (pure sliding), ~0.5 at min power (rolling)
    final p = power.clamp(0.0, 1.0);
    final powerRoll = (1.0 - p) * 0.5;

    // Spin effect: high spin → follow (toward aim), low spin → draw (away)
    final spinBlend = (followFactor * 0.5 * (1.0 - p * 0.4)).clamp(-0.8, 0.8);

    // Combined deflection direction:
    //  base = tangent (90° rule)
    //  + powerRoll toward aim (rolling reduces separation angle)
    //  + spinBlend toward/away from aim
    final totalFollow = powerRoll + spinBlend;
    final followDir = totalFollow >= 0 ? aimNorm : (aimNorm.clone()..negate());

    final result = tangentDir + followDir * totalFollow.abs();
    return result.length > 0.001 ? result.normalized() : tangentDir;
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

    if (sweep.abs() > math.pi) {
      sweep = sweep > 0 ? sweep - 2 * math.pi : sweep + 2 * math.pi;
    }

    const arcR = 6.0;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.x, center.y), radius: arcR),
      angle1,
      sweep,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.3,
    );

    // Only draw label here when triangle is NOT visible (small cut angles)
    final hasTriangle = showTriangle && angleDeg > 3.0 && angleDeg < 85.0;
    if (!hasTriangle) {
      final midAngle = angle1 + sweep / 2;
      final labelR = arcR + 4.0;
      final lx = center.x + math.cos(midAngle) * labelR;
      final ly = center.y + math.sin(midAngle) * labelR;
      _drawAngleLabel(canvas, Vector2(lx, ly), angleDeg, color);
    }
  }

  void _drawAngleLabel(Canvas canvas, Vector2 pos, double angle, Color color) {
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
    textPainter.paint(canvas, Offset(pos.x - textPainter.width / 2, pos.y - textPainter.height / 2));
  }

  void _drawDeflectionLabel(Canvas canvas, Vector2 pos, double angle) {
    final label = '分离${angle.round()}°';
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

  /// Right triangle with vertex at contact point T (midpoint of G-O).
  ///
  /// T = contact point, D = foot of perpendicular from C onto the pocket line
  /// through T, C = cue ball.
  /// Triangle: T-D-C with right angle at D.
  void _drawPocketTriangle(Canvas canvas, Vector2 cueBall, Vector2 objectBall,
      Vector2 ghostCenter, Vector2 contactPoint, Vector2 objectDir,
      {double? cutAngle, Color? cutColor}) {
    final lineUnit = objectDir;

    final tc = cueBall - contactPoint;
    final projLen = tc.dot(lineUnit);
    final foot = contactPoint + lineUnit * projLen;

    final perpDist = (cueBall - foot).length;
    if (perpDist < 0.5) return;

    final triPaint = Paint()
      ..color = const Color(0x44FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;

    canvas.drawLine(
      Offset(contactPoint.x, contactPoint.y),
      Offset(foot.x, foot.y),
      triPaint,
    );
    canvas.drawLine(
      Offset(foot.x, foot.y),
      Offset(cueBall.x, cueBall.y),
      triPaint,
    );
    canvas.drawLine(
      Offset(contactPoint.x, contactPoint.y),
      Offset(cueBall.x, cueBall.y),
      triPaint,
    );

    if (perpDist > 2.0 && projLen.abs() > 2.0) {
      final dToT = (contactPoint - foot).normalized() * 1.5;
      final dToC = (cueBall - foot).normalized() * 1.5;
      final sq1 = foot + dToT;
      final sq2 = foot + dToT + dToC;
      final sq3 = foot + dToC;
      canvas.drawLine(Offset(sq1.x, sq1.y), Offset(sq2.x, sq2.y), triPaint);
      canvas.drawLine(Offset(sq2.x, sq2.y), Offset(sq3.x, sq3.y), triPaint);
    }

    canvas.drawCircle(
      Offset(contactPoint.x, contactPoint.y),
      0.5,
      Paint()..color = const Color(0xFFFF9800),
    );

    final adjLen = projLen.abs();
    final hypLen = tc.length;
    if (perpDist < 0.1) return;

    final hypRatio = hypLen / perpDist;
    final adjRatio = adjLen / perpDist;

    final midAdj = (contactPoint + foot) * 0.5;
    final midPerp = (foot + cueBall) * 0.5;
    final midHyp = (contactPoint + cueBall) * 0.5;

    _drawTriLabel(canvas, midAdj, '长${adjRatio.toStringAsFixed(1)}', const Color(0xBBFFEB3B));
    _drawTriLabel(canvas, midPerp, '短1.0', const Color(0xBB00BFFF));
    _drawTriLabel(canvas, midHyp, '斜${hypRatio.toStringAsFixed(1)}', const Color(0xBB66BB6A));

    // Cut angle label inside the triangle (centroid area)
    if (cutAngle != null && cutAngle > 0.5) {
      final centroid = (contactPoint + foot + cueBall) / 3.0;
      _drawAngleLabel(canvas, centroid, cutAngle, cutColor ?? const Color(0xFFFFEB3B));
    }
  }

  /// Draw the "cut mark" on the target ball surface.
  /// The cut mark is where the aim line (from cue ball through ghost center G)
  /// intersects the object ball's circumference — i.e. the chord endpoints
  /// perpendicular to G→O through the contact point T.
  void _drawCutMark(Canvas canvas, Vector2 objectCenter, Vector2 ghostCenter) {
    final goDir = (objectCenter - ghostCenter);
    if (goDir.length < 0.001) return;
    final goUnit = goDir.normalized();
    // Perpendicular to G→O
    final perpUnit = Vector2(-goUnit.y, goUnit.x);

    final contactPoint = (objectCenter + ghostCenter) * 0.5;
    final r = TableConstants.ballRadius;

    // Find chord endpoints: line through T perpendicular to G→O intersected with ball circle
    final tc = contactPoint - objectCenter;
    final b = 2 * tc.dot(perpUnit);
    final c = tc.dot(tc) - r * r;
    final disc = b * b - 4 * c;
    if (disc < 0) return;

    final sqrtD = math.sqrt(disc);
    final s1 = (-b - sqrtD) / 2;
    final s2 = (-b + sqrtD) / 2;
    final p1 = contactPoint + perpUnit * s1;
    final p2 = contactPoint + perpUnit * s2;

    // Draw cut chord on ball
    final cutPaint = Paint()
      ..color = const Color(0xFFE91E63)
      ..strokeWidth = 0.4;
    canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), cutPaint);

    // Highlight chord endpoints
    final dotPaint = Paint()..color = const Color(0xFFE91E63);
    canvas.drawCircle(Offset(p1.x, p1.y), 0.35, dotPaint);
    canvas.drawCircle(Offset(p2.x, p2.y), 0.35, dotPaint);
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
