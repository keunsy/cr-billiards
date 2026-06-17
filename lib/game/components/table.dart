import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/painting.dart';

import '../table_constants.dart';

class Table extends Component {
  Table({required this.world});

  final Forge2DWorld world;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createCushions();
  }

  void _createCushions() {
    const hw = TableConstants.halfLength;
    const hh = TableConstants.halfWidth;
    // Gap from corner pocket center to cushion start
    const cornerGap = 7.5;
    // Gap from side pocket center to cushion end
    const sideGap = 6.5;

    // Top rail (y = -hh): two segments with side-pocket gap
    _addCushion(Vector2(-hw + cornerGap, -hh), Vector2(-sideGap, -hh));
    _addCushion(Vector2(sideGap, -hh), Vector2(hw - cornerGap, -hh));

    // Bottom rail (y = +hh)
    _addCushion(Vector2(-hw + cornerGap, hh), Vector2(-sideGap, hh));
    _addCushion(Vector2(sideGap, hh), Vector2(hw - cornerGap, hh));

    // Left rail (x = -hw)
    _addCushion(Vector2(-hw, -hh + cornerGap), Vector2(-hw, hh - cornerGap));

    // Right rail (x = +hw)
    _addCushion(Vector2(hw, -hh + cornerGap), Vector2(hw, hh - cornerGap));

    // Pocket mouth angled guides (slightly angled cushion lips at each corner)
    _addCornerAngles(-hw, -hh, 1, 1);
    _addCornerAngles(hw, -hh, -1, 1);
    _addCornerAngles(-hw, hh, 1, -1);
    _addCornerAngles(hw, hh, -1, -1);

    // Side pocket angled guides
    _addSidePocketAngles(-hh, -1);
    _addSidePocketAngles(hh, 1);
  }

  void _addCushion(Vector2 start, Vector2 end) {
    world.add(CushionSegment(start: start, end: end));
  }

  void _addCornerAngles(double cx, double cy, double sx, double sy) {
    const len = 3.5;
    const inset = 4.5;
    world.add(CushionSegment(
      start: Vector2(cx + sx * inset, cy),
      end: Vector2(cx + sx * (inset + len), cy + sy * len * 0.35),
    ));
    world.add(CushionSegment(
      start: Vector2(cx, cy + sy * inset),
      end: Vector2(cx + sx * len * 0.35, cy + sy * (inset + len)),
    ));
  }

  void _addSidePocketAngles(double y, double sy) {
    const len = 3.0;
    const inset = 4.0;
    world.add(CushionSegment(
      start: Vector2(-inset, y),
      end: Vector2(-(inset + len), y + sy * len * 0.3),
    ));
    world.add(CushionSegment(
      start: Vector2(inset, y),
      end: Vector2(inset + len, y + sy * len * 0.3),
    ));
  }

  @override
  void render(Canvas canvas) {
    const hw = TableConstants.halfLength;
    const hh = TableConstants.halfWidth;
    const rw = TableConstants.railWidth;

    // Outer frame (dark wood)
    _drawWoodFrame(canvas, hw, hh, rw);

    // Playing surface (green felt with texture)
    _drawFelt(canvas, hw, hh);

    // Cushion rubber strips along rails
    _drawCushionRubber(canvas, hw, hh);

    // Markings
    _drawHeadString(canvas);
    _drawFootSpot(canvas);
    _drawCenterSpot(canvas);
    _drawDiamonds(canvas, hw, hh, rw);
    _drawPockets(canvas);
  }

  void _drawWoodFrame(Canvas canvas, double hw, double hh, double rw) {
    final outerRect = Rect.fromLTRB(-hw - rw, -hh - rw, hw + rw, hh + rw);

    // Base wood color
    canvas.drawRRect(
      RRect.fromRectXY(outerRect, 5, 5),
      Paint()..color = const Color(0xFF4E342E),
    );

    // Wood grain effect via multiple thin horizontal stripes
    final grainPaint = Paint()
      ..color = const Color(0x18000000)
      ..strokeWidth = 0.4;
    for (var i = 0; i < 40; i++) {
      final y = outerRect.top + outerRect.height * i / 40;
      canvas.drawLine(
        Offset(outerRect.left + 2, y),
        Offset(outerRect.right - 2, y),
        grainPaint,
      );
    }

    // Inner bevel highlight
    final bevelRect = Rect.fromLTRB(-hw - 1.5, -hh - 1.5, hw + 1.5, hh + 1.5);
    canvas.drawRRect(
      RRect.fromRectXY(bevelRect, 2, 2),
      Paint()
        ..color = const Color(0xFF3E2723)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Highlight on top edge of frame
    canvas.drawLine(
      Offset(-hw - rw + 3, -hh - rw + 1.5),
      Offset(hw + rw - 3, -hh - rw + 1.5),
      Paint()
        ..color = const Color(0x33FFFFFF)
        ..strokeWidth = 0.8,
    );
  }

  void _drawFelt(Canvas canvas, double hw, double hh) {
    final feltRect = Rect.fromLTRB(-hw, -hh, hw, hh);

    // Base green
    canvas.drawRect(feltRect, Paint()..color = const Color(0xFF1B6B1F));

    // Subtle radial gradient for lighting effect
    canvas.drawRect(
      feltRect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0.0, -0.3),
          radius: 1.2,
          colors: [
            const Color(0xFF227D26).withValues(alpha: 0.4),
            const Color(0x00000000),
          ],
        ).createShader(feltRect),
    );

    // Subtle cloth texture via fine noise pattern
    final texturePaint = Paint()..color = const Color(0x08000000);
    final rng = math.Random(42);
    for (var i = 0; i < 300; i++) {
      final x = -hw + rng.nextDouble() * hw * 2;
      final y = -hh + rng.nextDouble() * hh * 2;
      canvas.drawCircle(Offset(x, y), 0.3 + rng.nextDouble() * 0.5, texturePaint);
    }

    // Slight vignette around edges
    canvas.drawRect(
      feltRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0x1A000000),
            const Color(0x00000000),
            const Color(0x00000000),
            const Color(0x1A000000),
          ],
          stops: const [0.0, 0.15, 0.85, 1.0],
        ).createShader(feltRect),
    );
  }

  void _drawCushionRubber(Canvas canvas, double hw, double hh) {
    const thickness = 2.0;
    final rubberPaint = Paint()..color = const Color(0xFF2E7D32);
    final rubberHighlight = Paint()..color = const Color(0x22FFFFFF);
    const cornerGap = 7.5;
    const sideGap = 6.5;

    // Top cushions
    _drawRubberStrip(canvas, Offset(-hw + cornerGap, -hh), Offset(-sideGap, -hh), thickness, rubberPaint, rubberHighlight, true);
    _drawRubberStrip(canvas, Offset(sideGap, -hh), Offset(hw - cornerGap, -hh), thickness, rubberPaint, rubberHighlight, true);

    // Bottom cushions
    _drawRubberStrip(canvas, Offset(-hw + cornerGap, hh), Offset(-sideGap, hh), -thickness, rubberPaint, rubberHighlight, true);
    _drawRubberStrip(canvas, Offset(sideGap, hh), Offset(hw - cornerGap, hh), -thickness, rubberPaint, rubberHighlight, true);

    // Left cushion
    _drawRubberStripV(canvas, Offset(-hw, -hh + cornerGap), Offset(-hw, hh - cornerGap), thickness, rubberPaint, rubberHighlight);

    // Right cushion
    _drawRubberStripV(canvas, Offset(hw, -hh + cornerGap), Offset(hw, hh - cornerGap), -thickness, rubberPaint, rubberHighlight);
  }

  void _drawRubberStrip(Canvas canvas, Offset start, Offset end, double thickness, Paint fill, Paint highlight, bool horizontal) {
    final rect = Rect.fromLTRB(
      start.dx, horizontal ? start.dy : start.dy,
      end.dx, horizontal ? start.dy + thickness : end.dy,
    );
    canvas.drawRect(rect, fill);
    canvas.drawLine(
      Offset(rect.left, rect.top + (thickness > 0 ? 0.5 : -0.5)),
      Offset(rect.right, rect.top + (thickness > 0 ? 0.5 : -0.5)),
      highlight,
    );
  }

  void _drawRubberStripV(Canvas canvas, Offset start, Offset end, double thickness, Paint fill, Paint highlight) {
    final rect = Rect.fromLTRB(
      start.dx, start.dy,
      start.dx + thickness, end.dy,
    );
    canvas.drawRect(rect, fill);
    canvas.drawLine(
      Offset(rect.left + (thickness > 0 ? 0.5 : -0.5), rect.top),
      Offset(rect.left + (thickness > 0 ? 0.5 : -0.5), rect.bottom),
      highlight,
    );
  }

  void _drawHeadString(Canvas canvas) {
    const x = TableConstants.headStringX;
    canvas.drawLine(
      Offset(x, -TableConstants.halfWidth + 3),
      Offset(x, TableConstants.halfWidth - 3),
      Paint()
        ..color = const Color(0x33FFFFFF)
        ..strokeWidth = 0.2,
    );
  }

  void _drawFootSpot(Canvas canvas) {
    canvas.drawCircle(
      const Offset(TableConstants.footSpotX, 0),
      0.7,
      Paint()..color = const Color(0x55FFFFFF),
    );
  }

  void _drawCenterSpot(Canvas canvas) {
    canvas.drawCircle(
      const Offset(0, 0),
      0.5,
      Paint()..color = const Color(0x33FFFFFF),
    );
  }

  void _drawDiamonds(Canvas canvas, double hw, double hh, double rw) {
    const diamondSize = 0.8;
    final diamondPaint = Paint()..color = const Color(0xCCE8D5B7);
    final diamondShadow = Paint()..color = const Color(0x33000000);

    void drawDiamond(double x, double y) {
      final path = Path()
        ..moveTo(x, y - diamondSize)
        ..lineTo(x + diamondSize * 0.6, y)
        ..lineTo(x, y + diamondSize)
        ..lineTo(x - diamondSize * 0.6, y)
        ..close();
      canvas.drawPath(path, diamondShadow);
      canvas.drawPath(path..shift(const Offset(-0.15, -0.15)), diamondPaint);
    }

    final railMid = rw * 0.55;
    for (var i = 1; i <= 7; i++) {
      final t = i / 8;
      final x = -hw + TableConstants.length * t;
      drawDiamond(x, -hh - railMid);
      drawDiamond(x, hh + railMid);
    }

    for (var i = 1; i <= 3; i++) {
      final t = i / 4;
      final y = -hh + TableConstants.width * t;
      drawDiamond(-hw - railMid, y);
      drawDiamond(hw + railMid, y);
    }
  }

  void _drawPockets(Canvas canvas) {
    for (var i = 0; i < TableConstants.pocketCenters.length; i++) {
      final c = TableConstants.pocketCenters[i];
      final r = TableConstants.pocketRadiusAt(i);

      // Outer shadow
      canvas.drawCircle(
        Offset(c.x + 0.3, c.y + 0.3),
        r + 1.0,
        Paint()..color = const Color(0x66000000),
      );

      // Pocket hole (dark)
      canvas.drawCircle(
        Offset(c.x, c.y),
        r + 0.8,
        Paint()..color = const Color(0xFF0D0D0D),
      );

      // Inner depth
      canvas.drawCircle(
        Offset(c.x, c.y),
        r * 0.75,
        Paint()..color = const Color(0xFF000000),
      );

      // Metal rim highlight
      canvas.drawCircle(
        Offset(c.x, c.y),
        r + 0.8,
        Paint()
          ..color = const Color(0x22FFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4,
      );
    }
  }
}

class CushionSegment extends BodyComponent {
  CushionSegment({required this.start, required this.end});

  final Vector2 start;
  final Vector2 end;

  static const cushionMarker = _CushionMarker();

  @override
  void render(Canvas canvas) {}

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);
    final fixtureDef = FixtureDef(shape)
      ..restitution = TableConstants.cushionRestitution
      ..friction = TableConstants.cushionFriction
      ..userData = cushionMarker;
    return world.createBody(BodyDef(type: BodyType.static))..createFixture(fixtureDef);
  }
}

class _CushionMarker {
  const _CushionMarker();
}
