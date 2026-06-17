import 'dart:math' as math;
import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        title: const Text('中式八球规则'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _Card(children: [
            _P('本规则参考《乔氏杯中式八球大师赛标准规则（2025版）》及中国台球协会（CBSA）2017版《中式台球竞赛总则》。实际比赛以当场赛事组委会公布的规则为准。',),
          ]),
          SizedBox(height: 16),
          // ============= 1. 器材与球 =============
          _H('器材与球'),
          _Card(children: [
            _P('中式八球使用 16 颗球：'),
            SizedBox(height: 8),
            _BallChart(),
            SizedBox(height: 12),
            _BL(items: [
              '1–7 号：全色球（实心色）',
              '9–15 号：花色球（带条纹）',
              '8 号：黑色球（关键球）',
              '白球（母球）：唯一可直接击打的球',
            ]),
            SizedBox(height: 8),
            _P('标准球台内径 254cm × 127cm（9 尺台），球直径 57.15mm。'),
          ]),

          // ============= 2. 摆球 =============
          SizedBox(height: 20),
          _H('摆球规则'),
          _Card(children: [
            _RackDiagram(),
            SizedBox(height: 12),
            _BL(items: [
              '三角架紧密排列，顶球放在置球点',
              '8 号球必须在正中央（第三排中间位置）',
              '三角形两个底角必须分别放一颗全色球和一颗花色球',
              '其余球花色和全色尽量分开排列',
              '前两排三颗球必须紧密相贴，后三排尽量摆紧',
              '球员可检查球堆并要求裁判修正',
            ]),
          ]),

          // ============= 3. 开球 =============
          SizedBox(height: 20),
          _H('开球'),
          _Card(children: [
            _P('开球方将母球放在开球线后任意位置。'),
            SizedBox(height: 8),
            _BL(items: [
              '母球置于开球线内任意位置',
              '母球必须先碰到球堆中的球',
              '开球合法条件：至少 4 颗目标球碰到库边，或有球入袋',
              '开球时 8 号入袋且无犯规：开球方可选择复位 8 号继续击打，或重新开球',
              '开球时 8 号入袋且犯规：对方可选择复位 8 号+线后自由球，或重摆由自己/对方开球',
            ]),
            _Tip('开球犯规时，对方有三种选择：\n'
                '① 线后自由球\n'
                '② 重新摆球由自己开球\n'
                '③ 重新摆球由对方开球'),
          ]),

          // ============= 4. 确定球组 =============
          SizedBox(height: 20),
          _H('确定球组（选色）'),
          _Card(children: [
            _P('开球后台面为"开放"状态。球组归属取决于开球后选手首先合法击进的球。'),
            SizedBox(height: 8),
            _BL(items: [
              '开球时无论进球与否，球局均为开放状态',
              '开球后，选手首次合法击进某组球中的一颗即确定球组',
              '球局开放时可击打除 8 号外的任意目标球',
              '球局开放时主球先碰 8 号球则犯规',
              '若开球后全色或花色球全部入袋，只能击打剩余的另一组',
            ]),
            _Tip('注意：开球进球不能确定球组。球组归属权取决于开球后合法击进某组球中的一颗球。'),
          ]),

          // ============= 5. 合法击球 =============
          SizedBox(height: 20),
          _H('合法击球要求'),
          _Card(children: [
            _BL(items: [
              '母球必须先碰到己方球组的球',
              '击球后必须满足以下至少一条：',
            ]),
            _Sub(items: [
              '有任意一颗球入袋',
              '母球或任意目标球碰到库边',
            ]),
            SizedBox(height: 8),
            _BL(items: [
              '连续进球可继续击球（不轮换）',
              '进球后如未犯规，继续击球',
              '未进球且未犯规，轮换给对方',
            ]),
          ]),

          // ============= 6. 犯规详解 =============
          SizedBox(height: 20),
          _H('犯规详解'),

          _FoulCard(
            icon: Icons.circle,
            iconColor: Color(0xFFF44336),
            title: '母球落袋（洗袋）',
            desc: '母球掉入任何球袋。这是最常见的犯规。',
            penalty: '对方获自由球（可放在台面任意位置）',
          ),
          _FoulCard(
            icon: Icons.close,
            iconColor: Color(0xFFFF9800),
            title: '未碰到合法目标球',
            desc: '母球出杆后没有先碰到己方球组的球。\n'
                '例：你是全色方，母球先碰到了花色球。',
            penalty: '对方获自由球',
          ),
          _FoulCard(
            icon: Icons.block,
            iconColor: Color(0xFFFF9800),
            title: '空杆（未碰任何球）',
            desc: '出杆后母球没有碰到任何目标球。',
            penalty: '对方获自由球',
          ),
          _FoulCard(
            icon: Icons.border_style,
            iconColor: Color(0xFFFF9800),
            title: '无球碰库',
            desc: '击球后没有任何球入袋，且母球和所有目标球都没有碰到库边。',
            penalty: '对方获自由球',
          ),
          _FoulCard(
            icon: Icons.flight_takeoff,
            iconColor: Color(0xFFFF9800),
            title: '球飞出台面',
            desc: '母球或目标球跳出台面。跳出的球不放回。',
            penalty: '对方获自由球（目标球不放回台面）',
          ),
          _FoulCard(
            icon: Icons.touch_app,
            iconColor: Color(0xFFFF9800),
            title: '非法触碰',
            desc: '用球杆以外的物体（手、衣服等）碰到台面上的球。',
            penalty: '对方获自由球',
          ),
          _FoulCard(
            icon: Icons.replay,
            iconColor: Color(0xFFFF9800),
            title: '推杆 / 连击',
            desc: '球杆与母球接触时间过长（推着走），或球杆二次接触母球。',
            penalty: '对方获自由球',
          ),
          _FoulCard(
            icon: Icons.hourglass_bottom,
            iconColor: Color(0xFFFF9800),
            title: '超时',
            desc: '在规定时间内未完成击球（比赛制一般每杆 30-45 秒）。',
            penalty: '对方获自由球',
          ),
          _FoulCard(
            icon: Icons.front_hand,
            iconColor: Color(0xFFFF9800),
            title: '双脚离地',
            desc: '击球瞬间两只脚都不在地面上。至少一只脚必须着地。',
            penalty: '对方获自由球',
          ),

          // ============= 7. 判负场景 =============
          SizedBox(height: 20),
          _H('直接判负场景'),
          _Card(children: [
            _P('以下情况该方直接输掉本局：'),
          ]),
          _DefeatCard(
            title: '提前击入 8 号球',
            desc: '己方球组尚未全部清完时，8 号球被打入任何球袋（无论有意无意）。',
          ),
          _DefeatCard(
            title: '击进 8 号同时犯规',
            desc: '击进 8 号球的同时发生犯规（母球落袋、未先碰 8 号等），开球阶段除外。',
          ),
          _DefeatCard(
            title: '最后一球与 8 号同时入袋',
            desc: '将本组最后一颗目标球击入袋的同时击进 8 号球。必须先清完本组球，再单独打 8 号。',
          ),
          _DefeatCard(
            title: '8 号球飞出台面',
            desc: '在任何时候 8 号球跳出台面，该方直接判负。',
          ),
          _Tip('注意：8 号球停留在台面上时只有犯规没有判负，8 号球飞出台面则一定判负。'),

          _Tip('关键提醒：在 8 号球阶段任何犯规都是致命的。'
              '如果没有把握，宁可打安全球也不要冒险进攻 8 号。'),

          // ============= 8. 胜负判定 =============
          SizedBox(height: 20),
          _H('胜负判定'),
          _Card(children: [
            _BL(items: [
              '将己方 7 颗球全部合法入袋后，合法将 8 号球击入球袋 → 获胜',
              '⚠ 最后一球与 8 号同时入袋 → 判负（必须先清完再单独打 8 号）',
              '所有球无需指球定袋，包括 8 号球',
              '比赛通常采用 N 局 M 胜制（如 9 局 5 胜）',
            ]),
          ]),

          // ============= 9. 自由球 =============
          SizedBox(height: 20),
          _H('自由球规则'),
          _Card(children: [
            _P('获得自由球权后：'),
            SizedBox(height: 8),
            _BL(items: [
              '可以手持母球放在台面任意位置（全台自由球）',
              '不能放在球袋口上',
              '不能与其他球重叠',
              '放好后可瞄准任意方向',
              '开球犯规：仅限开球线后放置（非全台自由球）',
            ]),
            _Tip('善用自由球是翻盘的关键机会。选择一个能连续清台的好位置比追求高难度进球更重要。'),
          ]),

          // ============= 10. 特殊情况 =============
          SizedBox(height: 20),
          _H('特殊情况处理'),
          _Card(children: [
            _SpecialCase(
              q: '僵局（无解球）怎么办？',
              a: '如果双方各击 3 次（共 6 次）都无法推进局面，重新摆球开局。',
            ),
            _SpecialCase(
              q: '目标球飞出台面后放哪？',
              a: '不放回台面，视为已出局。如果是 8 号飞出，打飞方直接判负。',
            ),
            _SpecialCase(
              q: '进了对方的球算犯规吗？',
              a: '如果母球先碰到了己方球，然后碰到对方球使其入袋，不算犯规（对方球不放回），'
                  '但你的回合结束，轮换给对方。',
            ),
            _SpecialCase(
              q: '同时进了己方和对方的球？',
              a: '只要击球合法（先碰己方球），不算犯规。己方球入袋有效，对方球也入袋有效。继续击球。',
            ),
            _SpecialCase(
              q: '母球贴库怎么击球？',
              a: '可以合法击球，但要确保击球后满足碰库或入袋条件。'
                  '如果母球紧贴目标球，须确保不推杆。',
            ),
          ]),

          SizedBox(height: 48),
          Center(
            child: Text('以上规则参考 CBSA 中式台球规则',
                style: TextStyle(color: Colors.white24, fontSize: 12)),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ===========================================================================
// Reusable widgets
// ===========================================================================
class _H extends StatelessWidget {
  const _H(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text,
            style: const TextStyle(
                color: Color(0xFF81C784), fontSize: 20, fontWeight: FontWeight.bold)),
      );
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );
}

class _P extends StatelessWidget {
  const _P(this.text);
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, height: 1.7));
}

class _BL extends StatelessWidget {
  const _BL({required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('• ', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
                    Expanded(child: Text(t, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, height: 1.5))),
                  ]),
                ))
            .toList(),
      );
}

class _Sub extends StatelessWidget {
  const _Sub({required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('– ', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                      Expanded(child: Text(t, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.4))),
                    ]),
                  ))
              .toList(),
        ),
      );
}

class _Tip extends StatelessWidget {
  const _Tip(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B4332).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: const Border(left: BorderSide(color: Color(0xFF66BB6A), width: 3)),
        ),
        child: Text(text, style: const TextStyle(color: Color(0xFFB9F6CA), fontSize: 13, height: 1.6)),
      );
}

// ---------------------------------------------------------------------------
// Foul card (orange border)
// ---------------------------------------------------------------------------
class _FoulCard extends StatelessWidget {
  const _FoulCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.desc,
    required this.penalty,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String desc;
  final String penalty;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFF9800).withValues(alpha: 0.3)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(desc,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, height: 1.5)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(penalty,
                    style: const TextStyle(color: Color(0xFFFF9800), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        ]),
      );
}

// ---------------------------------------------------------------------------
// Defeat card (red border)
// ---------------------------------------------------------------------------
class _DefeatCard extends StatelessWidget {
  const _DefeatCard({required this.title, required this.desc});
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF44336).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF44336).withValues(alpha: 0.4)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.dangerous, color: Color(0xFFF44336), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(color: Color(0xFFEF9A9A), fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(desc,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13, height: 1.5)),
            ]),
          ),
        ]),
      );
}

// ---------------------------------------------------------------------------
// Special case Q&A
// ---------------------------------------------------------------------------
class _SpecialCase extends StatelessWidget {
  const _SpecialCase({required this.q, required this.a});
  final String q;
  final String a;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Q: $q', style: const TextStyle(color: Color(0xFF81C784), fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('A: $a',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13, height: 1.5)),
        ]),
      );
}

// ---------------------------------------------------------------------------
// Ball chart diagram
// ---------------------------------------------------------------------------
class _BallChart extends StatelessWidget {
  const _BallChart();
  static const _colors = <int, Color>{
    1: Color(0xFFF9D923), 2: Color(0xFF1565C0), 3: Color(0xFFD32F2F), 4: Color(0xFF7B1FA2),
    5: Color(0xFFFF8F00), 6: Color(0xFF2E7D32), 7: Color(0xFF880E4F), 8: Color(0xFF1A1A1A),
    9: Color(0xFFF9D923), 10: Color(0xFF1565C0), 11: Color(0xFFD32F2F), 12: Color(0xFF7B1FA2),
    13: Color(0xFFFF8F00), 14: Color(0xFF2E7D32), 15: Color(0xFF880E4F),
  };

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 60,
        width: double.infinity,
        child: CustomPaint(painter: _BallChartPainter(_colors)),
      );
}

class _BallChartPainter extends CustomPainter {
  _BallChartPainter(this.colors);
  final Map<int, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final sp = (size.width - 20) / 15;
    final r = (sp * 0.4).clamp(8.0, 14.0);
    final x0 = (size.width - 15 * sp) / 2 + sp / 2;
    for (var i = 1; i <= 15; i++) {
      final x = x0 + (i - 1) * sp;
      final y = size.height / 2;
      final c = colors[i]!;
      if (i >= 9) {
        canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white);
        canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: r * 2, height: r * 0.9), Paint()..color = c);
      } else {
        canvas.drawCircle(Offset(x, y), r, Paint()..color = c);
      }
      canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1.2);
      final tp = TextPainter(
        text: TextSpan(text: '$i', style: TextStyle(color: i == 8 ? Colors.white : Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ---------------------------------------------------------------------------
// Rack diagram — shows triangular ball arrangement
// ---------------------------------------------------------------------------
class _RackDiagram extends StatelessWidget {
  const _RackDiagram();
  @override
  Widget build(BuildContext context) => SizedBox(height: 150, width: double.infinity, child: CustomPaint(painter: _RackPainter()));
}

class _RackPainter extends CustomPainter {
  static const _ballColors = <int, Color>{
    1: Color(0xFFF9D923), 2: Color(0xFF1565C0), 3: Color(0xFFD32F2F), 4: Color(0xFF7B1FA2),
    5: Color(0xFFFF8F00), 6: Color(0xFF2E7D32), 7: Color(0xFF880E4F), 8: Color(0xFF1A1A1A),
    9: Color(0xFFF9D923), 10: Color(0xFF1565C0), 11: Color(0xFFD32F2F), 12: Color(0xFF7B1FA2),
    13: Color(0xFFFF8F00), 14: Color(0xFF2E7D32), 15: Color(0xFF880E4F),
  };

  // Rows: standard rack layout (8 in center)
  static const _rows = [
    [1],
    [10, 2],
    [3, 8, 11],
    [9, 6, 12, 4],
    [7, 14, 5, 13, 15],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const r = 10.0;
    const gap = 2.0;
    final rowH = r * 2 * math.cos(math.pi / 6) + gap;
    // Center vertically
    final startY = (size.height - rowH * 4) / 2;
    // Center rack horizontally: widest row is 5 balls
    final maxRowW = 5 * (r * 2 + gap) - gap;
    final cx = (size.width - maxRowW) / 2 + maxRowW / 2;

    for (var row = 0; row < _rows.length; row++) {
      final balls = _rows[row];
      final y = startY + row * rowH;
      final rowW = balls.length * (r * 2 + gap) - gap;
      final startX = cx - rowW / 2 + r;
      for (var col = 0; col < balls.length; col++) {
        final num = balls[col];
        final x = startX + col * (r * 2 + gap);
        final c = _ballColors[num]!;
        final isStripe = num >= 9;

        if (isStripe) {
          canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white);
          canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: r * 2, height: r * 0.8),
            Paint()..color = c,
          );
        } else {
          canvas.drawCircle(Offset(x, y), r, Paint()..color = c);
        }
        canvas.drawCircle(
            Offset(x, y), r,
            Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);

        // Number
        final tp = TextPainter(
          text: TextSpan(
            text: '$num',
            style: TextStyle(color: num == 8 ? Colors.white : Colors.black87, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));

        // Highlight 8-ball position
        if (num == 8) {
          canvas.drawCircle(
              Offset(x, y), r + 2,
              Paint()..color = const Color(0xFFE91E63)..style = PaintingStyle.stroke..strokeWidth = 1.5);
        }
      }
    }

    // Label
    final tp = TextPainter(
      text: const TextSpan(
        text: '← 8号必须在中间',
        style: TextStyle(color: Color(0xFFE91E63), fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final labelX = cx + maxRowW / 2 + r * 1.5;
    tp.paint(canvas, Offset(labelX, startY + rowH * 2 - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
