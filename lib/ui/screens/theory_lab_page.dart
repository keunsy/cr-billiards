import 'dart:math' as math;
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Category & item data model
// ---------------------------------------------------------------------------
class _LabItem {
  const _LabItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() builder;
}

class _LabCategory {
  const _LabCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
  final String title;
  final IconData icon;
  final Color color;
  final List<_LabItem> items;
}

final List<_LabCategory> _categories = [
  _LabCategory(
    title: '瞄准法',
    icon: Icons.gps_fixed,
    color: const Color(0xFF66BB6A),
    items: [
      _LabItem(
        title: '假想球瞄准法',
        subtitle: '最基础的瞄准原理、常见问题与解决',
        icon: Icons.blur_circular,
        builder: () => const _GhostBallLab(),
      ),
      _LabItem(
        title: '角度瞄准法',
        subtitle: '切角三角形、厚薄与假想球',
        icon: Icons.change_history,
        builder: () => const _CutAngleTriangleLab(),
      ),
      _LabItem(
        title: '突出点瞄准法',
        subtitle: '突出点瞄准线、C→P连线与进球面',
        icon: Icons.radio_button_unchecked,
        builder: () => const _EdgeAimingLab(),
      ),
      _LabItem(
        title: '袋口边缘瞄准法',
        subtitle: '袋口边缘点→目标球中心，切边缘点对准',
        icon: Icons.sports_hockey,
        builder: () => const _PocketEdgeAimingLab(),
      ),
      _LabItem(
        title: 'CTE 瞄准系统',
        subtitle: 'Center-To-Edge 瞄准点+偏移+转回中心',
        icon: Icons.pivot_table_chart,
        builder: () => const _CTEAimingLab(),
      ),
      _LabItem(
        title: '平行线瞄准法',
        subtitle: '接触点→接触点平行移动，与假想球等价',
        icon: Icons.linear_scale,
        builder: () => const _ParallelLinesAimingLab(),
      ),
      _LabItem(
        title: '翻袋瞄准法',
        subtitle: '镜像法、菱形系统、等距法、补偿系统',
        icon: Icons.flip,
        builder: () => const _BankShotHub(),
      ),
      _LabItem(
        title: '库边球瞄准法',
        subtitle: '薄切法、挤库法（先碰库）',
        icon: Icons.vertical_align_center,
        builder: () => const _CushionBallHub(),
      ),
    ],
  ),
  _LabCategory(
    title: '物理原理',
    icon: Icons.science_outlined,
    color: const Color(0xFF42A5F5),
    items: [
      _LabItem(
        title: '入射角与反射角',
        subtitle: '库边反弹：入射角等于反射角',
        icon: Icons.compare_arrows,
        builder: () => const _ReflectionAngleLab(),
      ),
      _LabItem(
        title: '分离角（90度法则）',
        subtitle: '中杆碰撞后两球路径近似垂直',
        icon: Icons.open_in_full,
        builder: () => const _SeparationAngleLab(),
      ),
      _LabItem(
        title: '投射效应（Throw）',
        subtitle: '摩擦力导致目标球偏离理论方向',
        icon: Icons.swipe,
        builder: () => const _ThrowEffectLab(),
      ),
    ],
  ),
  _LabCategory(
    title: '走位与控球',
    icon: Icons.moving,
    color: const Color(0xFFFF9800),
    items: [
      _LabItem(
        title: '高中低杆走位',
        subtitle: '击球点高低决定碰后母球走向',
        icon: Icons.vertical_align_center,
        builder: () => const _HighMidLowLab(),
      ),
      _LabItem(
        title: '走位区域思维',
        subtitle: '控制白球到达好打区域，而非精确点位',
        icon: Icons.grid_view,
        builder: () => const _PositionZoneLab(),
      ),
    ],
  ),
  _LabCategory(
    title: '比赛规则',
    icon: Icons.menu_book,
    color: const Color(0xFFEF5350),
    items: [
      _LabItem(
        title: '中式八球规则速查',
        subtitle: '开球、球权、犯规、8号球、判负',
        icon: Icons.rule,
        builder: () => const _RulesQuickRefLab(),
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Entry: category list
// ---------------------------------------------------------------------------
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final hasItems = cat.items.isNotEmpty;
          return _CategoryCard(
            category: cat,
            onTap: hasItems
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _CategoryPage(category: cat),
                      ),
                    )
                : null,
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, this.onTap});
  final _LabCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final empty = category.items.isEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: empty ? Colors.white10 : category.color.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(category.icon,
                color: empty ? Colors.white24 : category.color, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: TextStyle(
                      color: empty ? Colors.white38 : Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    empty
                        ? '敬请期待'
                        : '${category.items.length} 个实验项目',
                    style: TextStyle(
                      color: empty ? Colors.white24 : Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (!empty)
              Icon(Icons.chevron_right, color: Colors.white38, size: 22),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Second level: items in a category
// ---------------------------------------------------------------------------
class _CategoryPage extends StatelessWidget {
  const _CategoryPage({super.key, required this.category});
  final _LabCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        title: Text(category.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: category.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final item = category.items[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _LabDetailPage(item: item, accentColor: category.color),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: category.color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: category.color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(item.subtitle,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white38, size: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Third level: single lab detail
// ---------------------------------------------------------------------------
class _LabDetailPage extends StatelessWidget {
  const _LabDetailPage({super.key, required this.item, required this.accentColor});
  final _LabItem item;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final content = item.builder();
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        title: Text(item.title),
      ),
      body: content is _BankShotHub || content is _CushionBallHub
          ? Padding(padding: const EdgeInsets.all(16), child: content)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [content],
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
// Ghost Ball Lab — fundamental aiming method
// ---------------------------------------------------------------------------
class _GhostBallLab extends StatefulWidget {
  const _GhostBallLab();
  @override
  State<_GhostBallLab> createState() => _GhostBallLabState();
}

class _GhostBallLabState extends State<_GhostBallLab> {
  double _cutAngle = 30;
  double _distance = 0.5; // 0=close, 1=far

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Sliders at top for immediate interaction
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Row(children: [
            const Text('切角', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _cutAngle,
                min: 5,
                max: 80,
                onChanged: (v) => setState(() => _cutAngle = v),
              ),
            ),
            Text('${_cutAngle.round()}°',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ]),
          Row(children: [
            const Text('距离', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _distance,
                min: 0.0,
                max: 1.0,
                onChanged: (v) => setState(() => _distance = v),
              ),
            ),
            Text(_distance < 0.33 ? '近' : _distance < 0.66 ? '中' : '远',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ]),
        ]),
      ),
      const SizedBox(height: 8),
      AspectRatio(
        aspectRatio: 1.5,
        child: CustomPaint(
          painter: _GhostBallPainter(
            cutAngleDeg: _cutAngle,
            distance: _distance,
          ),
          child: Container(),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 16, runSpacing: 6, children: const [
          _LegendItem(color: Color(0xFFF5F5F0), label: '母球 (C)'),
          _LegendItem(color: Color(0xFFE53935), label: '目标球 (O)'),
          _LegendItem(color: Color(0x6600E676), label: '假想球 (G)'),
          _LegendItem(color: Color(0xFF81C784), label: '袋口 (P)'),
        ]),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是假想球瞄准法？',
                  style: TextStyle(color: Color(0xFF66BB6A), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '假想球（Ghost Ball）是最基础的台球瞄准方法。\n'
                '想象在目标球与袋口连线的延长线上，放一个"看不见的球"（假想球），'
                '它的边缘刚好贴住目标球。\n\n'
                '操作步骤：\n'
                '1. 画出目标球→袋口的连线\n'
                '2. 在连线上找到假想球位置（与目标球刚好相切）\n'
                '3. 让白球瞄准假想球的中心出杆\n'
                '4. 白球到达假想球位置时，碰撞力沿连线方向传递给目标球\n\n'
                '拖动滑杆改变切角，观察假想球位置和进球线路的变化。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('假想球瞄准法（Ghost Ball）',
                style: TextStyle(color: Color(0xFF66BB6A), fontSize: 13, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(
              '原理：在目标球 O 与袋口 P 的连线延长线上，'
              '紧贴 O 放一个"假想球 G"。母球瞄准 G 的中心出杆即可。\n\n'
              '常见问题与解决：\n'
              '1. 球体立体感偏差（GBD） — 假想球是个三维球，'
              '但我们从球杆高度看到的是它的"投影"。由于球面弧度，'
              '假想球的中心在视觉上会偏离实际位置，导致"看薄"。'
              '这是所有接触点/假想球方法的通病，幸运的是碰撞偏转'
              '（Throw）会部分抵消此偏差\n'
              '2. 长距离球视觉失真 — 假想球在远处看起来"变形"，'
              '可配合"突出点法"或"CTE系统"辅助定位\n'
              '3. 薄球（大切角 >45°）— 假想球偏移很大，'
              '容易高估/低估接触点，建议用角度瞄准法或平行线法辅助\n'
              '4. 偏差累积 — 任何微小的瞄准偏差都被放大，'
              '长台更需重视瞄准姿势（下巴贴杆、视线对齐）\n'
              '5. 不适合翻袋 — 翻袋球用镜像法/菱形系统更直观',
              style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.6),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class _GhostBallPainter extends CustomPainter {
  _GhostBallPainter({required this.cutAngleDeg, required this.distance});
  final double cutAngleDeg;
  final double distance;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final ballR = w * 0.035;

    // Table background
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(0, 0, w, h), 6, 6),
      Paint()..color = const Color(0xFF1B6B1F),
    );

    // Pocket position
    final pocket = Offset(w * 0.88, h * 0.15);

    // Object ball position — moves based on distance slider
    final objX = w * (0.35 + distance * 0.3);
    final objY = h * (0.55 - distance * 0.1);
    final objBall = Offset(objX, objY);

    // Ghost ball: along O→P line, one diameter behind O
    final opDir = (pocket - objBall);
    final opLen = opDir.distance;
    final opNorm = opDir / opLen;
    final ghost = objBall - opNorm * (ballR * 2);

    // Cue ball: rotate the reverse-pocket direction by cutAngle to place cue ball
    final cutRad = cutAngleDeg * math.pi / 180;
    // Reverse pocket direction (pointing away from pocket)
    final revX = -opNorm.dx;
    final revY = -opNorm.dy;
    // Rotate clockwise by cutAngle
    final cgDirX = revX * math.cos(cutRad) + revY * math.sin(cutRad);
    final cgDirY = -revX * math.sin(cutRad) + revY * math.cos(cutRad);
    final cgDir = Offset(cgDirX, cgDirY);
    final cueDist = w * (0.15 + distance * 0.2);
    final cueBall = ghost + cgDir * cueDist;

    final dashes = Paint()
      ..color = Colors.white38
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // O → P line
    _drawDashedLine(canvas, objBall, pocket, dashes);

    // C → G aiming line
    final aimPaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..strokeWidth = 1.2;
    canvas.drawLine(cueBall, ghost, aimPaint);

    // G → O contact direction (shows ball will go to pocket)
    final contactPaint = Paint()
      ..color = const Color(0x99FFEB3B)
      ..strokeWidth = 1.0;
    canvas.drawLine(ghost, pocket, contactPaint);

    // Ghost ball (transparent)
    canvas.drawCircle(ghost, ballR, Paint()..color = const Color(0x3300E676));
    canvas.drawCircle(
      ghost, ballR,
      Paint()..color = const Color(0x8800E676)..style = PaintingStyle.stroke..strokeWidth = 1.2,
    );

    // Object ball
    canvas.drawCircle(objBall, ballR, Paint()..color = const Color(0xFFE53935));
    _drawLabel(canvas, objBall, 'O', ballR);

    // Cue ball
    canvas.drawCircle(cueBall, ballR, Paint()..color = const Color(0xFFF5F5F0));
    _drawLabel(canvas, cueBall, 'C', ballR, dark: true);

    // Pocket
    canvas.drawCircle(pocket, ballR * 1.5, Paint()..color = const Color(0xFF111111));
    canvas.drawCircle(
      pocket, ballR * 1.5,
      Paint()..color = const Color(0xFF81C784)..style = PaintingStyle.stroke..strokeWidth = 1.0,
    );
    _drawLabel(canvas, pocket, 'P', ballR * 1.5);

    // Ghost ball label
    _drawLabel(canvas, ghost + Offset(0, -ballR - 8), 'G', 0, color: const Color(0xFF00E676));

    if (cutAngleDeg > 5) {
      final arcR = ballR * 3;
      final startAngle = math.atan2(opNorm.dy, opNorm.dx) + math.pi;
      final sweepAngle = cutRad;
      canvas.drawArc(
        Rect.fromCircle(center: ghost, radius: arcR),
        startAngle, sweepAngle,
        false,
        Paint()..color = const Color(0xAAFFFFFF)..style = PaintingStyle.stroke..strokeWidth = 1.0,
      );
      final labelAngle = startAngle + sweepAngle / 2;
      final labelPos = ghost + Offset(math.cos(labelAngle), math.sin(labelAngle)) * (arcR + 10);
      _drawText(canvas, labelPos, '${cutAngleDeg.round()}°', 10, Colors.white70);
    }

    // Distance warning for long shots
    if (distance > 0.65) {
      _drawText(
        canvas, Offset(w * 0.05, h * 0.92),
        '远距离：假想球视觉变形大，建议辅助其他瞄准法', 10,
        const Color(0xFFFF9800),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    final dir = b - a;
    final len = dir.distance;
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

  void _drawLabel(Canvas canvas, Offset center, String text, double r,
      {bool dark = false, Color? color}) {
    _drawText(canvas, center + Offset(0, r + 10), text, 10,
        color ?? (dark ? Colors.black87 : Colors.white70));
  }

  void _drawText(Canvas canvas, Offset pos, String text, double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _GhostBallPainter old) =>
      old.cutAngleDeg != cutAngleDeg || old.distance != distance;
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
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFA726).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFA726).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('角度瞄准法（切角三角）',
                  style: TextStyle(color: Color(0xFFFFA726), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '切角三角是理解球与球碰撞角度的核心工具。\n'
                '当白球不是直球进袋时，需要"切"目标球的一侧。\n'
                '切角 = 目标球→袋口连线与白球→目标球连线之间的夹角。\n\n'
                '关键概念：\n'
                '• 切角越大，需要打的球越"薄"\n'
                '• 切角 0° = 直球（全厚）\n'
                '• 切角 90° = 完全擦边（全薄，几乎不可能）\n\n'
                '切换上方模式查看不同的角度可视化方式。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
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
        _LegendItem(
            color: Color(0xFFE91E63),
            label: '突出点瞄准线（平行于 C→G）& 切点'),
        _LegendItem(
            color: Color(0xFF00BCD4),
            label: '白球中心→袋口连线（C→P）'),
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
          _buildCutPointNote(),
          const SizedBox(height: 12),
          const _DeviationTable(),
        ],
      ),
    );
  }

  Widget _buildCutPointNote() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: const Color(0xFFE91E63).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('突出点切点位置表',
              style: TextStyle(
                  color: Color(0xFFE91E63),
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _CutPointTable(),
          const SizedBox(height: 10),
          const Text(
            '原理：粉色虚线 = 突出点轨迹（平行于 C→G，偏移 1 个球半径）\n'
            '• ≤30°：突出点瞄准线穿过目标球 → 有切点\n'
            '• =30°：突出点线恰好切到目标球最外缘（临界角度）\n'
            '• >30°：突出点线完全错过目标球，无切点\n\n'
            '实战：小角度看白球突出点对准目标球哪个位置瞄准；\n'
            '大角度（>30°）突出点已失效，必须依靠假想球(G)瞄准。',
            style: TextStyle(color: Colors.white38, fontSize: 10, height: 1.5),
          ),
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

class _CutPointTable extends StatelessWidget {
  const _CutPointTable();

  @override
  Widget build(BuildContext context) {
    // Edge line offset from center = r (one ball radius).
    // This line hits the object ball when sin(angle) * (CG distance component) <= r.
    // Simplified: at 30° the edge line just grazes the object ball edge.
    // "Position from center" = sin(angle)/sin(30°) = sin(angle) * 2,
    //   capped at 1.0 (= ball edge). Above 30° we switch to edge-based thinking.
    const angles = [5, 10, 15, 20, 25, 30, 35, 45, 60, 75];

    return Table(
      border: TableBorder.all(color: Colors.white12, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(0.8),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.8),
        3: FlexColumnWidth(1.0),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05)),
          children: const [
            _Cell('切角', bold: true, color: Color(0xFFFF6600)),
            _Cell('中心→边缘', bold: true, color: Color(0xFFE91E63)),
            _Cell('切点说明', bold: true),
            _Cell('厚薄', bold: true),
          ],
        ),
        for (final a in angles)
          TableRow(children: [
            _Cell('$a°', bold: true, color: const Color(0xFFFF6600)),
            _Cell(_edgeFraction(a), bold: true,
                color: a <= 30 ? const Color(0xFFE91E63) : const Color(0xFFFF9800)),
            _Cell(_cutPointDesc(a), color: a <= 30 ? Colors.white60 : Colors.white38),
            _Cell(_thicknessDesc(a)),
          ]),
      ],
    );
  }

  static String _edgeFraction(int angle) {
    // How far from center to edge the cut point is.
    // sin(angle) / sin(30°) gives ratio: 0 = center, 1 = edge
    final ratio = math.sin(angle * math.pi / 180) / math.sin(30 * math.pi / 180);
    if (angle <= 30) {
      final pct = (ratio * 100).round();
      return '$pct%';
    } else {
      // Beyond 30°: edge line misses ball. Show as "overflow" percentage.
      final pct = (ratio * 100).round();
      return '$pct%↑';
    }
  }

  static String _cutPointDesc(int angle) {
    if (angle <= 5) return '球面内侧（几乎正碰）';
    if (angle <= 15) return '偏内侧，"吃球"较多';
    if (angle <= 25) return '逐渐靠外，"吃球"减少';
    if (angle <= 30) return '恰好到球边缘（临界角度）';
    if (angle <= 45) return '突出点线已错过→换用假想球瞄准';
    if (angle <= 60) return '极薄→只能信赖假想球(G)瞄准';
    return '超薄→几乎擦边而过';
  }

  static String _thicknessDesc(int angle) {
    final cosA = math.cos(angle * math.pi / 180);
    if (cosA > 0.87) return '全厚';
    if (cosA > 0.71) return '3/4';
    if (cosA > 0.5) return '1/2';
    if (cosA > 0.26) return '1/4';
    return '极薄';
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
        const Color(0xFF66BB6A).withValues(alpha: 0.4), 1.2);

    // ---- Aim direction ----
    final aimDir = (ghost - cue);
    final aimNorm = aimDir.distance > 0 ? aimDir / aimDir.distance : Offset.zero;
    final aimPerp = Offset(-aimNorm.dy, aimNorm.dx);
    final sideSign = _dot(obj - cue, aimPerp) > 0 ? 1.0 : -1.0;

    // ---- White ball edge point (on ball surface, towards object ball side) ----
    final cueEdgePt = cue + aimPerp * (sideSign * r);

    // ---- Draw full-length parallel lines for visual clarity ----
    // 1. Center aim line C→G extended (faint pink dashed, full canvas width)
    final centerStart = cue - aimNorm * (w * 0.1);
    final centerEnd = cue + aimNorm * w * 1.5;
    _drawDashed(canvas, centerStart, centerEnd,
        const Color(0xFFE91E63).withValues(alpha: 0.4), 1.0);

    // Center line vs object ball intersection (C→G hits the object ball)
    final ccOC = cue - obj;
    final ccB = 2.0 * _dot(ccOC, aimNorm);
    final ccC = _dot(ccOC, ccOC) - r * r;
    final ccDisc = ccB * ccB - 4.0 * ccC;
    if (ccDisc >= 0) {
      final ccSqrt = math.sqrt(ccDisc);
      final ccT1 = (-ccB - ccSqrt) / 2.0;
      final ccHit = cue + aimNorm * ccT1;
      canvas.drawCircle(ccHit, 4, Paint()..color = const Color(0xFFE91E63).withValues(alpha: 0.5));
      canvas.drawCircle(ccHit, 4,
          Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1);
      _drawLabel(canvas, 'CG切点', ccHit + const Offset(0, -14),
          const Color(0xFFE91E63).withValues(alpha: 0.7), 10);
    }

    // 2. Edge line (parallel to C→G, offset by r, full canvas width)
    final edgeLineStart = cueEdgePt - aimNorm * (w * 0.1);
    final edgeLineEnd = cueEdgePt + aimNorm * w * 1.5;
    _drawDashed(canvas, edgeLineStart, edgeLineEnd,
        const Color(0xFFE91E63).withValues(alpha: 0.4), 1.5);

    // Mark the cue ball edge point
    canvas.drawCircle(cueEdgePt, 3.5,
        Paint()..color = const Color(0xFFE91E63));
    canvas.drawCircle(cueEdgePt, 3.5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1);

    // ---- Find where edge line intersects object ball ----
    final oc = cueEdgePt - obj;
    final b2 = 2.0 * _dot(oc, aimNorm);
    final c2 = _dot(oc, oc) - r * r;
    final disc = b2 * b2 - 4.0 * c2;

    if (disc >= 0) {
      final sqrtDisc = math.sqrt(disc);
      final t1 = (-b2 - sqrtDisc) / 2.0;
      final hitPt = cueEdgePt + aimNorm * t1;

      // Mark cut point on object ball surface
      canvas.drawCircle(hitPt, 5, Paint()..color = const Color(0xFFE91E63));
      canvas.drawCircle(hitPt, 5,
          Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);

      final labelOff = Offset(-aimPerp.dx * sideSign, -aimPerp.dy * sideSign) * 18;
      _drawLabel(canvas, '切点', hitPt + labelOff,
          const Color(0xFFE91E63), 11, bold: true);
    }

    // ---- C→P line and edge-to-pocket aiming ----
    {
      // 1. C→ pocket entry (where pocket line enters pocket hole)
      final pocketEntryOld = pocket - opNorm * r * 1.4;
      canvas.drawLine(
          cue,
          pocketEntryOld,
          Paint()
            ..color = const Color(0xFF00BCD4).withValues(alpha: 0.5)
            ..strokeWidth = 1.5);

      final cpDir = pocketEntryOld - cue;
      final cpDist = cpDir.distance;
      if (cpDist > 0) {
        final cpNorm = cpDir / cpDist;

        // 2. E = intersection of C→P with cue ball surface
        final cueBallEdgeToP = cue + cpNorm * r;
        canvas.drawCircle(cueBallEdgeToP, 3.5, Paint()..color = const Color(0xFF00BCD4));
        canvas.drawCircle(cueBallEdgeToP, 3.5,
            Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1);
        _drawLabel(canvas, 'E', cueBallEdgeToP + const Offset(-14, -10),
            const Color(0xFF00BCD4), 10);

        // 3. Target point on object ball: the point on pocket line (O→P) surface
        //    closest to cue ball (entry side of the pocket line through O).
        final pocketLineDir = (pocket - obj);
        final pocketLineDist = pocketLineDir.distance;
        if (pocketLineDist > 0) {
          final pocketLineNorm = pocketLineDir / pocketLineDist;
          // Point on object ball surface, facing away from pocket (cue-ball side)
          final objEntryPt = obj - pocketLineNorm * r;

          canvas.drawCircle(objEntryPt, 4, Paint()..color = const Color(0xFF00BCD4));
          canvas.drawCircle(objEntryPt, 4,
              Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);

          // 4. Draw E → objEntryPt line
          canvas.drawLine(
              cueBallEdgeToP,
              objEntryPt,
              Paint()
                ..color = const Color(0xFF00BCD4).withValues(alpha: 0.7)
                ..strokeWidth = 1.8);

          // Extend beyond as dashed
          final eoDir = (objEntryPt - cueBallEdgeToP);
          final eoDist = eoDir.distance;
          if (eoDist > 0) {
            final eoNorm = eoDir / eoDist;
            final extEnd = objEntryPt + eoNorm * (w * 0.3);
            _drawDashed(canvas, objEntryPt, extEnd,
                const Color(0xFF00BCD4).withValues(alpha: 0.4), 1.0);
          }
          _drawLabel(canvas, '进球面', objEntryPt + const Offset(0, 14),
              const Color(0xFF00BCD4), 10);
        }
      }
    }

    // Thickness info
    final cutAngleRad = cutAngleDeg * math.pi / 180;
    final overlapFraction = math.cos(cutAngleRad);
    final thicknessLabel = overlapFraction > 0.87
        ? '厚球'
        : overlapFraction > 0.5
            ? '${(overlapFraction * 100).round()}% 厚'
            : overlapFraction > 0.25
                ? '薄球'
                : '极薄';
    _drawLabel(canvas, thicknessLabel, obj + Offset(0, -r - 16),
        const Color(0xFFE91E63), 10, bold: true);

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

// ---------------------------------------------------------------------------
// Edge Aiming Lab — white ball edge line, C→P line, entry point
// ---------------------------------------------------------------------------
class _EdgeAimingLab extends StatefulWidget {
  const _EdgeAimingLab();

  @override
  State<_EdgeAimingLab> createState() => _EdgeAimingLabState();
}

class _EdgeAimingLabState extends State<_EdgeAimingLab> {
  double _cutAngleDeg = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('切角',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            Expanded(
              child: Slider(
                value: _cutAngleDeg,
                min: 5,
                max: 85,
                divisions: 80,
                label: '${_cutAngleDeg.toStringAsFixed(0)}°',
                activeColor: const Color(0xFF00BCD4),
                onChanged: (v) => setState(() => _cutAngleDeg = v),
              ),
            ),
            Text('${_cutAngleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFF00BCD4),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CustomPaint(
            painter: _EdgeAimingPainter(cutAngleDeg: _cutAngleDeg),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFF66BB6A), label: 'C→G 瞄准线（白球中心→假想球中心）'),
            _LegendItem(color: Color(0xFFFFEB3B), label: 'O→P 进球线（目标球→袋口）'),
            _LegendItem(
                color: Color(0xFFE91E63),
                label: '突出点瞄准线（平行于 C→G，偏移 1r）'),
            _LegendItem(
                color: Color(0xFF00BCD4),
                label: 'C→P 连线（白球中心→袋口远端）& E→进球面'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是突出点瞄准法？',
                  style: TextStyle(color: Color(0xFF66BB6A), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '突出点（Contact Point）瞄准法是一种直观的切球瞄准方式。\n\n'
                '方法：从白球视角看，目标球有一个"突出点"——'
                '就是目标球边缘上，对准白球方向最突出的那一点。\n'
                '将白球的边缘对准这个突出点出杆即可。\n\n'
                '操作步骤：\n'
                '1. 拖动滑杆改变切角\n'
                '2. 观察突出点（红色标记）的位置变化\n'
                '3. 白球的边缘需要对准突出点\n\n'
                '优势：不需要想象"假想球"，直接看球的边缘对位。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        _buildNote(),
      ],
    );
  }

  Widget _buildNote() {
    final angle = _cutAngleDeg;
    String note;
    if (angle <= 30) {
      note = '≤30°：突出点瞄准线（粉色）穿过目标球，有"突出点切点"。\n'
          '同时 C→P 连线（青色）与 E→进球面 连线展示另一种参考。\n'
          '两种参考在小角度时接近，角度越大差异越明显。';
    } else {
      note = '>30°：粉色突出点线已错过目标球，突出点切点消失。\n'
          '此时 C→P / E→进球面 连线（青色）仍可作为辅助参考，\n'
          '但精确进球必须依赖假想球(G)瞄准——绿色 C→G 线。';
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: const Color(0xFF00BCD4).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('突出点瞄准法说明',
              style: TextStyle(
                  color: Color(0xFF00BCD4),
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(note,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 11, height: 1.5)),
          const SizedBox(height: 8),
          const Text(
            '核心思想：用白球的突出点（而非中心）对准目标球或袋口方向，\n'
            '在小角度（≤30°）时可以直观判断"切多少球"。\n'
            '大角度时突出点参考失效，回归假想球(G)标准瞄准法。',
            style: TextStyle(color: Colors.white38, fontSize: 10, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Edge Aiming Painter
// ---------------------------------------------------------------------------
class _EdgeAimingPainter extends CustomPainter {
  _EdgeAimingPainter({required this.cutAngleDeg});

  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.04;

    final pocket = Offset(w * 0.88, h * 0.12);
    final obj = Offset(w * 0.58, h * 0.48);

    final op = (pocket - obj);
    final opNorm = op / op.distance;
    final ghost = obj - opNorm * 2 * r;
    final contact = obj - opNorm * r;

    // Place cue ball for given cut angle at ghost center vertex
    final vpDir = (pocket - ghost);
    final vpNorm = vpDir.distance > 0 ? vpDir / vpDir.distance : Offset.zero;
    final vpAngle = math.atan2(vpNorm.dy, vpNorm.dx);
    final targetRad = math.pi - cutAngleDeg * math.pi / 180;
    final cAngle = vpAngle - targetRad;
    final cDir = Offset(math.cos(cAngle), math.sin(cAngle));
    final cueDist = w * 0.42;
    final cue = ghost + cDir * cueDist;

    // ---- Background: pocket line O→P ----
    final ext = obj - opNorm * (w * 0.15);
    _drawDashed(canvas, ext, pocket, const Color(0xFFFFEB3B).withValues(alpha: 0.25), 1.2);

    // ---- Pocket ----
    canvas.drawCircle(pocket, r * 1.4, Paint()..color = const Color(0xFF0A0A0A));
    canvas.drawCircle(pocket, r * 1.4,
        Paint()..color = const Color(0xFF555555)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, 'P', pocket + const Offset(0, -20), const Color(0xFF999999), 12);

    // ---- Ghost ball ----
    canvas.drawCircle(ghost, r,
        Paint()..color = const Color(0xFFB482FF).withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, 'G', ghost + Offset(0, r + 14), const Color(0xFFB482FF).withValues(alpha: 0.5), 10);

    // ---- Contact point T ----
    canvas.drawCircle(contact, 3, Paint()..color = const Color(0xFFFF9800));
    _drawLabel(canvas, 'T', contact + const Offset(12, -8), const Color(0xFFFF9800), 10);

    // ---- Object ball ----
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFF9D923));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, 'O', obj + Offset(r + 6, -r - 4), const Color(0xFFF9D923), 12);

    // ---- Cue ball ----
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xFFF5F5F0));
    canvas.drawCircle(cue, r,
        Paint()..color = const Color(0xFFDDDDDD)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, 'C', cue + Offset(0, r + 14), const Color(0xFFEEEEEE), 12);

    // ---- C→G aim line (green) ----
    final aimDir = (ghost - cue);
    final aimNorm = aimDir.distance > 0 ? aimDir / aimDir.distance : Offset.zero;
    canvas.drawLine(cue, ghost, Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.6)..strokeWidth = 1.5);
    final aimExt = ghost + aimNorm * (w * 0.5);
    _drawDashed(canvas, ghost, aimExt, const Color(0xFF66BB6A).withValues(alpha: 0.2), 1.0);

    // ---- 1. Edge parallel line (pink) ----
    final aimPerp = Offset(-aimNorm.dy, aimNorm.dx);
    final sideSign = _dot(obj - cue, aimPerp) > 0 ? 1.0 : -1.0;
    final cueEdgePt = cue + aimPerp * (sideSign * r);

    final edgeStart = cueEdgePt - aimNorm * (w * 0.05);
    final edgeEnd = cueEdgePt + aimNorm * w * 1.5;
    _drawDashed(canvas, edgeStart, edgeEnd,
        const Color(0xFFE91E63).withValues(alpha: 0.4), 1.5);

    canvas.drawCircle(cueEdgePt, 3, Paint()..color = const Color(0xFFE91E63));

    // Edge line vs object ball intersection
    final oc = cueEdgePt - obj;
    final b2 = 2.0 * _dot(oc, aimNorm);
    final c2 = _dot(oc, oc) - r * r;
    final disc = b2 * b2 - 4.0 * c2;
    if (disc >= 0) {
      final t1 = (-b2 - math.sqrt(disc)) / 2.0;
      final hitPt = cueEdgePt + aimNorm * t1;
      canvas.drawCircle(hitPt, 5, Paint()..color = const Color(0xFFE91E63));
      canvas.drawCircle(hitPt, 5,
          Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
      _drawLabel(canvas, '突出点切点', hitPt + Offset(-aimPerp.dx * sideSign, -aimPerp.dy * sideSign) * 18,
          const Color(0xFFE91E63), 10, bold: true);
    }

    // ---- 2. C→ pocket entry point (where pocket line enters the pocket circle) ----
    // Pocket entry = pocket center - pocketLineDir * pocketRadius (near side of pocket hole)
    final pocketEntry = pocket - opNorm * r * 1.4;
    canvas.drawLine(cue, pocketEntry,
        Paint()..color = const Color(0xFF00BCD4).withValues(alpha: 0.5)..strokeWidth = 1.5);

    final cpDir = pocketEntry - cue;
    final cpDist = cpDir.distance;
    if (cpDist > 0) {
      final cpNorm = cpDir / cpDist;
      final cueBallEdgeToP = cue + cpNorm * r;
      canvas.drawCircle(cueBallEdgeToP, 3.5, Paint()..color = const Color(0xFF00BCD4));
      canvas.drawCircle(cueBallEdgeToP, 3.5,
          Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1);
      _drawLabel(canvas, 'E', cueBallEdgeToP + const Offset(-14, -10), const Color(0xFF00BCD4), 10);

      // Entry point on object ball (pocket line side)
      final pocketLineDir = (pocket - obj);
      final plDist = pocketLineDir.distance;
      if (plDist > 0) {
        final plNorm = pocketLineDir / plDist;
        final objEntry = obj - plNorm * r;
        canvas.drawCircle(objEntry, 4, Paint()..color = const Color(0xFF00BCD4));
        canvas.drawCircle(objEntry, 4,
            Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
        canvas.drawLine(cueBallEdgeToP, objEntry,
            Paint()..color = const Color(0xFF00BCD4).withValues(alpha: 0.7)..strokeWidth = 1.8);
        _drawLabel(canvas, '进球面', objEntry + const Offset(0, 14), const Color(0xFF00BCD4), 9);
      }
    }

    // ---- Angle label ----
    _drawLabel(canvas, '${cutAngleDeg.toStringAsFixed(1)}°',
        Offset(w * 0.35, h * 0.65), const Color(0xFFFF6600), 18, bold: true);
  }

  static double _dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color, double strokeWidth) {
    final dir = to - from;
    final length = dir.distance;
    if (length < 1) return;
    final norm = dir / length;
    const dashLen = 6.0;
    const gapLen = 4.0;
    final paint = Paint()..color = color..strokeWidth = strokeWidth;
    double d = 0;
    while (d < length) {
      final start = from + norm * d;
      final end = from + norm * math.min(d + dashLen, length);
      canvas.drawLine(start, end, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color, double fontSize,
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
  bool shouldRepaint(_EdgeAimingPainter old) => old.cutAngleDeg != cutAngleDeg;
}

// ---------------------------------------------------------------------------
// Pocket Edge Aiming Lab
// ---------------------------------------------------------------------------
class _PocketEdgeAimingLab extends StatefulWidget {
  const _PocketEdgeAimingLab();

  @override
  State<_PocketEdgeAimingLab> createState() => _PocketEdgeAimingLabState();
}

class _PocketEdgeAimingLabState extends State<_PocketEdgeAimingLab> {
  double _cutAngleDeg = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('切角',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            Expanded(
              child: Slider(
                value: _cutAngleDeg,
                min: 5,
                max: 85,
                divisions: 80,
                label: '${_cutAngleDeg.toStringAsFixed(0)}°',
                activeColor: const Color(0xFFFFA726),
                onChanged: (v) => setState(() => _cutAngleDeg = v),
              ),
            ),
            Text('${_cutAngleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFFFFA726),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CustomPaint(
            painter: _PocketEdgeAimingPainter(cutAngleDeg: _cutAngleDeg),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFF66BB6A), label: 'C→G 瞄准线（白球中心→假想球中心）'),
            _LegendItem(color: Color(0xFFFFEB3B), label: 'P→O 进球线（袋口中心穿过目标球延长）'),
            _LegendItem(
                color: Color(0xFF8D6E63),
                label: 'J1/J2 袋口嘴角（库边与袋口交接点）'),
            _LegendItem(
                color: Color(0xFFFFA726),
                label: '近侧嘴角→目标球中心 连线'),
            _LegendItem(
                color: Color(0xFFFF5722),
                label: '切边缘点（白球应瞄准的目标球表面点）'),
            _LegendItem(
                color: Color(0xFF9C27B0),
                label: 'G（假想球中心，对比参考）'),
          ],
        ),
        const SizedBox(height: 12),
        _buildNote(),
      ],
    );
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA726).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: const Color(0xFFFFA726).withValues(alpha: 0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('袋口边缘瞄准法说明',
              style: TextStyle(
                  color: Color(0xFFFFA726),
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(
            '原理：袋口两侧各有一个"嘴角"（Jaw point, J1/J2），\n'
            '即库边胶条与袋口的交接点——球桌上实际可见的边缘。\n\n'
            '取白球来球方向的近侧嘴角，画到目标球中心的连线，\n'
            '该线与目标球远侧表面的交点就是"切边缘点"，\n'
            '白球直接瞄准此点即可让目标球擦着袋口边缘进袋。\n\n'
            '优势：基于球桌上真实可见的参照物，比想象袋口中心更直观。\n'
            '局限：大角度时偏差增大，仍需结合假想球法校准。',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pocket Edge Aiming Painter
// ---------------------------------------------------------------------------
class _PocketEdgeAimingPainter extends CustomPainter {
  _PocketEdgeAimingPainter({required this.cutAngleDeg});

  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Ball radius: standard ball 52.5mm, use proportional size
    final r = math.min(w, h) * 0.038;

    // Fixed positions: pocket at top-right corner, object ball in center area
    final pocket = Offset(w * 0.85, h * 0.12);
    final obj = Offset(w * 0.55, h * 0.45);

    final op = (pocket - obj);
    final opNorm = op / op.distance;
    final ghost = obj - opNorm * 2 * r;

    // Place cue ball dynamically based on cut angle at ghost center
    final vpDir = (pocket - ghost);
    final vpNorm = vpDir.distance > 0 ? vpDir / vpDir.distance : Offset.zero;
    final vpAngle = math.atan2(vpNorm.dy, vpNorm.dx);
    final targetRad = math.pi - cutAngleDeg * math.pi / 180;
    final cAngle = vpAngle - targetRad;
    final cDir = Offset(math.cos(cAngle), math.sin(cAngle));
    final cueDist = w * 0.42;
    final cue = ghost + cDir * cueDist;

    // Aim direction from cue ball toward ghost center
    final aimDir = ghost - cue;
    final aimNorm = aimDir.distance > 0 ? aimDir / aimDir.distance : Offset.zero;

    // ---- Draw table background ----
    canvas.drawRect(Offset.zero & size,
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));

    // ---- Draw pocket: realistic corner pocket (top-right) ----
    // Real table geometry:
    //   - Ball diameter 52.5mm, corner pocket opening ~82mm (~1.56x ball diameter)
    //   - The pocket center (P) is BEHIND the jaw line (deeper into the corner)
    //   - Jaw1 on horizontal rail, Jaw2 on vertical rail
    //   - The two jaws form the "mouth" opening visible on the table
    //
    // Layout: P is at the actual corner. Jaws are FORWARD (toward the table) from P.
    // The "pocket center" for aiming purposes is often taken at the jaw midpoint.

    // Jaw positions: fixed relative to the corner area
    // For top-right corner: jaw1 is on the horizontal rail (left side), jaw2 on vertical rail (below)
    final jawOpeningHalf = r * 1.56; // half of 82mm opening ≈ 1.56 * ball_radius
    final jaw1 = Offset(pocket.dx - jawOpeningHalf * 1.1, pocket.dy + jawOpeningHalf * 0.1);
    final jaw2 = Offset(pocket.dx + jawOpeningHalf * 0.1, pocket.dy + jawOpeningHalf * 1.1);

    // P (pocket center) sits behind the jaw line — deeper into the corner
    // We keep `pocket` as-is (it's the aiming target), and place jaws FORWARD from it

    // Draw the pocket hole circle (centered at P, behind the jaw opening)
    final pocketVisR = r * 1.6;
    canvas.drawCircle(pocket, pocketVisR, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(pocket, pocketVisR,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2.5);

    // Draw cushion lines (rails) extending from jaw points outward along the rail
    final cushionLen = r * 12;
    final cushionPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = 4;
    // Horizontal rail extends left from jaw1
    canvas.drawLine(jaw1, jaw1 + const Offset(-1, 0) * cushionLen, cushionPaint);
    // Vertical rail extends down from jaw2
    canvas.drawLine(jaw2, jaw2 + const Offset(0, 1) * cushionLen, cushionPaint);

    // Draw jaw points
    canvas.drawCircle(jaw1, 4, Paint()..color = const Color(0xFF8D6E63));
    canvas.drawCircle(jaw1, 4,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    canvas.drawCircle(jaw2, 4, Paint()..color = const Color(0xFF8D6E63));
    canvas.drawCircle(jaw2, 4,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);

    _drawLabel(canvas, 'J1', jaw1 + const Offset(-12, -10), const Color(0xFF8D6E63), 10);
    _drawLabel(canvas, 'J2', jaw2 + const Offset(10, 10), const Color(0xFF8D6E63), 10);

    // Pocket center label
    _drawLabel(canvas, 'P', pocket + const Offset(10, -8), const Color(0xFFFFEB3B), 12, bold: true);

    // ---- Object ball ----
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, 'O', obj + Offset(0, r + 14), const Color(0xFFFFEB3B), 11, bold: true);

    // ---- Ghost ball ----
    canvas.drawCircle(ghost, r,
        Paint()..color = const Color(0x339C27B0)..style = PaintingStyle.fill);
    canvas.drawCircle(ghost, r,
        Paint()..color = const Color(0xFF9C27B0)..style = PaintingStyle.stroke..strokeWidth = 1);
    _drawLabel(canvas, 'G', ghost + Offset(0, r + 14), const Color(0xFF9C27B0), 10);

    // ---- Cue ball ----
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, 'C', cue + Offset(0, r + 14), Colors.white, 11, bold: true);

    // ---- 1. P→O extended line (yellow dashed): from pocket through object ball center and beyond ----
    final poDir = obj - pocket;
    final poDirNorm = poDir.distance > 0 ? poDir / poDir.distance : Offset.zero;
    // Extend well past the object ball to clearly show it passes through
    final poExtEnd = pocket + poDirNorm * (poDir.distance + r * 14);
    _drawDashed(canvas, pocket, poExtEnd,
        Paint()..color = const Color(0xAAFFEB3B)..strokeWidth = 1.5);

    // ---- 2. C→G aim line (green) ----
    final aimEnd = cue + aimNorm * cueDist * 1.1;
    canvas.drawLine(cue, aimEnd,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.6)..strokeWidth = 1.5);

    // ---- 3. Select the NEAR jaw point ----
    // The "near jaw" is the one on the same side as the cue ball's approach.
    final cueToObj = obj - cue;
    final opPerp = Offset(-opNorm.dy, opNorm.dx);
    final sideSign = _dot(cueToObj, opPerp) > 0 ? 1.0 : -1.0;
    final nearJaw = sideSign > 0 ? jaw1 : jaw2;
    final farJaw = sideSign > 0 ? jaw2 : jaw1;
    final nearJawLabel = sideSign > 0 ? 'J1' : 'J2';

    // Highlight the selected near jaw
    canvas.drawCircle(nearJaw, 6, Paint()..color = const Color(0xFFFFA726));
    canvas.drawCircle(nearJaw, 6,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '袋口边缘($nearJawLabel)', nearJaw + Offset(-opPerp.dx * sideSign * 22, -opPerp.dy * sideSign * 22 - 8),
        const Color(0xFFFFA726), 10, bold: true);

    // ---- 4. Line from near jaw to object ball center ----
    canvas.drawLine(nearJaw, obj,
        Paint()..color = const Color(0xFFFFA726).withValues(alpha: 0.8)..strokeWidth = 2);
    // Also show far jaw line faintly for reference
    _drawDashed(canvas, farJaw, obj,
        Paint()..color = const Color(0xFF8D6E63).withValues(alpha: 0.3)..strokeWidth = 1);

    // ---- 5. Cut edge point ----
    // Direction: from near jaw toward object ball center.
    // The cut point is on the far side of the ball (the side white ball must hit).
    final jawToObj = obj - nearJaw;
    final jawToObjNorm = jawToObj.distance > 0 ? jawToObj / jawToObj.distance : Offset.zero;
    final cutEdgePt = obj + jawToObjNorm * r;

    canvas.drawCircle(cutEdgePt, 5, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(cutEdgePt, 5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '切边缘点', cutEdgePt + Offset(opPerp.dx * sideSign * 18, opPerp.dy * sideSign * 18),
        const Color(0xFFFF5722), 11, bold: true);

    // ---- 6. White ball aim direction: C → cutEdgePt (how the player should aim) ----
    final aimToCut = cutEdgePt - cue;
    final aimToCutNorm = aimToCut.distance > 0 ? aimToCut / aimToCut.distance : Offset.zero;
    final aimLineEnd = cue + aimToCutNorm * (aimToCut.distance + r * 3);
    _drawDashed(canvas, cue, aimLineEnd,
        Paint()..color = const Color(0xFFFF5722).withValues(alpha: 0.6)..strokeWidth = 1.8);

    // ---- 7. Show angle difference between standard G-aim and pocket-edge aim ----
    final stdAimNorm = aimNorm;
    final edgeAimAngle = math.acos(
        (stdAimNorm.dx * aimToCutNorm.dx + stdAimNorm.dy * aimToCutNorm.dy)
            .clamp(-1.0, 1.0)) * 180 / math.pi;

    if (edgeAimAngle > 0.5) {
      final diffLabel = '偏差 ${edgeAimAngle.toStringAsFixed(1)}°';
      final midPt = (cue + cutEdgePt) / 2 + Offset(0, -20);
      _drawLabel(canvas, diffLabel, midPt, const Color(0xFFFF5722), 11, bold: true);
    }

    // ---- 8. Entry point on pocket side (where ball exits toward pocket) ----
    // Show this only as a small reference dot on the pocket-facing side of the ball.
    final exitPt = obj + opNorm * r;
    canvas.drawCircle(exitPt, 3, Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.6));

    // ---- 9. Cut angle arc at object ball center ----
    // The cut angle: between the incoming C→O direction and the outgoing O→P direction.
    // Arc is drawn at O (object ball center) between these two directions.
    final oToP = pocket - obj;
    final oToPNorm = oToP.distance > 0 ? oToP / oToP.distance : Offset.zero;
    final oToC = cue - obj;
    final oToCNorm = oToC.distance > 0 ? oToC / oToC.distance : Offset.zero;

    final arcStartAng = math.atan2(oToPNorm.dy, oToPNorm.dx);
    final arcEndAng = math.atan2(oToCNorm.dy, oToCNorm.dx);
    var arcSweep = arcEndAng - arcStartAng;
    if (arcSweep > math.pi) arcSweep -= 2 * math.pi;
    if (arcSweep < -math.pi) arcSweep += 2 * math.pi;

    final arcR = r * 1.8;
    final arcPaint = Paint()
      ..color = const Color(0xFFFFA726)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromCircle(center: obj, radius: arcR),
      arcStartAng,
      arcSweep,
      false,
      arcPaint,
    );

    // Angle label: place along the arc bisector, offset outward from obj
    final midArcAng = arcStartAng + arcSweep / 2;
    final labelDist = arcR + r * 1.5;
    final angleLabelPos = Offset(
      obj.dx + labelDist * math.cos(midArcAng),
      obj.dy + labelDist * math.sin(midArcAng),
    );
    _drawLabel(canvas, '${cutAngleDeg.toStringAsFixed(0)}°', angleLabelPos,
        const Color(0xFFFFA726), 14, bold: true);
  }

  static double _dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_PocketEdgeAimingPainter old) => old.cutAngleDeg != cutAngleDeg;
}

// ---------------------------------------------------------------------------
// CTE Aiming Lab — tabbed: Classic CTE + Pro One CTE
// ---------------------------------------------------------------------------
class _CTEAimingLab extends StatefulWidget {
  const _CTEAimingLab();

  @override
  State<_CTEAimingLab> createState() => _CTEAimingLabState();
}

class _CTEAimingLabState extends State<_CTEAimingLab> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  double _cutAngleDeg = 30;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tab,
          labelColor: const Color(0xFF26C6DA),
          unselectedLabelColor: Colors.white54,
          indicatorColor: const Color(0xFF26C6DA),
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          dividerHeight: 0,
          tabs: const [Tab(text: 'CTE 基础'), Tab(text: 'CTE 进阶（Pro One）')],
          onTap: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('切角',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            Expanded(
              child: Slider(
                value: _cutAngleDeg,
                min: 5,
                max: 55,
                divisions: 50,
                label: '${_cutAngleDeg.toStringAsFixed(0)}°',
                activeColor: const Color(0xFF26C6DA),
                onChanged: (v) => setState(() => _cutAngleDeg = v),
              ),
            ),
            Text('${_cutAngleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFF26C6DA),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CustomPaint(
            painter: _tab.index == 0
                ? _CTEAimingPainter(cutAngleDeg: _cutAngleDeg)
                : _ProOneCTEPainter(cutAngleDeg: _cutAngleDeg),
          ),
        ),
        const SizedBox(height: 12),
        if (_tab.index == 0) ..._buildClassicContent()
        else ..._buildProOneContent(),
      ],
    );
  }

  List<Widget> _buildClassicContent() {
    final thickness = math.cos(_cutAngleDeg * math.pi / 180);
    final pct = (thickness * 100).toStringAsFixed(0);
    return [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(color: Color(0xFF26C6DA), label: 'CTE 参考线'),
          _LegendItem(color: Color(0xFF66BB6A), label: '最终出杆方向'),
          _LegendItem(color: Color(0xFFFFEB3B), label: '进球路线'),
          _LegendItem(color: Color(0xFF9C27B0), label: '假想球位置'),
        ],
      ),
      const SizedBox(height: 12),

      // ---- 1. 什么是 CTE ----
      _infoCard(
        '什么是 CTE？',
        'CTE 全称 Center To Edge（中心对边缘），'
        '由 Stan Shuffett 在前人（Hal Houle）基础上发展并系统化。\n\n'
        '它是一套"视觉感知 + 半皮头偏移 + 转回中心"的出杆流程，'
        '用来代替传统的"假想球"瞄准法。\n\n'
        '核心优势：\n'
        '• 不需要在脑中想象一个看不见的"假想球"\n'
        '• 不需要估算接触点在目标球上的精确位置\n'
        '• 只需要识别 3 个固定参考点（A/B/C），配合一个固定偏移量\n'
        '• 操作步骤完全标准化，每一杆的流程都一样\n\n'
        '局限性：\n'
        '• 标准 CTE 覆盖 0°-45° 的切球（占实战中绝大多数球）\n'
        '• 超过 45° 的极薄球需要额外处理（如 edge to 1/8）\n'
        '• 需要大量练习来建立肌肉记忆，不是"学了就会"',
      ),
      const SizedBox(height: 8),

      // ---- 2. 目标球上的参考点 ----
      _infoCard(
        '目标球上的参考点（见左图俯视图）',
        '把目标球的直径四等分，得到 5 个点：\n\n'
        '中心 ── A ── B ── C ── 边缘\n'
        ' 0°     15°   30°   45°   >45°\n\n'
        '具体位置：\n'
        '• 中心 = 目标球正中（直球，0° 切角）\n'
        '• A 点 = 从中心到边缘的 1/4 处（15° 切角）\n'
        '• B 点 = 从中心到边缘的 2/4 处（30° 切角）\n'
        '• C 点 = 从中心到边缘的 3/4 处（45° 切角）\n'
        '• 边缘 = 目标球最外侧（>45° 极薄球）\n\n'
        '每个 1/4 间距 ≈ 9/16 英寸 ≈ 14mm（标准 57mm 球）。\n\n'
        '重要：这些点分布在目标球的赤道线上，'
        '方向是垂直于进球线（袋口方向）的。\n\n'
        '左切和右切的标记方向相反：\n'
        '• 左切球：从球心向左依次是 A、B、C\n'
        '• 右切球：从球心向右依次是 A、B、C\n'
        'A 总是离中心最近（切球方向的内侧），'
        'C 总是离中心最远（切球方向的外侧）。',
      ),
      const SizedBox(height: 8),

      // ---- 3. 两个视觉感知 ----
      _infoCard(
        'CTE 的两个视觉感知',
        'CTE 的核心是同时建立两个视觉对齐关系：\n\n'
        '感知 ①：CTE 感知\n'
        '  白球的中心线 对准 目标球的边缘\n'
        '  即 Center（白球中心）To Edge（目标球边缘）\n'
        '  这就是 CTE 名字的由来。\n\n'
        '感知 ②：Edge to A/B/C 感知\n'
        '  白球的另一侧边缘 对准 目标球上的 A、B 或 C 点\n'
        '  具体对准哪个点取决于切球角度。\n\n'
        '这两个感知需要同时成立。你站立时（还没趴下），'
        '找到一个位置，让你的眼睛能同时看到这两个对齐关系。\n'
        '此时白球在你的视野中变成一个"固定白球"——'
        '它有一条中心线和两个可见的边缘。\n\n'
        '举例 · 30° 左切球：\n'
        '  感知 ①：白球中心 对准 目标球右边缘\n'
        '  感知 ②：白球左边缘 对准 目标球上的 B 点\n'
        '  两个感知同时成立时，你就找到了正确的站位。',
      ),
      const SizedBox(height: 8),

      // ---- 4. 完整操作流程 ----
      _infoCard(
        '完整操作流程（5 步）',
        '第 1 步 · 读球\n'
        '站在桌边，先确定进球路线：\n'
        '  目标球 → 袋口的连线（图中黄色虚线）\n'
        '判断这大致是多少度的切球，选定用 A、B 还是 C 点。\n'
        '不需要精确度数，靠经验判断即可。\n\n'
        '第 2 步 · 建立双重感知\n'
        '走到白球后方，站直（还不要趴下），调整你的站位：\n'
        '  • 一只眼看：白球中心 → 目标球边缘（CTE 感知）\n'
        '  • 同时看：白球另一侧边缘 → 目标球 A/B/C 点\n'
        '当两个感知同时对齐时，你就建立了"固定白球"。\n'
        '此时白球的中心线和两侧边缘在你视野中都是清晰的。\n\n'
        '第 3 步 · 趴下对准\n'
        '保持住这个视觉感知，慢慢弯腰趴到出杆位置。\n'
        '把球杆沿着"白球中心 → 目标球瞄准点"的方向放好。\n'
        '这就是 CTE 参考线（图中青色线）。\n'
        '⚠️ 此时的球杆方向还不是最终出杆方向。\n\n'
        '第 4 步 · 偏移半皮头\n'
        '保持球杆方向不变，只平移杆头：\n'
        '  • 从白球中心向切球方向移动半个皮头（约 6mm）\n'
        '  • 左切球 → 杆头向左平移\n'
        '  • 右切球 → 杆头向右平移\n'
        '偏移量始终是半皮头，不会因角度不同而改变。\n\n'
        '偏移方向（内侧/外侧）决定了球的厚薄微调：\n'
        '  • 向"内侧"偏移（靠近切球方向）→ 使球打得更薄\n'
        '  • 向"外侧"偏移（远离切球方向）→ 使球打得更厚\n\n'
        '第 5 步 · 转回中心，出杆\n'
        '以后手（握杆手的位置）为固定支点，不要移动后手：\n'
        '  杆头从偏移位置 转回 白球正中心\n'
        '这个转动会自然地改变球杆的瞄准方向。\n'
        '当杆头回到白球正中心的那一刻，'
        '球杆已经自动指向了正确的出杆角度（图中绿色线）。\n\n'
        '确认杆头在白球中心，平稳运杆，出杆。\n\n'
        '注意：转回的过程非常小幅（半个皮头 ≈ 6mm），'
        '看起来几乎不像在"转"，更像是微调。'
        '这也是为什么外人很难看出 CTE 使用者在做什么。',
      ),
      const SizedBox(height: 8),

      // ---- 5. 编号速记法 ----
      _infoCard(
        '实战速记（编号系统）',
        '打球时不要在脑子里说"30度左切外侧半皮头转回"这种长句。\n'
        '用编号代替，简化思维负担：\n\n'
        '编号 1 = 15° 外侧偏移（直球和近直球也用此编号）\n'
        '编号 2 = 15° 内侧偏移\n'
        '编号 3 = 30° 内侧偏移\n'
        '编号 4 = 45° 外侧偏移\n'
        '编号 5 = 45° 内侧偏移\n\n'
        '补充说明：\n'
        '• 编号 2 和编号 3（内侧 15° 与内侧 30°）效果接近，\n'
        '  可互换使用，凭个人习惯选择。\n'
        '• 直球用编号 1（15° 外侧偏移）。\n'
        '• 45° 球没有 CTE 感知（白球中心已经对不上目标球边缘），\n'
        '  只使用 Edge to C 感知。\n'
        '• 超过 45° 可用 Edge to 1/8（目标球边缘再往外 1/8 处）。\n\n'
        '练习时，看到球就在心里说"这是 3"或"这是 1"，'
        '然后执行对应的标准流程。\n'
        '熟练后，整个判断 + 出杆只需要几秒钟。',
      ),
      const SizedBox(height: 8),

      // ---- 6. 当前设置 ----
      _infoCard(
        '当前设置：切球角 ${_cutAngleDeg.toStringAsFixed(0)}°',
        '${_cutAngleDeg < 8
            ? "几乎直球 → 编号 1\n\n"
              "使用 A 点 + 外侧半皮头偏移。\n"
              "球杆对准白球中心 → 目标球 A 点，\n"
              "杆头向外侧偏移半皮头，然后转回中心出杆。\n"
              "出杆方向几乎等于参考线方向。"
            : _cutAngleDeg < 23
            ? "约 15° 厚球 → 编号 1 或 2\n\n"
              "使用 A 点（内侧 1/4 处）。\n"
              "• 编号 1：外侧偏移 → 球打得更厚\n"
              "• 编号 2：内侧偏移 → 球打得更薄\n"
              "根据实际角度微调选择。\n"
              "转回角度很小，出杆方向接近参考线。"
            : _cutAngleDeg < 38
            ? "约 30° 中等切球 → 编号 3\n\n"
              "使用 B 点（边缘中心处）。\n"
              "内侧偏移半皮头，转回中心。\n"
              "转回后出杆方向与参考线有明显角度差。\n\n"
              "提示：编号 2（A 点内侧）和编号 3（B 点内侧）\n"
              "效果接近，可根据个人习惯选择。"
            : _cutAngleDeg < 50
            ? "约 45° 较薄球 → 编号 4 或 5\n\n"
              "使用 C 点（外侧 3/4 处）。\n"
              "注意：45° 时白球中心已无法对准目标球边缘，\n"
              "CTE 感知消失，只依靠 Edge to C 感知。\n"
              "• 编号 4：外侧偏移 → 稍厚\n"
              "• 编号 5：内侧偏移 → 稍薄"
            : "超过 45° 极薄球\n\n"
              "标准 CTE 的 A/B/C 点不再适用。\n"
              "可尝试 Edge to 1/8（目标球边缘外 1/8 处），\n"
              "但 CTE 在此范围的精度有限。\n"
              "建议配合其他瞄准方法（如分数球）辅助。"
        }',
      ),
    ];
  }

  List<Widget> _buildProOneContent() {
    final overlap = _proOneOverlap(_cutAngleDeg);
    return [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(color: Color(0xFF26C6DA), label: '参考线（白球中心 → 目标球背对袋口的边缘）'),
          _LegendItem(color: Color(0xFFFF9800), label: '重叠区域（白球边缘和目标球重合的部分）'),
          _LegendItem(color: Color(0xFF66BB6A), label: '实际出杆方向'),
          _LegendItem(color: Color(0xFFFFEB3B), label: '进球路线（袋口方向）'),
        ],
      ),
      const SizedBox(height: 12),
      _infoCard(
        '完整操作流程',
        '① 选线路：先看袋口，选最容易进的那个袋。'
        '想象一条从袋口穿过目标球中心的线——这就是进球线。\n'
        '   图中黄色虚线 O→P 就是进球线。\n\n'
        '② 站位：走到白球正后方，让身体对准进球方向。\n\n'
        '③ 建立参考线：低头沿球杆方向看，'
        '找到目标球上背对袋口的那个边缘'
        '（如果袋口在目标球右边，就找目标球的左边缘）。'
        '然后让白球的正中心对准这个边缘点。\n'
        '   → 图中青色线就是这条参考线。\n\n'
        '④ 读重叠量：保持参考线不动，同时注意白球面向袋口一侧的边缘'
        '（和参考线相对的另一边），'
        '看它和目标球"重叠"了多少。\n'
        '   → 图中橙色区域就是重叠的部分。\n\n'
        '⑤ 出杆：确认重叠量后，正常出杆。',
      ),
      const SizedBox(height: 8),
      _infoCard(
        'Pro One 的核心：重叠量 = 切角',
        '不需要记 A/B/C 三个点，直接看白球的边缘和目标球重合了多少：\n\n'
        '• 重叠面积大（白球边缘深入目标球很多）\n'
        '  → 切角小，打得厚，接近正面碰撞\n\n'
        '• 重叠面积小（白球边缘刚刚碰到目标球）\n'
        '  → 切角大，打得薄，接近擦边而过\n\n'
        '• 完全没有重叠 → 超过 50° 的极薄球\n\n'
        '这就像一把连续刻度尺，没有空档。\n'
        '每次打相同角度的球，重叠量都一样，'
        '打 100 个球后就形成肌肉记忆了。',
      ),
      const SizedBox(height: 8),
      _infoCard(
        '当前重叠量',
        '切角 ${_cutAngleDeg.toStringAsFixed(0)}° → '
        '重叠约 ${(overlap * 100).toStringAsFixed(0)}% 球径\n'
        '${overlap > 0.6 ? "（很厚，几乎正面撞）" : overlap > 0.3 ? "（中等厚度）" : overlap > 0.05 ? "（比较薄）" : "（极薄，几乎没有重叠）"}',
      ),
    ];
  }

  static double _proOneOverlap(double cutDeg) {
    final rad = cutDeg * math.pi / 180;
    return (math.cos(rad)).clamp(0.0, 1.0);
  }

  Widget _infoCard(String title, String body) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF26C6DA).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF26C6DA), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(body,
              style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.5)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CTE Aiming Painter
// ---------------------------------------------------------------------------
class _CTEAimingPainter extends CustomPainter {
  _CTEAimingPainter({required this.cutAngleDeg});

  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.055;

    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));

    // ===== LEFT HALF: Top-down view of OB with 5 aiming spots =====
    final obCenter = Offset(w * 0.22, h * 0.45);
    final obR = r * 2.5;
    // Object ball
    canvas.drawCircle(obCenter, obR, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obCenter, obR, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    // Center line (horizontal = pocket direction)
    canvas.drawLine(obCenter + Offset(-obR, 0), obCenter + Offset(obR, 0),
        Paint()..color = Colors.white38..strokeWidth = 0.8);
    // Spots: C B A CTR A B C
    const spots = [
      (-0.75, 'C'), (-0.5, 'B'), (-0.25, 'A'),
      (0.0, '中'),
      (0.25, 'A'), (0.5, 'B'), (0.75, 'C'),
    ];
    const spotAngles = ['45°', '30°', '15°', '', '15°', '30°', '45°'];
    for (var i = 0; i < spots.length; i++) {
      final (frac, label) = spots[i];
      final x = obCenter.dx + frac * obR;
      final spotColor = label == '中' ? Colors.white60 : (frac.abs() < 0.3 ? const Color(0xFF66BB6A) : frac.abs() < 0.6 ? const Color(0xFF26C6DA) : const Color(0xFFFF6600));
      canvas.drawCircle(Offset(x, obCenter.dy), 3, Paint()..color = spotColor);
      _drawLabel(canvas, label, Offset(x - 4, obCenter.dy + 8), spotColor, 9, bold: true);
      if (spotAngles[i].isNotEmpty) {
        _drawLabel(canvas, spotAngles[i], Offset(x - 8, obCenter.dy - 16), spotColor, 8);
      }
    }
    _drawLabel(canvas, '目标球俯视图 — 瞄准点位置', Offset(w * 0.05, h * 0.08), Colors.white60, 10);
    _drawLabel(canvas, '← 左切                  右切 →',
        Offset(obCenter.dx - obR, obCenter.dy + obR + 10), Colors.white38, 9);
    _drawLabel(canvas, '← 袋口方向', Offset(obCenter.dx - obR - 35, obCenter.dy - 4), Colors.white38, 8);

    // Highlight current angle's spot
    final cutRad = cutAngleDeg * math.pi / 180;
    final spotFrac = (cutAngleDeg / 45.0).clamp(0.0, 1.0) * 0.75;
    final currentSpotX = obCenter.dx + spotFrac * obR;
    canvas.drawCircle(Offset(currentSpotX, obCenter.dy), 6,
        Paint()..color = const Color(0xFFFF5722).withValues(alpha: 0.6)..style = PaintingStyle.stroke..strokeWidth = 2);

    // ===== RIGHT HALF: Shot diagram with cue ball, OB, pocket =====
    final pocket = Offset(w * 0.92, h * 0.10);
    final obj = Offset(w * 0.65, h * 0.50);
    final op = pocket - obj;
    final opNorm = op / op.distance;
    final ghost = obj - opNorm * 2 * r;

    final vpAngle = math.atan2(opNorm.dy, opNorm.dx);
    final cAngle = vpAngle - (math.pi - cutRad);
    final cueDist = w * 0.28;
    final cue = ghost + Offset(math.cos(cAngle), math.sin(cAngle)) * cueDist;
    final aimDir = ghost - cue;
    final aimNorm = aimDir.distance > 0 ? aimDir / aimDir.distance : Offset.zero;

    // O→P dashed
    _drawDashed(canvas, obj, pocket, Paint()..color = const Color(0xAAFFEB3B)..strokeWidth = 1.2);
    canvas.drawCircle(pocket, r * 1.0, Paint()..color = const Color(0xFF263238));

    // Object ball
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Ghost ball
    canvas.drawCircle(ghost, r, Paint()..color = const Color(0x229C27B0));
    canvas.drawCircle(ghost, r, Paint()..color = const Color(0xFF9C27B0)..style = PaintingStyle.stroke..strokeWidth = 1);

    // Cue ball
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // CTE reference line (cue center → OB far edge)
    final objFarEdge = obj - opNorm * r;
    final cteDir = objFarEdge - cue;
    final cteNorm = cteDir.distance > 0 ? cteDir / cteDir.distance : Offset.zero;
    canvas.drawLine(cue, cue + cteNorm * (cteDir.distance + r * 2),
        Paint()..color = const Color(0xFF26C6DA).withValues(alpha: 0.8)..strokeWidth = 1.8);
    canvas.drawCircle(objFarEdge, 3, Paint()..color = const Color(0xFF26C6DA));

    // Actual shot line (green)
    canvas.drawLine(cue, cue + aimNorm * (aimDir.distance + r * 4),
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2);

    // Angle arc
    final gAwayFromP = ghost - pocket;
    final gAwayNorm = gAwayFromP.distance > 0 ? gAwayFromP / gAwayFromP.distance : Offset.zero;
    final gToC = cue - ghost;
    final gToCNorm = gToC.distance > 0 ? gToC / gToC.distance : Offset.zero;
    final arcStart = math.atan2(gAwayNorm.dy, gAwayNorm.dx);
    final arcEnd = math.atan2(gToCNorm.dy, gToCNorm.dx);
    var sweep = arcEnd - arcStart;
    if (sweep > math.pi) sweep -= 2 * math.pi;
    if (sweep < -math.pi) sweep += 2 * math.pi;
    final arcR = r * 1.8;
    canvas.drawArc(Rect.fromCircle(center: ghost, radius: arcR), arcStart, sweep, false,
        Paint()..color = const Color(0xFF26C6DA)..style = PaintingStyle.stroke..strokeWidth = 2);
    final midAng = arcStart + sweep / 2;
    _drawLabel(canvas, '${cutAngleDeg.toStringAsFixed(0)}°',
        Offset(ghost.dx + (arcR + r * 0.8) * math.cos(midAng), ghost.dy + (arcR + r * 0.8) * math.sin(midAng)),
        const Color(0xFF26C6DA), 11, bold: true);

    // Labels
    _drawLabel(canvas, '白球', cue + Offset(-r, r + 8), Colors.white60, 9);
    _drawLabel(canvas, '目标球', obj + Offset(r + 4, 4), const Color(0xFFFFEB3B), 9);
    _drawLabel(canvas, '袋口', pocket + const Offset(4, -12), Colors.white38, 9);
    _drawLabel(canvas, '背面边缘', objFarEdge + Offset(-36, -14), const Color(0xFF26C6DA), 8);
  }

  static double _dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_CTEAimingPainter old) => old.cutAngleDeg != cutAngleDeg;
}

// ---------------------------------------------------------------------------
// Pro One CTE Painter — continuous overlap visualization
// ---------------------------------------------------------------------------
class _ProOneCTEPainter extends CustomPainter {
  _ProOneCTEPainter({required this.cutAngleDeg});

  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.042;

    final pocket = Offset(w * 0.82, h * 0.15);
    final obj = Offset(w * 0.55, h * 0.42);
    final op = pocket - obj;
    final opNorm = op / op.distance;
    final ghost = obj - opNorm * 2 * r;

    // Cue ball placement
    final vpDir = pocket - ghost;
    final vpNorm = vpDir.distance > 0 ? vpDir / vpDir.distance : Offset.zero;
    final vpAngle = math.atan2(vpNorm.dy, vpNorm.dx);
    final targetRad = math.pi - cutAngleDeg * math.pi / 180;
    final cAngle = vpAngle - targetRad;
    final cDir = Offset(math.cos(cAngle), math.sin(cAngle));
    final cueDist = w * 0.38;
    final cue = ghost + cDir * cueDist;

    final aimDir = ghost - cue;
    final aimNorm = aimDir.distance > 0 ? aimDir / aimDir.distance : Offset.zero;

    // Background
    canvas.drawRect(Offset.zero & size,
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));

    // Pocket
    canvas.drawCircle(pocket, r * 1.4, Paint()..color = const Color(0xFF263238));
    _drawLabel(canvas, 'P', pocket + const Offset(10, -8), const Color(0xFFFFEB3B), 11, bold: true);

    // O→P line
    _drawDashed(canvas, obj, pocket,
        Paint()..color = const Color(0xAAFFEB3B)..strokeWidth = 1.2);

    // Object ball
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, 'O', obj + Offset(0, r + 14), const Color(0xFFFFEB3B), 11, bold: true);

    // Cue ball
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);

    // CTE reference line: cue center → OB far edge
    final objFarEdge = obj - opNorm * r;
    final cteDir = objFarEdge - cue;
    final cteNorm = cteDir.distance > 0 ? cteDir / cteDir.distance : Offset.zero;
    final cteLineEnd = cue + cteNorm * (cteDir.distance + r * 4);
    canvas.drawLine(cue, cteLineEnd,
        Paint()..color = const Color(0xFF26C6DA).withValues(alpha: 0.8)..strokeWidth = 1.8);
    canvas.drawCircle(objFarEdge, 4, Paint()..color = const Color(0xFF26C6DA));
    canvas.drawCircle(objFarEdge, 4,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Ghost ball (faint)
    canvas.drawCircle(ghost, r,
        Paint()..color = const Color(0x229C27B0));
    canvas.drawCircle(ghost, r,
        Paint()..color = const Color(0x669C27B0)..style = PaintingStyle.stroke..strokeWidth = 1);

    // ---- Overlap visualization ----
    // Overlap = cos(cutAngle): 1.0 at 0° (full ball), 0.0 at 90° (miss)
    final overlapFrac = math.cos(cutAngleDeg * math.pi / 180).clamp(0.0, 1.0);

    if (overlapFrac > 0.02) {
      // The chord cuts the OB at distance (overlapFrac * r) from center,
      // measured from the "far edge" (the side facing the incoming cue ball).
      // The "overlap" region is the larger cap on the incoming-ball side.
      //
      // Half-angle of the UNCUT (non-overlap) cap:
      //   halfAngleNotOverlap = acos(overlapFrac)
      // The overlap cap sweeps 2π - 2*halfAngleNotOverlap = 2*(π - acos(overlapFrac))
      final halfAngleNotOverlap = math.acos(overlapFrac.clamp(-1.0, 1.0));
      final overlapSweep = 2 * (math.pi - halfAngleNotOverlap);

      // Direction: the overlap region faces TOWARD the cue ball (incoming direction)
      final incomingAngle = math.atan2(aimNorm.dy, aimNorm.dx);

      final overlapPaint = Paint()
        ..color = const Color(0xFFFF9800).withValues(alpha: 0.40)
        ..style = PaintingStyle.fill;

      // Draw the overlap cap as a pie sector (close enough for small r)
      canvas.drawArc(
        Rect.fromCircle(center: obj, radius: r),
        incomingAngle - overlapSweep / 2,
        overlapSweep,
        true,
        overlapPaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: obj, radius: r),
        incomingAngle - overlapSweep / 2,
        overlapSweep,
        false,
        Paint()..color = const Color(0xFFFF9800)..style = PaintingStyle.stroke..strokeWidth = 1.5,
      );

      // Label
      _drawLabel(canvas, '重合 ${(overlapFrac * 100).toStringAsFixed(0)}%',
          obj + Offset(0, -r - 14), const Color(0xFFFF9800), 11, bold: true);
    }

    // Actual aim line (green) — extend through ghost ball
    final aimEnd = cue + aimNorm * (aimDir.distance + r * 4);
    canvas.drawLine(cue, aimEnd,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.7)..strokeWidth = 2);

    // Angle arc: cut angle at ghost ball (same fix as classic CTE)
    final gAwayFromP2 = ghost - pocket;
    final gAwayNorm2 = gAwayFromP2.distance > 0 ? gAwayFromP2 / gAwayFromP2.distance : Offset.zero;
    final gToC2 = cue - ghost;
    final gToCNorm2 = gToC2.distance > 0 ? gToC2 / gToC2.distance : Offset.zero;

    final arcStartAng2 = math.atan2(gAwayNorm2.dy, gAwayNorm2.dx);
    final arcEndAng2 = math.atan2(gToCNorm2.dy, gToCNorm2.dx);
    var arcSweep2 = arcEndAng2 - arcStartAng2;
    if (arcSweep2 > math.pi) arcSweep2 -= 2 * math.pi;
    if (arcSweep2 < -math.pi) arcSweep2 += 2 * math.pi;
    final arcR2 = r * 2.5;
    canvas.drawArc(
      Rect.fromCircle(center: ghost, radius: arcR2),
      arcStartAng2, arcSweep2, false,
      Paint()..color = const Color(0xFF26C6DA)..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    final midArcAng2 = arcStartAng2 + arcSweep2 / 2;
    final angleLabelPos2 = Offset(
      ghost.dx + (arcR2 + r * 1.2) * math.cos(midArcAng2),
      ghost.dy + (arcR2 + r * 1.2) * math.sin(midArcAng2),
    );
    _drawLabel(canvas, '${cutAngleDeg.toStringAsFixed(0)}°', angleLabelPos2,
        const Color(0xFF26C6DA), 13, bold: true);
  }

  static double _dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_ProOneCTEPainter old) => old.cutAngleDeg != cutAngleDeg;
}

// ---------------------------------------------------------------------------
// Parallel Lines Aiming Lab (平行线瞄准法 / Contact-Point-to-Contact-Point)
// ---------------------------------------------------------------------------
class _ParallelLinesAimingLab extends StatefulWidget {
  const _ParallelLinesAimingLab();
  @override
  State<_ParallelLinesAimingLab> createState() => _ParallelLinesAimingLabState();
}

class _ParallelLinesAimingLabState extends State<_ParallelLinesAimingLab> {
  double _cutAngleDeg = 30;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          const Text('切角', style: TextStyle(color: Colors.white70, fontSize: 12)),
          Expanded(
            child: Slider(
              value: _cutAngleDeg,
              min: 5,
              max: 75,
              onChanged: (v) => setState(() => _cutAngleDeg = v),
            ),
          ),
          Text('${_cutAngleDeg.round()}°',
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 8),
      AspectRatio(
        aspectRatio: 1.5,
        child: CustomPaint(
          painter: _ParallelLinesAimingPainter(cutAngleDeg: _cutAngleDeg),
          child: Container(),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 16, runSpacing: 6, children: const [
          _LegendItem(color: Color(0xFFF5F5F0), label: '母球 (C)'),
          _LegendItem(color: Color(0xFFE53935), label: '目标球 (O)'),
          _LegendItem(color: Color(0x6600E676), label: '假想球 (G)'),
          _LegendItem(color: Color(0xFFFFEB3B), label: '进球线（O→P）'),
          _LegendItem(color: Color(0xFF42A5F5), label: '平行线（过 C 平行进球线）'),
          _LegendItem(color: Color(0xFFFF5722), label: '接触点连线（CP_C → CP_O）'),
          _LegendItem(color: Color(0xFF66BB6A), label: '瞄准线（平移到 C 中心）'),
        ]),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是平行线瞄准法？',
                  style: TextStyle(color: Color(0xFF66BB6A), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '平行线法（Parallel Lines / Contact-Point-to-Contact-Point）'
                '利用两次平行移动来找到瞄准方向，'
                '数学上与假想球法完全等价。\n\n'
                '操作步骤：\n'
                '1. 画出进球线：目标球中心 → 袋口中心\n'
                '2. 将进球线平行移动到母球，找到母球上的接触点 (CP_C)\n'
                '3. 在目标球上找到被碰撞的接触点 (CP_O)——进球线的反方向\n'
                '4. 连接 CP_C → CP_O 得到接触点连线\n'
                '5. 将接触点连线平行移动回母球中心 → 即为瞄准方向\n\n'
                '优势：不需要想象"假想球"，只需看球的表面接触点。\n'
                '对薄切球（大角度）特别有效——接触点偏移比假想球更直观。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('数学等价性',
                style: TextStyle(color: Color(0xFF42A5F5), fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text(
              '平行线法和假想球法看起来不同，但几何上完全等价：\n\n'
              '• 假想球法：找到 G 点（目标球背后一个直径处），瞄准 G 中心\n'
              '• 平行线法：通过两次平行移动找到同样的瞄准方向\n\n'
              '证明：CP_C → CP_O 连线过假想球中心 G，'
              '平移到 C 中心后与 C → G 方向完全相同。',
              style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.6),
            ),
            const SizedBox(height: 8),
            Text(
              '当前切角 ${_cutAngleDeg.round()}° — '
              '${_cutAngleDeg < 20 ? "直球或小角度，两种方法都很直观" : _cutAngleDeg < 45 ? "中等角度，平行线法的接触点偏移容易看到" : "大角度薄切，平行线法比假想球更好用"}',
              style: const TextStyle(color: Color(0xFFFFEB3B), fontSize: 11),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('实战技巧',
                  style: TextStyle(color: Color(0xFFFF9800), fontSize: 13, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '快速使用方法（站在球台后方时）：\n'
                '1. 站在目标球后方，目视进球线（O→P）\n'
                '2. 在目标球"背面"（远离袋口侧）找到接触点 CP_O\n'
                '3. 走到母球后方，想象进球线平移到母球上\n'
                '4. 母球"前面"（面对目标球侧）的对应点就是 CP_C\n'
                '5. 将 CP_C→CP_O 连线方向作为出杆方向\n\n'
                '半球法则（特殊角度）：\n'
                '• 切角 30° 时：CP_O 在目标球赤道位置（半球切割线）\n'
                '  — 即母球瞄准目标球的"边缘"，俗称"半颗球"\n'
                '• 切角 0°（直球）：CP_O 在最远端，母球正面撞击\n'
                '• 切角 90°（极薄）：CP_O 在最近端，几乎擦边而过\n\n'
                '各方法适用场景对比：\n'
                '• 直球/小角度（<15°）→ 任何方法都行，直觉瞄准即可\n'
                '• 中等角度（15°-45°）→ 假想球法 or 平行线法均好用\n'
                '• 大角度薄切（>45°）→ 平行线法优于假想球（视觉参考更清晰）\n'
                '• 长距离切球 → 平行线法+CTE 组合最稳定\n'
                '• 翻袋球 → 不适用，需用镜像法/菱形系统',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.6),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('局限性与常见问题',
                  style: TextStyle(color: Color(0xFFE53935), fontSize: 13, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '1. ⚠ 球体立体感造成的"看薄"偏差（最关键！）\n'
                '   平行线法在平面图上完美，但球是立体球面。'
                '我们从球杆高度（接近水平）看球时，球面上的接触'
                '点和赤道位置有弧面差异：\n'
                '   • 我们看到的球"边缘"是球的赤道（最宽处）\n'
                '   • 但实际碰撞接触点在赤道偏下的球面上\n'
                '   • 接触点的视觉投影比实际位置更靠球心\n'
                '   → 效果：按平面理论瞄准，实际会"偏薄"（overcut）\n'
                '   → 角度越大偏差越明显（30° 约偏 0.5°，60° 约偏 2°）\n'
                '   → 补偿：瞄准时比理论点"稍厚"一点，或习惯瞄偏\n'
                '   → Dr. Dave 称之为 GBD（Ghost Ball Deflection）\n'
                '   → 所有基于接触点的方法都有此问题，包括假想球法——'
                '不是平行线法独有的缺陷\n'
                '   → 规避方法见下方"GBD 规避策略"卡片\n\n'
                '2. 碰撞诱导偏转（CIT / Throw）\n'
                '   平行线法假设纯几何碰撞，但实际中球与球碰撞时'
                '摩擦力会产生"偏转"（Throw）——目标球实际走向会'
                '偏离纯几何线 1°-3°。对薄切球影响尤为明显。\n'
                '   → 补偿方法：大角度薄切时，瞄准点比几何计算点'
                '"多切一点"（约半个球径偏移量的 3-5%）\n'
                '   → 好消息：GBD（看薄）和 Throw（偏转）部分互相抵消\n\n'
                '3. 俯视视角误差\n'
                '   站在球台旁边俯视时，球的"接触点"位置会因视角'
                '倾斜而产生视差。特别是远距离球，球面上的点从不同'
                '角度看位置不同（这与第 1 点球体立体感相关联）。\n'
                '   → 补偿方法：趴下瞄准时，让主视眼沿球杆方向看；'
                '站着预判时，习惯性多看两眼确认\n\n'
                '4. 不适用加塞（Side Spin）情况\n'
                '   母球带侧旋时，碰撞后目标球走向会额外偏移'
                '（顺塞偏多，反塞偏少），纯平行线法无法补偿。\n'
                '   → 需要结合经验微调瞄准点\n\n'
                '5. 心理依赖"接触点"可能干扰节奏\n'
                '   初学者过于关注找准接触点，容易在瞄准阶段花太多'
                '时间思考，影响出杆流畅度。\n'
                '   → 建议：练习时慢慢找点，比赛时凭肌肉记忆快速定位\n\n'
                '6. 球堆密集时难以使用\n'
                '   当目标球附近有其他球遮挡时，无法清楚看到接触点'
                '位置，此时假想球法可能更灵活。',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.6),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GBD 规避策略',
                  style: TextStyle(color: Color(0xFF9C27B0), fontSize: 13, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '方法一：利用 GBD 与 Throw 的互相抵消\n'
                '  GBD 让你"看薄"（偏向 overcut），而碰撞摩擦（Throw）'
                '让目标球"偏厚"走。两者方向相反，在很多角度下接近'
                '抵消。因此——不做修正、按直觉瞄准反而是对的！\n'
                '  Dr. Dave 指出：大多数球手"潜意识学会了补偿"，'
                '刻意纠正反而打不准。\n\n'
                '方法二：使用 Gearing Outside English（齿轮外塞）\n'
                '  在切球时加适量的"顺塞"（切球方向的外侧旋转），'
                '可以完全消除 Throw，让目标球精确走几何线路。\n'
                '  • 半球切（30°）约需 50% 侧旋\n'
                '  • 角度越大需要的外塞越多\n'
                '  • 缺点：母球路线也会因侧旋改变，需要同步调整\n\n'
                '方法三：改用不依赖接触点的瞄准系统\n'
                '  CTE（Center-To-Edge）系统通过球杆枢转来定位'
                '瞄准方向，不依赖球面上的接触点判断，因此完全'
                '不受 GBD 影响。适合对 GBD 敏感的大角度薄切球。\n\n'
                '方法四：提高击球速度\n'
                '  Throw 量在慢速球时最大（摩擦时间长），快速击球'
                '时 Throw 显著减小（减少一半以上）。所以打快球时'
                'GBD 反而不会被 Throw 抵消——此时需要有意识地'
                '"瞄厚"一点来补偿 GBD。\n\n'
                '方法五：练习"肌肉记忆校准"\n'
                '  固定同一角度反复练习，让身体自动记住正确的视觉'
                '偏差量。不同角度分别练（15°/30°/45°/60°），'
                '每个角度练到自动化后换下一个。这是职业球员最终'
                '依赖的方法——他们不计算 GBD，而是凭手感校准。',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class _ParallelLinesAimingPainter extends CustomPainter {
  _ParallelLinesAimingPainter({required this.cutAngleDeg});
  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = w * 0.035;

    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromLTWH(0, 0, w, h), 6, 6),
      Paint()..color = const Color(0xFF1B6B1F),
    );

    // Positions
    final pocket = Offset(w * 0.88, h * 0.15);
    final obj = Offset(w * 0.52, h * 0.48);

    // Pocket line direction (O → P)
    final opDir = pocket - obj;
    final opLen = opDir.distance;
    final opNorm = opDir / opLen;

    // Ghost ball position (for reference)
    final ghost = obj - opNorm * (r * 2);

    // Cue ball — placed based on cut angle
    final cutRad = cutAngleDeg * math.pi / 180;
    final revX = -opNorm.dx;
    final revY = -opNorm.dy;
    final cgDirX = revX * math.cos(cutRad) + revY * math.sin(cutRad);
    final cgDirY = -revX * math.sin(cutRad) + revY * math.cos(cutRad);
    final cgDir = Offset(cgDirX, cgDirY);
    final cueDist = w * 0.28;
    final cue = ghost + cgDir * cueDist;

    // Contact point on OB (CP_O): the point on OB surface facing away from pocket
    final cpO = obj - opNorm * r;

    // Contact point on CB (CP_C): shift pocket line parallel to CB, find CB surface point
    final cpC = cue + opNorm * r;

    // Step 1: O → P pocket line (yellow dashed)
    _drawDashed(canvas, obj, pocket,
        Paint()..color = const Color(0xFFFFEB3B).withValues(alpha: 0.7)..strokeWidth = 1.5);

    // Step 2: Parallel line through CB (blue dashed, full length for visual)
    final parallelStart = cue - opNorm * (w * 0.15);
    final parallelEnd = cue + opNorm * (w * 0.4);
    _drawDashed(canvas, parallelStart, parallelEnd,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.5)..strokeWidth = 1.2);

    // Parallel indicator arrows (small marks between the two parallel lines)
    final midParallel = (obj + cue) * 0.5;
    final perpDir = Offset(-opNorm.dy, opNorm.dx);
    final markLen = r * 0.8;
    for (var i = 0; i < 3; i++) {
      final t = -1.0 + i;
      final markCenter = midParallel + perpDir * (t * r * 3);
      canvas.drawLine(
        markCenter - perpDir * markLen,
        markCenter + perpDir * markLen,
        Paint()..color = Colors.white24..strokeWidth = 0.8,
      );
    }

    // Step 3: CP_C → CP_O contact point line (red/orange)
    canvas.drawLine(cpC, cpO,
        Paint()..color = const Color(0xFFFF5722).withValues(alpha: 0.85)..strokeWidth = 2.0);
    _drawArrow(canvas, cpC, cpO, const Color(0xFFFF5722), r * 0.4);

    // Step 4: Aim line — parallel shift of CP line to CB center (green)
    final cpDir = cpO - cpC;
    final cpDirLen = cpDir.distance;
    if (cpDirLen > 0.1) {
      final cpNorm = cpDir / cpDirLen;
      final aimEnd = cue + cpNorm * cueDist * 0.8;
      canvas.drawLine(cue, aimEnd,
          Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 2.0);
      _drawArrow(canvas, cue, aimEnd, const Color(0xFF66BB6A), r * 0.5);
    }

    // Ghost ball (faint reference)
    canvas.drawCircle(ghost, r, Paint()..color = const Color(0x2200E676));
    canvas.drawCircle(ghost, r,
        Paint()..color = const Color(0x6600E676)..style = PaintingStyle.stroke..strokeWidth = 1.0);

    // Object ball
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFE53935));
    _drawBallLabel(canvas, obj, 'O', r);

    // Cue ball
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xFFF5F5F0));
    _drawBallLabel(canvas, cue, 'C', r, dark: true);

    // Contact points (small filled dots)
    canvas.drawCircle(cpO, 4, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(cpO, 4,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    canvas.drawCircle(cpC, 4, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(cpC, 4,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Labels for contact points
    _drawLabel(canvas, 'CP_O', cpO + const Offset(8, -14), const Color(0xFFFF5722), 9, bold: true);
    _drawLabel(canvas, 'CP_C', cpC + const Offset(8, 8), const Color(0xFFFF5722), 9, bold: true);

    // Pocket
    canvas.drawCircle(pocket, r * 1.5, Paint()..color = const Color(0xFF111111));
    canvas.drawCircle(pocket, r * 1.5,
        Paint()..color = const Color(0xFF81C784)..style = PaintingStyle.stroke..strokeWidth = 1.0);
    _drawLabel(canvas, 'P', pocket + Offset(0, r * 1.5 + 10), Colors.white70, 10);

    // Ghost ball label
    _drawLabel(canvas, 'G', ghost + Offset(0, -r - 8), const Color(0xFF00E676), 9);

    // Step labels
    _drawLabel(canvas, '① 进球线 O→P', Offset(w * 0.65, h * 0.08), const Color(0xFFFFEB3B), 10);
    _drawLabel(canvas, '② 平行移动到 C', parallelEnd + const Offset(4, -4), const Color(0xFF42A5F5), 9);
    _drawLabel(canvas, '③ 连接接触点', (cpC + cpO) * 0.5 + const Offset(-40, 12), const Color(0xFFFF5722), 9);

    // Cut angle arc
    if (cutAngleDeg > 5) {
      final arcR = r * 3;
      final startAngle = math.atan2(opNorm.dy, opNorm.dx) + math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: ghost, radius: arcR),
        startAngle, cutRad,
        false,
        Paint()..color = Colors.white54..style = PaintingStyle.stroke..strokeWidth = 1.0,
      );
      final labelAngle = startAngle + cutRad / 2;
      final labelPos = ghost + Offset(math.cos(labelAngle), math.sin(labelAngle)) * (arcR + 10);
      _drawLabel(canvas, '${cutAngleDeg.round()}°', labelPos, Colors.white70, 10);
    }
  }

  void _drawDashed(Canvas canvas, Offset a, Offset b, Paint paint) {
    final dir = b - a;
    final len = dir.distance;
    if (len < 1) return;
    final norm = dir / len;
    const dashLen = 5.0;
    const gapLen = 3.0;
    var d = 0.0;
    while (d < len) {
      final s = a + norm * d;
      final e = a + norm * math.min(d + dashLen, len);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Color color, double size) {
    final dir = to - from;
    final len = dir.distance;
    if (len < 1) return;
    final norm = dir / len;
    final perp = Offset(-norm.dy, norm.dx);
    final tip = to;
    final left = tip - norm * size * 2 + perp * size;
    final right = tip - norm * size * 2 - perp * size;
    final path = Path()..moveTo(tip.dx, tip.dy)..lineTo(left.dx, left.dy)..lineTo(right.dx, right.dy)..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawBallLabel(Canvas canvas, Offset center, String text, double radius, {bool dark = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(
        color: dark ? Colors.black87 : Colors.white,
        fontSize: radius * 0.9,
        fontWeight: FontWeight.bold,
      )),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color, double fontSize, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      )),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_ParallelLinesAimingPainter old) => old.cutAngleDeg != cutAngleDeg;
}

// ---------------------------------------------------------------------------
// Bank Shot Hub (翻袋瞄准法 — Tab container)
// ---------------------------------------------------------------------------
class _BankShotHub extends StatefulWidget {
  const _BankShotHub();

  @override
  State<_BankShotHub> createState() => _BankShotHubState();
}

class _BankShotHubState extends State<_BankShotHub> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  static const _tabs = ['镜像法', '等距法', '平行位移', '菱形系统', '补偿系统', '总览'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          indicatorColor: const Color(0xFF66BB6A),
          labelColor: const Color(0xFF66BB6A),
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: const [
              SingleChildScrollView(child: _BankMirrorLab()),
              SingleChildScrollView(child: _BankEqualDistLab()),
              SingleChildScrollView(child: _BankParallelShiftLab()),
              SingleChildScrollView(child: _BankDiamondLab()),
              SingleChildScrollView(child: _BankCompensationLab()),
              SingleChildScrollView(child: _BankOverviewLab()),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bank Shot: Midpoint Method (中点瞄准法)
// ---------------------------------------------------------------------------
class _BankMidpointLab extends StatefulWidget {
  const _BankMidpointLab();

  @override
  State<_BankMidpointLab> createState() => _BankMidpointLabState();
}

class _BankMidpointLabState extends State<_BankMidpointLab> {
  double _ballDistFromRail = 0.3;
  double _ballX = 0.35;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('离库距离',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballDistFromRail,
                min: 0.1,
                max: 0.6,
                divisions: 50,
                activeColor: const Color(0xFF26C6DA),
                onChanged: (v) => setState(() => _ballDistFromRail = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('球横向位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballX,
                min: 0.15,
                max: 0.6,
                divisions: 45,
                activeColor: const Color(0xFF26C6DA),
                onChanged: (v) => setState(() => _ballX = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _BankMidpointPainter(
              ballDistRatio: _ballDistFromRail,
              ballXRatio: _ballX,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFF26C6DA), label: '目标球→袋口连线'),
            _LegendItem(color: Color(0xFFFF5722), label: '中心点（连线中点）'),
            _LegendItem(color: Color(0xFF66BB6A), label: '实际球路（球→中点库边→袋口）'),
            _LegendItem(color: Color(0xFFFF9800), label: '入射角 = 反射角'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF26C6DA).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('中点瞄准法说明',
                  style: TextStyle(
                      color: Color(0xFF26C6DA), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '最简单直觉的翻袋法，2步完成：\n\n'
                '1. 连接目标球和目标袋口\n'
                '2. 找到这条连线的中点\n'
                '3. 球打向中点在库边上的投影位置\n\n'
                '原理：当球到库边的距离 ≈ 库边到袋口的距离时，\n'
                '中点恰好就是镜像法的理想瞄准点。\n\n'
                '局限：\n'
                '• 只在"等距"情况下完全准确\n'
                '• 球离库远或袋口离库远时需要修正\n'
                '• 适合快速估算，不适合精确瞄准',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Midpoint Painter
// ---------------------------------------------------------------------------
class _BankMidpointPainter extends CustomPainter {
  _BankMidpointPainter({required this.ballDistRatio, required this.ballXRatio});

  final double ballDistRatio;
  final double ballXRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.038;

    // Rail in the middle
    final railY = h * 0.5;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 5);
    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.1));

    // Object ball below rail
    final distFromRail = (h - railY) * ballDistRatio;
    final ballX = w * ballXRatio;
    final ballY = railY + distFromRail;
    final ball = Offset(ballX, ballY);

    // Target pocket (top-right area, above rail)
    final pocket = Offset(w * 0.85, railY * 0.15);

    // Midpoint of ball→pocket line
    final midpoint = Offset((ball.dx + pocket.dx) / 2, (ball.dy + pocket.dy) / 2);

    // Project midpoint onto rail (directly above/below midpoint at railY)
    final railAimPoint = Offset(midpoint.dx, railY);

    // ---- Ball to pocket line (cyan dashed) ----
    _drawDashed(canvas, ball, pocket,
        Paint()..color = const Color(0xFF26C6DA).withValues(alpha: 0.7)..strokeWidth = 1.5);

    // ---- Midpoint marker ----
    canvas.drawCircle(midpoint, 5, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(midpoint, 5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '中点', midpoint + const Offset(12, 0),
        const Color(0xFFFF5722), 10, bold: true);

    // ---- Projection line from midpoint to rail (vertical dashed) ----
    _drawDashed(canvas, midpoint, railAimPoint,
        Paint()..color = Colors.white54..strokeWidth = 1);

    // ---- Aim point on rail ----
    canvas.drawCircle(railAimPoint, 6, Paint()..color = const Color(0xFFFF9800));
    canvas.drawCircle(railAimPoint, 6,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '瞄准点', railAimPoint + const Offset(0, 14),
        const Color(0xFFFF9800), 10, bold: true);

    // ---- Actual ball path (green) ----
    canvas.drawLine(ball, railAimPoint,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);
    canvas.drawLine(railAimPoint, pocket,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);

    // ---- Object ball ----
    canvas.drawCircle(ball, r * 1.2, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(ball, r * 1.2,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', ball + Offset(r * 2, 0), const Color(0xFFFFEB3B), 10);

    // ---- Pocket ----
    canvas.drawCircle(pocket, r * 1.5, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(pocket, r * 1.5,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '目标袋', pocket + const Offset(0, 16), Colors.white70, 10);

    // ---- Mirror-method reference point for comparison ----
    final mirrorBallY = 2 * railY - ball.dy;
    final mirrorBall = Offset(ball.dx, mirrorBallY);
    final mDir = pocket - mirrorBall;
    final mDy = railY - mirrorBall.dy;
    final mT = (mDir.dy.abs() < 0.01) ? 0.5 : mDy / mDir.dy;
    final mirrorAimX = (mirrorBall.dx + mT * mDir.dx).clamp(r, w - r);
    final mirrorAimPt = Offset(mirrorAimX, railY);
    // Draw mirror aim point (small white-outlined diamond)
    canvas.drawCircle(mirrorAimPt, 4,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.5));
    canvas.drawCircle(mirrorAimPt, 4,
        Paint()..color = Colors.white54..style = PaintingStyle.stroke..strokeWidth = 1);

    // Offset label showing the difference between midpoint and mirror methods
    final aimDiff = (railAimPoint.dx - mirrorAimPt.dx).abs();
    if (aimDiff > 2) {
      _drawLabel(canvas, '偏差 ${(aimDiff / r).toStringAsFixed(1)}R',
          Offset((railAimPoint.dx + mirrorAimPt.dx) / 2, railY + r * 3),
          Colors.white54, 10);
    }

    _drawLabel(canvas, '⚠ 近似法，有偏差',
        Offset(w * 0.5, h * 0.92), const Color(0xFFFF9800), 10);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_BankMidpointPainter old) =>
      old.ballDistRatio != ballDistRatio || old.ballXRatio != ballXRatio;
}

// ---------------------------------------------------------------------------
// Bank Shot: Mirror Image Lab
// ---------------------------------------------------------------------------
class _BankMirrorLab extends StatefulWidget {
  const _BankMirrorLab();

  @override
  State<_BankMirrorLab> createState() => _BankMirrorLabState();
}

class _BankMirrorLabState extends State<_BankMirrorLab> {
  double _ballDistFromRail = 0.3;
  double _bankAngle = 45;
  bool _mirrorBall = true; // true=镜像目标球（默认）, false=镜像袋口

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode toggle
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _mirrorBall = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: !_mirrorBall
                        ? const Color(0xFF42A5F5).withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
                    border: Border.all(
                      color: !_mirrorBall
                          ? const Color(0xFF42A5F5)
                          : Colors.white24,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text('镜像袋口',
                      style: TextStyle(
                        color: !_mirrorBall ? const Color(0xFF42A5F5) : Colors.white54,
                        fontSize: 13,
                        fontWeight: !_mirrorBall ? FontWeight.bold : FontWeight.normal,
                      )),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _mirrorBall = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _mirrorBall
                        ? const Color(0xFF66BB6A).withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                    border: Border.all(
                      color: _mirrorBall
                          ? const Color(0xFF66BB6A)
                          : Colors.white24,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text('镜像目标球',
                      style: TextStyle(
                        color: _mirrorBall ? const Color(0xFF66BB6A) : Colors.white54,
                        fontSize: 13,
                        fontWeight: _mirrorBall ? FontWeight.bold : FontWeight.normal,
                      )),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('球离库距离',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballDistFromRail,
                min: 0.08,
                max: 0.7,
                divisions: 62,
                activeColor: _mirrorBall ? const Color(0xFF66BB6A) : const Color(0xFF42A5F5),
                onChanged: (v) => setState(() => _ballDistFromRail = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('翻袋角度',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _bankAngle,
                min: 15,
                max: 75,
                divisions: 60,
                label: '${_bankAngle.toStringAsFixed(0)}°',
                activeColor: _mirrorBall ? const Color(0xFF66BB6A) : const Color(0xFF42A5F5),
                onChanged: (v) => setState(() => _bankAngle = v),
              ),
            ),
            Text('${_bankAngle.toStringAsFixed(0)}°',
                style: TextStyle(
                    color: _mirrorBall ? const Color(0xFF66BB6A) : const Color(0xFF42A5F5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _BankMirrorPainter(
              ballDistRatio: _ballDistFromRail,
              bankAngleDeg: _bankAngle,
              mirrorBall: _mirrorBall,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (!_mirrorBall)
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendItem(color: Color(0xFF42A5F5), label: '镜像袋口（库边外的虚拟袋口）'),
              _LegendItem(color: Color(0xFFFFEB3B), label: '目标球→镜像袋口连线（确定瞄准点）'),
              _LegendItem(color: Color(0xFF66BB6A), label: '实际球路（入射→反射）'),
              _LegendItem(color: Color(0xFFFF5722), label: '库边瞄准点（球碰库位置）'),
              _LegendItem(color: Color(0xFFFF9800), label: '入射角 = 反射角'),
            ],
          )
        else
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendItem(color: Color(0xFF66BB6A), label: '镜像目标球（库边外的虚拟球）'),
              _LegendItem(color: Color(0xFFFFEB3B), label: '镜像球→袋口连线（确定瞄准点）'),
              _LegendItem(color: Color(0xFF42A5F5), label: '实际球路（入射→反射）'),
              _LegendItem(color: Color(0xFFFF5722), label: '库边瞄准点（球碰库位置）'),
              _LegendItem(color: Color(0xFFFF9800), label: '入射角 = 反射角'),
            ],
          ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF42A5F5).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF42A5F5).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是镜像法？',
                  style: TextStyle(color: Color(0xFF42A5F5), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '镜像法是翻袋瞄准的经典方法。\n'
                '想象库边是一面镜子，袋口的"镜像"就在库边对面。\n'
                '白球→镜像袋口的连线与库边的交点就是瞄准点。\n\n'
                '操作步骤：\n'
                '1. 找到袋口在库边对面的镜像位置\n'
                '2. 从白球向镜像袋口画一条直线\n'
                '3. 直线与库边的交点就是白球应该击打的库边点\n'
                '4. 白球击中该点后反弹进袋\n\n'
                '拖动滑杆调节白球位置，观察镜像点和翻袋线路的变化。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (_mirrorBall ? const Color(0xFF66BB6A) : const Color(0xFF42A5F5))
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: (_mirrorBall ? const Color(0xFF66BB6A) : const Color(0xFF42A5F5))
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _mirrorBall ? '镜像目标球法说明' : '镜像袋口法说明',
                style: TextStyle(
                  color: _mirrorBall ? const Color(0xFF66BB6A) : const Color(0xFF42A5F5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _mirrorBall
                    ? '原理：入射角=反射角，等效于"球穿过库边到镜像位置"。\n\n'
                      '步骤：\n'
                      '1. 找到目标球关于库边的"镜像对称点"\n'
                      '2. 从袋口画线到镜像球\n'
                      '3. 该线与库边的交点 = 瞄准点\n'
                      '4. 将目标球打向该瞄准点即可翻袋\n\n'
                      '优势：翻袋时球通常靠近库边，镜像距离短，\n'
                      '虚拟球容易想象，实战中更直觉。'
                    : '原理：理想状态下入射角=反射角（如光反射）。\n\n'
                      '步骤：\n'
                      '1. 找到目标袋口关于库边的"镜像对称点"\n'
                      '2. 从目标球中心画线到镜像点\n'
                      '3. 该线与库边的交点 = 瞄准点\n'
                      '4. 将目标球打向该瞄准点即可翻袋\n\n'
                      '注意：袋口离库远时，镜像点也远，\n'
                      '需要更多想象力来定位虚拟目标。',
                style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
              const SizedBox(height: 8),
              const Text(
                '⚠ 两种镜像法数学上完全等价，瞄准点相同。\n'
                '• 力量大 → 出射角变小（库边"吃球"效应）\n'
                '• 力量小 → 出射角略大（接近理想镜像）\n'
                '• 加塞会改变反射角度',
                style: TextStyle(color: Colors.white54, fontSize: 10, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bank Shot Mirror Painter
// ---------------------------------------------------------------------------
class _BankMirrorPainter extends CustomPainter {
  _BankMirrorPainter({
    required this.ballDistRatio,
    required this.bankAngleDeg,
    this.mirrorBall = false,
  });

  final double ballDistRatio;
  final double bankAngleDeg;
  final bool mirrorBall;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.032;

    final railY = h * 0.45;
    final railPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = 5;
    canvas.drawLine(Offset(0, railY), Offset(w, railY), railPaint);

    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.1));

    // Object ball position: below the rail
    final ballDistFromRail = (h - railY) * ballDistRatio;
    final objY = railY + ballDistFromRail;
    final objX = w * 0.35;
    final obj = Offset(objX, objY);

    // Target pocket (below rail, to the right)
    final targetPocketY = h * 0.85;
    final bankRad = bankAngleDeg * math.pi / 180;
    final targetPocketX = objX + (targetPocketY - railY) * math.tan(bankRad) * 0.6;
    final targetPocket = Offset(targetPocketX.clamp(w * 0.15, w * 0.95), targetPocketY);

    // Rail contact point (same for both modes — mathematically equivalent)
    final mirrorPocket = Offset(targetPocket.dx, 2 * railY - targetPocket.dy);
    final dir = mirrorPocket - obj;
    final t = dir.dy != 0 ? (railY - obj.dy) / dir.dy : 0.0;
    final railContactX = obj.dx + t * dir.dx;
    final railContact = Offset(railContactX.clamp(r, w - r), railY);

    // Mirror point for the alternate mode
    final mirrorObj = Offset(obj.dx, 2 * railY - obj.dy);

    if (mirrorBall) {
      _paintMirrorBallMode(canvas, w, h, r, railY, obj, targetPocket, mirrorObj, railContact);
    } else {
      _paintMirrorPocketMode(canvas, w, h, r, railY, obj, targetPocket, mirrorPocket, railContact);
    }

    // ---- Common: angle arcs at rail contact ----
    _paintAngleArcs(canvas, r, railContact, obj, targetPocket);

    // ---- Object ball ----
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', obj + Offset(r + 10, 0), const Color(0xFFFFEB3B), 10);

    // ---- Cue ball ----
    final cueDir = obj - railContact;
    final cueNorm = cueDir.distance > 0 ? cueDir / cueDir.distance : Offset.zero;
    final cue = obj + cueNorm * (r * 8);
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, '白球', cue + Offset(0, r + 12), Colors.white70, 10);
    _drawDashed(canvas, cue, obj,
        Paint()..color = Colors.white38..strokeWidth = 1.2);

    // ---- Target pocket ----
    canvas.drawCircle(targetPocket, r * 1.5, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(targetPocket, r * 1.5,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '目标袋', targetPocket + const Offset(0, -16), Colors.white70, 10);

    _drawLabel(canvas, '距库 ${(ballDistRatio * 100).toStringAsFixed(0)}%',
        obj + Offset(-r * 5, 0), Colors.white38, 9);
  }

  // Mode A: mirror the pocket across the rail
  void _paintMirrorPocketMode(Canvas canvas, double w, double h, double r,
      double railY, Offset obj, Offset targetPocket, Offset mirrorPocket, Offset railContact) {
    // Virtual mirror pocket
    canvas.drawCircle(mirrorPocket, r * 0.8,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.3));
    canvas.drawCircle(mirrorPocket, r * 0.8,
        Paint()..color = const Color(0xFF42A5F5)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '镜像袋口', mirrorPocket + const Offset(0, -14),
        const Color(0xFF42A5F5), 9);

    // Dashed symmetry line between real pocket and mirror pocket
    _drawDashed(canvas, targetPocket, mirrorPocket,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.3)..strokeWidth = 1);

    // Aiming reference: obj → mirrorPocket
    _drawDashed(canvas, obj, mirrorPocket,
        Paint()..color = const Color(0xAAFFEB3B)..strokeWidth = 1.5);

    // Actual ball path
    canvas.drawLine(obj, railContact,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);
    canvas.drawLine(railContact, targetPocket,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);

    // Rail contact point
    canvas.drawCircle(railContact, 5, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(railContact, 5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '瞄准点', railContact + const Offset(0, 14),
        const Color(0xFFFF5722), 10, bold: true);
  }

  // Mode B: mirror the object ball across the rail
  void _paintMirrorBallMode(Canvas canvas, double w, double h, double r,
      double railY, Offset obj, Offset targetPocket, Offset mirrorObj, Offset railContact) {
    // Virtual mirror ball
    canvas.drawCircle(mirrorObj, r * 0.8,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.3));
    canvas.drawCircle(mirrorObj, r * 0.8,
        Paint()..color = const Color(0xFF66BB6A)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '镜像球', mirrorObj + const Offset(0, -14),
        const Color(0xFF66BB6A), 9);

    // Dashed symmetry line between real ball and mirror ball
    _drawDashed(canvas, obj, mirrorObj,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.3)..strokeWidth = 1);

    // Aiming reference: targetPocket → mirrorObj
    _drawDashed(canvas, targetPocket, mirrorObj,
        Paint()..color = const Color(0xAAFFEB3B)..strokeWidth = 1.5);

    // Actual ball path
    canvas.drawLine(obj, railContact,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.8)..strokeWidth = 2.5);
    canvas.drawLine(railContact, targetPocket,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.8)..strokeWidth = 2.5);

    // Rail contact point
    canvas.drawCircle(railContact, 5, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(railContact, 5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '瞄准点', railContact + const Offset(0, 14),
        const Color(0xFFFF5722), 10, bold: true);
  }

  void _paintAngleArcs(Canvas canvas, double r, Offset railContact, Offset obj, Offset targetPocket) {
    final inDir = obj - railContact;
    final inNorm = inDir.distance > 0 ? inDir / inDir.distance : Offset.zero;
    final outDir = targetPocket - railContact;
    final outNorm = outDir.distance > 0 ? outDir / outDir.distance : Offset.zero;

    final incidentAngle = math.acos(inNorm.dy.abs().clamp(0.0, 1.0)) * 180 / math.pi;
    final reflectedAngle = math.acos(outNorm.dy.abs().clamp(0.0, 1.0)) * 180 / math.pi;

    final arcR = r * 3;
    _drawDashed(canvas, railContact, railContact + Offset(0, arcR * 1.8),
        Paint()..color = Colors.white38..strokeWidth = 1);

    final normalStartAngle = math.pi / 2;
    final inAngle = math.atan2(inNorm.dy, inNorm.dx);
    var inSweep = inAngle - normalStartAngle;
    if (inSweep > math.pi) inSweep -= 2 * math.pi;
    if (inSweep < -math.pi) inSweep += 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: railContact, radius: arcR),
      normalStartAngle, inSweep, false,
      Paint()..color = const Color(0xFFFF9800)..style = PaintingStyle.stroke..strokeWidth = 2,
    );

    final outAngle = math.atan2(outNorm.dy, outNorm.dx);
    var outSweep = outAngle - normalStartAngle;
    if (outSweep > math.pi) outSweep -= 2 * math.pi;
    if (outSweep < -math.pi) outSweep += 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: railContact, radius: arcR * 0.75),
      normalStartAngle, outSweep, false,
      Paint()..color = const Color(0xFFFF9800)..style = PaintingStyle.stroke..strokeWidth = 2,
    );

    _drawLabel(canvas, '${incidentAngle.toStringAsFixed(0)}°',
        railContact + Offset(inNorm.dx * arcR * 1.8, arcR * 1.2), const Color(0xFFFF9800), 11, bold: true);
    _drawLabel(canvas, '${reflectedAngle.toStringAsFixed(0)}°',
        railContact + Offset(outNorm.dx * arcR * 1.8, arcR * 1.2), const Color(0xFFFF9800), 11, bold: true);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_BankMirrorPainter old) =>
      old.ballDistRatio != ballDistRatio ||
      old.bankAngleDeg != bankAngleDeg ||
      old.mirrorBall != mirrorBall;
}

// ---------------------------------------------------------------------------
// Bank Shot: 1/3-more-than-twice Compensation Lab
// ---------------------------------------------------------------------------
class _BankCompensationLab extends StatefulWidget {
  const _BankCompensationLab();

  @override
  State<_BankCompensationLab> createState() => _BankCompensationLabState();
}

class _BankCompensationLabState extends State<_BankCompensationLab> {
  double _ballDistFromRail = 0.3;
  double _bankAngle = 45;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('球离库距离',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballDistFromRail,
                min: 0.08,
                max: 0.7,
                divisions: 62,
                activeColor: const Color(0xFFAB47BC),
                onChanged: (v) => setState(() => _ballDistFromRail = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('翻袋角度',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _bankAngle,
                min: 15,
                max: 75,
                divisions: 60,
                label: '${_bankAngle.toStringAsFixed(0)}°',
                activeColor: const Color(0xFFAB47BC),
                onChanged: (v) => setState(() => _bankAngle = v),
              ),
            ),
            Text('${_bankAngle.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFFAB47BC),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _BankCompensationPainter(
              ballDistRatio: _ballDistFromRail,
              bankAngleDeg: _bankAngle,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFFAB47BC), label: '补偿后瞄准点（实际应打位置）'),
            _LegendItem(color: Color(0xFF42A5F5), label: '镜像法瞄准点（理论位置，偏短）'),
            _LegendItem(color: Color(0xFF66BB6A), label: '补偿后实际球路'),
            _LegendItem(color: Color(0xFFFF9800), label: '1/3 补偿距离标注'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEF5350).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEF5350).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是 1/3 超过两倍补偿？',
                  style: TextStyle(color: Color(0xFFEF5350), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '菱形系统的结果是近似值，当碰库角度大时需要补偿修正。\n\n'
                '补偿规则：\n'
                '当计算出的碰库点编号超过 2 倍（即角度较大），\n'
                '需要将超出 2 倍的部分乘以 1/3 来修正。\n\n'
                '例如：计算值 = 5，超过 2×2=4 的部分是 1，\n'
                '补偿 = 4 + 1×(1/3) = 4.33\n\n'
                '操作步骤：\n'
                '1. 先用菱形系统计算碰库点\n'
                '2. 如果结果超过 2 倍，应用 1/3 补偿\n'
                '3. 拖动滑杆观察补偿量的变化\n\n'
                '高角度翻袋时这个补偿非常重要。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFAB47BC).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFAB47BC).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1/3 超过两倍系统',
                  style: TextStyle(
                      color: Color(0xFFAB47BC), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '原理：实际台球库边有"吃球"效应（球陷入胶边再弹出），\n'
                '导致真实反射角 < 理论反射角（出射偏"短"）。\n\n'
                '补偿规则：\n'
                '• 先用镜像法算出理论瞄准点\n'
                '• 球到库边距离 × 2 = "两倍距离"\n'
                '• 再加上 1/3 菱形（diamond）距离的补偿\n'
                '• 最终瞄准点比镜像法偏远 1/3\n\n'
                '适用：中等力量击球。大力时补偿需更多，轻力时减少补偿。\n'
                '记忆口诀："1/3 多过两倍"',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bank Compensation Painter
// ---------------------------------------------------------------------------
class _BankCompensationPainter extends CustomPainter {
  _BankCompensationPainter({required this.ballDistRatio, required this.bankAngleDeg});

  final double ballDistRatio;
  final double bankAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.032;

    // Rail in upper-middle area
    final railY = h * 0.3;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 5);
    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));

    // Diamond markers on rail
    final diamondSpacing = w / 8;
    for (int i = 0; i <= 8; i++) {
      final dx = i * diamondSpacing;
      canvas.drawCircle(Offset(dx, railY - 3), 3,
          Paint()..color = Colors.white54);
    }

    // Object ball
    final ballDistFromRail = (h - railY) * ballDistRatio;
    final objY = railY + ballDistFromRail;
    final objX = w * 0.35;
    final obj = Offset(objX, objY);

    // Target pocket
    final targetPocketY = h * 0.88;
    final bankRad = bankAngleDeg * math.pi / 180;
    final targetPocketX = objX + (targetPocketY - railY) * math.tan(bankRad) * 0.5;
    final targetPocket = Offset(targetPocketX.clamp(w * 0.1, w * 0.9), targetPocketY);

    // Mirror method: ideal contact point
    final mirrorPocket = Offset(targetPocket.dx, 2 * railY - targetPocket.dy);
    final mirrorDir = mirrorPocket - obj;
    final tMirror = mirrorDir.dy != 0 ? (railY - obj.dy) / mirrorDir.dy : 0.0;
    final mirrorContactX = obj.dx + tMirror * mirrorDir.dx;
    final mirrorContact = Offset(mirrorContactX.clamp(r, w - r), railY);

    // 1/3 compensation: shift the aim point further along the rail
    // The compensation is 1/3 of the ball-to-rail distance measured in diamond units
    final compensation = diamondSpacing * 0.33 * (ballDistRatio / 0.3);
    // Direction: toward the target pocket side
    final compensationDir = (targetPocket.dx > obj.dx) ? 1.0 : -1.0;
    final compensatedContact = Offset(
      (mirrorContact.dx + compensationDir * compensation).clamp(r, w - r),
      railY,
    );

    // ---- Mirror contact point (faint) ----
    canvas.drawCircle(mirrorContact, 4,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.5));
    canvas.drawCircle(mirrorContact, 4,
        Paint()..color = const Color(0xFF42A5F5)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '镜像点', mirrorContact + const Offset(0, 16),
        const Color(0xFF42A5F5), 10);

    // Mirror aim line (faint dashed)
    _drawDashed(canvas, obj, mirrorContact,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.3)..strokeWidth = 1);
    _drawDashed(canvas, mirrorContact, targetPocket,
        Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.3)..strokeWidth = 1);

    // ---- Compensated contact point ----
    canvas.drawCircle(compensatedContact, 6, Paint()..color = const Color(0xFFAB47BC));
    canvas.drawCircle(compensatedContact, 6,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '补偿瞄准点', compensatedContact + const Offset(0, -14),
        const Color(0xFFAB47BC), 10, bold: true);

    // ---- Compensation distance arrow ----
    final arrowY = railY + 24;
    canvas.drawLine(Offset(mirrorContact.dx, arrowY), Offset(compensatedContact.dx, arrowY),
        Paint()..color = const Color(0xFFFF9800)..strokeWidth = 2);
    // Arrow heads
    final arrowDir = compensationDir;
    canvas.drawLine(
      Offset(compensatedContact.dx, arrowY),
      Offset(compensatedContact.dx - arrowDir * 6, arrowY - 4),
      Paint()..color = const Color(0xFFFF9800)..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(compensatedContact.dx, arrowY),
      Offset(compensatedContact.dx - arrowDir * 6, arrowY + 4),
      Paint()..color = const Color(0xFFFF9800)..strokeWidth = 2,
    );
    _drawLabel(canvas, '+1/3', Offset((mirrorContact.dx + compensatedContact.dx) / 2, arrowY + 12),
        const Color(0xFFFF9800), 10, bold: true);

    // ---- Actual ball path with compensation (green) ----
    canvas.drawLine(obj, compensatedContact,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);
    canvas.drawLine(compensatedContact, targetPocket,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);

    // ---- Object ball ----
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', obj + Offset(r + 10, 4), const Color(0xFFFFEB3B), 10);

    // ---- Target pocket ----
    canvas.drawCircle(targetPocket, r * 1.5, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(targetPocket, r * 1.5,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '目标袋', targetPocket + const Offset(0, -16), Colors.white70, 10);

    // ---- Angle comparison ----
    // Incident angle at compensated point
    final inDir = obj - compensatedContact;
    final inNorm = inDir.distance > 0 ? inDir / inDir.distance : Offset.zero;
    final incidentAngle = math.acos(inNorm.dy.abs().clamp(0.0, 1.0)) * 180 / math.pi;

    final outDir = targetPocket - compensatedContact;
    final outNorm2 = outDir.distance > 0 ? outDir / outDir.distance : Offset.zero;
    final reflectedAngle = math.acos(outNorm2.dy.abs().clamp(0.0, 1.0)) * 180 / math.pi;

    _drawLabel(canvas, '入射 ${incidentAngle.toStringAsFixed(0)}°',
        Offset(w * 0.08, h * 0.4), Colors.white54, 10);
    _drawLabel(canvas, '反射 ${reflectedAngle.toStringAsFixed(0)}°',
        Offset(w * 0.92, h * 0.4), Colors.white54, 10);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_BankCompensationPainter old) =>
      old.ballDistRatio != ballDistRatio || old.bankAngleDeg != bankAngleDeg;
}

// ---------------------------------------------------------------------------
// Bank Shot: Diamond System Lab
// ---------------------------------------------------------------------------
class _BankDiamondLab extends StatefulWidget {
  const _BankDiamondLab();

  @override
  State<_BankDiamondLab> createState() => _BankDiamondLabState();
}

class _BankDiamondLabState extends State<_BankDiamondLab> {
  double _startDiamond = 3;
  double _targetDiamond = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('目标球位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _startDiamond,
                min: 1,
                max: 7,
                divisions: 12,
                label: _startDiamond.toStringAsFixed(1),
                activeColor: const Color(0xFF66BB6A),
                onChanged: (v) => setState(() => _startDiamond = v),
              ),
            ),
            Text('#${_startDiamond.toStringAsFixed(1)}',
                style: const TextStyle(color: Color(0xFF66BB6A), fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            const Text('目标袋位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _targetDiamond,
                min: 1,
                max: 8,
                divisions: 14,
                label: _targetDiamond.toStringAsFixed(1),
                activeColor: const Color(0xFFFF5722),
                onChanged: (v) => setState(() => _targetDiamond = v),
              ),
            ),
            Text('#${_targetDiamond.toStringAsFixed(1)}',
                style: const TextStyle(color: Color(0xFFFF5722), fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CustomPaint(
            painter: _BankDiamondPainter(
              startDiamond: _startDiamond,
              targetDiamond: _targetDiamond,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildCalculation(),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是菱形系统？',
                  style: TextStyle(color: Color(0xFFFF9800), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '菱形系统是利用球台边框上的标记点（菱形/圆点）来计算翻袋路线。\n\n'
                '核心公式：出发点编号 - 目标袋编号 = 碰库点编号\n\n'
                '操作步骤：\n'
                '1. 找到白球对应的边框编号（出发点）\n'
                '2. 找到目标袋口对应的边框编号\n'
                '3. 用公式计算碰库点编号\n'
                '4. 白球瞄准碰库点出杆\n\n'
                '拖动滑杆改变参数，观察菱形编号和计算结果。\n'
                '注意：菱形系统是近似方法，实际需要根据力度和塞度微调。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('菱形系统说明',
                  style: TextStyle(
                      color: Color(0xFF66BB6A), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '原理：球桌边的菱形标记将库边等分为若干段。\n'
                '利用这些标记作为固定参照物，通过简单的加减法\n'
                '计算出库边上的瞄准位置。\n\n'
                '最简方法：\n'
                '1. 确定目标球最近的菱形编号（起始编号）\n'
                '2. 确定目标袋口对应的菱形编号（目标编号）\n'
                '3. 瞄准编号 = (起始 + 目标) ÷ 2\n'
                '   即两点中间的位置！\n\n'
                '球从起始点打向"中间点"后，会反弹到目标位置。\n'
                '这就是最直觉的"连线看终点"方法。',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalculation() {
    final aimPoint = (_startDiamond + _targetDiamond) / 2;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9800).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('#${_startDiamond.toStringAsFixed(1)}',
              style: const TextStyle(color: Color(0xFF66BB6A), fontSize: 16, fontWeight: FontWeight.bold)),
          const Text(' + ', style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text('#${_targetDiamond.toStringAsFixed(1)}',
              style: const TextStyle(color: Color(0xFFFF5722), fontSize: 16, fontWeight: FontWeight.bold)),
          const Text(' ) ÷ 2 = ', style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text('瞄准 #${aimPoint.toStringAsFixed(1)}',
              style: const TextStyle(color: Color(0xFFFF9800), fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Diamond System Painter
// ---------------------------------------------------------------------------
class _BankDiamondPainter extends CustomPainter {
  _BankDiamondPainter({required this.startDiamond, required this.targetDiamond});

  final double startDiamond;
  final double targetDiamond;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.035;

    // Draw table outline
    final tableRect = Rect.fromLTRB(w * 0.05, h * 0.08, w * 0.95, h * 0.92);
    final tablePaint = Paint()
      ..color = const Color(0xFF1B5E20).withValues(alpha: 0.4);
    canvas.drawRect(tableRect, tablePaint);

    // Rails
    final railPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawRect(tableRect, railPaint);

    // Diamond markers on top rail (1-8, left to right)
    final topRailY = tableRect.top;
    final botRailY = tableRect.bottom;
    final leftRailX = tableRect.left;
    final rightRailX = tableRect.right;
    final diamondSpacingX = (rightRailX - leftRailX) / 8;
    final diamondSpacingY = (botRailY - topRailY) / 4;

    // Top rail diamonds (numbered 1-8)
    for (int i = 0; i <= 8; i++) {
      final x = leftRailX + i * diamondSpacingX;
      canvas.drawCircle(Offset(x, topRailY), 4, Paint()..color = Colors.white38);
      _drawLabel(canvas, '$i', Offset(x, topRailY - 12), Colors.white54, 10);
    }
    // Bottom rail diamonds
    for (int i = 0; i <= 8; i++) {
      final x = leftRailX + i * diamondSpacingX;
      canvas.drawCircle(Offset(x, botRailY), 4, Paint()..color = Colors.white38);
      _drawLabel(canvas, '$i', Offset(x, botRailY + 12), Colors.white54, 10);
    }
    // Left rail diamonds
    for (int i = 0; i <= 4; i++) {
      final y = topRailY + i * diamondSpacingY;
      canvas.drawCircle(Offset(leftRailX, y), 4, Paint()..color = Colors.white38);
    }
    // Right rail diamonds
    for (int i = 0; i <= 4; i++) {
      final y = topRailY + i * diamondSpacingY;
      canvas.drawCircle(Offset(rightRailX, y), 4, Paint()..color = Colors.white38);
    }

    // Object ball position (on bottom rail line, at startDiamond)
    final ballX = leftRailX + startDiamond * diamondSpacingX;
    final ballY = botRailY - r * 3;
    final ball = Offset(ballX, ballY);

    // Target position (on bottom rail, at targetDiamond)
    final targetX = leftRailX + targetDiamond * diamondSpacingX;
    final target = Offset(targetX, botRailY);

    // Aim point on top rail (midpoint calculation)
    final aimDiamond = (startDiamond + targetDiamond) / 2;
    final aimX = leftRailX + aimDiamond * diamondSpacingX;
    final aimPoint = Offset(aimX, topRailY);

    // ---- Draw ball path: ball → aimPoint → target ----
    canvas.drawLine(ball, aimPoint,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);
    canvas.drawLine(aimPoint, target,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);

    // ---- Highlight aim point on top rail ----
    canvas.drawCircle(aimPoint, 7, Paint()..color = const Color(0xFFFF9800));
    canvas.drawCircle(aimPoint, 7,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '瞄准 #${aimDiamond.toStringAsFixed(1)}',
        aimPoint + const Offset(0, 18), const Color(0xFFFF9800), 11, bold: true);

    // ---- Object ball ----
    canvas.drawCircle(ball, r * 1.3, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(ball, r * 1.3,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '#${startDiamond.toStringAsFixed(1)}',
        ball + Offset(0, -r * 2.5), const Color(0xFF66BB6A), 11, bold: true);

    // ---- Target pocket/position ----
    canvas.drawCircle(target, r * 1.5, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(target, r * 1.5,
        Paint()..color = const Color(0xFFFF5722)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    _drawLabel(canvas, '#${targetDiamond.toStringAsFixed(1)}',
        target + const Offset(0, -16), const Color(0xFFFF5722), 11, bold: true);

    // ---- Angle arcs at aim point ----
    final inDir = ball - aimPoint;
    final inNorm = inDir.distance > 0 ? inDir / inDir.distance : Offset.zero;
    final outDir = target - aimPoint;
    final outNorm = outDir.distance > 0 ? outDir / outDir.distance : Offset.zero;

    final arcR = r * 3;
    final normalAng = math.pi / 2; // normal points down into table
    final inAng = math.atan2(inNorm.dy, inNorm.dx);
    var inSweep = inAng - normalAng;
    if (inSweep > math.pi) inSweep -= 2 * math.pi;
    if (inSweep < -math.pi) inSweep += 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: aimPoint, radius: arcR),
      normalAng, inSweep, false,
      Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.7)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    final outAng = math.atan2(outNorm.dy, outNorm.dx);
    var outSweep = outAng - normalAng;
    if (outSweep > math.pi) outSweep -= 2 * math.pi;
    if (outSweep < -math.pi) outSweep += 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: aimPoint, radius: arcR * 0.7),
      normalAng, outSweep, false,
      Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.7)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_BankDiamondPainter old) =>
      old.startDiamond != startDiamond || old.targetDiamond != targetDiamond;
}

// ---------------------------------------------------------------------------
// Bank Shot: Equal Distance Method (等距法)
// ---------------------------------------------------------------------------
class _BankEqualDistLab extends StatefulWidget {
  const _BankEqualDistLab();

  @override
  State<_BankEqualDistLab> createState() => _BankEqualDistLabState();
}

class _BankEqualDistLabState extends State<_BankEqualDistLab> {
  double _ballDistFromRail = 0.35;
  double _ballXPosition = 0.4;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('离库距离',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballDistFromRail,
                min: 0.1,
                max: 0.6,
                divisions: 50,
                activeColor: const Color(0xFF00BCD4),
                onChanged: (v) => setState(() => _ballDistFromRail = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('水平位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballXPosition,
                min: 0.15,
                max: 0.7,
                divisions: 55,
                activeColor: const Color(0xFF00BCD4),
                onChanged: (v) => setState(() => _ballXPosition = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _BankEqualDistPainter(
              ballDistRatio: _ballDistFromRail,
              ballXRatio: _ballXPosition,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFF00BCD4), label: '距离 d（球到库边 = 库边到镜像点）'),
            _LegendItem(color: Color(0xFFFF5722), label: '镜像点（库边另一侧等距位置）'),
            _LegendItem(color: Color(0xFFFFEB3B), label: '镜像点→目标袋连线（确定瞄准点）'),
            _LegendItem(color: Color(0xFF66BB6A), label: '实际球路'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是等距法？',
                  style: TextStyle(color: Color(0xFF66BB6A), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '等距法是一种简单的翻袋估算方法。\n'
                '核心：目标球到库边的距离 = 白球碰库点到库边垂足的距离。\n\n'
                '操作步骤：\n'
                '1. 量（目测）目标球到库边的垂直距离\n'
                '2. 在库边上找到一个点，使白球到该点的距离等于目标球的距离\n'
                '3. 这个点就是白球的碰库点\n\n'
                '拖动滑杆观察等距关系的变化。适合快速估算翻袋路线。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF00BCD4).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('等距法说明',
                  style: TextStyle(
                      color: Color(0xFF00BCD4), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '最直观的翻袋瞄准法，3步完成：\n\n'
                '1. 量出目标球到库边的距离 d\n'
                '2. 在库边的另一侧，量出相同距离 d\n'
                '   → 得到"镜像点"\n'
                '3. 连接"镜像点"和"目标袋口"\n'
                '   → 连线与库边的交点 = 瞄准点\n\n'
                '本质：就是镜像法的最简化操作版本。\n'
                '不需要想象整个袋口的镜像，只需要\n'
                '量一个距离、画一条线。\n\n'
                '技巧：可以用球杆量距离（1杆≈1.5m），\n'
                '或者用身体感觉估算。',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Equal Distance Painter
// ---------------------------------------------------------------------------
class _BankEqualDistPainter extends CustomPainter {
  _BankEqualDistPainter({required this.ballDistRatio, required this.ballXRatio});

  final double ballDistRatio;
  final double ballXRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.03;

    // Rail in the middle
    final railY = h * 0.5;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 5);

    // Table area below rail
    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));
    // Above rail (lighter)
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.1));

    // Object ball below rail
    final distFromRail = (h - railY) * ballDistRatio;
    final ballX = w * ballXRatio;
    final ballY = railY + distFromRail;
    final ball = Offset(ballX, ballY);

    // Mirror point above rail (equal distance)
    final mirrorY = railY - distFromRail;
    final mirrorPoint = Offset(ballX, mirrorY);

    // Target pocket (bottom-right corner)
    final targetPocket = Offset(w * 0.88, h * 0.92);

    // Line from mirror point to target pocket → intersection with rail = aim point
    final mpToTarget = targetPocket - mirrorPoint;
    final tAim = mpToTarget.dy != 0 ? (railY - mirrorPoint.dy) / mpToTarget.dy : 0.0;
    final aimX = mirrorPoint.dx + tAim * mpToTarget.dx;
    final aimPoint = Offset(aimX.clamp(r, w - r), railY);

    // ---- Draw distance indicators (d) ----
    // Below rail: ball to rail
    final distIndicatorX = ballX - r * 4;
    canvas.drawLine(Offset(distIndicatorX, railY), Offset(distIndicatorX, ballY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    // Arrows
    canvas.drawLine(Offset(distIndicatorX - 3, railY + 5), Offset(distIndicatorX, railY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    canvas.drawLine(Offset(distIndicatorX + 3, railY + 5), Offset(distIndicatorX, railY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    canvas.drawLine(Offset(distIndicatorX - 3, ballY - 5), Offset(distIndicatorX, ballY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    canvas.drawLine(Offset(distIndicatorX + 3, ballY - 5), Offset(distIndicatorX, ballY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    _drawLabel(canvas, 'd', Offset(distIndicatorX - 10, (railY + ballY) / 2),
        const Color(0xFF00BCD4), 12, bold: true);

    // Above rail: rail to mirror
    canvas.drawLine(Offset(distIndicatorX, mirrorY), Offset(distIndicatorX, railY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    canvas.drawLine(Offset(distIndicatorX - 3, mirrorY + 5), Offset(distIndicatorX, mirrorY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    canvas.drawLine(Offset(distIndicatorX + 3, mirrorY + 5), Offset(distIndicatorX, mirrorY),
        Paint()..color = const Color(0xFF00BCD4)..strokeWidth = 1.5);
    _drawLabel(canvas, 'd', Offset(distIndicatorX - 10, (railY + mirrorY) / 2),
        const Color(0xFF00BCD4), 12, bold: true);

    // ---- Mirror point ----
    canvas.drawCircle(mirrorPoint, 5, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(mirrorPoint, 5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '镜像点', mirrorPoint + const Offset(14, 0),
        const Color(0xFFFF5722), 10, bold: true);

    // ---- Mirror point to target pocket line (yellow dashed) ----
    _drawDashed(canvas, mirrorPoint, targetPocket,
        Paint()..color = const Color(0xAAFFEB3B)..strokeWidth = 1.5);

    // ---- Aim point on rail ----
    canvas.drawCircle(aimPoint, 6, Paint()..color = const Color(0xFFFF9800));
    canvas.drawCircle(aimPoint, 6,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '瞄准点', aimPoint + const Offset(0, 14),
        const Color(0xFFFF9800), 10, bold: true);

    // ---- Actual ball path (green) ----
    canvas.drawLine(ball, aimPoint,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);
    canvas.drawLine(aimPoint, targetPocket,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);

    // ---- Object ball ----
    canvas.drawCircle(ball, r * 1.2, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(ball, r * 1.2,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', ball + Offset(r * 2, 0), const Color(0xFFFFEB3B), 10);

    // ---- Target pocket ----
    canvas.drawCircle(targetPocket, r * 1.5, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(targetPocket, r * 1.5,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '目标袋', targetPocket + const Offset(-16, -14), Colors.white70, 10);

    // ---- Vertical dashed line from ball to mirror (shows symmetry) ----
    _drawDashed(canvas, ball, mirrorPoint,
        Paint()..color = Colors.white24..strokeWidth = 1);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_BankEqualDistPainter old) =>
      old.ballDistRatio != ballDistRatio || old.ballXRatio != ballXRatio;
}

// ---------------------------------------------------------------------------
// Bank Shot: Parallel Shift Method (平行位移法)
// ---------------------------------------------------------------------------
class _BankParallelShiftLab extends StatefulWidget {
  const _BankParallelShiftLab();

  @override
  State<_BankParallelShiftLab> createState() => _BankParallelShiftLabState();
}

class _BankParallelShiftLabState extends State<_BankParallelShiftLab> {
  double _ballDistFromRail = 0.35;
  double _ballXPosition = 0.35;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('离库距离',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballDistFromRail,
                min: 0.1,
                max: 0.6,
                divisions: 50,
                activeColor: const Color(0xFFAB47BC),
                onChanged: (v) => setState(() => _ballDistFromRail = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('水平位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballXPosition,
                min: 0.15,
                max: 0.65,
                divisions: 50,
                activeColor: const Color(0xFFAB47BC),
                onChanged: (v) => setState(() => _ballXPosition = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _BankParallelShiftPainter(
              ballDistRatio: _ballDistFromRail,
              ballXRatio: _ballXPosition,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFFAB47BC), label: '平移后的虚拟球（贴在库边上）'),
            _LegendItem(color: Color(0xFFFFEB3B), label: '虚拟球→袋口方向（确定反射角）'),
            _LegendItem(color: Color(0xFF66BB6A), label: '实际球路（保持同样角度）'),
            _LegendItem(color: Color(0xFFFF5722), label: '库边瞄准点'),
            _LegendItem(color: Color(0xFFFF9800), label: '入射角 = 反射角'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFAB47BC).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFAB47BC).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是平行位移法？',
                  style: TextStyle(color: Color(0xFFAB47BC), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '平行位移法利用几何平移来确定翻袋路线。\n\n'
                '操作步骤：\n'
                '1. 画出目标球→袋口的直线\n'
                '2. 将这条线平行移动到白球位置\n'
                '3. 平行线与库边的交点就是碰库点\n'
                '4. 白球经过碰库点反弹后会到达目标球→袋口连线上\n\n'
                '拖动滑杆调节位置，观察平行线的位移效果。\n'
                '优势：直观、容易在实战中目测。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFAB47BC).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFAB47BC).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('平行位移法说明',
                  style: TextStyle(
                      color: Color(0xFFAB47BC), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '思路：把球"推"到库边上，直接看出反射角度。\n\n'
                '步骤：\n'
                '1. 想象目标球沿垂直方向平移到库边上\n'
                '2. 从这个虚拟位置看向目标袋口\n'
                '3. 记住这个角度（反射角）\n'
                '4. 回到球的真实位置，以同样角度\n'
                '   打向库边 → 反弹后自然入袋\n\n'
                '优势：\n'
                '• 不需要在库边另一侧想象任何东西\n'
                '• 所有参考点都在球台面上可见\n'
                '• 球离库近时几乎不需要想象\n\n'
                '本质：与镜像法等价，但用"平移+角度保持"\n'
                '替代了"镜像+连线"的思路。',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Parallel Shift Painter
// ---------------------------------------------------------------------------
class _BankParallelShiftPainter extends CustomPainter {
  _BankParallelShiftPainter({required this.ballDistRatio, required this.ballXRatio});

  final double ballDistRatio;
  final double ballXRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.03;

    final railY = h * 0.4;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 5);

    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.1));

    // Object ball below rail
    final distFromRail = (h - railY) * ballDistRatio;
    final ballX = w * ballXRatio;
    final ballY = railY + distFromRail;
    final ball = Offset(ballX, ballY);

    // Virtual ball "shifted" to the rail
    final shiftedBall = Offset(ballX, railY);

    // Target pocket (bottom-right)
    final targetPocket = Offset(w * 0.88, h * 0.92);

    // The key insight: if the ball were ON the rail, the angle to the pocket
    // gives us the reflection angle. The real aim point uses this same angle.
    // Reflection angle from shiftedBall to pocket
    final shiftedToPocket = targetPocket - shiftedBall;
    final reflectAngle = math.atan2(shiftedToPocket.dy, shiftedToPocket.dx);

    // Mirror the angle about the rail normal to get the incidence direction
    // If reflectAngle is the outgoing angle (going down-right from rail),
    // the incoming angle is mirrored: same horizontal component, negated vertical
    final incomingDx = math.cos(reflectAngle);
    final incomingDy = -math.sin(reflectAngle);

    // Find where the incoming ray from the ball hits the rail
    // ball + t * (incomingDx, incomingDy) → y = railY
    // incomingDy should be negative (going up toward rail) when ball is below
    final tHit = incomingDy != 0 ? (railY - ballY) / incomingDy : 0.0;
    final aimX = ballX + tHit * incomingDx;
    final aimPoint = Offset(aimX.clamp(r, w - r), railY);

    // ---- Shift arrow: ball → shiftedBall (vertical, purple dashed) ----
    _drawDashed(canvas, ball, shiftedBall,
        Paint()..color = const Color(0xFFAB47BC).withValues(alpha: 0.6)..strokeWidth = 1.5);
    // Arrow head
    canvas.drawLine(
        shiftedBall + const Offset(-4, 6), shiftedBall,
        Paint()..color = const Color(0xFFAB47BC)..strokeWidth = 1.5);
    canvas.drawLine(
        shiftedBall + const Offset(4, 6), shiftedBall,
        Paint()..color = const Color(0xFFAB47BC)..strokeWidth = 1.5);

    // ---- Shifted ball (virtual, on rail) ----
    canvas.drawCircle(shiftedBall, r * 0.8,
        Paint()..color = const Color(0xFFAB47BC).withValues(alpha: 0.3));
    canvas.drawCircle(shiftedBall, r * 0.8,
        Paint()..color = const Color(0xFFAB47BC)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '虚拟球', shiftedBall + const Offset(0, -14),
        const Color(0xFFAB47BC), 9);

    // ---- Reference line: shiftedBall → pocket (yellow dashed) ----
    _drawDashed(canvas, shiftedBall, targetPocket,
        Paint()..color = const Color(0xAAFFEB3B)..strokeWidth = 1.5);

    // ---- Actual ball path (green solid) ----
    canvas.drawLine(ball, aimPoint,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);
    canvas.drawLine(aimPoint, targetPocket,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)..strokeWidth = 2.5);

    // ---- Aim point ----
    canvas.drawCircle(aimPoint, 5, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(aimPoint, 5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '瞄准点', aimPoint + const Offset(0, 14),
        const Color(0xFFFF5722), 10, bold: true);

    // ---- Angle arcs ----
    final inDir = ball - aimPoint;
    final inNorm = inDir.distance > 0 ? inDir / inDir.distance : Offset.zero;
    final outDir = targetPocket - aimPoint;
    final outNorm = outDir.distance > 0 ? outDir / outDir.distance : Offset.zero;

    final arcR = r * 3;
    _drawDashed(canvas, aimPoint, aimPoint + Offset(0, arcR * 1.8),
        Paint()..color = Colors.white38..strokeWidth = 1);

    final normalStartAngle = math.pi / 2;
    final inAngle = math.atan2(inNorm.dy, inNorm.dx);
    var inSweep = inAngle - normalStartAngle;
    if (inSweep > math.pi) inSweep -= 2 * math.pi;
    if (inSweep < -math.pi) inSweep += 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: aimPoint, radius: arcR),
      normalStartAngle, inSweep, false,
      Paint()..color = const Color(0xFFFF9800)..style = PaintingStyle.stroke..strokeWidth = 2,
    );

    final outAngle = math.atan2(outNorm.dy, outNorm.dx);
    var outSweep = outAngle - normalStartAngle;
    if (outSweep > math.pi) outSweep -= 2 * math.pi;
    if (outSweep < -math.pi) outSweep += 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: aimPoint, radius: arcR * 0.75),
      normalStartAngle, outSweep, false,
      Paint()..color = const Color(0xFFFF9800)..style = PaintingStyle.stroke..strokeWidth = 2,
    );

    final incidentAngle = math.acos(inNorm.dy.abs().clamp(0.0, 1.0)) * 180 / math.pi;
    final reflectedAngle2 = math.acos(outNorm.dy.abs().clamp(0.0, 1.0)) * 180 / math.pi;
    _drawLabel(canvas, '${incidentAngle.toStringAsFixed(0)}°',
        aimPoint + Offset(inNorm.dx * arcR * 1.8, arcR * 1.2), const Color(0xFFFF9800), 11, bold: true);
    _drawLabel(canvas, '${reflectedAngle2.toStringAsFixed(0)}°',
        aimPoint + Offset(outNorm.dx * arcR * 1.8, arcR * 1.2), const Color(0xFFFF9800), 11, bold: true);

    // ---- Object ball ----
    canvas.drawCircle(ball, r * 1.2, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(ball, r * 1.2,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', ball + Offset(r * 2, 0), const Color(0xFFFFEB3B), 10);

    // ---- Cue ball (fixed position, bottom-left of object ball) ----
    final cue = Offset(w * 0.12, h * 0.78);
    canvas.drawCircle(cue, r * 1.2, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r * 1.2,
        Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, '白球', cue + Offset(0, r * 2 + 4), Colors.white70, 10);
    _drawDashed(canvas, cue, ball,
        Paint()..color = Colors.white38..strokeWidth = 1.2);

    // ---- Target pocket ----
    canvas.drawCircle(targetPocket, r * 1.5, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(targetPocket, r * 1.5,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '目标袋', targetPocket + const Offset(-16, -14), Colors.white70, 10);

    _drawLabel(canvas, '距库 ${(ballDistRatio * 100).toStringAsFixed(0)}%',
        ball + Offset(-r * 5, 0), Colors.white38, 9);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_BankParallelShiftPainter old) =>
      old.ballDistRatio != ballDistRatio || old.ballXRatio != ballXRatio;
}

// ---------------------------------------------------------------------------
// Bank Shot: Overview (总览)
// ---------------------------------------------------------------------------
class _BankOverviewLab extends StatelessWidget {
  const _BankOverviewLab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section('一、翻袋类型', const [
          _OverviewRow('一库翻袋', '碰一次库进袋', '★★'),
          _OverviewRow('两库翻袋', '碰两次库，路径与出发平行', '★★★'),
          _OverviewRow('三库翻袋', '碰三次库（斯诺克常用）', '★★★★'),
          _OverviewRow('K球 Kick', '白球碰库后击中目标球', '★★★'),
        ]),
        const SizedBox(height: 12),
        _section('二、6种瞄准方法', const [
          _OverviewRow('① 镜像法', '入射角=反射角，袋口做对称', '基础'),
          _OverviewRow('② 等距法', '量距离 d，找镜像点连线', '最直观'),
          _OverviewRow('③ 菱形系统', '(起始+目标)÷2=瞄准位置', '最系统'),
          _OverviewRow('④ 1/3补偿', '镜像法+1/3库边补偿', '最准确'),
          _OverviewRow('⑤ 投影镜像', '从白球视角投影碰库位置', '职业变体'),
          _OverviewRow('⑥ 三库系统', '起始数-瞄准数=到达数', '斯诺克'),
        ]),
        const SizedBox(height: 12),
        _comparisonTable(),
        const SizedBox(height: 12),
        _proTips(),
        const SizedBox(height: 12),
        _factors(),
      ],
    );
  }

  Widget _section(String title, List<_OverviewRow> rows) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...rows.map((r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(width: 90, child: Text(r.name, style: const TextStyle(color: Color(0xFF66BB6A), fontSize: 11))),
                Expanded(child: Text(r.desc, style: const TextStyle(color: Colors.white70, fontSize: 11))),
                Text(r.tag, style: const TextStyle(color: Color(0xFFFF9800), fontSize: 10)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _comparisonTable() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9800).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('三、最常用 / 最准确 / 职业用',
              style: TextStyle(color: Color(0xFFFF9800), fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            '中式八球：常用 镜像法+等距法 | 准确 1/3补偿 | 职业 1/3补偿+经验\n'
            '九球/十球：常用 菱形系统 | 准确 1/3补偿 | 职业 菱形+1/3补偿\n'
            '斯诺克  ：常用 三库系统 | 准确 三库系统 | 职业 三库+感觉',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.8),
          ),
        ],
      ),
    );
  }

  Widget _proTips() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFAB47BC).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFAB47BC).withValues(alpha: 0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('四、职业选手真实做法',
              style: TextStyle(color: Color(0xFFAB47BC), fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(
            '1. 基础：镜像法/等距法作为心理模型\n'
            '2. 精确：用 1/3 补偿系统修正库边效应\n'
            '3. 辅助：菱形系统做快速验证\n'
            '4. 最终：大量重复练习 → 肌肉记忆 + 感觉微调\n\n'
            '"感觉"不是玄学——是对力量、塞、台面、胶边状态的\n'
            '综合经验判断。职业赛前会专门测试库边反弹特性。',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _factors() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF42A5F5).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF42A5F5).withValues(alpha: 0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('五、影响翻袋准确度的因素',
              style: TextStyle(color: Color(0xFF42A5F5), fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(
            '• 力量：大力→出射角变小（库边吃球），小力→接近理想反射\n'
            '• 旋转：白球的塞传递给目标球，改变反射角\n'
            '• 球台：胶边老化/温度/湿度影响反弹\n'
            '• 球面：脏球摩擦力不同\n'
            '• 衰减：远距离翻袋精度明显下降',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _OverviewRow {
  const _OverviewRow(this.name, this.desc, this.tag);
  final String name;
  final String desc;
  final String tag;
}

// ===========================================================================
// Cushion Ball Hub (库边球瞄准法 — Tab container)
// ===========================================================================
class _CushionBallHub extends StatefulWidget {
  const _CushionBallHub();

  @override
  State<_CushionBallHub> createState() => _CushionBallHubState();
}

class _CushionBallHubState extends State<_CushionBallHub> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  static const _tabs = ['薄切法', '挤库法', '平行瞄准法'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          indicatorColor: const Color(0xFF26C6DA),
          labelColor: const Color(0xFF26C6DA),
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: const [
              _CushionDirectCutLab(),
              SingleChildScrollView(child: _CushionFirstLab()),
              SingleChildScrollView(child: _ParallelAimLab()),
            ],
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// Cushion Ball: Direct Cut (薄切法)
// ===========================================================================
class _CushionDirectCutLab extends StatefulWidget {
  const _CushionDirectCutLab();

  @override
  State<_CushionDirectCutLab> createState() => _CushionDirectCutLabState();
}

class _CushionDirectCutLabState extends State<_CushionDirectCutLab> {
  double _ballXPosition = 0.45;
  double _gapFromRail = 0.0; // 0 = flush, up to ~1 ball diameter away
  double _cutAngle = 30; // degrees

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Text('球沿库位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballXPosition,
                min: 0.15,
                max: 0.85,
                divisions: 70,
                activeColor: const Color(0xFF26C6DA),
                onChanged: (v) => setState(() => _ballXPosition = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('离库距离',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _gapFromRail,
                min: 0,
                max: 1.0,
                divisions: 50,
                activeColor: const Color(0xFF26C6DA),
                onChanged: (v) => setState(() => _gapFromRail = v),
              ),
            ),
            Text(_gapFromRail < 0.05 ? '贴库' : '${(_gapFromRail * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: Color(0xFF26C6DA), fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            const Text('切球角度',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _cutAngle,
                min: 5,
                max: 70,
                divisions: 65,
                activeColor: const Color(0xFF26C6DA),
                onChanged: (v) => setState(() => _cutAngle = v),
              ),
            ),
            Text('${_cutAngle.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFF26C6DA), fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _CushionBallAimingPainter(
              ballXRatio: _ballXPosition,
              gapRatio: _gapFromRail,
              cutAngleDeg: _cutAngle,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFFFFEB3B), label: '目标球'),
            _LegendItem(color: Colors.white70, label: '白球'),
            _LegendItem(color: Color(0xFF26C6DA), label: '进球线（球→袋口）'),
            _LegendItem(color: Color(0xFFFF5722), label: '瞄准接触点'),
            _LegendItem(color: Color(0xFF66BB6A), label: '白球击球方向'),
            _LegendItem(color: Color(0xFFFF9800), label: '库边干涉区域'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF26C6DA).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF26C6DA).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是薄切法？',
                  style: TextStyle(color: Color(0xFF26C6DA), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '当目标球贴库或近库时，白球无法从正面全面接触目标球，'
                '只能击打球体露出库边的一小部分（"月牙区"）。'
                '薄切法就是利用小角度切球，只碰目标球表面的薄层，'
                '让目标球沿库边滚向袋口。\n\n'
                '操作步骤：\n'
                '1. 找到目标球→袋口连线（青色虚线）\n'
                '2. 沿连线反方向找到目标球背面的接触点（红色圆点）\n'
                '3. 白球瞄准接触点方向出杆\n'
                '4. 球越贴库，切角越要小（薄），否则碰不到球\n\n'
                '用下面的滑杆调节参数，观察白球路线和库边干涉区的变化。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF26C6DA).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF26C6DA).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('库边球瞄准要点',
                  style: TextStyle(
                      color: Color(0xFF26C6DA), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '贴库球（球紧贴库边）：\n'
                '• 白球无法从正面接触目标球中心下方\n'
                '• 只能打到目标球露出库边的"突出部分"\n'
                '• 切角越大，露出越少，越难进球\n'
                '• 大角度贴库球几乎不可能进球\n\n'
                '近库球（球离库 0.5-1 个球径）：\n'
                '• 白球可以打到的接触面积增大\n'
                '• 但库边仍限制白球接近路线\n'
                '• 需要注意白球是否会先碰库\n\n'
                '关键技巧：\n'
                '• 贴库球优先考虑薄切（小角度）\n'
                '• 大角度时放弃进球，做安全球\n'
                '• 拉杆可以避免白球撞库\n'
                '• 视觉上关注"库边露出的月牙形区域"',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Cushion Direct Cut Painter
// ---------------------------------------------------------------------------
class _CushionBallAimingPainter extends CustomPainter {
  _CushionBallAimingPainter({
    required this.ballXRatio,
    required this.gapRatio,
    required this.cutAngleDeg,
  });

  final double ballXRatio;
  final double gapRatio;
  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.04;

    // Rail at top
    final railY = h * 0.15;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 6);

    // Table surface
    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));
    // Above rail (cushion)
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF4E342E).withValues(alpha: 0.2));

    // Object ball position
    final gap = r * 2 * gapRatio; // 0 = flush against rail
    final objX = w * ballXRatio;
    final objY = railY + r + gap;
    final obj = Offset(objX, objY);

    // Target pocket (top-right corner)
    final pocket = Offset(w * 0.92, railY);

    // Ball-to-pocket direction (the ideal line)
    final ballToPocket = pocket - obj;
    final ballToPocketDist = ballToPocket.distance;
    final ballToPocketNorm = ballToPocketDist > 0 ? ballToPocket / ballToPocketDist : Offset.zero;

    // Contact point on the object ball surface (along the ball-to-pocket line, rear side)
    final contactPoint = obj - ballToPocketNorm * r;

    // Cue ball approach direction (at the given cut angle from the pocket line)
    // We want the cue ball to always be on the table side (below the rail)
    final cutRad = cutAngleDeg * math.pi / 180;
    final pocketAngle = math.atan2(ballToPocketNorm.dy, ballToPocketNorm.dx);
    final cueAngle = pocketAngle + math.pi + cutRad;
    final cueDir = Offset(math.cos(cueAngle), math.sin(cueAngle));

    // Cue ball position (along cue approach line, behind contact point)
    var cue = contactPoint + cueDir * (r * 7);
    // Clamp cue ball to stay on the table surface
    if (cue.dy < railY + r + 4) {
      cue = Offset(cue.dx, railY + r + 4);
    }
    if (cue.dy > h - r) {
      cue = Offset(cue.dx, h - r);
    }
    if (cue.dx < r) {
      cue = Offset(r, cue.dy);
    }
    if (cue.dx > w - r) {
      cue = Offset(w - r, cue.dy);
    }

    // Check if cue ball path would hit the rail before reaching the object ball
    // (rail interference zone)
    final cueToContact = contactPoint - cue;
    final cueToContactDist = cueToContact.distance;
    final cueToContactNorm = cueToContactDist > 0 ? cueToContact / cueToContactDist : Offset.zero;

    // Find closest point of cue ball path to the rail
    // Parametric: P(t) = cue + t * dir, find min distance to y=railY
    // The cue ball has radius r, so it interferes if path passes within r of rail
    final willHitRail = cue.dy - r < railY + 2 ||
        (cueToContactNorm.dy < 0 && (cue.dy - r * 2) < railY);

    // ---- Draw interference zone if applicable ----
    if (gapRatio < 0.3) {
      // Highlight the area where the rail blocks approach
      final interferenceRect = Rect.fromLTRB(
        objX - r * 3, railY, objX + r * 3, railY + r + gap,
      );
      canvas.drawRect(
        interferenceRect,
        Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.15),
      );
      canvas.drawRect(
        interferenceRect,
        Paint()
          ..color = const Color(0xFFFF9800).withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      _drawLabel(canvas, '库边干涉区',
          Offset(objX, railY + (r + gap) / 2), const Color(0xFFFF9800), 10);
    }

    // ---- Ball-to-pocket line (cyan dashed) ----
    _drawDashed(canvas, obj, pocket,
        Paint()..color = const Color(0xFF26C6DA).withValues(alpha: 0.7)..strokeWidth = 1.5);

    // ---- Cue ball approach line (green solid, to contact point) ----
    canvas.drawLine(cue, contactPoint,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.7)..strokeWidth = 2);

    // ---- Contact point ----
    canvas.drawCircle(contactPoint, 4, Paint()..color = const Color(0xFFFF5722));
    canvas.drawCircle(contactPoint, 4,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '接触点', contactPoint + const Offset(12, 10),
        const Color(0xFFFF5722), 10, bold: true);

    // ---- "Exposed crescent" — the part of ball visible above rail ----
    if (gapRatio < 0.5) {
      // Draw a subtle arc showing the exposed portion of the ball
      final exposedAngle = gap < r
          ? math.acos(((r - gap) / r).clamp(-1.0, 1.0))
          : math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: obj, radius: r + 2),
        -math.pi / 2 - exposedAngle,
        exposedAngle * 2,
        false,
        Paint()
          ..color = const Color(0xFFFFEB3B).withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }

    // ---- Object ball ----
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', obj + Offset(r + 12, 0), const Color(0xFFFFEB3B), 10);

    // ---- Cue ball ----
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, '白球', cue + Offset(0, r + 10), Colors.white70, 10);

    // ---- Rail interference warning ----
    if (willHitRail && cutAngleDeg > 20) {
      _drawLabel(canvas, '⚠ 白球可能先碰库',
          Offset(w * 0.5, h * 0.9), const Color(0xFFFF5722), 12, bold: true);
    }

    // ---- Pocket ----
    canvas.drawCircle(pocket, r * 1.3, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(pocket, r * 1.3,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '袋口', pocket + const Offset(-20, 14), Colors.white70, 10);

    // ---- Gap indicator ----
    if (gapRatio >= 0.05) {
      _drawLabel(canvas, '间距 ${(gapRatio * 100).toStringAsFixed(0)}%',
          Offset(objX - r * 4, objY - r - 4), Colors.white38, 10);
    } else {
      _drawLabel(canvas, '贴库',
          Offset(objX - r * 3, objY - r - 4), const Color(0xFFFF9800), 10, bold: true);
    }
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_CushionBallAimingPainter old) =>
      old.ballXRatio != ballXRatio ||
      old.gapRatio != gapRatio ||
      old.cutAngleDeg != cutAngleDeg;
}

// ===========================================================================
// Cushion Ball: Cushion-First Method (挤库法 / 先碰库法)
// ===========================================================================
class _CushionFirstLab extends StatefulWidget {
  const _CushionFirstLab();

  @override
  State<_CushionFirstLab> createState() => _CushionFirstLabState();
}

class _CushionFirstLabState extends State<_CushionFirstLab> {
  double _ballXPosition = 0.4;
  double _cueAngleOffset = 0.5; // 0=close to ball, 1=far from ball on rail

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('球沿库位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballXPosition,
                min: 0.2,
                max: 0.75,
                divisions: 55,
                activeColor: const Color(0xFFEF5350),
                onChanged: (v) => setState(() => _ballXPosition = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('白球角度',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _cueAngleOffset,
                min: 0.1,
                max: 0.9,
                divisions: 80,
                activeColor: const Color(0xFFEF5350),
                onChanged: (v) => setState(() => _cueAngleOffset = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _CushionFirstPainter(
              ballXRatio: _ballXPosition,
              cueAngleRatio: _cueAngleOffset,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFFFFEB3B), label: '目标球（贴库）'),
            _LegendItem(color: Colors.white70, label: '白球'),
            _LegendItem(color: Color(0xFFEF5350), label: '白球→库边（先碰库）'),
            _LegendItem(color: Color(0xFF66BB6A), label: '库边反弹→挤出目标球'),
            _LegendItem(color: Color(0xFF26C6DA), label: '目标球出球方向→袋口'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEF5350).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEF5350).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是挤库法？',
                  style: TextStyle(color: Color(0xFFEF5350), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '挤库法（也叫"先打库再碰球"）：\n'
                '白球先撞击目标球旁边的库边，利用库边反弹的力'
                '把目标球"挤"向袋口方向。\n\n'
                '适用场景：目标球紧贴库边，薄切法角度太大无法进球时。\n\n'
                '操作步骤：\n'
                '1. 白球瞄准目标球旁边的库边（而非目标球本身）\n'
                '2. 白球先碰库边反弹\n'
                '3. 反弹后碰到目标球，把球"挤"向袋口\n'
                '4. 白球击库点离目标球越近，挤球效果越强\n\n'
                '用滑杆调节参数观察白球的碰库→碰球路线。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEF5350).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFEF5350).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('挤库法（先碰库）说明',
                  style: TextStyle(
                      color: Color(0xFFEF5350), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '适用：大角度贴库球，直接打球面不够。\n\n'
                '原理：\n'
                '白球先碰库边，反弹后同时接触目标球\n'
                '和库边，把目标球"挤"离库边。\n\n'
                '步骤：\n'
                '1. 瞄准目标球前方的库边（球的来球侧）\n'
                '2. 白球碰库后弹向目标球\n'
                '3. 目标球被"夹"在白球和库边之间\n'
                '4. 被挤出后沿一定角度离开\n\n'
                '关键：\n'
                '• 碰库点离目标球越近 → 出球角度越小\n'
                '• 碰库点离目标球越远 → 出球角度越大\n'
                '• 力度影响挤压效果：中等力度最好控制\n'
                '• 加顺塞可以增加挤压效果',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Cushion-First Painter
// ---------------------------------------------------------------------------
class _CushionFirstPainter extends CustomPainter {
  _CushionFirstPainter({required this.ballXRatio, required this.cueAngleRatio});

  final double ballXRatio;
  final double cueAngleRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.045;

    final railY = h * 0.15;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 6);
    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF4E342E).withValues(alpha: 0.2));

    // --- Layout ---
    // Object ball: near the top-rail, position controlled by ballXRatio
    final objX = w * (0.35 + ballXRatio * 0.25);
    final obj = Offset(objX, railY + r);

    // Pocket: top-right corner
    final pocket = Offset(w * 0.92, railY);

    // Cue ball: lower-left, vertical position controlled by cueAngleRatio
    final cueX = w * 0.15;
    final cueY = railY + r * 3 + cueAngleRatio * (h * 0.55 - r * 3);
    final cue = Offset(cueX, cueY);

    // --- Core geometry: mirror method for correct reflection ---
    // Mirror the object ball across the rail (flip Y relative to railY)
    final mirrorObjY = 2 * railY - obj.dy;
    final mirrorObj = Offset(obj.dx, mirrorObjY);
    // Cushion contact = intersection of line(cue→mirrorObj) with rail (y=railY)
    final dy1 = railY - cue.dy;
    final dy2 = mirrorObj.dy - cue.dy;
    final t = (dy2.abs() < 0.01) ? 0.5 : dy1 / dy2;
    final contactX = (cue.dx + t * (mirrorObj.dx - cue.dx)).clamp(r * 2, objX - r * 0.5);
    final cushionContact = Offset(contactX, railY);

    // --- Path 1: Cue ball → Cushion contact (red solid) ---
    canvas.drawLine(cue, cushionContact,
        Paint()..color = const Color(0xFFEF5350).withValues(alpha: 0.85)..strokeWidth = 2.5);
    // Arrow head at cushion contact
    _drawArrow(canvas, cue, cushionContact, const Color(0xFFEF5350), r * 0.5);

    // --- Path 2: Cushion → Object ball (green solid, rebound path) ---
    canvas.drawLine(cushionContact, obj,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.85)..strokeWidth = 2.5);
    _drawArrow(canvas, cushionContact, obj, const Color(0xFF66BB6A), r * 0.5);

    // --- Path 3: Object ball → Pocket (cyan dashed, ball exit) ---
    _drawDashed(canvas, obj, pocket,
        Paint()..color = const Color(0xFF26C6DA).withValues(alpha: 0.7)..strokeWidth = 2);

    // --- Angle indicators ---
    final refAngle = math.atan2(obj.dy - cushionContact.dy, obj.dx - cushionContact.dx);
    final arcR = r * 2.5;
    // Incident arc: from rail-normal (pointing down = pi/2) to incoming direction (reversed)
    final incomingAngle = math.atan2(cue.dy - cushionContact.dy, cue.dx - cushionContact.dx);
    canvas.drawArc(
      Rect.fromCircle(center: cushionContact, radius: arcR),
      math.pi / 2, incomingAngle - math.pi / 2,
      false,
      Paint()..color = const Color(0xFFEF5350).withValues(alpha: 0.5)..strokeWidth = 1.5..style = PaintingStyle.stroke,
    );
    canvas.drawArc(
      Rect.fromCircle(center: cushionContact, radius: arcR),
      math.pi / 2, refAngle - math.pi / 2,
      false,
      Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.5)..strokeWidth = 1.5..style = PaintingStyle.stroke,
    );
    // Rail normal line (dashed, downward from contact)
    _drawDashed(canvas, cushionContact, cushionContact + Offset(0, r * 3),
        Paint()..color = Colors.white38..strokeWidth = 1);

    // --- Cushion contact point ---
    canvas.drawCircle(cushionContact, 5, Paint()..color = const Color(0xFFEF5350));
    canvas.drawCircle(cushionContact, 5,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '碰库点', cushionContact + Offset(-20, -16),
        const Color(0xFFEF5350), 10, bold: true);

    // --- Squeeze zone highlight ---
    final squeezeRect = Rect.fromCenter(
      center: Offset((objX + cushionContact.dx) / 2, railY + r * 0.5),
      width: (objX - cushionContact.dx).abs() + r,
      height: r * 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(squeezeRect, const Radius.circular(4)),
      Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.15),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(squeezeRect, const Radius.circular(4)),
      Paint()
        ..color = const Color(0xFFFF9800).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke..strokeWidth = 1,
    );
    _drawLabel(canvas, '挤压区', Offset((objX + cushionContact.dx) / 2, railY + r * 2.8),
        const Color(0xFFFF9800), 9);

    // --- Object ball ---
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', obj + Offset(r + 8, 4), const Color(0xFFFFEB3B), 10);

    // --- Cue ball ---
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, '白球', cue + Offset(0, r + 10), Colors.white70, 10);

    // --- Pocket ---
    canvas.drawCircle(pocket, r * 1.3, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(pocket, r * 1.3,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '袋口', pocket + const Offset(-12, 14), Colors.white70, 10);

    // --- Distance label ---
    final contactDist = (objX - cushionContact.dx) / r;
    _drawLabel(canvas, '距球 ${contactDist.toStringAsFixed(1)}R',
        Offset((objX + cushionContact.dx) / 2, railY + r * 4.2), Colors.white54, 9);

    // --- Legend ---
    final legendY = h * 0.92;
    _drawLegendItem(canvas, Offset(w * 0.08, legendY), const Color(0xFFEF5350), '白球→库边', false);
    _drawLegendItem(canvas, Offset(w * 0.32, legendY), const Color(0xFF66BB6A), '反弹→目标球', false);
    _drawLegendItem(canvas, Offset(w * 0.60, legendY), const Color(0xFF26C6DA), '目标球→袋口', true);
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Color color, double arrowSize) {
    final dir = (to - from);
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    final perp = Offset(-unit.dy, unit.dx);
    final tip = to;
    final left = tip - unit * arrowSize + perp * arrowSize * 0.5;
    final right = tip - unit * arrowSize - perp * arrowSize * 0.5;
    final path = Path()..moveTo(tip.dx, tip.dy)..lineTo(left.dx, left.dy)..lineTo(right.dx, right.dy)..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawLegendItem(Canvas canvas, Offset pos, Color color, String label, bool dashed) {
    final lineEnd = pos + const Offset(20, 0);
    if (dashed) {
      _drawDashed(canvas, pos, lineEnd, Paint()..color = color..strokeWidth = 2);
    } else {
      canvas.drawLine(pos, lineEnd, Paint()..color = color..strokeWidth = 2);
    }
    _drawLabel(canvas, label, pos + const Offset(24, -4), color, 9);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_CushionFirstPainter old) =>
      old.ballXRatio != ballXRatio || old.cueAngleRatio != cueAngleRatio;
}

// ===========================================================================
// Cushion Ball: Parallel Aiming (平行瞄准法)
// ===========================================================================
class _ParallelAimLab extends StatefulWidget {
  const _ParallelAimLab();

  @override
  State<_ParallelAimLab> createState() => _ParallelAimLabState();
}

class _ParallelAimLabState extends State<_ParallelAimLab> {
  double _ballXPosition = 0.45;
  double _gapFromRail = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('球沿库位置',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _ballXPosition,
                min: 0.2,
                max: 0.75,
                divisions: 55,
                activeColor: const Color(0xFF66BB6A),
                onChanged: (v) => setState(() => _ballXPosition = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('离库距离',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Expanded(
              child: Slider(
                value: _gapFromRail,
                min: 0.0,
                max: 0.5,
                divisions: 50,
                activeColor: const Color(0xFF66BB6A),
                onChanged: (v) => setState(() => _gapFromRail = v),
              ),
            ),
            Text(_gapFromRail < 0.05 ? '贴库' : '${(_gapFromRail * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                    color: Color(0xFF66BB6A), fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 14 / 10,
          child: CustomPaint(
            painter: _ParallelAimPainter(
              ballXRatio: _ballXPosition,
              gapRatio: _gapFromRail,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFFFFEB3B), label: '目标球'),
            _LegendItem(color: Colors.white70, label: '母球'),
            _LegendItem(color: Color(0xFF66BB6A), label: '母球瞄准线（平行偏移）'),
            _LegendItem(color: Color(0xFF26C6DA), label: '进球线（目标球→袋口）'),
            _LegendItem(color: Color(0xFFFF9800), label: '瞄准点（偏移半球径）'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是平行瞄准法？',
                  style: TextStyle(color: Color(0xFF66BB6A), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '贴库球最简单的瞄准方法，不需要计算切角。\n\n'
                '核心思路：\n'
                '目标球贴库时，母球无法瞄准球心正面。'
                '平行瞄准法将瞄准点从球心沿库边方向向袋口侧偏移半个球径。\n\n'
                '步骤：\n'
                '1. 从袋口向目标球画想象线（进球线）\n'
                '2. 找到目标球中心\n'
                '3. 沿库边方向（朝袋口侧）偏移半个球径 → 瞄准点\n'
                '4. 母球瞄准该点出杆\n\n'
                '母球的瞄准线和进球线近似平行，因此得名。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('平行瞄准法要点',
                  style: TextStyle(
                      color: Color(0xFF66BB6A), fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '为什么叫"平行"：\n'
                '母球的瞄准线和"球心→袋口"连线近似平行，\n'
                '偏移量恒定为半个球径。\n\n'
                '适用条件：\n'
                '• 贴库球或极近库球\n'
                '• 小到中等角度（< 45°）\n'
                '• 目标球到袋口距离不太远\n\n'
                '不适用时：\n'
                '• 大角度贴库球 → 用挤库法\n'
                '• 离库超过一个球径 → 用普通假想球法\n\n'
                '技巧：\n'
                '• 视觉上只需找到球心偏移半球的位置\n'
                '• 不需要计算切角或假想球\n'
                '• 出杆力度中等偏小为宜',
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Parallel Aiming Painter
// ---------------------------------------------------------------------------
class _ParallelAimPainter extends CustomPainter {
  _ParallelAimPainter({required this.ballXRatio, required this.gapRatio});

  final double ballXRatio;
  final double gapRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.045;

    // Rail
    final railY = h * 0.15;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 6);
    canvas.drawRect(Offset(0, railY) & Size(w, h - railY),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.3));
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF4E342E).withValues(alpha: 0.2));

    // Object ball
    final objX = w * (0.3 + ballXRatio * 0.3);
    final gap = gapRatio * r * 2;
    final obj = Offset(objX, railY + r + gap);

    // Pocket (top-right corner)
    final pocket = Offset(w * 0.92, railY);

    // Pocket direction from object ball
    final opDir = pocket - obj;
    final opLen = opDir.distance;
    final opNorm = opDir / opLen;

    // Parallel aim: offset half a ball radius along the rail toward the pocket.
    final railTowardPocket = Offset(pocket.dx > obj.dx ? 1.0 : -1.0, 0.0);
    final aimPoint = obj + railTowardPocket * (r * 0.5);

    // Cue ball position: below and to the left
    final cue = Offset(w * 0.15, h * 0.72);

    // --- Draw lines ---
    // 1. Pocket line: object center → pocket (cyan dashed)
    _drawDashed(canvas, obj, pocket,
        Paint()..color = const Color(0xFF26C6DA).withValues(alpha: 0.6)..strokeWidth = 1.5);

    // 2. Mother ball aim line → aim point (green solid)
    canvas.drawLine(cue, aimPoint,
        Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.85)..strokeWidth = 2.5);

    // 3. Extend aim line beyond aim point (green dashed)
    final aimDir = (aimPoint - cue);
    final aimDist = aimDir.distance;
    if (aimDist > 1) {
      final aimNorm = aimDir / aimDist;
      _drawDashed(canvas, aimPoint, aimPoint + aimNorm * (r * 4),
          Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.4)..strokeWidth = 1.5);
    }

    // 4. Show the half-radius rail offset: obj center → aim point bracket
    final offsetMid = (obj + aimPoint) * 0.5;
    final bracketOffset = Offset(0, r * 1.5);
    canvas.drawLine(
      obj + bracketOffset, aimPoint + bracketOffset,
      Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.8)..strokeWidth = 1.5,
    );
    canvas.drawLine(
      obj + bracketOffset * 0.7, obj + bracketOffset * 1.3,
      Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.8)..strokeWidth = 1,
    );
    canvas.drawLine(
      aimPoint + bracketOffset * 0.7, aimPoint + bracketOffset * 1.3,
      Paint()..color = const Color(0xFFFF9800).withValues(alpha: 0.8)..strokeWidth = 1,
    );
    _drawLabel(canvas, '½R', offsetMid + bracketOffset * 1.5,
        const Color(0xFFFF9800), 10, bold: true);

    // 5. Show parallelism: aim line vs pocket line are approximately parallel
    final parallelEnd = aimPoint + opNorm * (r * 8);
    _drawDashed(canvas, aimPoint, parallelEnd,
        Paint()..color = const Color(0xFF26C6DA).withValues(alpha: 0.25)..strokeWidth = 1);
    final midParallel = (aimPoint + parallelEnd) * 0.5;
    _drawLabel(canvas, '≈平行', Offset(midParallel.dx, midParallel.dy - 10),
        const Color(0xFF26C6DA), 9);

    // --- Aim point marker ---
    canvas.drawCircle(aimPoint, 3, Paint()..color = const Color(0xFFFF9800));
    canvas.drawCircle(aimPoint, 3,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '瞄准点', aimPoint + Offset(-r - 24, -4),
        const Color(0xFFFF9800), 10, bold: true);

    // --- Object ball ---
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    // Cross-hair at center
    canvas.drawLine(Offset(obj.dx - r * 0.4, obj.dy), Offset(obj.dx + r * 0.4, obj.dy),
        Paint()..color = Colors.black38..strokeWidth = 0.8);
    canvas.drawLine(Offset(obj.dx, obj.dy - r * 0.4), Offset(obj.dx, obj.dy + r * 0.4),
        Paint()..color = Colors.black38..strokeWidth = 0.8);
    _drawLabel(canvas, '目标球', obj + Offset(-r - 28, 4), const Color(0xFFFFEB3B), 10);

    // --- Cue ball ---
    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()..color = const Color(0xFFBBBBBB)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, '母球', cue + Offset(0, r + 10), Colors.white70, 10);

    // --- Pocket ---
    canvas.drawCircle(pocket, r * 1.3, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(pocket, r * 1.3,
        Paint()..color = const Color(0xFF5D4037)..style = PaintingStyle.stroke..strokeWidth = 2);
    _drawLabel(canvas, '袋口', pocket + const Offset(-12, 14), Colors.white70, 10);

    // --- Gap indicator ---
    if (gapRatio >= 0.05) {
      _drawLabel(canvas, '间距 ${(gapRatio * 100).toStringAsFixed(0)}%',
          Offset(objX - r * 4, obj.dy - r - 8), Colors.white38, 10);
    } else {
      _drawLabel(canvas, '贴库',
          Offset(objX - r * 3, obj.dy - r - 8), const Color(0xFFFF9800), 10, bold: true);
    }
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color,
      double fontSize, {bool bold = false}) {
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
  bool shouldRepaint(_ParallelAimPainter old) =>
      old.ballXRatio != ballXRatio || old.gapRatio != gapRatio;
}

// ===========================================================================
// Physics Labs — 物理原理
// ===========================================================================

class _ReflectionAngleLab extends StatefulWidget {
  const _ReflectionAngleLab();

  @override
  State<_ReflectionAngleLab> createState() => _ReflectionAngleLabState();
}

class _ReflectionAngleLabState extends State<_ReflectionAngleLab> {
  double _incidentAngleDeg = 35;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('入射角',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            Expanded(
              child: Slider(
                value: _incidentAngleDeg,
                min: 10,
                max: 80,
                divisions: 70,
                label: '${_incidentAngleDeg.toStringAsFixed(0)}°',
                activeColor: const Color(0xFF42A5F5),
                onChanged: (v) => setState(() => _incidentAngleDeg = v),
              ),
            ),
            Text('${_incidentAngleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFF42A5F5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CustomPaint(
            painter: _ReflectionAnglePainter(
              incidentAngleDeg: _incidentAngleDeg,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFF42A5F5), label: '入射路径（碰库前）'),
            _LegendItem(color: Color(0xFF66BB6A), label: '反射路径（碰库后）'),
            _LegendItem(color: Color(0xFFFF9800), label: '入射角 / 反射角弧线'),
            _LegendItem(color: Color(0xFF78909C), label: '法线（垂直于库边）'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFAB47BC).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFAB47BC).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是入射角与反射角？',
                  style: TextStyle(color: Color(0xFFAB47BC), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '球碰到库边时的反弹遵循"入射角 ≈ 反射角"原则：\n'
                '球撞击库边的角度（入射角）等于反弹离开的角度（反射角）。\n\n'
                '操作步骤：\n'
                '1. 拖动滑杆改变入射角度\n'
                '2. 观察入射线（来球方向）和反射线（反弹方向）\n'
                '3. 注意两个角度始终相等\n\n'
                '注意：实际打球中，旋转（加塞）会改变反弹角度——'
                '顺塞增大反弹角，逆塞减小反弹角。本实验展示的是无塞的理想情况。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF42A5F5).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: const Color(0xFF42A5F5).withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '入射角 = 反射角 = ${_incidentAngleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFF42A5F5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '理想库边反弹遵循镜面反射：球碰库时的入射角（相对法线）\n'
                '等于反射角。翻袋、解球、走位都建立在这个原理上。\n\n'
                '实战注意：大力击球时库边会"吃球"，出射角略小于入射角；\n'
                '加塞、脏球、胶边老化都会让实际反射偏离理想值。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReflectionAnglePainter extends CustomPainter {
  _ReflectionAnglePainter({required this.incidentAngleDeg});

  final double incidentAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.045;

    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.25));

    final railY = h * 0.28;
    canvas.drawLine(Offset(0, railY), Offset(w, railY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 8);
    canvas.drawRect(Offset.zero & Size(w, railY),
        Paint()..color = const Color(0xFF4E342E).withValues(alpha: 0.15));

    final hit = Offset(w * 0.5, railY);
    final incRad = incidentAngleDeg * math.pi / 180;
    final pathLen = h * 0.55;

    final inDir = Offset(math.sin(incRad), -math.cos(incRad));
    final outDir = Offset(math.sin(incRad), math.cos(incRad));

    final inStart = hit - inDir * pathLen;
    final outEnd = hit + outDir * pathLen;

    _drawDashed(canvas, inStart, hit,
        Paint()..color = const Color(0xFF78909C).withValues(alpha: 0.5)..strokeWidth = 1.5);
    canvas.drawLine(inStart, hit,
        Paint()..color = const Color(0xFF42A5F5)..strokeWidth = 3);
    canvas.drawLine(hit, outEnd,
        Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 3);

    canvas.drawCircle(hit, 6,
        Paint()..color = const Color(0xFFFF9800));
    canvas.drawCircle(hit, 6,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    _drawLabel(canvas, '碰库点', hit + const Offset(0, 16),
        const Color(0xFFFF9800), 10, bold: true);

    canvas.drawLine(hit, hit + Offset(0, h * 0.22),
        Paint()
          ..color = const Color(0xFF78909C).withValues(alpha: 0.7)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round);
    _drawLabel(canvas, '法线', hit + Offset(0, h * 0.24),
        const Color(0xFF78909C), 10);

    final arcR = h * 0.14;
    canvas.drawArc(
      Rect.fromCircle(center: hit, radius: arcR),
      -math.pi / 2 - incRad,
      incRad,
      false,
      Paint()
        ..color = const Color(0xFF42A5F5).withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawArc(
      Rect.fromCircle(center: hit, radius: arcR * 0.75),
      math.pi / 2,
      incRad,
      false,
      Paint()
        ..color = const Color(0xFF66BB6A).withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final incLabelAngle = -math.pi / 2 - incRad / 2;
    _drawLabel(
      canvas,
      '入射 ${incidentAngleDeg.toStringAsFixed(0)}°',
      hit + Offset(math.cos(incLabelAngle), math.sin(incLabelAngle)) * (arcR + 18),
      const Color(0xFF42A5F5),
      10,
      bold: true,
    );
    final refLabelAngle = math.pi / 2 + incRad / 2;
    _drawLabel(
      canvas,
      '反射 ${incidentAngleDeg.toStringAsFixed(0)}°',
      hit + Offset(math.cos(refLabelAngle), math.sin(refLabelAngle)) * (arcR + 18),
      const Color(0xFF66BB6A),
      10,
      bold: true,
    );

    canvas.drawCircle(inStart, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(inStart, r,
        Paint()
          ..color = const Color(0xFFBBBBBB)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2);
    _drawLabel(canvas, '白球', inStart + Offset(0, r + 12), Colors.white70, 10);

    final ghostEnd = hit + outDir * (pathLen * 0.35);
    canvas.drawCircle(ghostEnd, r,
        Paint()
          ..color = const Color(0xEEFFFFFF).withValues(alpha: 0.35)
          ..style = PaintingStyle.fill);
    canvas.drawCircle(ghostEnd, r,
        Paint()
          ..color = const Color(0xFF66BB6A).withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
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
  bool shouldRepaint(_ReflectionAnglePainter old) =>
      old.incidentAngleDeg != incidentAngleDeg;
}

class _SeparationAngleLab extends StatefulWidget {
  const _SeparationAngleLab();

  @override
  State<_SeparationAngleLab> createState() => _SeparationAngleLabState();
}

class _SeparationAngleLabState extends State<_SeparationAngleLab> {
  double _cutAngleDeg = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('切角',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            Expanded(
              child: Slider(
                value: _cutAngleDeg,
                min: 5,
                max: 85,
                divisions: 80,
                label: '${_cutAngleDeg.toStringAsFixed(0)}°',
                activeColor: const Color(0xFF42A5F5),
                onChanged: (v) => setState(() => _cutAngleDeg = v),
              ),
            ),
            Text('${_cutAngleDeg.toStringAsFixed(0)}°',
                style: const TextStyle(
                    color: Color(0xFF42A5F5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CustomPaint(
            painter: _SeparationAnglePainter(cutAngleDeg: _cutAngleDeg),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Colors.white70, label: '白球（碰前）'),
            _LegendItem(color: Color(0xFFFFEB3B), label: '目标球'),
            _LegendItem(color: Color(0xFF66BB6A), label: '目标球出球方向'),
            _LegendItem(color: Color(0xFF42A5F5), label: '白球碰后走位'),
            _LegendItem(color: Color(0xFFFF9800), label: '分离角（≈90°）'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF42A5F5).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF42A5F5).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('什么是分离角？',
                  style: TextStyle(color: Color(0xFF42A5F5), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '分离角是白球碰撞目标球后，白球偏转路径与原击球方向之间的夹角。\n\n'
                '核心规则（90° 法则）：\n'
                '中杆无旋转击球时，白球与目标球的分离方向近似成 90°。\n\n'
                '操作步骤：\n'
                '1. 拖动滑杆改变切角（白球碰撞角度）\n'
                '2. 观察碰撞后白球与目标球的分离方向\n'
                '3. 注意分离角始终接近 90°（中杆情况下）\n\n'
                '这是走位的基础：知道切角就能预测白球碰撞后的偏转方向。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF42A5F5).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: const Color(0xFF42A5F5).withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('90 度法则',
                  style: TextStyle(
                      color: Color(0xFF42A5F5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                '中杆（不加塞、不高低杆）击球时，碰后白球与目标球的\n'
                '运动方向近似互相垂直，分离角 ≈ 90°。\n\n'
                '切角改变的是各自方向在 90° 约束下的分配，\n'
                '但理想弹性碰撞下分离角本身保持 90°。\n\n'
                '加塞、高低杆、大力/小力都会让实际分离角偏离 90°。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SeparationAnglePainter extends CustomPainter {
  _SeparationAnglePainter({required this.cutAngleDeg});

  final double cutAngleDeg;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.04;

    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.2));

    final pocket = Offset(w * 0.88, h * 0.15);
    final obj = Offset(w * 0.62, h * 0.48);
    final op = pocket - obj;
    final opNorm = op.distance > 0 ? op / op.distance : const Offset(1, 0);
    final vpAngle = math.atan2(opNorm.dy, opNorm.dx);

    final cutRad = cutAngleDeg * math.pi / 180;
    final targetRad = math.pi - cutRad;
    final cAngle = vpAngle - targetRad;
    final cDir = Offset(math.cos(cAngle), math.sin(cAngle));
    final cue = obj + cDir * w * 0.38;

    final objDir = (obj - cue);
    final objNorm = objDir.distance > 0 ? objDir / objDir.distance : opNorm;

    // 90° rule: object exits toward pocket; cue exits perpendicular to object path.
    final objExitDir = opNorm;
    var cueExitDir = Offset(-opNorm.dy, opNorm.dx);
    if (_dot(cueExitDir, objNorm) < 0) {
      cueExitDir = Offset(opNorm.dy, -opNorm.dx);
    }

    final contact = obj - opNorm * r;
    final pathLen = w * 0.32;

    canvas.drawLine(cue, contact,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.35)
          ..strokeWidth = 2);
    canvas.drawLine(obj, obj + objExitDir * pathLen,
        Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 3);
    canvas.drawLine(contact, contact + cueExitDir * pathLen,
        Paint()..color = const Color(0xFF42A5F5)..strokeWidth = 3);

    _drawDashed(canvas, obj, pocket,
        Paint()..color = const Color(0xFFFFEB3B).withValues(alpha: 0.4)..strokeWidth = 1.5);

    final arcR = r * 2.8;
    canvas.drawArc(
      Rect.fromCircle(center: contact, radius: arcR),
      math.atan2(objExitDir.dy, objExitDir.dx),
      math.pi / 2,
      false,
      Paint()
        ..color = const Color(0xFFFF9800).withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    _drawLabel(
      canvas,
      '90°',
      contact +
          Offset(
            (objExitDir.dx - cueExitDir.dx) * arcR * 0.55,
            (objExitDir.dy - cueExitDir.dy) * arcR * 0.55,
          ),
      const Color(0xFFFF9800),
      12,
      bold: true,
    );

    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()
          ..color = const Color(0xFFBBBBBB)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2);
    _drawLabel(canvas, '白球', cue + Offset(-r - 8, r + 8), Colors.white70, 10);

    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', obj + Offset(r + 10, -4), const Color(0xFFFFEB3B), 10);

    canvas.drawCircle(pocket, r * 1.3, Paint()..color = const Color(0xFF263238));
    canvas.drawCircle(pocket, r * 1.3,
        Paint()
          ..color = const Color(0xFF5D4037)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    _drawLabel(canvas, '袋口', pocket + const Offset(0, 16), Colors.white54, 10);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
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

  static double _dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;

  @override
  bool shouldRepaint(_SeparationAnglePainter old) =>
      old.cutAngleDeg != cutAngleDeg;
}

class _ThrowEffectLab extends StatelessWidget {
  const _ThrowEffectLab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(
          '什么是 Throw（投射效应）',
          const Color(0xFF42A5F5),
          '两球碰撞时，球与球之间的摩擦力会把旋转和侧向力"投射"到目标球上，\n'
          '使目标球的实际出球方向偏离几何切角预测的方向。\n\n'
          '简单说：你瞄准的方向 ≠ 目标球实际走的方向。',
        ),
        const SizedBox(height: 12),
        _card(
          '击球速度的影响',
          const Color(0xFF66BB6A),
          '• 快速击球 → 接触时间短 → 摩擦力小 → throw 小\n'
          '• 慢速击球 → 接触时间长 → 摩擦力大 → throw 大\n\n'
          '因此同一颗切球，轻推往往比大力更"跑位偏"。',
        ),
        const SizedBox(height: 12),
        _card(
          '加塞的影响',
          const Color(0xFFFF9800),
          '• 顺塞（跟旋转方向一致）→ 增大 throw，目标球偏出更多\n'
          '• 反塞 → 减小甚至反向 throw\n'
          '• 侧塞越大 → throw 越明显\n\n'
          '职业球员会根据 throw 量微调瞄准点，尤其在薄切和近距离球。',
        ),
        const SizedBox(height: 12),
        _card(
          '实战建议',
          const Color(0xFFAB47BC),
          '1. 需要精确进袋时 → 适当加快击球，减少 throw\n'
          '2. 需要精确走位时 → 预判 throw 带来的偏差\n'
          '3. 顺塞薄切 → 瞄准要"让一点"，反塞则"多切一点"\n'
          '4. 练球时对比同切角不同力度，建立 throw 肌肉记忆',
        ),
      ],
    );
  }

  Widget _card(String title, Color color, String body) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}

// ===========================================================================
// Position Labs — 走位与控球
// ===========================================================================

class _HighMidLowLab extends StatefulWidget {
  const _HighMidLowLab();

  @override
  State<_HighMidLowLab> createState() => _HighMidLowLabState();
}

class _HighMidLowLabState extends State<_HighMidLowLab> {
  double _hitPoint = 0;

  String get _hitLabel {
    if (_hitPoint > 0.33) return '高杆';
    if (_hitPoint < -0.33) return '低杆';
    return '中杆';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('击球点',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            Expanded(
              child: Slider(
                value: _hitPoint,
                min: -1,
                max: 1,
                divisions: 40,
                label: _hitLabel,
                activeColor: const Color(0xFFFF9800),
                onChanged: (v) => setState(() => _hitPoint = v),
              ),
            ),
            Text(_hitLabel,
                style: const TextStyle(
                    color: Color(0xFFFF9800),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: CustomPaint(
            painter: _HighMidLowPainter(hitPoint: _hitPoint),
          ),
        ),
        const SizedBox(height: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: Color(0xFFFF9800), label: '击球点标记'),
            _LegendItem(color: Color(0xFF66BB6A), label: '目标球出球方向'),
            _LegendItem(color: Color(0xFF42A5F5), label: '白球碰后走位'),
            _LegendItem(color: Colors.white38, label: '中杆 ≈ 90° 分离（斯登）'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('高中低杆如何影响走位？',
                  style: TextStyle(color: Color(0xFFFF9800), fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                '击球点在母球的上、中、下不同位置，会产生不同的旋转效果：\n\n'
                '• 高杆（上方）：母球带前旋，碰撞后跟进\n'
                '• 中杆（中心）：母球无旋，碰撞后滑行→定杆\n'
                '• 低杆（下方）：母球带回旋，碰撞后回缩\n\n'
                '操作步骤：\n'
                '1. 拖动滑杆从低到高调整击球点\n'
                '2. 观察白球碰撞后的路径变化\n'
                '3. 高杆→白球跟着目标球走；低杆→白球往回走\n\n'
                '掌握高中低杆是走位的核心技能。',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.6),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: const Color(0xFFFF9800).withValues(alpha: 0.3)),
          ),
          child: Text(
            _hitPoint > 0.33
                ? '高杆（跟进）：杆头击中白球上部，碰后白球继续沿击球方向前进，\n'
                  '适合需要白球跟进球或走到远端走位。'
                : _hitPoint < -0.33
                    ? '低杆（拉回）：杆头击中白球下部，碰后白球向回旋转并回撤，\n'
                      '适合需要白球回到近处或避开障碍。'
                    : '中杆（斯登）：杆头击中白球中心，碰后白球近似垂直弹开（90°法则），\n'
                      '是最常用的定杆走位基础。',
            style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _HighMidLowPainter extends CustomPainter {
  _HighMidLowPainter({required this.hitPoint});

  final double hitPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(w, h) * 0.04;

    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.2));

    final obj = Offset(w * 0.72, h * 0.48);
    final pocket = Offset(w * 0.92, h * 0.15);
    final op = pocket - obj;
    final opNorm = op.distance > 0 ? op / op.distance : const Offset(1, 0);

    final cue = Offset(w * 0.28, h * 0.48);
    final objDir = (obj - cue);
    final objNorm = objDir.distance > 0 ? objDir / objDir.distance : opNorm;

    // Rotate from object exit direction (O→P); π/2 = stun perpendicular (90° rule).
    final cueExitAngle = math.pi / 2 - hitPoint * math.pi / 3;
    final cueExitDir = Offset(
      opNorm.dx * math.cos(cueExitAngle) - opNorm.dy * math.sin(cueExitAngle),
      opNorm.dx * math.sin(cueExitAngle) + opNorm.dy * math.cos(cueExitAngle),
    );

    final contact = obj - opNorm * r;
    final pathLen = w * 0.28;

    canvas.drawLine(cue, contact,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.35)
          ..strokeWidth = 2);
    canvas.drawLine(obj, obj + opNorm * pathLen,
        Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 3);
    canvas.drawLine(contact, contact + cueExitDir * pathLen,
        Paint()..color = const Color(0xFF42A5F5)..strokeWidth = 3);

    final hitOffsetY = -hitPoint * r * 0.75;
    final hitSpot = cue + Offset(0, hitOffsetY);
    canvas.drawCircle(hitSpot, 4, Paint()..color = const Color(0xFFFF9800));
    canvas.drawCircle(hitSpot, 4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    final stickEnd = cue - objNorm * r * 3.5;
    canvas.drawLine(stickEnd, cue - objNorm * r * 1.1,
        Paint()
          ..color = const Color(0xFF8D6E63)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round);
    _drawLabel(canvas, '击球点', hitSpot + Offset(14, 0),
        const Color(0xFFFF9800), 10, bold: true);

    canvas.drawCircle(cue, r, Paint()..color = const Color(0xEEFFFFFF));
    canvas.drawCircle(cue, r,
        Paint()
          ..color = const Color(0xFFBBBBBB)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2);
    _drawLabel(canvas, '白球', cue + Offset(0, r + 12), Colors.white70, 10);

    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(obj, r,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    _drawLabel(canvas, '目标球', obj + Offset(r + 8, -6), const Color(0xFFFFEB3B), 10);

    canvas.drawCircle(pocket, r * 1.2, Paint()..color = const Color(0xFF263238));
    _drawLabel(canvas, 'P', pocket + const Offset(0, -14),
        const Color(0xFFFFEB3B), 10, bold: true);
    _drawDashed(canvas, obj, pocket,
        Paint()..color = const Color(0xFFFFEB3B).withValues(alpha: 0.35)..strokeWidth = 1.2);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final dir = to - from;
    final dist = dir.distance;
    if (dist < 1) return;
    final unit = dir / dist;
    const dashLen = 6.0;
    const gapLen = 4.0;
    double d = 0;
    while (d < dist) {
      final s = from + unit * d;
      final e = from + unit * math.min(d + dashLen, dist);
      canvas.drawLine(s, e, paint);
      d += dashLen + gapLen;
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
  bool shouldRepaint(_HighMidLowPainter old) => old.hitPoint != hitPoint;
}

class _PositionZoneLab extends StatelessWidget {
  const _PositionZoneLab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(
          '区域思维 vs 点位思维',
          const Color(0xFFFF9800),
          '初学者常追求"白球必须停在某一个点"。\n'
          '进阶思路是：白球只需进入"好打的区域"即可。\n\n'
          '一个区域通常比精确点大 2～3 个球径，\n'
          '走位成功率会大幅提升，心理压力也更小。',
        ),
        const SizedBox(height: 12),
        _card(
          '什么是"好打的区域"',
          const Color(0xFF66BB6A),
          '• 下一颗目标球在直球或中小切角范围内\n'
          '• 不被其他球阻挡，出杆空间充足\n'
          '• 即使偏差半个球径，下一杆仍可轻松进球\n'
          '• 尽量远离库边和障碍球',
        ),
        const SizedBox(height: 12),
        _card(
          '如何规划区域走位',
          const Color(0xFF42A5F5),
          '1. 先看下一颗甚至下两颗球的理想区域\n'
          '2. 反推本杆白球应到达的大致范围\n'
          '3. 选择高/中/低杆和力度，让白球"落进区域"\n'
          '4. 区域偏大一点比精确但冒险更划算',
        ),
        const SizedBox(height: 12),
        _card(
          '图示理解',
          const Color(0xFFAB47BC),
          '想象台面上用粉笔画一个椭圆区域：\n\n'
          '  ┌─────────────┐\n'
          '  │  ○  ○  ○   │  ← 区域内任意停点都可接受\n'
          '  │    ▲目标球  │\n'
          '  └─────────────┘\n\n'
          '清台时逐杆扩大可接受区域，比逐杆追精确点更稳。',
        ),
      ],
    );
  }

  Widget _card(String title, Color color, String body) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}

// ===========================================================================
// Rules Lab — 比赛规则
// ===========================================================================

class _RulesQuickRefLab extends StatelessWidget {
  const _RulesQuickRefLab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card('开球', const Color(0xFFEF5350), [
          '• 白球需置于开球线后',
          '• 至少 4 颗球碰库，或至少 1 颗球进袋，否则犯规',
          '• 开球进 8 号球：8 号复位，开球方继续或重开（视规则版本）',
        ]),
        const SizedBox(height: 12),
        _card('球权（全色 / 花色）', const Color(0xFFFF9800), [
          '• 开球后未定色，台面为开放球局',
          '• 合法进首颗球后定色（1-7 全色，9-15 花色）',
          '• 进 8 号前须清空己方全部 7 颗球',
        ]),
        const SizedBox(height: 12),
        _card('常见犯规', const Color(0xFF42A5F5), [
          '• 白球落袋',
          '• 未先击中己方目标球（或未合法击中任何球）',
          '• 击球后无任何球碰库且无球进袋',
          '• 白球飞离台面、推杆、连击、触球等',
          '• 犯规后：对手获得自由球（全台任意放置）',
        ]),
        const SizedBox(height: 12),
        _card('8 号球', const Color(0xFF66BB6A), [
          '• 清空己方 7 颗球后方可击打 8 号',
          '• 8 号须指定袋口（部分规则要求报袋）',
          '• 8 号合法进袋 → 获胜',
        ]),
        const SizedBox(height: 12),
        _card('判负（直接输掉本局）', const Color(0xFFAB47BC), [
          '• 未清空己方球就打进 8 号',
          '• 8 号进错袋',
          '• 8 号与白球同时落袋',
          '• 8 号飞出台面',
        ]),
      ],
    );
  }

  Widget _card(String title, Color color, List<String> bullets) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(b,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12, height: 1.4)),
              )),
        ],
      ),
    );
  }
}
