import 'dart:math' as math;
import 'package:flutter/material.dart';

class AngleToolLab extends StatefulWidget {
  const AngleToolLab({super.key});

  @override
  State<AngleToolLab> createState() => _AngleToolLabState();
}

class _AngleToolLabState extends State<AngleToolLab> {
  Offset _cueBall = const Offset(0.25, 0.55);
  Offset _objBall = const Offset(0.55, 0.40);

  String? _dragging; // 'cue' | 'obj' | null

  // Two-point selection: user taps key points to measure between them
  String? _selectedPt1; // point label or null
  String? _selectedPt2;

  static const _pockets = [
    Offset(0.04, 0.06),
    Offset(0.50, 0.04),
    Offset(0.96, 0.06),
    Offset(0.04, 0.94),
    Offset(0.50, 0.96),
    Offset(0.96, 0.94),
  ];

  // Canvas is locked to AspectRatio(2/1), so one normalized y-unit covers
  // only half the physical length of one x-unit. Measure in this "iso" space
  // (y × h/w) to match the pixel-space painter; iso length × 254 == cm.
  static const _dyScale = 0.5; // h/w, fixed by AspectRatio(2.0/1.0)

  static Offset _iso(Offset n) => Offset(n.dx, n.dy * _dyScale);

  int _nearestPocketIndex() {
    double minD = double.infinity;
    int idx = 0;
    final obj = _iso(_objBall);
    for (var i = 0; i < _pockets.length; i++) {
      final d = (obj - _iso(_pockets[i])).distance;
      if (d < minD) {
        minD = d;
        idx = i;
      }
    }
    return idx;
  }

  Offset _toCanvas(Offset norm, Size size) =>
      Offset(norm.dx * size.width, norm.dy * size.height);

  Offset _toNorm(Offset canvas, Size size) =>
      Offset(
        (canvas.dx / size.width).clamp(0.06, 0.94),
        (canvas.dy / size.height).clamp(0.08, 0.92),
      );

  Map<String, Offset> _computeKeyPoints(Size size) {
    final w = size.width;
    final h = size.height;
    final ballR = w * 0.025;
    final pi = _nearestPocketIndex();
    final pocket = _pockets[pi];

    final pC = Offset(pocket.dx * w, pocket.dy * h);
    final oC = Offset(_objBall.dx * w, _objBall.dy * h);
    final cC = Offset(_cueBall.dx * w, _cueBall.dy * h);

    final opDir = pC - oC;
    final opLen = opDir.distance;
    if (opLen < 1) return {'C': cC, 'O': oC, 'P': pC};
    final opNorm = opDir / opLen;

    final ghost = oC - opNorm * (ballR * 2);
    final cgDir = ghost - cC;
    final cgLen = cgDir.distance;

    final pocketR = ballR * 1.4;
    final perpX = -opNorm.dy;
    final perpY = opNorm.dx;
    final edgeL = pC + Offset(perpX, perpY) * pocketR;
    final edgeR = pC - Offset(perpX, perpY) * pocketR;

    final pts = <String, Offset>{
      'C': cC,
      'O': oC,
      'P': pC,
      'G': ghost,
      'L': edgeL,
      'R': edgeR,
    };

    if (cgLen > 1) {
      final cgNorm = cgDir / cgLen;
      pts['I'] = cC + cgNorm * ballR;

      final cpDir = pC - cC;
      final cpLen = cpDir.distance;
      if (cpLen > 1) {
        pts['N'] = cC + (cpDir / cpLen) * ballR;
      }

      pts['T'] = oC - opNorm * ballR;
      pts['F'] = oC + opNorm * ballR;
    }

    return pts;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 4),
      AspectRatio(
        aspectRatio: 2.0 / 1.0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            return Listener(
              onPointerDown: (e) => _onPointerDown(e.localPosition, size),
              onPointerMove: (e) => _onPointerMove(e.localPosition, size),
              onPointerUp: (e) => _onPointerUp(e.localPosition, size),
              child: CustomPaint(
                painter: _AngleToolPainter(
                  cueBall: _cueBall,
                  objBall: _objBall,
                  pocketIndex: _nearestPocketIndex(),
                  selectedPt1: _selectedPt1,
                  selectedPt2: _selectedPt2,
                ),
                size: size,
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 4),
      _buildSelectionPanel(),
      const SizedBox(height: 4),
      _buildInfoPanel(),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 14, runSpacing: 6, children: const [
          _LegendDot(color: Color(0xFFF5F5F0), label: '母球 C'),
          _LegendDot(color: Color(0xFFE53935), label: '目标球 O'),
          _LegendDot(color: Color(0xFF111111), label: '袋口 P', border: Color(0xFF81C784)),
          _LegendDot(color: Color(0x5500E676), label: '假想球 G', border: Color(0xFF00E676)),
          _LegendDot(color: Color(0xFFFF9800), label: '接触点 I'),
          _LegendDot(color: Color(0xFF80DEEA), label: '近袋点 N'),
          _LegendDot(color: Color(0xFFCE93D8), label: '碰撞点 T'),
          _LegendDot(color: Color(0xFFA5D6A7), label: '近袋点 F'),
          _LegendDot(color: Color(0xFFFFD54F), label: '袋口边缘 L/R'),
        ]),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF42A5F5).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF42A5F5).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('使用说明',
                  style: TextStyle(color: Color(0xFF42A5F5), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '拖动母球(C)或目标球(O)调整位置，点击任意两个关键点查看连线角度。\n\n'
                '操作：\n'
                '• 拖动 — 移动 C 或 O\n'
                '• 单击关键点 — 选择第一个点（橙色光环）\n'
                '• 再单击另一个点 — 选择第二个点，显示连线/距离/角度\n'
                '• 再次单击 — 重新选择',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildSelectionPanel() {
    if (_selectedPt1 == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text('点击任意关键点开始测量',
              style: TextStyle(color: Colors.white38, fontSize: 12),
              textAlign: TextAlign.center),
        ),
      );
    }

    final label1 = _selectedPt1!;
    final label2 = _selectedPt2;

    if (label2 == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('已选 $label1', style: const TextStyle(color: Color(0xFFFF9800), fontSize: 13, fontWeight: FontWeight.bold)),
              const Text('  →  点击第二个点', style: TextStyle(color: Colors.white54, fontSize: 12)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() { _selectedPt1 = null; _selectedPt2 = null; }),
                child: const Icon(Icons.close, size: 16, color: Colors.white38),
              ),
            ],
          ),
        ),
      );
    }

    // Both points selected — show measurement
    // Use a dummy size for calculations (actual canvas size not available here,
    // so we use a standard reference)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9800).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text('$label1 → $label2',
                style: const TextStyle(color: Color(0xFFFF9800), fontSize: 14, fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() { _selectedPt1 = null; _selectedPt2 = null; }),
              child: const Text('清除', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    final pi = _nearestPocketIndex();
    final pocket = _pockets[pi];
    // Measure in iso space (see _iso): angles match the pixel-space painter
    // exactly and iso length × 254 == painter's pixels / w × 254 (cm).
    final obj = _iso(_objBall);
    final cue = _iso(_cueBall);
    final pk = _iso(pocket);
    final opDir = pk - obj;
    final opLen = opDir.distance;
    if (opLen < 0.001) return const SizedBox.shrink();
    final opNorm = opDir / opLen;

    const ballR = 0.025; // matches painter's ballR = w * 0.025 in iso units
    final ghost = obj - opNorm * (ballR * 2);

    final cgDir = ghost - cue;
    final cgLen = cgDir.distance;
    if (cgLen < 0.001) return const SizedBox.shrink();

    // Cut angle θ = ∠(object travel dir O→P, cue travel dir C→G):
    // θ = 0° is a straight ball, θ ≤ 90° is a legal pot.
    final cutAngle = _angleBetween(opNorm, cgDir / cgLen) * 180 / math.pi;
    final validShot = cutAngle <= 90;

    final coDir = obj - cue;
    final coLen = coDir.distance;
    if (coLen < 0.001) return const SizedBox.shrink();
    final aimDeviation = _angleBetween(opNorm, coDir / coLen) * 180 / math.pi;

    final separationAngle = validShot ? (90.0 - cutAngle.clamp(0, 89.9)) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('切球角度', '${cutAngle.toStringAsFixed(1)}°',
                  validShot ? _cutAngleDesc(cutAngle) : '⚠ 无法直接进球'),
              _infoRow('瞄准偏差角', '${aimDeviation.toStringAsFixed(1)}°', null),
              if (validShot)
                _infoRow('分离角 (中杆)', '${separationAngle.toStringAsFixed(1)}°',
                    separationAngle > 85 ? '接近直球' : null),
              _infoRow('C→O 距离', '${(coLen * 254).toStringAsFixed(0)} cm', null),
              _infoRow('O→P 距离', '${(opLen * 254).toStringAsFixed(0)} cm', null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, String? note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          if (note != null) ...[
            const SizedBox(width: 8),
            Text(note, style: const TextStyle(color: Color(0xFFFFB74D), fontSize: 11)),
          ],
        ],
      ),
    );
  }

  String? _cutAngleDesc(double deg) {
    if (deg < 10) return '厚球';
    if (deg < 25) return '中厚';
    if (deg < 45) return '半球';
    if (deg < 65) return '中薄';
    return '薄球';
  }

  double _angleBetween(Offset a, Offset b) {
    final dot = a.dx * b.dx + a.dy * b.dy;
    return math.acos(dot.clamp(-1.0, 1.0));
  }

  Offset? _pointerDownPos;
  bool _didDrag = false;
  static const _dragThreshold = 6.0;

  void _onPointerDown(Offset localPos, Size size) {
    _pointerDownPos = localPos;
    _didDrag = false;

    final cueCanvas = _toCanvas(_cueBall, size);
    final objCanvas = _toCanvas(_objBall, size);
    final hitR = size.width * 0.05;

    final dCue = (localPos - cueCanvas).distance;
    final dObj = (localPos - objCanvas).distance;

    if (dCue < hitR && dCue <= dObj) {
      _dragging = 'cue';
    } else if (dObj < hitR) {
      _dragging = 'obj';
    } else {
      _dragging = null;
    }
  }

  void _onPointerMove(Offset localPos, Size size) {
    if (_pointerDownPos != null &&
        (localPos - _pointerDownPos!).distance > _dragThreshold) {
      _didDrag = true;
    }

    if (_dragging == null || !_didDrag) return;
    final norm = _toNorm(localPos, size);
    setState(() {
      if (_dragging == 'cue') {
        _cueBall = norm;
      } else if (_dragging == 'obj') {
        _objBall = norm;
      }
    });
  }

  void _onPointerUp(Offset localPos, Size size) {
    if (!_didDrag) {
      // Treat as tap — try to select a key point
      final pts = _computeKeyPoints(size);
      final hitR = size.width * 0.06;

      String? tapped;
      double minDist = hitR;
      for (final entry in pts.entries) {
        final d = (localPos - entry.value).distance;
        if (d < minDist) {
          minDist = d;
          tapped = entry.key;
        }
      }

      if (tapped != null) {
        setState(() {
          if (_selectedPt1 == null) {
            _selectedPt1 = tapped;
            _selectedPt2 = null;
          } else if (_selectedPt2 == null) {
            if (tapped == _selectedPt1) {
              _selectedPt1 = null;
            } else {
              _selectedPt2 = tapped;
            }
          } else {
            _selectedPt1 = tapped;
            _selectedPt2 = null;
          }
        });
      }
    }

    _dragging = null;
    _pointerDownPos = null;
    _didDrag = false;
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

class _AngleToolPainter extends CustomPainter {
  _AngleToolPainter({
    required this.cueBall,
    required this.objBall,
    required this.pocketIndex,
    this.selectedPt1,
    this.selectedPt2,
  });

  final Offset cueBall;
  final Offset objBall;
  final int pocketIndex;
  final String? selectedPt1;
  final String? selectedPt2;

  static const _pockets = _AngleToolLabState._pockets;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final ballR = w * 0.025;

    // Table
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(0, 0, w, h), 6, 6),
      Paint()..color = const Color(0xFF1B6B1F),
    );
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(0, 0, w, h), 6, 6),
      Paint()..color = const Color(0xFF8B4513)..style = PaintingStyle.stroke..strokeWidth = 3,
    );

    final pocket = _pockets[pocketIndex];
    final pC = Offset(pocket.dx * w, pocket.dy * h);
    final oC = Offset(objBall.dx * w, objBall.dy * h);
    final cC = Offset(cueBall.dx * w, cueBall.dy * h);

    final opDir = pC - oC;
    final opLen = opDir.distance;
    if (opLen < 1) return;
    final opNorm = opDir / opLen;

    final ghost = oC - opNorm * (ballR * 2);
    final cgDir = ghost - cC;
    final cgLen = cgDir.distance;

    // Cut angle θ = ∠(O→P, cue travel dir): 0° straight ball, >90° illegal.
    final cutAngleDeg = cgLen > 1
        ? _angleBetweenVec(opNorm, cgDir / cgLen) * 180 / math.pi
        : 0.0;
    final validShot = cgLen > 1 && cutAngleDeg <= 90;

    // Collect all key points for selection hit-testing and rendering
    final pts = <String, Offset>{
      'C': cC, 'O': oC, 'P': pC, 'G': ghost,
    };

    final pocketR = ballR * 1.4;
    final perpX = -opNorm.dy;
    final perpY = opNorm.dx;
    final edgeL = pC + Offset(perpX, perpY) * pocketR;
    final edgeR = pC - Offset(perpX, perpY) * pocketR;
    pts['L'] = edgeL;
    pts['R'] = edgeR;

    if (cgLen > 1) {
      final cgNorm = cgDir / cgLen;
      pts['I'] = cC + cgNorm * ballR;
      final cpDir = pC - cC;
      final cpLen = cpDir.distance;
      if (cpLen > 1) {
        pts['N'] = cC + (cpDir / cpLen) * ballR;
      }
      pts['T'] = oC - opNorm * ballR;
      pts['F'] = oC + opNorm * ballR;
    }

    // --- Draw all pockets ---
    for (var i = 0; i < _pockets.length; i++) {
      final pp = Offset(_pockets[i].dx * w, _pockets[i].dy * h);
      canvas.drawCircle(pp, pocketR, Paint()..color = const Color(0xFF111111));
      if (i == pocketIndex) {
        canvas.drawCircle(pp, pocketR,
            Paint()..color = const Color(0xFF81C784)..style = PaintingStyle.stroke..strokeWidth = 1.5);
        const crossR = 3.0;
        canvas.drawLine(pp - const Offset(crossR, 0), pp + const Offset(crossR, 0),
            Paint()..color = const Color(0xFF81C784)..strokeWidth = 1.0);
        canvas.drawLine(pp - const Offset(0, crossR), pp + const Offset(0, crossR),
            Paint()..color = const Color(0xFF81C784)..strokeWidth = 1.0);
        _drawKeyPoint(canvas, edgeL, const Color(0xFFFFD54F), 'L');
        _drawKeyPoint(canvas, edgeR, const Color(0xFFFFD54F), 'R');
        _drawDashedLine(canvas, oC, edgeL,
            Paint()..color = const Color(0x33FFD54F)..strokeWidth = 0.6);
        _drawDashedLine(canvas, oC, edgeR,
            Paint()..color = const Color(0x33FFD54F)..strokeWidth = 0.6);
      }
    }

    // --- Standard lines (dimmed) ---
    final dashedPaint = Paint()..color = Colors.white24..strokeWidth = 0.8;
    _drawDashedLine(canvas, oC, pC, dashedPaint);

    if (cgLen > 1) {
      canvas.drawLine(cC, ghost, Paint()..color = const Color(0xCC66BB6A)..strokeWidth = 1.5);
      final cgNorm = cgDir / cgLen;
      final aimEnd = cC + cgNorm * (cgLen + w * 0.15);
      _drawDashedLine(canvas, ghost, aimEnd,
          Paint()..color = const Color(0x5566BB6A)..strokeWidth = 0.8);
    }
    canvas.drawLine(ghost, pC, Paint()..color = const Color(0x88FFEB3B)..strokeWidth = 1.0);

    // Separation line (cue-ball path after contact — only for a legal pot)
    if (validShot) {
      final perpDir = Offset(-opNorm.dy, opNorm.dx);
      final cgNorm = cgDir / cgLen;
      final dot = perpDir.dx * cgNorm.dx + perpDir.dy * cgNorm.dy;
      final sepDir = dot > 0 ? perpDir : Offset(-perpDir.dx, -perpDir.dy);
      final sepEnd = oC + sepDir * (w * 0.15);
      _drawDashedLine(canvas, oC, sepEnd,
          Paint()..color = const Color(0x6642A5F5)..strokeWidth = 1.0);
      _drawText(canvas, sepEnd + const Offset(0, -10), '母球路径(中杆)', 9,
          const Color(0xFF42A5F5));
    }

    // --- Angle arcs ---
    if (cgLen > 1) {
      final cgNormUnit = cgDir / cgLen;

      // 1) Cut angle arc at ghost ball (white): object travel dir vs cue travel dir
      if (cutAngleDeg > 2 && cutAngleDeg < 90) {
        final arcR = ballR * 3;
        final fromAngle = math.atan2(opNorm.dy, opNorm.dx);
        final toAngle = math.atan2(cgNormUnit.dy, cgNormUnit.dx);
        final sweep = _shortestSweep(fromAngle, toAngle);

        canvas.drawArc(Rect.fromCircle(center: ghost, radius: arcR),
            fromAngle, sweep, false,
            Paint()..color = const Color(0xCCFFFFFF)..style = PaintingStyle.stroke..strokeWidth = 1.2);
        final labelA = fromAngle + sweep / 2;
        final labelPos = ghost + Offset(math.cos(labelA), math.sin(labelA)) * (arcR + 10);
        _drawText(canvas, labelPos, '切${cutAngleDeg.toStringAsFixed(1)}°', 10, Colors.white);
      }

      // 2) Aim deviation arc at O (orange): O→P vs reverse C→O
      final coDir = oC - cC;
      final coLen = coDir.distance;
      if (coLen > 1) {
        final coNorm = coDir / coLen;
        final aimDevRad = _angleBetweenVec(opNorm, coNorm);
        final aimDevDeg = aimDevRad * 180 / math.pi;
        if (aimDevDeg > 2) {
          final arcR2 = ballR * 2.5;
          final fromAngle2 = math.atan2(opNorm.dy, opNorm.dx);
          final toAngle2 = math.atan2(-coNorm.dy, -coNorm.dx);
          final sweep2 = _shortestSweep(fromAngle2, toAngle2);

          canvas.drawArc(Rect.fromCircle(center: oC, radius: arcR2),
              fromAngle2, sweep2, false,
              Paint()..color = const Color(0xBBFF9800)..style = PaintingStyle.stroke..strokeWidth = 1.2);
          final labelA2 = fromAngle2 + sweep2 / 2;
          final labelPos2 = oC + Offset(math.cos(labelA2), math.sin(labelA2)) * (arcR2 + 10);
          _drawText(canvas, labelPos2, '偏${aimDevDeg.toStringAsFixed(1)}°', 9, const Color(0xFFFF9800));
        }
      }

      // 3) Separation angle arc at O (blue): cue travel dir → cue deflection dir,
      //    arc span = |90° − θ| = the label shown below.
      if (cutAngleDeg > 2 && cutAngleDeg < 90) {
        final perpDir = Offset(-opNorm.dy, opNorm.dx);
        final dot = perpDir.dx * cgNormUnit.dx + perpDir.dy * cgNormUnit.dy;
        final sepDir = dot > 0 ? perpDir : Offset(-perpDir.dx, -perpDir.dy);
        final sepAngle = math.atan2(sepDir.dy, sepDir.dx);
        final cueAngle = math.atan2(cgNormUnit.dy, cgNormUnit.dx);
        final sepSweep = _shortestSweep(cueAngle, sepAngle);

        if (sepSweep.abs() > 0.05) {
          final arcR3 = ballR * 4;
          canvas.drawArc(Rect.fromCircle(center: oC, radius: arcR3),
              cueAngle, sepSweep, false,
              Paint()..color = const Color(0x9942A5F5)..style = PaintingStyle.stroke..strokeWidth = 1.2);
          final sepDeg = (90.0 - cutAngleDeg).abs();
          final labelA3 = cueAngle + sepSweep / 2;
          final labelPos3 = oC + Offset(math.cos(labelA3), math.sin(labelA3)) * (arcR3 + 10);
          _drawText(canvas, labelPos3, '分${sepDeg.toStringAsFixed(1)}°', 9, const Color(0xFF42A5F5));
        }
      }
    }

    // --- Distance labels ---
    final coMid = Offset((cC.dx + oC.dx) / 2, (cC.dy + oC.dy) / 2);
    final coDist = (cC - oC).distance / w * 254;
    _drawText(canvas, coMid + const Offset(0, -10), '${coDist.toStringAsFixed(0)} cm', 9, Colors.white54);

    final opMid = Offset((oC.dx + pC.dx) / 2, (oC.dy + pC.dy) / 2);
    final opDist = (oC - pC).distance / w * 254;
    _drawText(canvas, opMid + const Offset(0, 12), '${opDist.toStringAsFixed(0)} cm', 9, Colors.white54);

    // --- Key surface points ---
    if (cgLen > 1 && pts.containsKey('I')) {
      _drawKeyPoint(canvas, pts['I']!, const Color(0xFFFF9800), 'I');
      if (pts.containsKey('N')) {
        _drawKeyPoint(canvas, pts['N']!, const Color(0xFF80DEEA), 'N');
        _drawDashedLine(canvas, cC, pC,
            Paint()..color = const Color(0x3380DEEA)..strokeWidth = 0.6);
      }
      if (pts.containsKey('T')) {
        _drawKeyPoint(canvas, pts['T']!, const Color(0xFFCE93D8), 'T');
      }
      if (pts.containsKey('F')) {
        _drawKeyPoint(canvas, pts['F']!, const Color(0xFFA5D6A7), 'F');
      }
    }

    // --- Balls (solid balls first, then ghost on top) ---
    _drawBall(canvas, oC, ballR, const Color(0xFFE53935));
    _drawText(canvas, oC + Offset(0, ballR + 10), 'O', 10, Colors.white70);

    _drawBall(canvas, cC, ballR, const Color(0xFFF5F5F0));
    _drawText(canvas, cC + Offset(0, ballR + 10), 'C', 10, Colors.black54);

    _drawText(canvas, pC + Offset(0, pocketR + 10), 'P', 10, const Color(0xFF81C784));

    // Ghost ball drawn last so it's always visible
    canvas.drawCircle(ghost, ballR, Paint()..color = const Color(0x8800E676));
    canvas.drawCircle(ghost, ballR,
        Paint()..color = const Color(0xFF00E676)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    final crossR = ballR * 0.5;
    final crossPaint = Paint()..color = const Color(0xFF00E676)..strokeWidth = 1.5;
    canvas.drawLine(ghost - Offset(crossR, 0), ghost + Offset(crossR, 0), crossPaint);
    canvas.drawLine(ghost - Offset(0, crossR), ghost + Offset(0, crossR), crossPaint);
    _drawText(canvas, ghost + Offset(0, -ballR - 8), 'G', 11, const Color(0xFF00E676));

    // --- Selection highlight ---
    for (final sel in [selectedPt1, selectedPt2]) {
      if (sel != null && pts.containsKey(sel)) {
        final sp = pts[sel]!;
        canvas.drawCircle(sp, ballR * 0.8,
            Paint()..color = const Color(0xAAFF9800)..style = PaintingStyle.stroke..strokeWidth = 2.0);
      }
    }

    // --- Selected pair measurement line ---
    if (selectedPt1 != null && selectedPt2 != null &&
        pts.containsKey(selectedPt1) && pts.containsKey(selectedPt2)) {
      final p1 = pts[selectedPt1]!;
      final p2 = pts[selectedPt2]!;
      final selDist = (p1 - p2).distance;

      // Bright measurement line
      canvas.drawLine(p1, p2,
          Paint()..color = const Color(0xEEFF9800)..strokeWidth = 2.0);

      // Distance label
      final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      final distCm = selDist / w * 254;
      _drawText(canvas, mid + const Offset(0, -14),
          '$selectedPt1→$selectedPt2: ${distCm.toStringAsFixed(1)} cm', 11,
          const Color(0xFFFF9800));

      // Angle with O→P line (if meaningful)
      if (selDist > 2) {
        final selDir = (p2 - p1);
        final selNorm = selDir / selDist;
        final angle = _angleBetweenVec(opNorm, selNorm) * 180 / math.pi;
        final displayAngle = angle > 90 ? 180 - angle : angle;
        _drawText(canvas, mid + const Offset(0, 6),
            '与O→P夹角: ${displayAngle.toStringAsFixed(1)}°', 10,
            const Color(0xFFFFCC80));
      }
    }

    // Drag hint
    _drawText(canvas, Offset(w * 0.5, h - 10),
        '拖动 C/O 移动 · 点击关键点测量', 10, Colors.white30);
  }

  void _drawKeyPoint(Canvas canvas, Offset pt, Color color, String label) {
    const dotR = 3.0;
    canvas.drawCircle(pt, dotR + 1, Paint()..color = Colors.black54);
    canvas.drawCircle(pt, dotR, Paint()..color = color);
    _drawText(canvas, pt + const Offset(0, -10), label, 9, color);
  }

  void _drawBall(Canvas canvas, Offset center, double r, Color color) {
    canvas.drawCircle(center + const Offset(1, 2), r,
        Paint()..color = Colors.black26..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    final gradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      colors: [
        Color.lerp(color, Colors.white, 0.35)!,
        color,
        Color.lerp(color, Colors.black, 0.3)!,
      ],
      stops: const [0, 0.5, 1],
    );
    canvas.drawCircle(center, r,
        Paint()..shader = gradient.createShader(Rect.fromCircle(center: center, radius: r)));
    canvas.drawCircle(center + Offset(-r * 0.25, -r * 0.25), r * 0.2,
        Paint()..color = Colors.white.withValues(alpha: 0.4));
  }

  double _shortestSweep(double from, double to) {
    var sweep = to - from;
    while (sweep > math.pi) { sweep -= 2 * math.pi; }
    while (sweep < -math.pi) { sweep += 2 * math.pi; }
    return sweep;
  }

  double _angleBetweenVec(Offset a, Offset b) {
    final dot = a.dx * b.dx + a.dy * b.dy;
    return math.acos(dot.clamp(-1.0, 1.0));
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    final dir = b - a;
    final len = dir.distance;
    if (len < 1) return;
    final norm = dir / len;
    const dash = 4.0;
    const gap = 3.0;
    var d = 0.0;
    while (d < len) {
      final s = a + norm * d;
      final e = a + norm * (d + dash).clamp(0, len);
      canvas.drawLine(s, e, paint);
      d += dash + gap;
    }
  }

  void _drawText(Canvas canvas, Offset pos, String text, double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _AngleToolPainter old) =>
      old.cueBall != cueBall || old.objBall != objBall ||
      old.pocketIndex != pocketIndex ||
      old.selectedPt1 != selectedPt1 || old.selectedPt2 != selectedPt2;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label, this.border});
  final Color color;
  final String label;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: border != null ? Border.all(color: border!, width: 1) : null,
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ]);
  }
}
