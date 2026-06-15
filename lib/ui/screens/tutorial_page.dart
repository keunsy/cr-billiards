import 'dart:math' as math;

import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        title: const Text('中八教程'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          // ============ Part 1: Basics ============
          _SectionHeader(number: 1, title: '认识球桌与球'),
          _InfoCard(children: [
            _Paragraph(
              '中式八球使用 16 颗球：1 颗白色母球和 15 颗目标球。'
              '1-7 号为全色球（实心色），9-15 号为花色球（带条纹），8 号为黑色球。',
            ),
            SizedBox(height: 12),
            _BallChartWidget(),
            SizedBox(height: 12),
            _Paragraph(
              '标准球台内径 254cm × 127cm，6 个球袋（4 个底袋、2 个中袋）。'
              '开球线位于距端库 1/4 处，置球点位于另一侧 1/4 处。',
            ),
            SizedBox(height: 12),
            _TableDiagramWidget(),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 2, title: '比赛目标'),
          _InfoCard(children: [
            _Paragraph(
              '目标：先把己方球组（全色或花色）全部打进球袋，最后合法打入 8 号球即获胜。\n\n'
              '开球后，谁先合法打进哪组球，就拥有那组；另一方拥有另一组。',
            ),
          ]),

          // ============ Part 2: Controls ============
          SizedBox(height: 32),
          _SectionHeader(number: 3, title: '游戏操控——瞄准'),
          _InfoCard(children: [
            _Paragraph(
              '点击或拖动球台任意位置来调整瞄准方向。白球与目标球的连线构成你的击球轨迹。',
            ),
            SizedBox(height: 12),
            _AimDiagramWidget(),
            SizedBox(height: 12),
            _LegendRow(color: Color(0xFF66BB6A), label: '绿色虚线 = 白球轨迹（瞄准方向）'),
            _LegendRow(color: Color(0xFFFFEB3B), label: '黄色虚线 = 目标球预测路径（进球线）'),
            _LegendRow(color: Color(0xFF00BFFF), label: '蓝色虚线 = 白球偏转路径（分离角）'),
            _LegendRow(color: Color(0x99FFFFFF), label: '半透明圈 = 假想球（白球碰撞位置）'),
            _LegendRow(color: Color(0xFFFF5722), label: '红色圆点 = 接触点'),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 4, title: '游戏操控——蓄力与击球'),
          _InfoCard(children: [
            _Paragraph(
              '屏幕右侧为力度条，从底部绿色（轻击）到顶部红色（全力）。',
            ),
            SizedBox(height: 8),
            _BulletList(items: [
              '点击力度条任意位置 → 直接设定力量',
              '上下拖动力度条 → 微调',
              '调好后点击右下角红色按钮击球',
              '等所有球停止运动后才能下一杆',
            ]),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 5, title: '游戏操控——加塞'),
          _InfoCard(children: [
            _Paragraph(
              '屏幕左侧的白色圆盘控制加塞（击球点偏移），红点代表球杆击打白球的位置。',
            ),
            SizedBox(height: 12),
            _SpinDiagramWidget(),
            SizedBox(height: 12),
            _BulletList(items: [
              '红点偏左 → 白球碰后向左偏',
              '红点偏右 → 白球碰后向右偏',
              '红点居中 → 无旋转（中杆）',
            ]),
          ]),

          // ============ Part 3: Theory ============
          SizedBox(height: 32),
          _SectionHeader(number: 6, title: '切角与分离角'),
          _InfoCard(children: [
            _Paragraph(
              '切角（cut angle）是瞄准方向与球心连线之间的夹角。切角越大，目标球偏离越多。',
            ),
            SizedBox(height: 12),
            _CutAngleDiagramWidget(),
            SizedBox(height: 12),
            _Paragraph(
              '分离角是白球碰撞后偏转的角度。在无旋转的中杆击球下：\n\n'
              '• 切角 ≈ 0°（正面撞）→ 白球停住，目标球直线前进\n'
              '• 切角 30° → 白球偏转约 60°\n'
              '• 切角 45° → 白球和目标球各偏 45°（形成直角）\n\n'
              '记住：切角 + 分离角 ≈ 90°（在无旋转下近似成立）',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 7, title: '直角三角形模型'),
          _InfoCard(children: [
            _Paragraph(
              '碰撞几何可以用直角三角形来理解：',
            ),
            SizedBox(height: 12),
            _TriangleDiagramWidget(),
            SizedBox(height: 12),
            _BulletList(items: [
              '斜边 = 白球入射方向',
              '长边 = 目标球运动方向（碰撞法线）',
              '短边 = 白球偏转方向（碰撞切线）',
              '标注的倍数比帮助你判断力度分配',
            ]),
          ]),

          // ============ Part 4: Placement ============
          SizedBox(height: 32),
          _SectionHeader(number: 8, title: '放球操作'),
          _InfoCard(children: [
            _BulletList(items: [
              '标准模式开局：长按白球拖到开球线后任意位置',
              '白球落袋后：长按白球拖到台面任意位置',
              '练习模式：长按任意球拖动到任意位置',
            ]),
            SizedBox(height: 8),
            _Paragraph('长按约 0.4 秒开始拖动，球会变为半透明表示正在移动。'),
          ]),

          // ============ Part 5: Settings ============
          SizedBox(height: 24),
          _SectionHeader(number: 9, title: '辅助线设置'),
          _InfoCard(children: [
            _Paragraph('游戏内右上角有两个控制按钮：'),
            SizedBox(height: 8),
            _BulletList(items: [
              '「隐藏/显示辅助线」→ 快速开关所有辅助线',
              '⚙️ 图标 → 进入详细设置，可独立控制：',
            ]),
            SizedBox(height: 8),
            _SubList(items: [
              '瞄准辅助线（白球轨迹 + 假想球 + 接触点）',
              '进球预测线（目标球路径）',
              '切角角度（弧线 + 数值）',
              '分离角线（白球偏转路径）',
              '角度三角形（直角三角形 + 倍数比）',
            ]),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 10, title: '犯规规则'),
          _InfoCard(children: [
            _Paragraph('常见犯规（橙色提示）：'),
            SizedBox(height: 8),
            _BulletList(items: [
              '白球落袋（洗袋）→ 对方获自由球',
              '白球未击中任何球 → 犯规',
              '无球入袋且无球碰库 → 犯规',
              '8 号球在己方球未清完前入袋 → 直接判负',
            ]),
          ]),

          SizedBox(height: 48),
          Center(
            child: Text(
              '祝你打出好球！🎱',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ============ Reusable Widgets ============

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.number, required this.title});
  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2E7D32),
            ),
            alignment: Alignment.center,
            child: Text('$number', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Color(0xFF81C784), fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, height: 1.7),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
                    Expanded(child: Text(item, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, height: 1.5))),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _SubList extends StatelessWidget {
  const _SubList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('– ', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                      Expanded(child: Text(item, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.4))),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(width: 16, height: 3, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13))),
        ],
      ),
    );
  }
}

// ============ Custom Paint Diagrams ============

class _BallChartWidget extends StatelessWidget {
  const _BallChartWidget();

  static const _ballColors = <int, Color>{
    1: Color(0xFFF9D923), 2: Color(0xFF1565C0), 3: Color(0xFFD32F2F), 4: Color(0xFF7B1FA2),
    5: Color(0xFFFF8F00), 6: Color(0xFF2E7D32), 7: Color(0xFF880E4F), 8: Color(0xFF1A1A1A),
    9: Color(0xFFF9D923), 10: Color(0xFF1565C0), 11: Color(0xFFD32F2F), 12: Color(0xFF7B1FA2),
    13: Color(0xFFFF8F00), 14: Color(0xFF2E7D32), 15: Color(0xFF880E4F),
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: CustomPaint(painter: _BallChartPainter(_ballColors)),
    );
  }
}

class _BallChartPainter extends CustomPainter {
  _BallChartPainter(this.colors);
  final Map<int, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = (size.width - 20) / 15;
    final r = (spacing * 0.4).clamp(5.0, 10.0);
    final startX = (size.width - 15 * spacing) / 2 + spacing / 2;

    for (var i = 1; i <= 15; i++) {
      final x = startX + (i - 1) * spacing;
      final y = size.height / 2;
      final color = colors[i]!;
      final isStripe = i >= 9;

      if (isStripe) {
        canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white);
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: r * 2, height: r * 0.9),
          Paint()..color = color,
        );
      } else {
        canvas.drawCircle(Offset(x, y), r, Paint()..color = color);
      }

      canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);

      final tp = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(color: i == 8 ? Colors.white : Colors.black87, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TableDiagramWidget extends StatelessWidget {
  const _TableDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 120, child: CustomPaint(painter: _TableDiagramPainter()));
  }
}

class _TableDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.85;
    final h = w / 2;
    final ox = (size.width - w) / 2;
    final oy = (size.height - h) / 2;

    // Felt
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 4, 4),
      Paint()..color = const Color(0xFF1B6B1F),
    );

    // Rail
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 4, 4),
      Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 4,
    );

    // Pockets
    final pocketPaint = Paint()..color = const Color(0xFF0D0D0D);
    const pr = 5.0;
    for (final p in [
      Offset(ox, oy), Offset(ox + w / 2, oy), Offset(ox + w, oy),
      Offset(ox, oy + h), Offset(ox + w / 2, oy + h), Offset(ox + w, oy + h),
    ]) {
      canvas.drawCircle(p, pr, pocketPaint);
    }

    // Head string
    final hsx = ox + w / 4;
    canvas.drawLine(
      Offset(hsx, oy + 6), Offset(hsx, oy + h - 6),
      Paint()..color = Colors.white24..strokeWidth = 1,
    );

    // Foot spot
    canvas.drawCircle(Offset(ox + w * 3 / 4, oy + h / 2), 3, Paint()..color = Colors.white38);

    // Labels
    _drawLabel(canvas, '开球线', Offset(hsx, oy + h + 8), Colors.white54);
    _drawLabel(canvas, '置球点', Offset(ox + w * 3 / 4, oy + h + 8), Colors.white54);
    _drawLabel(canvas, '底袋', Offset(ox - 2, oy - 10), Colors.white38);
    _drawLabel(canvas, '中袋', Offset(ox + w / 2 - 8, oy - 10), Colors.white38);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AimDiagramWidget extends StatelessWidget {
  const _AimDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100, child: CustomPaint(painter: _AimDiagramPainter()));
  }
}

class _AimDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cue ball
    canvas.drawCircle(Offset(cx - 80, cy), 8, Paint()..color = Colors.white);
    _drawLabel(canvas, '白球', Offset(cx - 92, cy + 12), Colors.white54);

    // Ghost ball
    canvas.drawCircle(
      Offset(cx + 10, cy - 12), 8,
      Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    _drawLabel(canvas, '假想球', Offset(cx - 2, cy + 2), Colors.white38);

    // Object ball
    canvas.drawCircle(Offset(cx + 30, cy - 5), 8, Paint()..color = const Color(0xFFF9D923));
    _drawLabel(canvas, '目标球', Offset(cx + 16, cy + 10), const Color(0xAAF9D923));

    // Green aim line
    _drawDashed(canvas, Offset(cx - 72, cy), Offset(cx + 10, cy - 12), const Color(0xFF66BB6A));

    // Yellow object path
    _drawDashed(canvas, Offset(cx + 30, cy - 5), Offset(cx + 100, cy - 30), const Color(0xFFFFEB3B));

    // Blue deflection
    _drawDashed(canvas, Offset(cx + 10, cy - 12), Offset(cx + 10, cy + 30), const Color(0xFF00BFFF));

    // Contact point
    canvas.drawCircle(Offset(cx + 22, cy - 9), 3, Paint()..color = const Color(0xFFFF5722));
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    final delta = to - from;
    final len = delta.distance;
    final step = delta / len;
    const dash = 4.0;
    const gap = 3.0;
    var traveled = 0.0;
    while (traveled < len) {
      final end = math.min(traveled + dash, len);
      canvas.drawLine(from + step * traveled, from + step * end, paint);
      traveled += dash + gap;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpinDiagramWidget extends StatelessWidget {
  const _SpinDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 90, child: CustomPaint(painter: _SpinDiagramPainter()));
  }
}

class _SpinDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = (size.width / 12).clamp(16.0, 30.0);
    final dotOffset = r * 0.5;
    final dotR = r * 0.16;

    void drawBall(double cx, double cy, double dx, double dy, String label) {
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white12);
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);
      canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), Paint()..color = Colors.white10..strokeWidth = 0.5);
      canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), Paint()..color = Colors.white10..strokeWidth = 0.5);
      canvas.drawCircle(Offset(cx + dx, cy + dy), dotR, Paint()..color = Colors.red);
      final tp = TextPainter(
        text: TextSpan(text: label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy + r + 4));
    }

    final spacing = size.width / 4;
    final cy = size.height / 2 - 4;
    drawBall(spacing, cy, 0, 0, '中杆');
    drawBall(spacing * 2, cy, -dotOffset, 0, '左塞');
    drawBall(spacing * 3, cy, dotOffset, 0, '右塞');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CutAngleDiagramWidget extends StatelessWidget {
  const _CutAngleDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 110, child: CustomPaint(painter: _CutAngleDiagramPainter()));
  }
}

class _CutAngleDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Ghost ball
    canvas.drawCircle(Offset(cx, cy), 10, Paint()..color = Colors.white10..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Object ball
    final objX = cx + 25.0;
    final objY = cy - 8.0;
    canvas.drawCircle(Offset(objX, objY), 10, Paint()..color = const Color(0x55FFEB3B));

    // Aim direction (from left)
    final aimFrom = Offset(cx - 80, cy + 10);
    _drawDashed(canvas, aimFrom, Offset(cx, cy), const Color(0xFF66BB6A));

    // Center line (ghost → object)
    canvas.drawLine(Offset(cx, cy), Offset(objX, objY), Paint()..color = Colors.white30..strokeWidth = 1);

    // Object path
    final objDir = Offset(objX - cx, objY - cy);
    final objLen = objDir.distance;
    final objNorm = objDir / objLen;
    _drawDashed(canvas, Offset(objX, objY), Offset(objX + objNorm.dx * 60, objY + objNorm.dy * 60), const Color(0xFFFFEB3B));

    // Arc for cut angle
    final aimDir = Offset(cx - aimFrom.dx, cy - aimFrom.dy);
    final angle1 = math.atan2(-aimDir.dy, -aimDir.dx);
    final angle2 = math.atan2(objY - cy, objX - cx);
    var sweep = angle2 - angle1;
    if (sweep > math.pi) sweep -= 2 * math.pi;
    if (sweep < -math.pi) sweep += 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: 20),
      angle1,
      sweep,
      false,
      Paint()..color = Colors.orangeAccent..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );

    _drawLabel(canvas, '切角', Offset(cx + 8, cy + 14), Colors.orangeAccent);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    const dash = 4.0;
    const gap = 3.0;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + dash, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += dash + gap;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TriangleDiagramWidget extends StatelessWidget {
  const _TriangleDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 120, child: CustomPaint(painter: _TriangleDiagramPainter()));
  }
}

class _TriangleDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Triangle vertices for 30° cut angle
    const cutDeg = 30.0;
    const cutRad = cutDeg * math.pi / 180;
    const triSize = 80.0;
    final a = Offset(cx - 40, cy + 20); // origin
    final b = Offset(a.dx + triSize * math.cos(cutRad), a.dy - triSize * math.sin(cutRad)); // hypotenuse end
    final foot = Offset(b.dx, a.dy); // right angle

    // Fill
    final path = Path()..moveTo(a.dx, a.dy)..lineTo(b.dx, b.dy)..lineTo(foot.dx, foot.dy)..close();
    canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.04));

    // Edges
    final edgePaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawLine(a, b, edgePaint..color = const Color(0xFF66BB6A)); // hypotenuse
    canvas.drawLine(a, foot, edgePaint..color = const Color(0xFFFFEB3B)); // adjacent
    canvas.drawLine(foot, b, edgePaint..color = const Color(0xFF00BFFF)); // opposite

    // Right angle marker
    const sq = 8.0;
    canvas.drawLine(Offset(foot.dx - sq, foot.dy), Offset(foot.dx - sq, foot.dy - sq), Paint()..color = Colors.white30..strokeWidth = 1);
    canvas.drawLine(Offset(foot.dx - sq, foot.dy - sq), Offset(foot.dx, foot.dy - sq), Paint()..color = Colors.white30..strokeWidth = 1);

    // Labels
    final hypMid = (a + b) / 2;
    final adjMid = (a + foot) / 2;
    final oppMid = (foot + b) / 2;

    final sinA = math.sin(cutRad);
    final cosA = math.cos(cutRad);
    final hypR = (1 / sinA).toStringAsFixed(1);
    final adjR = (cosA / sinA).toStringAsFixed(1);

    _drawLabel(canvas, '斜$hypR', Offset(hypMid.dx - 30, hypMid.dy - 10), const Color(0xFF66BB6A));
    _drawLabel(canvas, '长$adjR', Offset(adjMid.dx - 8, adjMid.dy + 4), const Color(0xFFFFEB3B));
    _drawLabel(canvas, '短1.0', Offset(oppMid.dx + 4, oppMid.dy - 6), const Color(0xFF00BFFF));
    _drawLabel(canvas, '30°', Offset(a.dx + 20, a.dy - 16), Colors.orangeAccent);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
