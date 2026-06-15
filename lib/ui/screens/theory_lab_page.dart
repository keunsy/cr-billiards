import 'dart:math' as math;
import 'package:flutter/material.dart';

class TheoryLabPage extends StatelessWidget {
  const TheoryLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        title: const Text('理论实验室'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _LabCard(
            title: '切角三角形',
            subtitle: '切角、厚薄与假想球',
            icon: Icons.change_history,
            child: _CutAngleTriangleLab(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable card wrapper
// ---------------------------------------------------------------------------
class _LabCard extends StatelessWidget {
  const _LabCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF16213E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: const Color(0xFF66BB6A), size: 22),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13)),
            ]),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cut Angle Triangle Lab — interactive diagram with mode switching
// ---------------------------------------------------------------------------
class _CutAngleTriangleLab extends StatefulWidget {
  const _CutAngleTriangleLab();

  @override
  State<_CutAngleTriangleLab> createState() => _CutAngleTriangleLabState();
}

enum _TriangleMode { objectCenter, contactPoint, ghostCenter }

class _CutAngleTriangleLabState extends State<_CutAngleTriangleLab> {
  _TriangleMode _mode = _TriangleMode.ghostCenter;
  double _cutAngleDeg = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode buttons
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _modeChip('目标球中心 O', _TriangleMode.objectCenter,
                const Color(0xFF4CAF50)),
            _modeChip(
                '接触点 T', _TriangleMode.contactPoint, const Color(0xFFFF9800)),
            _modeChip('假想球中心 G ✅', _TriangleMode.ghostCenter,
                const Color(0xFF9C27B0)),
          ],
        ),
        const SizedBox(height: 12),

        // Angle slider
        Row(
          children: [
            const Text('切角', style: TextStyle(color: Colors.white70, fontSize: 13)),
            Expanded(
              child: Slider(
                value: _cutAngleDeg,
                min: 5,
                max: 85,
                divisions: 80,
                label: '${_cutAngleDeg.toStringAsFixed(0)}°',
                activeColor: const Color(0xFFFF6600),
                onChanged: (v) => setState(() => _cutAngleDeg = v),
              ),
            ),
            Text('${_cutAngleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFFFF6600),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),

        // Diagram
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CustomPaint(
            painter: _TrianglePainter(
              mode: _mode,
              cutAngleDeg: _cutAngleDeg,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Legend & theory
        _buildLegend(),
        const SizedBox(height: 12),
        _buildTheory(),
      ],
    );
  }

  Widget _modeChip(String label, _TriangleMode mode, Color color) {
    final selected = _mode == mode;
    return GestureDetector(
      onTap: () => setState(() => _mode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? color : Colors.white24, width: selected ? 2 : 1),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildLegend() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LegendItem(color: Color(0xFFFFEB3B), label: '邻边（沿进球线方向）'),
        _LegendItem(color: Color(0xFF00BFFF), label: '对边（垂直偏移量）'),
        _LegendItem(color: Color(0xFF66BB6A), label: '斜边（白球运动方向）'),
        _LegendItem(color: Color(0xFFE91E63), label: '切割线（瞄准线穿过目标球的弦）'),
      ],
    );
  }

  Widget _buildTheory() {
    final sinV = math.sin(_cutAngleDeg * math.pi / 180);
    String thickness;
    if (sinV < 0.13) {
      thickness = '全厚（正面碰）';
    } else if (sinV < 0.38) {
      thickness = '3/4 厚';
    } else if (sinV < 0.63) {
      thickness = '1/2 厚（半球）';
    } else if (sinV < 0.88) {
      thickness = '1/4 厚';
    } else {
      thickness = '极薄球';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: const Border(left: BorderSide(color: Color(0xFFFF6600), width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sin ${_cutAngleDeg.toStringAsFixed(0)}° = ${sinV.toStringAsFixed(3)}  →  $thickness',
            style: const TextStyle(
                color: Color(0xFFFF6600), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _mode == _TriangleMode.ghostCenter
                ? 'G（假想球中心）= 标准切角，C→G 就是白球运动方向'
                : _mode == _TriangleMode.objectCenter
                    ? 'O（目标球中心）= 简化近似，与标准切角有偏差（见表）'
                    : 'T（接触点）= 折中近似，精度介于 O 和 G 之间（见表）',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 12),
          const _DeviationTable(),
        ],
      ),
    );
  }
}

class _DeviationTable extends StatelessWidget {
  const _DeviationTable();

  static const _data = [
    (30, 27.02, -2.98, 28.44, -1.56),
    (45, 40.72, -4.28, 42.78, -2.22),
    (60, 54.65, -5.35, 57.25, -2.75),
    (72, 66.01, -5.99, 68.94, -3.06),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('O/T 与标准切角(G)的偏差',
            style: TextStyle(
                color: Color(0xFFFF6600), fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Table(
          border: TableBorder.all(color: Colors.white12, width: 0.5),
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05)),
              children: const [
                _Cell('G(标准)', bold: true, color: Color(0xFF9C27B0)),
                _Cell('O 角度', bold: true),
                _Cell('O 偏差', bold: true, color: Color(0xFFFF6600)),
                _Cell('T 角度', bold: true),
                _Cell('T 偏差', bold: true, color: Color(0xFFFF6600)),
              ],
            ),
            for (final row in _data)
              TableRow(children: [
                _Cell('${row.$1}°', bold: true, color: const Color(0xFF4CAF50)),
                _Cell('${row.$2}°'),
                _Cell('${row.$3}°', color: const Color(0xFFFF6600)),
                _Cell('${row.$4}°'),
                _Cell('${row.$5}°', color: const Color(0xFFFF6600)),
              ]),
          ],
        ),
        const SizedBox(height: 4),
        const Text('O 最大偏差近 6°，T 最大约 3°，角度越大偏差越大',
            style: TextStyle(color: Color(0xFFFF6600), fontSize: 10)),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, {this.bold = false, this.color = Colors.white60});
  final String text;
  final bool bold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(width: 16, height: 3, color: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom painter — all triangle geometry
// ---------------------------------------------------------------------------
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.mode, required this.cutAngleDeg});

  final _TriangleMode mode;
  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.04; // ball radius

    // Layout: pocket top-right, obj center-right, cue bottom-left
    final pocket = Offset(w * 0.88, h * 0.12);
    final obj = Offset(w * 0.58, h * 0.48);

    // Directions
    final op = (pocket - obj);
    final opNorm = op / op.distance;

    // Ghost ball center: one diameter behind obj on pocket line
    final ghost = obj - opNorm * 2 * r;
    // Contact point: midpoint
    final contact = obj - opNorm * r;

    // Determine vertex for current mode
    final Offset vertex;
    switch (mode) {
      case _TriangleMode.objectCenter:
        vertex = obj;
      case _TriangleMode.contactPoint:
        vertex = contact;
      case _TriangleMode.ghostCenter:
        vertex = ghost;
    }

    // Place cue ball so that angle at vertex = cutAngleDeg
    final vpDir = (pocket - vertex);
    final vpNorm = vpDir.distance > 0 ? vpDir / vpDir.distance : Offset.zero;
    final vpAngle = math.atan2(vpNorm.dy, vpNorm.dx);
    final targetRad = math.pi - cutAngleDeg * math.pi / 180;
    final cAngle = vpAngle - targetRad;
    final cDir = Offset(math.cos(cAngle), math.sin(cAngle));
    final cueDist = w * 0.42;
    final cue = vertex + cDir * cueDist;

    // ---- Draw background elements ----
    // Pocket line (dashed)
    final ext = obj - opNorm * (w * 0.18);
    _drawDashed(canvas, ext, pocket, const Color(0xFF555555), 1.2);

    // Pocket
    canvas.drawCircle(pocket, r * 1.4,
        Paint()..color = const Color(0xFF0A0A0A));
    canvas.drawCircle(
        pocket,
        r * 1.4,
        Paint()
          ..color = const Color(0xFF555555)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    _drawLabel(canvas, 'P', pocket + const Offset(0, -20),
        const Color(0xFF999999), 12);

    // Ghost ball outline
    canvas.drawCircle(
        ghost,
        r,
        Paint()
          ..color = const Color(0xFFB482FF).withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    _drawLabel(canvas, 'G', ghost + Offset(0, r + 14),
        const Color(0xFFB482FF).withValues(alpha: 0.6), 11);

    // Contact point
    canvas.drawCircle(contact, 3, Paint()..color = const Color(0xFFFF9800));
    _drawLabel(canvas, 'T', contact + const Offset(12, -8),
        const Color(0xFFFF9800), 10);

    // Object ball
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFF9D923));
    canvas.drawCircle(
        obj,
        r,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    _drawLabel(
        canvas, 'O', obj + Offset(r + 6, -r - 4), const Color(0xFFF9D923), 12);

    // Cue ball
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFF9D923));
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xFFF5F5F0));
    canvas.drawCircle(
        cue,
        r,
        Paint()
          ..color = const Color(0xFFDDDDDD)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    _drawLabel(
        canvas, 'C', cue + Offset(0, r + 14), const Color(0xFFEEEEEE), 12);

    // Aim line C→G (faint)
    _drawDashed(canvas, cue, ghost,
        const Color(0xFF66BB6A).withValues(alpha: 0.3), 1.2);

    // ---- Cut line: chord through contact point T, perpendicular to G→O ----
    final goDir = (obj - ghost);
    final goNorm = goDir.distance > 0 ? goDir / goDir.distance : Offset.zero;
    final cutDir = Offset(-goNorm.dy, goNorm.dx);

    // Intersect line through contact perpendicular to G→O with obj circle
    final tc = contact - obj;
    final bCut = 2 * _dot(tc, cutDir);
    final cCut = _dot(tc, tc) - r * r;
    final discCut = bCut * bCut - 4 * cCut;
    if (discCut >= 0) {
      final sqrtD = math.sqrt(math.max(0, discCut));
      final s1 = (-bCut - sqrtD) / 2;
      final s2 = (-bCut + sqrtD) / 2;
      final cut1 = contact + cutDir * s1;
      final cut2 = contact + cutDir * s2;

      final cutPaint = Paint()
        ..color = const Color(0xFFE91E63)
        ..strokeWidth = 2.5;
      canvas.drawLine(cut1, cut2, cutPaint);

      // Extension dashes
      _drawDashed(canvas, cut1 - cutDir * 15, cut1,
          const Color(0xFFE91E63).withValues(alpha: 0.3), 1.2);
      _drawDashed(canvas, cut2, cut2 + cutDir * 15,
          const Color(0xFFE91E63).withValues(alpha: 0.3), 1.2);

      canvas.drawCircle(cut1, 3, Paint()..color = const Color(0xFFE91E63));
      canvas.drawCircle(cut2, 3, Paint()..color = const Color(0xFFE91E63));

      final chordMid = (cut1 + cut2) / 2;
      final chordLen = (cut2 - cut1).distance;
      _drawLabel(canvas, '切割线', chordMid + goNorm * 16,
          const Color(0xFFE91E63), 10);
      _drawLabel(
          canvas,
          '${(chordLen / (2 * r)).toStringAsFixed(2)} 球径',
          chordMid + goNorm * 28,
          const Color(0xFFE91E63).withValues(alpha: 0.7),
          9);
    }

    // ---- Triangle (vertex already determined above) ----
    final Color vertexColor;
    final String vertexLabel;
    switch (mode) {
      case _TriangleMode.objectCenter:
        vertexColor = const Color(0xFF4CAF50);
        vertexLabel = '顶点 O';
      case _TriangleMode.contactPoint:
        vertexColor = const Color(0xFFFF9800);
        vertexLabel = '顶点 T';
      case _TriangleMode.ghostCenter:
        vertexColor = const Color(0xFF9C27B0);
        vertexLabel = '顶点 G';
    }

    // Perpendicular foot D: project C onto line from vertex along OP
    final vc = cue - vertex;
    final proj = _dot(vc, opNorm);
    final foot = vertex + opNorm * proj;

    // Triangle edges
    final triPaint = Paint()..strokeWidth = 2.5..style = PaintingStyle.stroke;

    triPaint.color = const Color(0xFFFFEB3B);
    canvas.drawLine(vertex, foot, triPaint);

    triPaint.color = const Color(0xFF00BFFF);
    canvas.drawLine(foot, cue, triPaint);

    triPaint.color = const Color(0xFF66BB6A);
    canvas.drawLine(vertex, cue, triPaint);

    // Right angle marker at D
    final sq = r * 0.7;
    final dToV = (vertex - foot);
    final dToVn = dToV.distance > 0 ? dToV / dToV.distance : Offset.zero;
    final dToC = (cue - foot);
    final dToCn = dToC.distance > 0 ? dToC / dToC.distance : Offset.zero;
    final raPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final ra1 = foot + dToVn * sq;
    final ra2 = foot + dToVn * sq + dToCn * sq;
    final ra3 = foot + dToCn * sq;
    canvas.drawLine(ra1, ra2, raPaint);
    canvas.drawLine(ra2, ra3, raPaint);

    // Foot label
    canvas.drawCircle(foot, 3.5, Paint()..color = Colors.white);
    _drawLabel(canvas, 'D(90°)', foot + const Offset(8, -12), Colors.white, 11);

    // Vertex highlight
    canvas.drawCircle(vertex, 5, Paint()..color = vertexColor);
    _drawLabel(canvas, vertexLabel, vertex + const Offset(0, -18), vertexColor, 12,
        bold: true);

    // Angle arc at vertex
    final startAng = math.atan2(foot.dy - vertex.dy, foot.dx - vertex.dx);
    final endAng = math.atan2(cue.dy - vertex.dy, cue.dx - vertex.dx);
    var sweep = endAng - startAng;
    if (sweep > math.pi) sweep -= 2 * math.pi;
    if (sweep < -math.pi) sweep += 2 * math.pi;

    final arcR = r * 2.5;
    final arcPaint = Paint()
      ..color = const Color(0xFFFF6600)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawArc(
      Rect.fromCircle(center: vertex, radius: arcR),
      startAng,
      sweep,
      false,
      arcPaint,
    );

    // Angle at this vertex
    final vToC = (cue - vertex);
    final vToCn = vToC.distance > 0 ? vToC / vToC.distance : Offset.zero;
    final vToP = (pocket - vertex);
    final vToPn = vToP.distance > 0 ? vToP / vToP.distance : Offset.zero;
    final fullAngle =
        math.acos(_dot(vToCn, vToPn).clamp(-1.0, 1.0)) * 180 / math.pi;
    final thisAngle = 180 - fullAngle;

    // Angle text
    final midAng = startAng + sweep / 2;
    final tx = vertex.dx + arcR * 2.2 * math.cos(midAng);
    final ty = vertex.dy + arcR * 2.2 * math.sin(midAng);
    _drawLabel(canvas, '${thisAngle.toStringAsFixed(1)}°', Offset(tx, ty),
        const Color(0xFFFF6600), 16,
        bold: true);

    // Edge ratio labels
    final adjLen = (foot - vertex).distance;
    final oppLen = (cue - foot).distance;
    final hypLen = (cue - vertex).distance;
    final base = oppLen > 0.1 ? oppLen : 1;

    final midAdj = (vertex + foot) / 2;
    final adjPerp = Offset(-opNorm.dy, opNorm.dx);
    _drawLabel(canvas, '×${(adjLen / base).toStringAsFixed(1)}',
        midAdj + adjPerp * 16, const Color(0xFFFFEB3B), 11,
        bold: true);

    final midOpp = (foot + cue) / 2;
    final oppDirN = dToC.distance > 0 ? dToC / dToC.distance : Offset.zero;
    final oppPerp = Offset(-oppDirN.dy, oppDirN.dx);
    _drawLabel(canvas, '×1.0', midOpp + oppPerp * 18, const Color(0xFF00BFFF), 11,
        bold: true);

    final midHyp = (vertex + cue) / 2;
    final hypDirN = vToC.distance > 0 ? vToC / vToC.distance : Offset.zero;
    final hypPerp = Offset(-hypDirN.dy, hypDirN.dx);
    _drawLabel(canvas, '×${(hypLen / base).toStringAsFixed(1)}',
        midHyp - hypPerp * 16, const Color(0xFF66BB6A), 11,
        bold: true);

    // Bottom info
    _drawLabel(
        canvas,
        'θ = ${thisAngle.toStringAsFixed(1)}°   sin θ = ${math.sin(thisAngle * math.pi / 180).toStringAsFixed(3)}',
        Offset(w / 2, h - 8),
        Colors.white38,
        10);
  }

  double _dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;

  void _drawDashed(
      Canvas canvas, Offset from, Offset to, Color color, double width) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;
    final d = to - from;
    final len = d.distance;
    final dir = d / len;
    const dashLen = 6.0;
    const gapLen = 4.0;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + dashLen, len);
      canvas.drawLine(from + dir * t, from + dir * end, paint);
      t = end + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize,
      {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_TrianglePainter old) =>
      old.mode != mode || old.cutAngleDeg != cutAngleDeg;
}
