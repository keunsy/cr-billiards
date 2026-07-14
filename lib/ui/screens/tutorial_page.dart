import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../game/billiards_game.dart';
import '../../game/systems/ball_rack.dart';
import 'game_screen.dart';
import 'rules_page.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------
class _TutorialItem {
  const _TutorialItem({
    required this.title,
    required this.icon,
    required this.builder,
  });
  final String title;
  final IconData icon;
  final Widget Function() builder;
}

class _TutorialCategory {
  const _TutorialCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
  final String title;
  final IconData icon;
  final Color color;
  final List<_TutorialItem> items;
}

// ---------------------------------------------------------------------------
// Categories registry — add new categories / items here
// ---------------------------------------------------------------------------
final List<_TutorialCategory> _categories = [
  _TutorialCategory(
    title: '基础入门',
    icon: Icons.school_outlined,
    color: const Color(0xFF66BB6A),
    items: [
      _TutorialItem(title: '认识球桌与球', icon: Icons.sports, builder: () => const _TableAndBalls()),
      _TutorialItem(title: '中八比赛规则', icon: Icons.gavel, builder: () => const _Rules()),
      _TutorialItem(title: '犯规与罚则', icon: Icons.warning_amber, builder: () => const _Fouls()),
    ],
  ),
  _TutorialCategory(
    title: '姿势与出杆',
    icon: Icons.accessibility_new,
    color: const Color(0xFF42A5F5),
    items: [
      _TutorialItem(title: '站位与身体姿势', icon: Icons.directions_walk, builder: () => const _Stance()),
      _TutorialItem(title: '架杆手法', icon: Icons.pan_tool_alt, builder: () => const _BridgeHand()),
      _TutorialItem(title: '出杆与发力', icon: Icons.speed, builder: () => const _StrokeAndPower()),
      _TutorialItem(title: '常见问题自查', icon: Icons.troubleshoot, builder: () => const _StrokeTroubleshooting()),
    ],
  ),
  _TutorialCategory(
    title: '瞄准与进球',
    icon: Icons.gps_fixed,
    color: const Color(0xFFFFA726),
    items: [
      _TutorialItem(title: '主视眼与瞄准视线', icon: Icons.visibility, builder: () => const _DominantEyeGuide()),
      _TutorialItem(title: '假想球瞄准法', icon: Icons.blur_circular, builder: () => const _GhostBall()),
      _TutorialItem(title: '切角与厚薄', icon: Icons.change_history, builder: () => const _CutAngle()),
      _TutorialItem(title: '常用进球线路', icon: Icons.route, builder: () => const _PottingLines()),
    ],
  ),
  _TutorialCategory(
    title: '走位与加塞',
    icon: Icons.moving,
    color: const Color(0xFFAB47BC),
    items: [
      _TutorialItem(title: '分离角原理', icon: Icons.call_split, builder: () => const _DeflectionAngle()),
      _TutorialItem(title: '高中低杆', icon: Icons.swap_vert, builder: () => const _HighMidLow()),
      _TutorialItem(title: '左右塞（侧旋）', icon: Icons.sync_alt, builder: () => const _SideSpin()),
      _TutorialItem(title: '走位计划', icon: Icons.map_outlined, builder: () => const _PositionPlan()),
    ],
  ),
  _TutorialCategory(
    title: '开球与战术',
    icon: Icons.military_tech,
    color: const Color(0xFFEF5350),
    items: [
      _TutorialItem(title: '开球技巧', icon: Icons.rocket_launch, builder: () => const _BreakShot()),
      _TutorialItem(title: '清台顺序规划', icon: Icons.format_list_numbered, builder: () => const _RunOut()),
      _TutorialItem(title: '安全球战术', icon: Icons.shield, builder: () => const _Safety()),
      _TutorialItem(title: '分级练球指南', icon: Icons.fitness_center, builder: () => const _PracticeGuide()),
    ],
  ),
  _TutorialCategory(
    title: 'App 操作指南',
    icon: Icons.touch_app,
    color: const Color(0xFF78909C),
    items: [
      _TutorialItem(title: '瞄准与击球', icon: Icons.ads_click, builder: () => const _AppAiming()),
      _TutorialItem(title: '力度与加塞控件', icon: Icons.tune, builder: () => const _AppControls()),
      _TutorialItem(title: '放球与辅助线设置', icon: Icons.settings, builder: () => const _AppSettings()),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Entry page — category list
// ---------------------------------------------------------------------------
class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        title: const Text('桌球教程'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length + 2,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          if (i == 0) {
            return _TopEntryCard(
              icon: Icons.menu_book_outlined,
              color: const Color(0xFFEF5350),
              title: '规则说明',
              subtitle: '中式八球完整规则',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RulesPage()),
              ),
            );
          }
          if (i == 1) {
            return _TopEntryCard(
              icon: Icons.fitness_center,
              color: const Color(0xFF66BB6A),
              title: '分级练球指南',
              subtitle: '从入门到高级的训练路线',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _DetailPage(
                    accentColor: const Color(0xFF66BB6A),
                    item: _TutorialItem(
                      title: '分级练球指南',
                      icon: Icons.fitness_center,
                      builder: () => const _PracticeGuide(),
                    ),
                  ),
                ),
              ),
            );
          }
          final cat = _categories[i - 2];
          return _CatCard(
            category: cat,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _CatPage(category: cat)),
            ),
          );
        },
      ),
    );
  }
}

class _CatCard extends StatelessWidget {
  const _CatCard({required this.category, required this.onTap});
  final _TutorialCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: category.color.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(category.icon, color: category.color, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.title,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${category.items.length} 个章节',
                      style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white38, size: 22),
          ],
        ),
      ),
    );
  }
}

class _TopEntryCard extends StatelessWidget {
  const _TopEntryCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: Colors.white38, size: 22),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Second level — item list within a category
// ---------------------------------------------------------------------------
class _CatPage extends StatelessWidget {
  const _CatPage({super.key, required this.category});
  final _TutorialCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(backgroundColor: const Color(0xFF1B4332), title: Text(category.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: category.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final item = category.items[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _DetailPage(item: item, accentColor: category.color)),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: category.color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: category.color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
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
// Third level — detail page
// ---------------------------------------------------------------------------
class _DetailPage extends StatelessWidget {
  const _DetailPage({super.key, required this.item, required this.accentColor});
  final _TutorialItem item;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(backgroundColor: const Color(0xFF1B4332), title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [item.builder(), const SizedBox(height: 32)],
      ),
    );
  }
}

// ===========================================================================
// Reusable UI widgets
// ===========================================================================
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: Text(title, style: const TextStyle(color: Color(0xFF81C784), fontSize: 18, fontWeight: FontWeight.bold)),
      );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
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
  Widget build(BuildContext context) => Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, height: 1.7));
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

class _Tip extends StatelessWidget {
  const _Tip(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B4332).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: const Border(left: BorderSide(color: Color(0xFF66BB6A), width: 3)),
        ),
        child: Text(text, style: const TextStyle(color: Color(0xFFB9F6CA), fontSize: 13, height: 1.6)),
      );
}

class _QA extends StatelessWidget {
  const _QA({required this.items});
  final List<({String q, String a})> items;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B4332).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF66BB6A).withValues(alpha: 0.3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('常见问答',
              style: TextStyle(color: Color(0xFF81C784), fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Q: ${item.q}',
                      style: const TextStyle(color: Color(0xFFB9F6CA), fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('A: ${item.a}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, height: 1.5)),
                ]),
              )),
        ]),
      );
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Container(width: 16, height: 3, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13))),
        ]),
      );
}

// ===========================================================================
// Content builders — 基础入门
// ===========================================================================
class _TableAndBalls extends StatelessWidget {
  const _TableAndBalls();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '球'),
        _InfoCard(children: [
          _P('中式八球使用 16 颗球：1 颗白色母球（Cue Ball）和 15 颗目标球。\n'
              '1-7 号为全色球（实心色），9-15 号为花色球（带条纹），8 号为黑色球。'),
          SizedBox(height: 12),
          _BallChartWidget(),
          SizedBox(height: 8),
          _P('标准球直径 57.15mm（2¼ 英寸），母球可以相同或略重。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '球台'),
        _InfoCard(children: [
          _P('标准球台内径 254cm × 127cm（9 英尺台），6 个球袋：4 个底袋（corner pockets）、2 个中袋（side pockets）。'),
          SizedBox(height: 12),
          _TableDiagramWidget(),
          SizedBox(height: 12),
          _BL(items: [
            '开球线：距端库 1/4 处的纵线',
            '置球点：对侧 1/4 处的交点，三角架球的顶点位置',
            '中袋口略宽于底袋口（约大 5mm），但进球角度限制更多',
            '库边（cushion）有弹性，球碰到会反弹',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '三角架球'),
        _InfoCard(children: [
          _P('开球前，15 颗目标球用三角架紧密排列：'),
          SizedBox(height: 8),
          _BL(items: [
            '8 号球必须放在三角形正中央（第三排中间）',
            '三角形顶点（第一颗球）放在置球点上',
            '其余球随机排列，但两个底角的球须一全色一花色',
            '所有球必须紧贴，无缝隙',
          ]),
          _Tip('诀窍：用手指推紧三角架再移除，确保球排列紧密，这影响开球散布效果。'),
        ]),
      ]);
}

class _Rules extends StatelessWidget {
  const _Rules();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // 器材与球
        _SectionHeader(title: '器材与球'),
        _InfoCard(children: [
          _P('中式八球使用 16 颗球：'),
          SizedBox(height: 4),
          _BL(items: [
            '1–7 号：全色球（实心色）',
            '9–15 号：花色球（带条纹）',
            '8 号：黑色球（关键球）',
            '白球（母球）：唯一可直接击打的球',
          ]),
          SizedBox(height: 4),
          _P('标准球台内径 254cm × 127cm（9 尺台），球直径 57.15mm。'),
        ]),

        // 摆球
        SizedBox(height: 16),
        _SectionHeader(title: '摆球规则'),
        _InfoCard(children: [
          _BL(items: [
            '三角架紧密排列，顶球放在置球点',
            '8 号球必须在正中央（第三排中间位置）',
            '三角形两个底角必须分别放一颗全色球和一颗花色球',
            '其余球随机排列',
            '所有球必须紧贴，无缝隙',
          ]),
        ]),

        // 开球
        SizedBox(height: 16),
        _SectionHeader(title: '开球'),
        _InfoCard(children: [
          _P('开球方将母球放在开球线后任意位置。'),
          SizedBox(height: 4),
          _BL(items: [
            '母球必须先碰到三角架内的球',
            '开球合法的条件：至少 4 颗球碰到库边，或有球入袋',
            '开球时 8 号入袋：重新摆球开局（或重置 8 号到置球点）',
            '开球犯规：对方获得开球线后自由球',
          ]),
          _Tip('如果开球未达到 4 球碰库的要求，对方可选择：\n'
              '① 接受台面现状继续比赛\n'
              '② 要求重新开球'),
        ]),

        // 确定球组
        SizedBox(height: 16),
        _SectionHeader(title: '确定球组（选色）'),
        _InfoCard(children: [
          _P('开球后台面为"开放"状态，任何球入袋都不决定球组。'),
          SizedBox(height: 4),
          _BL(items: [
            '开球后，击球方需合法进球才能确定球组',
            '首次合法击入某组球后，该组归该方所有',
            '若开球时同时击入全色和花色球，击球方可任选一组',
            '未确定球组前，击球方可瞄准任意目标球（8 号除外）',
          ]),
          _Tip('注意：仅靠开球进球不能确定球组，必须在后续击球中合法进球才算。'),
        ]),

        // 合法击球
        SizedBox(height: 16),
        _SectionHeader(title: '合法击球要求'),
        _InfoCard(children: [
          _BL(items: [
            '母球必须先碰到己方球组的球',
            '击球后必须满足以下至少一条：有任意一颗球入袋，或母球/任意目标球碰到库边',
            '连续进球可继续击球（不轮换）',
            '未进球且未犯规，轮换给对方',
            '所有球无需指袋（包括 8 号球）',
          ]),
          _Tip('中式八球执行 CBSA《中式台球竞赛总则》，所有球无需指球定袋，与美式 8 球的指袋规则不同。'),
        ]),

        // 犯规详解
        SizedBox(height: 16),
        _SectionHeader(title: '犯规详解'),
        _InfoCard(children: [
          _BL(items: [
            '母球落袋（洗袋）→ 对方获自由球（可放台面任意位置）',
            '未碰到合法目标球（先碰到对方球）→ 对方获自由球',
            '空杆（母球未碰任何球）→ 对方获自由球',
            '无球碰库（击球后无球入袋且无球碰库）→ 对方获自由球',
            '球飞出台面 → 对方获自由球（目标球不放回台面）',
            '非法触碰（用球杆以外物体碰到球）→ 对方获自由球',
            '推杆/连击（球杆二次接触母球）→ 对方获自由球',
            '超时（比赛制一般每杆 30-45 秒）→ 对方获自由球',
            '双脚离地击球 → 对方获自由球',
          ]),
        ]),

        // 判负场景
        SizedBox(height: 16),
        _SectionHeader(title: '直接判负场景'),
        _InfoCard(children: [
          _BL(items: [
            '提前击入 8 号球：己方球组未清完时 8 号入袋',
            '击 8 号时母球落袋：打 8 号时母球同时或先于 8 号落袋',
            '击 8 号时犯规：打 8 号球时发生任何犯规',
            '8 号球飞出台面：任何时候 8 号跳出台面',
            '连续三次犯规：同一方连续三杆均犯规（部分赛事规则）',
          ]),
          _Tip('关键提醒：在 8 号球阶段任何犯规都是致命的。如果没有把握，宁可打安全球也不要冒险进攻 8 号。'),
        ]),

        // 胜负判定
        SizedBox(height: 16),
        _SectionHeader(title: '胜负判定'),
        _InfoCard(children: [
          _BL(items: [
            '将己方 7 颗球全部合法入袋后，合法将 8 号球击入球袋 → 获胜',
            '若 8 号与最后一颗己方球同时入袋，只要击球合法且母球未落袋 → 获胜',
            '比赛通常采用 N 局 M 胜制（如 9 局 5 胜）',
          ]),
        ]),

        // 自由球
        SizedBox(height: 16),
        _SectionHeader(title: '自由球规则'),
        _InfoCard(children: [
          _P('获得自由球权后：'),
          SizedBox(height: 4),
          _BL(items: [
            '可以手持母球放在台面任意位置（全台自由球）',
            '不能放在球袋口上，不能与其他球重叠',
            '放好后可瞄准任意方向',
            '开球犯规：仅限开球线后放置（非全台自由球）',
          ]),
          _Tip('善用自由球是翻盘的关键机会。选择能连续清台的好位置比追求高难度进球更重要。'),
        ]),

        // 特殊情况
        SizedBox(height: 16),
        _SectionHeader(title: '特殊情况'),
        _InfoCard(children: [
          _BL(items: [
            '僵局：双方各击 3 次都无法推进 → 重新摆球开局',
            '目标球飞出台面：不放回台面（8 号飞出则打飞方判负）',
            '进了对方的球：母球先碰己方球后碰到对方球入袋 → 不犯规，但回合结束',
            '同时进己方和对方球：只要击球合法，都有效，继续击球',
            '母球贴库/贴球：合法击球，但须确保击球后满足碰库或入袋条件',
          ]),
        ]),
        SizedBox(height: 8),
        _Tip('以上规则参考 CBSA《中式台球竞赛总则》。'),
      ]);
}

class _Fouls extends StatelessWidget {
  const _Fouls();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '犯规类型速查'),
        _InfoCard(children: [
          _BL(items: [
            '母球落袋（洗袋）— 最常见的犯规',
            '空杆 — 母球出杆后没有碰到任何球',
            '先碰对方球 — 母球先碰到的不是己方球组',
            '无球碰库 — 击球后无球入袋且无球碰库边',
            '球飞出台面 — 母球或目标球跳离台面',
            '推杆/连击 — 球杆二次接触母球',
            '非法触碰 — 用手、衣服等碰到球',
            '双脚离地 — 出杆时两脚均不在地面',
            '超时 — 超过规定击球时间（比赛制）',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '犯规后果'),
        _InfoCard(children: [
          _BL(items: [
            '一般犯规：对方获自由球权（可将母球放在台面任意位置）',
            '开球犯规：对方获开球线后自由球，或选择重新开球',
            '打 8 号时犯规：直接判负',
            '连续三次犯规（部分赛事）：直接判负',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '避免犯规的实战建议'),
        _InfoCard(children: [
          _BL(items: [
            '击球前先确认目标球属于己方球组',
            '没有把握时宁可打安全球（防守）',
            '注意球杆跟进动作，避免二次触碰母球',
            '母球贴近目标球时，减小力度并注意出杆角度',
            '打 8 号球阶段格外谨慎，任何犯规都直接判负',
          ]),
          _Tip('核心原则：稳中求胜。高手之间的比赛往往是比谁犯规少，而不是比谁进攻猛。'),
        ]),
      ]);
}

// ===========================================================================
// Content builders — 姿势与出杆
// ===========================================================================
class _Stance extends StatelessWidget {
  const _Stance();
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionHeader(title: '完整站位流程（分步教学）'),
        const _InfoCard(children: [
          _P('标准站位可以分解为 5 个步骤，按顺序执行：'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('第 1 步 · 站在球后方观察（最重要的一步）'),
          SizedBox(height: 4),
          _BL(items: [
            '站在母球正后方约 50-80cm 处，身体完全直立，面朝球台',
            '不要急着趴下！先用眼睛"画线"：目光从母球出发 → 经过目标球的接触点 → 到袋口中心',
            '如果是切球（目标球不是直对袋口），先找到假想球的位置——想象一颗球紧贴在目标球背面、朝向袋口方向',
            '在脑中确定一条清晰的"瞄准线"：母球中心 → 假想球中心',
            '确认线路后，记住这个方向感。趴下后不再重新判断方向',
          ]),
          _Tip('这一步最重要！70% 的瞄准在站着的时候就完成了。站着的视角比趴下看更全面，能看到全台布局。很多人匆忙趴下导致瞄不准，就是因为跳过了这一步。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('第 2 步 · 右脚踩线'),
          SizedBox(height: 4),
          _BL(items: [
            '确定瞄准方向后，想象地上有一条从母球延伸到你身后的"瞄准线"',
            '右脚（握杆同侧脚）踩在这条线的正上方。脚的内侧边缘大致对齐这条线',
            '脚尖朝向球台方向，或稍微外八（约 10-20°）——不要内八',
            '右腿完全打直，膝盖锁住不弯。这条腿是你的"支撑柱"，承受大部分体重',
            '右脚的位置决定了你趴下后整个身体的朝向——如果脚踩偏了，后面都会跟着偏',
          ]),
          _Tip('自检方法：趴下前，低头看看右脚是否踩在球杆的延长线上。如果脚偏了，不要在趴下后扭身体补偿——站起来重新踩。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('第 3 步 · 左脚找位'),
          SizedBox(height: 4),
          _BL(items: [
            '左脚向左前方迈出一步，与右脚距离约一肩宽（40-50cm）',
            '左脚位置比右脚稍微靠前（朝球台方向偏 10-20cm），形成前后错开',
            '左腿膝盖微弯，形成弓步。弯曲程度以舒适为准，不需要像弓箭步那么深',
            '两脚之间的连线大致与球台边平行（不要一前一后踩成一条直线，那样会左右不稳）',
            '重心分配：约 70% 在右脚（支撑腿），30% 在左脚',
            '双脚脚底完全贴地——不要踮脚或抬脚跟',
          ]),
          _Tip('两脚的稳定性决定了全身的稳定性。如果你趴下后觉得身体晃，90% 的原因是脚的位置不对。太窄站不稳，太宽趴不下去。先找到自己舒服的宽度，然后固定下来。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('第 4 步 · 俯身趴下'),
          SizedBox(height: 4),
          _BL(items: [
            '双脚位置固定好后，保持右腿不动，身体慢慢向前弯腰',
            '同时右手握杆伸向球台，左手前伸准备架杆',
            '背部尽量保持平直，像一块板子——不要弓背（驼背）也不要塌腰（过度下沉）',
            '下巴慢慢靠近球杆。理想状态：下巴距球杆 0-5cm，或轻触球杆。不要用力压在杆上',
            '头的中心线（鼻梁 → 下巴中间）与球杆在同一个垂直面上',
            '双眼沿球杆方向前看——你应该能看到杆头、母球、目标球大致在一条线上',
            '肩膀自然倾斜：握杆侧（右肩）微微提起，架杆侧（左肩）稍低。不要强行端平',
          ]),
          _Tip('俯身时最常见的错误：\n① 头抬太高，下巴离杆太远 → 视线和杆不重合，瞄准不精确\n② 背弓得太厉害 → 肩膀紧张，出杆不顺\n③ 俯身太快 → 重心没找好就趴下了，全程都在晃'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('第 5 步 · 调整后手和手架'),
          SizedBox(height: 4),
          _P('后手（握杆手）：'),
          _BL(items: [
            '自然下垂，前臂与地面垂直',
            '从正后方看：后手 → 手肘 → 肩膀应在同一条垂直线上',
            '握在球杆重心后方约 10-15cm（用手指找平衡点再往后一拳）',
          ]),
          SizedBox(height: 8),
          _P('前手（架杆手）：'),
          _BL(items: [
            '架杆手距离母球约 15-25cm（约一拃长）',
            '手掌五指张开，稳稳压在台面上，不要悬空',
            '初学用"开放式架杆"：拇指翘起靠食指形成 V 型导槽',
            '球杆放在导槽中，确认能自由前后滑动，无卡顿',
            '手架的高度决定击球点：高杆抬高虎口，低杆压低虎口，中杆让杆头对准球中心',
          ]),
          _Tip('手架是最容易被忽视但非常关键的环节。手架不稳 = 杆头晃 = 出杆偏。详细的架杆手法见"架杆手法"教程。'),
        ]),
        const SizedBox(height: 8),
        SizedBox(height: 150, width: double.infinity, child: CustomPaint(painter: _StancePainter())),
        const SizedBox(height: 16),
        const _SectionHeader(title: '三点一线'),
        const _InfoCard(children: [
          _P('从正后方看，以下三点应在同一条垂直线上：'),
          SizedBox(height: 4),
          _BL(items: [
            '① 球杆（底部）',
            '② 下巴正中（面部中心线）',
            '③ 后手大臂（肩膀正下方）',
          ]),
          _Tip('这是台球姿势的核心原则。三点一线意味着你的视线、球杆和出杆方向完全对齐。如果其中任何一点偏移，出杆必定偏。'),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '重心分配'),
        const _InfoCard(children: [
          _BL(items: [
            '右腿（支撑腿）承受约 70% 体重，打直不弯',
            '左腿（前腿）承受约 30% 体重，微弯成弓步',
            '上半身重量通过前手架分担一部分到球台上',
            '重心不能太靠前（前倒）也不能太靠后（站不稳）',
          ]),
          _Tip('检验方法：趴好后，前手突然离开台面——如果身体马上倒，说明重心太靠前了。理想状态是前手离开后身体能保持稳定 2-3 秒。'),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '握杆详解'),
        const _InfoCard(children: [
          _P('握杆位置'),
          SizedBox(height: 4),
          _BL(items: [
            '握在球杆重心后方约 10-15cm（每根杆不同，需自己找）',
            '找重心方法：用一根手指托住球杆，找到平衡点，往后方约一拳就是握杆位',
            '根据击球距离调整：远台握后一些，近台握前一些',
          ]),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('握杆姿势'),
          SizedBox(height: 4),
          _BL(items: [
            '虎口（拇指与食指间）轻轻贴住球杆，像一个"吊环"',
            '手腕自然下垂，不内翻也不外翻',
            '整体力度：像握一支牙刷或一个纸杯——不松到掉，不紧到捏扁',
          ]),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('各手指分工'),
          SizedBox(height: 4),
          _BL(items: [
            '拇指 — 从下方托住球杆，提供向上的支撑力。拇指和食指组成"虎口"，是握杆的核心',
            '食指 — 从侧面（或上方）轻搭球杆，与拇指配合形成导向通道。不需要用力，只起限位作用',
            '中指 — 主要的"握持手指"，从球杆下方环绕提供向上的支撑。试杆和出杆时，中指感受球杆的重量和滑动',
            '无名指 — 辅助中指提供支撑，力度更轻',
            '小指 — 几乎不施力，自然搭在球杆上即可。有些选手小指甚至不碰球杆',
          ]),
          _Tip('核心原则：拇指 + 中指提供主要支撑（像一个钩子挂住球杆），食指做导向，无名指和小指只是"陪衬"。绝对不要五指一起握紧！'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('出杆时各手指的变化'),
          SizedBox(height: 4),
          _BL(items: [
            '试杆时：所有手指保持轻松，球杆在虎口中自由滑动',
            '最后拉杆时：后三指（中指、无名指、小指）会因为手腕下垂而稍微松开——这是正常的',
            '出杆瞬间：虎口稍微收紧（拇指和食指发力），中指配合握住——这就是"鞭打"效应',
            '送杆后：手指回到放松状态',
          ]),
          _Tip('常见错误：出杆时五指同时紧握（"攥拳出杆"）。这会让手腕僵硬、杆尾翘起、出杆歪斜。正确的感觉是"松→松→紧一下→松"。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('测试握力'),
          SizedBox(height: 4),
          _BL(items: [
            '测试 1：让朋友轻拉你的球杆，如果能轻松抽走说明太松；完全抽不动说明太紧。理想是有轻微阻力但能缓慢抽出',
            '测试 2：趴好后，把后三指全部松开，只用拇指和食指（虎口）夹住球杆——如果球杆不掉，说明虎口力度够了',
            '测试 3：做 5 次空杆，注意手指是否全程紧握。如果是，有意识地在每次试杆时松开后三指',
          ]),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('轻握为什么不会歪？'),
          SizedBox(height: 4),
          _P('很多新手误以为"轻握 = 拉杆会歪"，其实恰恰相反：'),
          SizedBox(height: 4),
          _BL(items: [
            '球杆在虎口中是"滑动"的，不是被手指"推拉"的。手指只是导轨',
            '握紧时，手指的微小偏差会直接带偏球杆方向（手指变成了"推杆器"）',
            '松握时，球杆被虎口限制在固定通道里，方向由手肘和前臂决定',
            '拉杆歪的真正原因：手肘位置偏（不在球杆正上方）、大臂跟着动了、手腕拉到底时扭了',
          ]),
          _Tip('记住：出杆方向不是手指控制的，是手肘控制的。手指的唯一任务是"不阻碍球杆直线滑动"。所以越松越好——只要不松到球杆掉下来。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('后手运动原理'),
          SizedBox(height: 4),
          _BL(items: [
            '大臂完全不动（固定在体侧，不前后摆动）',
            '前臂像钟摆一样，以手肘为轴心前后摆动',
            '手腕跟随前臂自然运动，不单独发力',
            '击球瞬间：虎口稍微收紧（鞭打效应），其余时间保持松弛',
          ]),
          _Tip('练习方法：站在球台旁，不趴下，右手自然下垂握杆，只让前臂前后摆动。大臂贴住身体不动。感受"钟摆"节奏。'),
        ]),
        const SizedBox(height: 8),
        SizedBox(height: 130, width: double.infinity, child: CustomPaint(painter: _GripPainter())),
        const SizedBox(height: 16),
        const _SectionHeader(title: '站位练习方法'),
        const _InfoCard(children: [
          _P('练习 1 · 空杆直线（每天 10 分钟）'),
          SizedBox(height: 4),
          _BL(items: [
            '在球台上贴一条 60cm 的胶带（沿着台面纵向）',
            '不放球，只做空杆练习',
            '按照 5 步流程站位 → 趴下 → 试杆 3 次 → 出杆',
            '观察杆头是否全程在胶带正上方滑动',
            '每次练 30-50 杆，重点感受"钟摆"节奏',
          ]),
          _Tip('这个练习的唯一目标是：出杆直。不要在意力度、速度，只关注球杆是否走直线。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('练习 2 · 4 分点直球推白球'),
          SizedBox(height: 4),
          _BL(items: [
            '母球放在 4 分点（开球线中心），对准远端底袋',
            '用中杆（击打母球正中心）推白球进袋',
            '连续进 10 个 = 通过，可以增加距离',
            '每次打偏了，停下来检查站位是否走了 5 步流程',
          ]),
          _Tip('这个练习同时锻炼站位和出杆。刚开始可能只能连进 3-5 个，坚持一周通常能达到连续 10 个。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('练习 3 · 录像自检'),
          SizedBox(height: 4),
          _BL(items: [
            '让朋友从正后方拍摄你的出杆过程',
            '也可以用手机支架自己录',
            '回放时检查：球杆是否在身体中线？后手是否在肘下方？头有没有抬起？',
            '对比"感觉"和"实际"的差异——多数人的偏差自己感觉不到',
          ]),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('练习 4 · 矿泉水瓶穿越'),
          SizedBox(height: 4),
          _BL(items: [
            '在球台边库放一个空矿泉水瓶',
            '将球杆从瓶口中穿过，做空杆练习',
            '如果出杆时碰到瓶壁，说明出杆不直',
            '目标：连续 20 次穿越不碰瓶壁',
          ]),
          _Tip('这个练习对纠正"出杆偏"特别有效。瓶口直径约 2.5cm，比球杆粗不了多少，偏一点就会碰到。'),
        ]),
        const SizedBox(height: 8),
        const _InfoCard(children: [
          _P('练习进阶路线'),
          SizedBox(height: 4),
          _BL(items: [
            '第 1 周：空杆直线 + 矿泉水瓶穿越（不放球，纯练姿势）',
            '第 2 周：4 分点直球推白球（最近距离开始）',
            '第 3 周：逐步增加距离（每次增加 30cm）',
            '第 4 周：加入简单切球角度（15°、30°）',
            '长期：每次上台前，先做 5 分钟空杆热身',
          ]),
          _Tip('动作固化需要 3-4 周的重复练习。在这期间不要着急打比赛或复杂球，先把基本功练扎实。'),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '视线流程'),
        const _InfoCard(children: [
          _P('趴下后到出杆，眼睛应该有固定的"看球顺序"：'),
          SizedBox(height: 4),
          _BL(items: [
            '① 先看目标球（确认进球方向和接触点）',
            '② 再看母球（确认杆头对准击球点）',
            '③ 试杆过程中目光在母球和目标球之间交替 2-3 次',
            '④ 最后一次试杆拉回时，目光锁定目标球',
            '⑤ 出杆！出杆时眼睛看目标球，不看母球',
          ]),
          _Tip('出杆时看目标球而非母球，是职业与业余的最大区别之一。看母球会导致下意识调整出杆方向。就像投篮时看篮筐而非看球。'),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '呼吸与节奏'),
        const _InfoCard(children: [
          _BL(items: [
            '趴下瞄准时正常呼吸，不要憋气',
            '最后一次拉杆停顿时，自然呼出',
            '出杆时保持平稳的呼气或自然呼吸',
            '出杆后保持趴下姿势（定杆）1-2 秒，不急于起身',
          ]),
          _Tip('紧张比赛中最容易犯的错：憋气然后仓促出杆。深呼吸 → 慢慢吐气 → 在吐气的过程中平稳出杆，能有效缓解紧张。'),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '球杆角度'),
        const _InfoCard(children: [
          _BL(items: [
            '球杆应尽量与台面保持平行（水平出杆）',
            '杆尾稍微高于杆头是正常的（1-3°倾斜），但不能太陡',
            '球杆越水平，母球走的路线越可控，不容易跳球或向下扎',
            '只有在打扎杆（Massé）或跳球时才需要明显抬高杆尾',
          ]),
          _Tip('检查方法：趴好后让朋友从侧面看你的球杆——如果杆尾明显高于杆头（超过 5°），说明你的后手位置太高或者身体趴得不够低。'),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '身体各部位检查清单'),
        const _InfoCard(children: [
          _BL(items: [
            '头部 → 下巴贴杆或极近，不抬头',
            '眼睛 → 沿球杆方向平视，最后看目标球',
            '肩膀 → 右肩自然提起，左肩稍压低',
            '背部 → 尽量平直，不弓背',
            '右大臂 → 贴体侧，与球杆同一直线',
            '右前臂 → 垂直于地面（试杆最后拉到底时）',
            '右手 → 松握，虎口贴杆',
            '左手 → 架杆稳固贴台面，不悬空',
            '右腿 → 伸直打直，踩在瞄准线上',
            '左腿 → 微弯成弓步',
          ]),
          _Tip('趴好之后，从上到下过一遍这个清单。初期可能需要 10 秒，熟练后只需要 2-3 秒就能确认。'),
        ]),
        const _QA(items: [
          (q: '站位时两脚应该分多宽？', a: '前后脚大致与肩同宽或略宽，前脚指向球台，后脚自然分开。太窄站不稳，太宽则趴下困难、出杆受限。'),
          (q: '应该用哪只眼睛瞄准？', a: '多数人是主视眼与球杆同侧（右撇子常用右眼），但因人而异。关键是让视线沿球杆穿过母球中心，找到最清晰、最稳定的那只眼。'),
          (q: '初学者最常见的姿势错误是什么？', a: '身体太直、重心太高、握杆过紧、大臂跟着动。这些都会导致出杆不稳、瞄准偏移。'),
          (q: '如何自己检查站位是否正确？', a: '趴下后让球杆从下巴正下方穿过；从后方看，球杆应在身体正中线上。也可以录视频回放，比凭感觉更客观。'),
          (q: '个子矮 / 手臂短趴不到台面怎么办？', a: '可以穿底稍厚的鞋子、用更短的球杆、或调整握杆位置偏前一些。关键是能舒适地趴下并保持稳定，不需要强行模仿高个子的姿势。'),
          (q: '左撇子该怎么站？', a: '完全镜像：左手握杆、右手架杆、左脚踩瞄准线、右脚弓步。其余原则不变。'),
          (q: '为什么要下巴贴杆？', a: '下巴贴杆让你的视线尽可能贴近球杆，就像步枪瞄准时眼睛贴近瞄准镜一样。视线越贴近球杆，瞄准越精确，偏差越小。'),
        ]),
      ]);
}

class _BridgeHand extends StatelessWidget {
  const _BridgeHand();
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionHeader(title: '开放式架杆（Open Bridge）'),
        const _InfoCard(children: [
          _P('最常用的基础架杆，适合初学者和大多数击球场景。'),
          SizedBox(height: 8),
          _BL(items: [
            '手掌摊平放在台面上，五指自然张开，指尖和掌根抓紧台布',
            '拇指向上翘起，紧靠食指第一关节形成 V 型导槽——这个槽就叫"虎口"',
            '虎口的高低决定杆头击球点：打高杆拇指抬高，打低杆压低虎口',
            '球杆沿虎口前后滑动，拇指提供侧向限位，保证出杆直',
            '出杆时只有球杆在动，架杆手纹丝不动',
          ]),
          _Tip('关键：虎口要贴合球杆但不能夹紧。松了球杆左右晃，紧了出杆不顺滑。开始练习时先用开放式虎口，稳了再过渡到闭合式。'),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          width: double.infinity,
          child: CustomPaint(painter: _OpenBridgePainter()),
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: '闭合式架杆（Closed Bridge）'),
        const _InfoCard(children: [
          _P('职业选手最常用的架杆，精度和稳定性最高。'),
          SizedBox(height: 8),
          _BL(items: [
            '食指弯曲圈住球杆，形成一个完整的环',
            '中指、无名指、小指三指撑住台面提供支撑',
            '拇指抵住食指中节，提供向下的压力锁紧球杆',
            '球杆被手指完全包裹，出杆方向更稳定',
          ]),
          _Tip('闭合式在发力较大时（开球、长距离击球）优势明显。初学建议先用开放式，等出杆稳定后过渡到闭合式。'),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          width: double.infinity,
          child: CustomPaint(painter: _ClosedBridgePainter()),
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: '凤眼架（Phoenix Eye Bridge）'),
        const _InfoCard(children: [
          _P('中式台球最流行的架杆方式，兼具开放式的视野和闭合式的稳定性，是大部分中式八球选手的首选。'),
          SizedBox(height: 8),
          _BL(items: [
            '食指弯曲，与拇指指尖对接形成一个"凤眼"形状的环，球杆穿过这个环',
            '中指、无名指、小指三指张开撑住台面，提供稳定支撑',
            '拇指和食指的接触点形成虎口——球杆在虎口中前后滑动',
            '虎口不能太紧（出杆不顺）也不能太松（球杆左右晃动）',
            '通过调节手掌隆起高度，控制球杆击打母球的位置（高中低杆）',
          ]),
          _Tip('凤眼架的核心：食指第一关节弯曲搭在拇指指尖上，而不是像闭合式那样整根食指绕一圈。这样形成的环更紧凑，视线也更好。'),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          width: double.infinity,
          child: CustomPaint(painter: _PhoenixEyeBridgePainter()),
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: '特殊架杆'),
        const _InfoCard(children: [
          _P('以下场景需要特殊架杆技巧：'),
          SizedBox(height: 8),
          _BL(items: [
            '高架杆：母球被其他球挡住时，抬高手掌用指尖撑台面，球杆从上方经过障碍球。注意只用中杆或稍上，避免低杆（容易滑杆）',
            '靠库架杆：母球贴库或靠近库边时，手搭在库边上方，用拇指和食指在库边上形成导槽。球杆从库边上方滑过',
            '架杆器（Spider/Cross）：母球太远手够不到时，使用辅助工具搭在台面上。架杆器也分为高架和十字架两种',
            '背手架杆：球在身体另一侧时，用非惯用手架杆或翻转手腕架杆',
          ]),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: CustomPaint(painter: _SpecialBridgePainter()),
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: '架杆手距离与高度'),
        const _InfoCard(children: [
          _BL(items: [
            '架杆手到母球距离：一般 15–25 cm（约一拃长）',
            '距离太近：手挡视线，出杆行程不够',
            '距离太远：杆头偏移放大，精度下降',
            '高杆时：V 槽/环抬高约 1–2 cm',
            '低杆时：V 槽/环尽量压低到台面',
            '中杆：V 槽高度让杆头对准母球中心',
          ]),
        ]),
        const _QA(items: [
          (q: '什么时候从开放式换成闭合式架杆？', a: '出杆稳定、能连续进球后可尝试闭合式。需要大力击球（开球、长距离）或追求更高精度时，闭合式通常更稳。'),
          (q: '母球贴库时怎么架杆？', a: '手搭在库边上方，用指尖或掌根撑住台面，让球杆从库边上方滑过。保持架杆手稳定，避免球杆被库边卡住。'),
          (q: '架杆手离母球多远合适？', a: '一般 15–25 cm，以出杆时杆头能自然穿过母球为准。太近手挡视线，太远则控制精度下降。'),
          (q: '架杆不稳怎么办？', a: '手指用力压紧台面、拇指与食指形成稳固 V 槽，出杆时只让球杆在槽内滑动，架杆手本身不要跟着动。'),
          (q: '高架杆容易滑杆怎么办？', a: '高架时尽量只打中杆或偏上，避免低杆。指尖要抓紧台布，让球杆稳定滑动。出杆轻柔，不要发死力。'),
        ]),
      ]);
}

class _OpenBridgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Schematic cross-section view: looking from front along the cue
    final tableY = h * 0.65;
    canvas.drawRect(Rect.fromLTWH(0, tableY, w, h - tableY), Paint()..color = const Color(0xFF1B4332));
    canvas.drawLine(Offset(0, tableY), Offset(w, tableY), Paint()..color = const Color(0xFF4E342E)..strokeWidth = 2);

    // Cue stick (horizontal, side view)
    final cueY = tableY - 22;
    canvas.drawLine(Offset(cx - 120, cueY), Offset(cx + 130, cueY),
      Paint()..color = const Color(0xFFFFF8E1)..strokeWidth = 5..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(cx + 130, cueY), 3, Paint()..color = const Color(0xFF26C6DA));

    // Schematic: thumb (left, angled up)
    final thumbBase = Offset(cx - 20, tableY - 2);
    final thumbTip = Offset(cx - 35, cueY - 14);
    canvas.drawLine(thumbBase, thumbTip, Paint()..color = const Color(0xFFE8B89D)..strokeWidth = 8..strokeCap = StrokeCap.round);
    canvas.drawCircle(thumbTip, 5, Paint()..color = const Color(0xFFE8B89D));

    // Schematic: index finger base (right, angled up)
    final indexBase = Offset(cx + 10, tableY - 2);
    final indexTop = Offset(cx + 5, cueY - 8);
    canvas.drawLine(indexBase, indexTop, Paint()..color = const Color(0xFFE8B89D)..strokeWidth = 8..strokeCap = StrokeCap.round);
    canvas.drawCircle(indexTop, 5, Paint()..color = const Color(0xFFE8B89D));

    // V-groove highlight between thumb tip and index top
    canvas.drawLine(thumbTip, Offset(cx - 15, cueY + 2), Paint()..color = const Color(0xFFFF9800)..strokeWidth = 2);
    canvas.drawLine(Offset(cx - 15, cueY + 2), indexTop, Paint()..color = const Color(0xFFFF9800)..strokeWidth = 2);

    // 虎口 label with arrow
    _arrow(canvas, Offset(cx - 70, h * 0.12), Offset(cx - 20, cueY - 4), const Color(0xFFFF9800));
    _lbl(canvas, '虎口（V型槽）', Offset(cx - 105, h * 0.05), const Color(0xFFFF9800), bold: true);

    // Other fingers on table (schematic dots)
    for (var i = 0; i < 3; i++) {
      final fx = cx + 30 + i * 20.0;
      canvas.drawCircle(Offset(fx, tableY - 4), 5, Paint()..color = const Color(0xFFE8B89D));
      canvas.drawLine(Offset(fx, tableY - 4), Offset(fx, tableY - 16),
        Paint()..color = const Color(0xFFE8B89D)..strokeWidth = 6..strokeCap = StrokeCap.round);
    }

    // Labels
    _lbl(canvas, '拇指', Offset(thumbTip.dx - 20, thumbTip.dy - 16), Colors.white54);
    _lbl(canvas, '食指', Offset(indexTop.dx + 8, indexTop.dy - 14), Colors.white54);
    _lbl(canvas, '中/无/小指撑台面', Offset(cx + 18, tableY - 30), Colors.white54);
    _lbl(canvas, '球杆', Offset(cx + 85, cueY - 14), Colors.white54);
    _lbl(canvas, '← 球杆在虎口中前后滑动 →', Offset(cx - 80, tableY + 10), const Color(0xFF66BB6A));

    // View label
    _lbl(canvas, '正面剖面示意图', Offset(w - 100, 4), Colors.white24);
  }

  void _arrow(Canvas c, Offset from, Offset to, Color cl) {
    c.drawLine(from, to, Paint()..color = cl..strokeWidth = 1.5);
    final d = to - from; final n = d / d.distance; final p = Offset(-n.dy, n.dx);
    c.drawPath(Path()..moveTo(to.dx, to.dy)
      ..lineTo(to.dx - n.dx * 6 + p.dx * 3, to.dy - n.dy * 6 + p.dy * 3)
      ..lineTo(to.dx - n.dx * 6 - p.dx * 3, to.dy - n.dy * 6 - p.dy * 3)..close(),
      Paint()..color = cl);
  }

  void _lbl(Canvas c, String t, Offset p, Color cl, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _ClosedBridgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Table surface
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, cy + 5, size.width, size.height - cy - 5), const Radius.circular(4)),
      Paint()..color = const Color(0xFF1B4332),
    );

    final handColor = const Color(0xFFE8B89D);
    final handPaint = Paint()..color = handColor;
    final outline = Paint()..color = Colors.white38..style = PaintingStyle.stroke..strokeWidth = 1.5;

    // Palm
    final palmRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + 5, cy + 22), width: 95, height: 50), const Radius.circular(10));
    canvas.drawRRect(palmRect, handPaint);
    canvas.drawRRect(palmRect, outline);

    // Support fingers (middle, ring, pinky)
    for (var i = 0; i < 3; i++) {
      final fx = cx + 10 + i * 18.0;
      final fp = Path()
        ..moveTo(fx - 6, cy + 2)
        ..lineTo(fx - 5, cy - 22)
        ..quadraticBezierTo(fx, cy - 28, fx + 5, cy - 22)
        ..lineTo(fx + 6, cy + 2)
        ..close();
      canvas.drawPath(fp, handPaint);
      canvas.drawPath(fp, outline);
    }

    // Index finger curled around cue (loop/ring shape)
    final loopCenter = Offset(cx - 12, cy - 8);
    canvas.drawOval(Rect.fromCenter(center: loopCenter, width: 32, height: 24),
      Paint()..color = handColor.withValues(alpha: 0.75));
    canvas.drawOval(Rect.fromCenter(center: loopCenter, width: 32, height: 24), outline);

    // Highlight the loop
    canvas.drawOval(Rect.fromCenter(center: loopCenter, width: 32, height: 24),
      Paint()..color = const Color(0x33FF9800)..style = PaintingStyle.stroke..strokeWidth = 2.5);

    // Thumb pressing on index finger from below
    final thumbPath = Path()
      ..moveTo(cx - 40, cy + 15)
      ..lineTo(cx - 52, cy - 10)
      ..quadraticBezierTo(cx - 56, cy - 20, cx - 46, cy - 22)
      ..lineTo(cx - 30, cy - 5)
      ..close();
    canvas.drawPath(thumbPath, handPaint);
    canvas.drawPath(thumbPath, outline);

    // Cue stick through the loop
    final cuePaint = Paint()..color = const Color(0xFFFFF8E1)..strokeWidth = 4..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 130, cy - 8), Offset(cx + 140, cy - 8), cuePaint);
    canvas.drawCircle(Offset(cx + 140, cy - 8), 3, Paint()..color = const Color(0xFF26C6DA));

    // Arrows and labels
    _arrow(canvas, Offset(cx - 50, cy - 45), loopCenter + const Offset(0, -12), const Color(0xFFFF9800));
    _lbl(canvas, '食指弯曲环绕球杆', Offset(cx - 90, cy - 50), const Color(0xFFFF9800));

    _arrow(canvas, Offset(cx - 80, cy + 40), Offset(cx - 46, cy + 5), const Color(0xFF66BB6A));
    _lbl(canvas, '拇指从下方压住食指', Offset(cx - 110, cy + 42), const Color(0xFF66BB6A));

    _lbl(canvas, '三指撑台面', Offset(cx + 15, cy - 38), Colors.white54);
    _lbl(canvas, '球杆穿过食指环', Offset(cx + 50, cy - 20), Colors.white54);
  }

  void _arrow(Canvas c, Offset from, Offset to, Color cl) {
    c.drawLine(from, to, Paint()..color = cl..strokeWidth = 1.5);
    final d = to - from; final n = d / d.distance; final p = Offset(-n.dy, n.dx);
    c.drawPath(Path()..moveTo(to.dx, to.dy)
      ..lineTo(to.dx - n.dx * 6 + p.dx * 3, to.dy - n.dy * 6 + p.dy * 3)
      ..lineTo(to.dx - n.dx * 6 - p.dx * 3, to.dy - n.dy * 6 - p.dy * 3)..close(),
      Paint()..color = cl);
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _PhoenixEyeBridgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Table surface
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, cy + 5, size.width, size.height - cy - 5), const Radius.circular(4)),
      Paint()..color = const Color(0xFF1B4332),
    );

    final handColor = const Color(0xFFE8B89D);
    final handPaint = Paint()..color = handColor;
    final outline = Paint()..color = Colors.white38..style = PaintingStyle.stroke..strokeWidth = 1.5;

    // Palm
    final palmRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx + 5, cy + 22), width: 95, height: 50), const Radius.circular(10));
    canvas.drawRRect(palmRect, handPaint);
    canvas.drawRRect(palmRect, outline);

    // Three support fingers (middle, ring, pinky)
    for (var i = 0; i < 3; i++) {
      final fx = cx + 10 + i * 18.0;
      final fp = Path()
        ..moveTo(fx - 6, cy + 2)
        ..lineTo(fx - 5, cy - 22)
        ..quadraticBezierTo(fx, cy - 28, fx + 5, cy - 22)
        ..lineTo(fx + 6, cy + 2)
        ..close();
      canvas.drawPath(fp, handPaint);
      canvas.drawPath(fp, outline);
    }

    // Index finger: bent, tip touching thumb tip to form "phoenix eye"
    final indexPath = Path()
      ..moveTo(cx - 10, cy + 2)
      ..quadraticBezierTo(cx - 20, cy - 18, cx - 28, cy - 14)
      ..quadraticBezierTo(cx - 35, cy - 10, cx - 30, cy - 2)
      ..lineTo(cx - 10, cy + 2)
      ..close();
    canvas.drawPath(indexPath, handPaint);
    canvas.drawPath(indexPath, outline);

    // Thumb: coming up from below, tip meeting index finger tip
    final thumbPath = Path()
      ..moveTo(cx - 42, cy + 15)
      ..lineTo(cx - 48, cy - 2)
      ..quadraticBezierTo(cx - 50, cy - 12, cx - 40, cy - 14)
      ..lineTo(cx - 30, cy - 2)
      ..close();
    canvas.drawPath(thumbPath, handPaint);
    canvas.drawPath(thumbPath, outline);

    // "Phoenix eye" connection point
    final eyeCenter = Offset(cx - 32, cy - 8);
    canvas.drawCircle(eyeCenter, 8, Paint()..color = const Color(0x44FF9800)..style = PaintingStyle.stroke..strokeWidth = 2.5);

    // Cue stick through the phoenix eye
    final cuePaint = Paint()..color = const Color(0xFFFFF8E1)..strokeWidth = 4..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 130, cy - 6), Offset(cx + 140, cy - 6), cuePaint);
    canvas.drawCircle(Offset(cx + 140, cy - 6), 3, Paint()..color = const Color(0xFF26C6DA));

    // Labels with arrows
    _arrow(canvas, Offset(cx - 80, cy - 45), eyeCenter + const Offset(-2, -10), const Color(0xFFFF9800));
    _lbl(canvas, '"凤眼"= 虎口', Offset(cx - 110, cy - 50), const Color(0xFFFF9800));
    _lbl(canvas, '食指尖搭拇指尖', Offset(cx - 100, cy - 38), const Color(0xFFFF9800));

    _lbl(canvas, '三指张开撑住台面', Offset(cx + 10, cy - 38), Colors.white54);
    _lbl(canvas, '球杆在凤眼中滑动', Offset(cx + 50, cy - 20), Colors.white54);

    // Side comparison note
    _lbl(canvas, '比闭合式更紧凑，视线更好', Offset(cx - 50, cy + 42), const Color(0xFF66BB6A));
  }

  void _arrow(Canvas c, Offset from, Offset to, Color cl) {
    c.drawLine(from, to, Paint()..color = cl..strokeWidth = 1.5);
    final d = to - from; final n = d / d.distance; final p = Offset(-n.dy, n.dx);
    c.drawPath(Path()..moveTo(to.dx, to.dy)
      ..lineTo(to.dx - n.dx * 6 + p.dx * 3, to.dy - n.dy * 6 + p.dy * 3)
      ..lineTo(to.dx - n.dx * 6 - p.dx * 3, to.dy - n.dy * 6 - p.dy * 3)..close(),
      Paint()..color = cl);
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _SpecialBridgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sectionW = w / 3;
    final scale = h / 200.0;
    final br = 10.0 * scale; // ball radius
    final cw = 4.0 * scale;  // cue width

    final tablePaint = Paint()..color = const Color(0xFF1B4332);
    final railPaint = Paint()..color = const Color(0xFF2D6A4F);
    final ballPaint = Paint()..color = Colors.white;
    final cuePaint = Paint()
      ..color = const Color(0xFFFFF8E1)
      ..strokeWidth = cw
      ..strokeCap = StrokeCap.round;
    final handPaint = Paint()..color = const Color(0xFFE8B89D);
    final fs = (12.0 * scale).clamp(10.0, 14.0);

    // Section 1: High bridge
    final s1cx = sectionW / 2;
    canvas.drawRect(Rect.fromLTWH(0, h * 0.5, sectionW - 4, h * 0.5), tablePaint);
    canvas.drawCircle(Offset(s1cx + 14 * scale, h * 0.45), br, Paint()..color = const Color(0xFFD32F2F));
    canvas.drawCircle(Offset(s1cx - 20 * scale, h * 0.35), 8 * scale, handPaint);
    canvas.drawCircle(Offset(s1cx - 32 * scale, h * 0.4), 7 * scale, handPaint);
    canvas.drawLine(Offset(s1cx - 60 * scale, h * 0.28), Offset(s1cx + 60 * scale, h * 0.28), cuePaint);
    canvas.drawCircle(Offset(s1cx + 60 * scale, h * 0.28), 3 * scale, Paint()..color = const Color(0xFF26C6DA));
    canvas.drawCircle(Offset(s1cx + 66 * scale, h * 0.5), br, ballPaint);
    _drawLabel(canvas, '高架杆', Offset(s1cx - 18, h * 0.06), const Color(0xFF26C6DA), fs);

    // Section 2: Rail bridge
    final s2cx = sectionW + sectionW / 2;
    canvas.drawRect(Rect.fromLTWH(sectionW + 2, h * 0.5, sectionW - 4, h * 0.5), tablePaint);
    canvas.drawRect(Rect.fromLTWH(sectionW + 2, h * 0.42, sectionW - 4, 14 * scale), railPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(s2cx, h * 0.36), width: 42 * scale, height: 22 * scale),
        Radius.circular(5 * scale)),
      handPaint,
    );
    canvas.drawLine(Offset(s2cx - 60 * scale, h * 0.33), Offset(s2cx + 60 * scale, h * 0.33), cuePaint);
    canvas.drawCircle(Offset(s2cx + 60 * scale, h * 0.33), 3 * scale, Paint()..color = const Color(0xFF26C6DA));
    canvas.drawCircle(Offset(s2cx + 66 * scale, h * 0.5), br, ballPaint);
    _drawLabel(canvas, '靠库架杆', Offset(s2cx - 26, h * 0.06), const Color(0xFF26C6DA), fs);

    // Section 3: Mechanical bridge (spider)
    final s3cx = 2 * sectionW + sectionW / 2;
    canvas.drawRect(Rect.fromLTWH(2 * sectionW + 2, h * 0.5, sectionW - 4, h * 0.5), tablePaint);
    final spiderPaint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..strokeWidth = 4 * scale;
    canvas.drawLine(Offset(s3cx - 36 * scale, h * 0.5), Offset(s3cx + 24 * scale, h * 0.5), spiderPaint);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(s3cx + 24 * scale, h * 0.44), width: 26 * scale, height: 18 * scale),
      Paint()..color = const Color(0xFF616161),
    );
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(s3cx + 15 * scale + i * 7.0 * scale, h * 0.38, 4 * scale, 8 * scale),
        Paint()..color = const Color(0xFF424242),
      );
    }
    canvas.drawLine(Offset(s3cx - 70 * scale, h * 0.36), Offset(s3cx + 70 * scale, h * 0.36), cuePaint);
    canvas.drawCircle(Offset(s3cx + 70 * scale, h * 0.36), 3 * scale, Paint()..color = const Color(0xFF26C6DA));
    canvas.drawCircle(Offset(s3cx + 76 * scale, h * 0.5), br, ballPaint);
    _drawLabel(canvas, '架杆器', Offset(s3cx - 18, h * 0.06), const Color(0xFF26C6DA), fs);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color, double fontSize) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _StrokeAndPower extends StatelessWidget {
  const _StrokeAndPower();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '出杆节奏'),
        _InfoCard(children: [
          _BL(items: [
            '1. 试杆（warm-up strokes）：前后轻柔试杆 3-5 次，找准节奏',
            '2. 停顿（pause）：最后一次拉回杆时短暂停顿，确认瞄准',
            '3. 出杆（delivery）：平稳向前推送，不要猛戳',
            '4. 送杆（follow-through）：杆头穿过母球位置继续向前延伸',
          ]),
          _Tip('出杆后保持趴下的姿势 1-2 秒（"定杆"），不要急于起身看结果。这能纠正很多初学者的常见问题。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '发力控制'),
        _InfoCard(children: [
          _P('力度分五档来理解：'),
          SizedBox(height: 8),
          _BL(items: [
            '1 档（轻推）：近距离定杆、微调',
            '2 档（中轻）：短距离走位',
            '3 档（中力）：常规击球，最常用',
            '4 档（大力）：长距离走位、翻袋',
            '5 档（全力）：仅用于开球',
          ]),
          _Tip('80% 的击球用 2-3 档力度就够了。大力更难控制白球，初学者应克制发力冲动。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '常见杆法术语'),
        _InfoCard(children: [
          _BL(items: [
            '跟杆（Follow / 高杆）：击打母球上部，母球带前旋碰到目标球后继续向前跟进',
            '缩杆（Draw / 拉杆 / 低杆）：击打母球下部，母球带回旋碰到目标球后向后缩回',
            '定杆（Stop / Stun / 中杆）：击打母球正中心，近距离时母球撞击后原地停住',
            '推杆（Push / 登杆）：中力偏上击打，母球滑行后微微跟进，行进距离可控',
            '扎杆（Massé）：球杆几乎垂直击打母球侧面，让母球走弧线绕过障碍',
            '跳球（Jump）：球杆大角度向下戳击母球，使母球跳离台面跃过障碍球',
            '刹车球（Nip Draw）：短促低杆，母球碰到目标球后只缩回很短距离',
            '登杆（Drag）：中高杆配合中等力度，母球先滑行再慢慢跟进',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '杆法与击球点对照'),
        _InfoCard(children: [
          _SpinDiagramWidgetVertical(),
          SizedBox(height: 8),
          _BL(items: [
            '高杆（偏上）→ 跟杆 / 推杆 / 登杆',
            '中杆（正中）→ 定杆 / 滑行',
            '低杆（偏下）→ 缩杆 / 拉杆 / 刹车球',
          ]),
          _Tip('杆法的核心是"击球点 + 力度 + 出杆速度"的组合。'
              '同样的高杆，轻打是推杆效果，重打才是大跟杆。'),
        ]),
        const _QA(items: [
          (q: '如何提高出杆直线度？', a: '慢速练习定杆：只动前臂、大臂固定，出杆后保持姿势 1–2 秒观察杆头是否沿瞄准线延伸。每天空杆或直线定杆练习 10 分钟，比猛打有效得多。'),
          (q: '"定杆"是什么意思？', a: '出杆后球杆停在穿过母球的位置，身体保持趴下不动，用来检查出杆是否直、瞄准是否准。也是中杆近台击球后母球停住的效果名称。'),
          (q: '为什么送杆很重要？', a: '送杆让杆头充分穿过母球，传递完整动量并减少侧旋干扰。收杆过早会导致戳球、跳球或力度失控。'),
          (q: '击球时母球"跳"起来怎么办？', a: '通常是杆头戳击母球上部或出杆过陡。降低杆头角度，击打中心偏下一点，出杆平稳推送而非猛戳，并检查台面是否平整。'),
          (q: '跟杆和推杆有什么区别？', a: '跟杆是大力高杆，母球碰目标球后大幅度跟进；推杆是中力偏上杆，母球先滑行再慢慢跟进，距离更短更可控。实战中推杆用得更多。'),
          (q: '缩杆打不出来怎么办？', a: '缩杆三要素：1) 低击球点（但不要太低打滑）；2) 出杆速度要快（不是力度大）；3) 快速收杆不送杆。另外检查皮头是否粗糙够"吃球"，新皮头或太滑的皮头打不出缩杆。'),
        ]),
      ]);
}

class _StrokeTroubleshooting extends StatelessWidget {
  const _StrokeTroubleshooting();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '出杆总是偏左 / 偏右'),
        _InfoCard(children: [
          _P('球系统性地往一边跑，通常有以下原因（按可能性排序）：'),
          SizedBox(height: 8),
          _BL(items: [
            '后手位置偏移 — 握杆手不在手肘正下方，出杆时球杆走弧线而非直线',
            '手腕内翻 / 外翻 — 击球瞬间手腕不自觉扭动，带偏杆头方向',
            '主视眼错位 — 主视眼与球杆不在同一侧，瞄准线本身就有偏差',
            '身体朝向不对 — 站位角度和出杆方向有夹角，造成系统性偏移',
          ]),
          _Tip('自检方法：让朋友从正后方拍视频，看你的球杆出杆时是否走直线。大部分偏差自己感觉不到，但从后面看一目了然。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '试杆越多越歪'),
        _InfoCard(children: [
          _P('新手常见：不试杆反而准，试杆几次后打歪了。原因是"二次瞄准干扰"：'),
          SizedBox(height: 8),
          _BL(items: [
            '趴下后第一感觉瞄准是对的（大脑已完成角度判断）',
            '试杆时眼睛在母球和目标球之间来回看，越看越怀疑',
            '微调杆的方向 → 再调回来 → 最终完全偏离初始瞄准线',
          ]),
          _Tip('正确做法：站着的时候确定方向，趴下后不再改方向。试杆只是让手臂热身，不是重新瞄准。试杆时眼睛盯住目标球，最后一次前推时果断出杆。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '拉杆长了就打歪'),
        _InfoCard(children: [
          _P('拉杆行程越长，偏差被放大的概率越大：'),
          SizedBox(height: 8),
          _BL(items: [
            '大臂跟着动了 — 应该只有前臂像钟摆运动，大臂完全不动',
            '手架松动 — 前手没有"钉"在台面上，杆头跟着晃',
            '握杆过紧 — 发力时整个手臂僵硬，杆尾翘起或偏移',
          ]),
          _Tip('拉杆行程长不等于力度大。力度来自出杆的加速度，而非行程距离。试试正常拉杆距离，出杆瞬间"鞭打"加速，既准又有力。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '远台直球打不进'),
        _InfoCard(children: [
          _BL(items: [
            '小偏差在远距离被放大 — 杆头偏1mm，到远端可能差几厘米',
            '身体晃动 — 距离越远，对出杆稳定性要求越高',
            '视觉误差 — 远距离时假想球位置更难精确判断',
          ]),
          _Tip('练习方法：从30cm开始打直球，能连续进10个后增加距离。每次增加约30cm，直到全台长度。不要一上来就练远台。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '出杆时身体/头抬起'),
        _InfoCard(children: [
          _P('最常见的初学者坏习惯，也是职业选手和业余的最大区别之一：'),
          SizedBox(height: 8),
          _BL(items: [
            '急于看结果 — 出杆瞬间就抬头看球进没进，带动身体上移',
            '杆尾翘起 — 头一抬，后手位置跟着变，球杆不再水平',
            '瞄准白搭 — 趴了几秒钟仔细瞄，一抬头全浪费了',
          ]),
          _Tip('强制纠正：出杆后数"一、二"再起身。把"定杆（冻住）"当作击球动作的一部分，不是可选项。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '主视眼自检'),
        _InfoCard(children: [
          _P('不知道主视眼是哪只，瞄准可能一直偏：'),
          SizedBox(height: 8),
          _BL(items: [
            '双手伸直，拇指和食指做一个小三角对准远处某个点',
            '交替闭左眼和右眼',
            '目标没动的那只眼就是你的主视眼',
            '球杆应对准主视眼正下方',
          ]),
          _Tip('如果主视眼和握杆手不同侧（交叉主导），需要调整下巴位置或站位角度来补偿，这很正常，不少职业选手也是如此。'),
        ]),
        _QA(items: [
          (q: '我试杆不试杆都打歪怎么办？', a: '回到最基础：放弃进球目标，只练空杆直线。台面上贴一条胶带，练习杆头沿直线前后运动。每天50杆，一周内会有明显改善。'),
          (q: '握杆应该多紧？', a: '想象握一个纸杯——既不能松到掉，也不能紧到捏扁。出杆时后三指自然松开，击球瞬间虎口稍微收紧即可。'),
          (q: '为什么别人出杆看起来很轻松但球很有力？', a: '因为他们的力量来自手腕加速（鞭打效应），而不是整条手臂的僵硬用力。松弛的出杆 + 加速的鞭打 = 力度大且准确。'),
          (q: '什么时候该去找教练？', a: '如果你认真练了2-3个月，基本功仍没有明显进步（直球进球率低于60%），建议找教练纠正动作。坏习惯练久了反而更难改。'),
        ]),
      ]);
}

// ===========================================================================
// Content builders — 瞄准与进球
// ===========================================================================
class _DominantEyeGuide extends StatelessWidget {
  const _DominantEyeGuide();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '主视眼与瞄准'),
        _InfoCard(children: [
          _P('人的两只眼睛中有一只是"主导眼"（dominant eye），大脑主要用它来判断方向和距离。'
             '台球瞄准时，必须让主视眼正对球杆线，否则瞄准方向会有系统性偏差。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '自测主视眼'),
        _InfoCard(children: [
          _BL(items: [
            '双手伸直，拇指和食指围成一个小三角形',
            '双眼睁开，透过三角形对准远处一个物体',
            '闭左眼 → 物体仍在三角形内 = 右眼主导',
            '闭右眼 → 物体仍在三角形内 = 左眼主导',
          ]),
          _Tip('约 70% 的人是右眼主导。主视眼通常和惯用手在同一侧，但不一定。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '下巴位置调整'),
        _InfoCard(children: [
          _P('趴下瞄准时，下巴贴杆。关键是让主视眼正好在球杆正上方：'),
          SizedBox(height: 8),
          _BL(items: [
            '右眼主导：下巴稍偏左，使右眼对准球杆中心线',
            '左眼主导：下巴稍偏右，使左眼对准球杆中心线',
            '验证方法：趴下后闭合非主视眼，球杆方向不应有偏移',
          ]),
          _Tip('如果闭眼后发现球杆方向"跳动"了，说明头部位置需要调整。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '瞄准视线循环'),
        _InfoCard(children: [
          _P('职业选手的视线使用方法：'),
          SizedBox(height: 8),
          _BL(items: [
            '站立阶段：双眼观察进球线，从球后方确认方向',
            '趴下对准：视线在母球和目标球之间来回 2-3 次',
            '出杆瞬间：视线锁定在目标球（或接触点）上！',
            '出杆后：保持姿势 1-2 秒，不要急于抬头',
          ]),
          _Tip('出杆时看目标球而非母球，是职业与业余的最大区别之一。看母球会导致下意识调整出杆方向。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '长距离瞄准要点'),
        _InfoCard(children: [
          _P('长距离球（超过半台）是准度最大的挑战，因为微小的方向偏差会被放大。'),
          SizedBox(height: 8),
          _BL(items: [
            '先确认"目标球→袋口"方向（近端，准确度高）',
            '再确认假想球位置',
            '最后对齐母球→假想球（每段独立确认，减少累积误差）',
            '力度中等偏小 — 大力容易偏，且走位难控制',
            '前手桥要稳 — 长距离时桥手不稳影响巨大',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '母球边缘对准法（简化 CTE）'),
        _InfoCard(children: [
          _P('一种快速估算切角的方法，用母球和目标球的相对位置关系判断厚薄：'),
          SizedBox(height: 8),
          _BL(items: [
            '直球（0°）：母球中心 → 目标球中心',
            '3/4 球（~15°）：母球中心 → 目标球中心与边缘之间',
            '半球（~30°）：母球边缘 → 目标球中心',
            '1/4 球（~48°）：母球边缘 → 目标球边缘',
          ]),
          _Tip('这种方法在长距离时比假想球法更实用，因为不依赖视觉上的假想球位置。详见理论实验室的 CTE 瞄准法。'),
        ]),
        SizedBox(height: 16),
        _QA(items: [
          (q: '用哪只眼睛瞄准？', a: '始终双眼睁开。但头部位置要让主视眼对准球杆中心线。不要闭一只眼瞄准，会丧失立体视觉。'),
          (q: '双眼看到两条线怎么办？', a: '这是正常的双眼视差。以主视眼看到的那条线为准。趴下后闭合非主视眼确认方向，然后双眼睁开出杆。'),
          (q: '为什么出杆时要看目标球？', a: '看母球会引起无意识的微调，导致出杆方向偏移。锁定目标球让身体自动完成"手眼协调"。类似投篮时看篮筐而非球。'),
          (q: '主视眼和惯用手不同侧怎么办？', a: '这叫"交叉主导"（cross-dominant）。需要更大幅度地调整下巴位置。有些选手甚至会调整站位角度来补偿。'),
        ]),
      ]);
}

class _GhostBall extends StatelessWidget {
  const _GhostBall();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '假想球瞄准法'),
        _InfoCard(children: [
          _P('最基础也最重要的瞄准方法。设想母球在碰撞瞬间应该到达的位置（假想球），然后朝那个位置击球。'),
          SizedBox(height: 12),
          _AimDiagramWidget(),
          SizedBox(height: 12),
          _BL(items: [
            '假想球（Ghost Ball）= 母球与目标球碰撞时母球所在的位置',
            '假想球的中心在"目标球中心→袋口"连线的延长线上',
            '假想球与目标球刚好相切（紧挨着）',
            '你只需要瞄准假想球的中心，打过去就行',
          ]),
          _Tip('练习方法：不放母球，先用眼睛找到假想球位置，然后摆一颗球验证。反复练习直到你能秒判假想球位。'),
        ]),
        SizedBox(height: 12),
        _LegendRow(color: Color(0xFF66BB6A), label: '绿色虚线 = 母球瞄准方向'),
        _LegendRow(color: Color(0xFFFFEB3B), label: '黄色虚线 = 目标球预测路径'),
        _LegendRow(color: Color(0xFF00BFFF), label: '蓝色虚线 = 母球分离路径'),
        _LegendRow(color: Color(0x99FFFFFF), label: '半透明圈 = 假想球'),
        _LegendRow(color: Color(0xFFFF5722), label: '红色圆点 = 接触点'),
        const _QA(items: [
          (q: '怎么练习假想球瞄准？', a: '先不放母球，用眼睛找到假想球位置，再摆一颗球验证是否相切。反复练习不同角度，直到能秒判假想球位。'),
          (q: '为什么远距离时假想球法容易失效？', a: '距离越远，瞄准误差被放大，且母球运行中会受摩擦力、侧旋影响。远距离需更依赖厚薄感和经验修正。'),
          (q: '看不到假想球位置怎么办？', a: '从袋口向目标球画一条线，在目标球后方、与目标球相切的位置就是假想球中心。也可以借助辅助线或先在脑中标记接触点。'),
          (q: '假想球法能和其他瞄准法结合吗？', a: '可以。先用假想球确定大致方向，再用厚薄比例（几分球）微调，碰库走位时还要结合高低杆和分离角。'),
        ]),
      ]);
}

class _CutAngle extends StatelessWidget {
  const _CutAngle();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '切角（Cut Angle）'),
        _InfoCard(children: [
          _P('切角是瞄准方向与球心连线之间的夹角，决定了你需要"切"多少。'),
          SizedBox(height: 12),
          _CutAngleDiagramWidget(),
          SizedBox(height: 12),
          _BL(items: [
            '0° = 直球（正面撞击），最容易',
            '15° = 几乎正面，薄薄切一点',
            '30° = 半厚球，常见角度',
            '45° = 半球，母球和目标球各偏 45°',
            '60° = 薄球，需要精确瞄准',
            '75°+ = 极薄球，高难度',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '厚薄与切角的关系'),
        _InfoCard(children: [
          _P('老师傅常说"打几分球"，指的是厚薄比例：'),
          SizedBox(height: 8),
          _BL(items: [
            '全厚 = 正面击中 = 切角 ≈ 0°',
            '3/4 厚 ≈ 切角 14°',
            '1/2 厚（半球）≈ 切角 30°',
            '1/4 厚 ≈ 切角 48°',
            '极薄 ≈ 切角 70°+',
          ]),
          _Tip('记住公式：厚度 = cos(切角)。半球就是 cos30° ≈ 0.87，所以实际覆盖量比"一半"更多。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '直角三角形辅助'),
        _InfoCard(children: [
          _P('碰撞瞬间的几何可以用直角三角形来理解，帮助判断力度分配：'),
          SizedBox(height: 12),
          _TriangleDiagramWidget(),
          SizedBox(height: 12),
          _BL(items: [
            '斜边 = 母球运动方向（你击球的方向）',
            '邻边 = 目标球运动方向（碰撞法线）',
            '对边 = 母球偏转方向（碰撞切线）',
            '标注的倍数比帮助估算力度分配',
          ]),
        ]),
        const _QA(items: [
          (q: '不用量角器怎么估算切角？', a: '用厚薄感：全厚≈0°、3/4厚≈15°、半球≈30°、1/4厚≈45°。练习时对照辅助线显示的角度，培养肉眼判断能力。'),
          (q: '厚薄和切角是什么关系？', a: '切角越大，球越薄，母球覆盖目标球的比例越小。记住：厚度 ≈ cos(切角)，半球实际覆盖比"一半"更多。'),
          (q: '切角不同时母球会怎样走？', a: '薄球时母球偏转大、目标球获得的力小；厚球时母球偏转小、目标球更容易入袋。中杆滑行时，切角 + 母球偏转角 ≈ 90°。'),
          (q: '薄球总是打不进怎么办？', a: '先确认假想球位置，薄球需适当加力。从 30° 以内练起，逐步增加切角，不要一上来就练极薄球。'),
        ]),
      ]);
}

class _PottingLines extends StatelessWidget {
  const _PottingLines();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PottingLinesDiagramWidget(),
        SizedBox(height: 16),
        _SectionHeader(title: '直球线路'),
        _InfoCard(children: [
          _P('母球、目标球、袋口三点一线时为直球，只需中杆正面击打。'),
          SizedBox(height: 8),
          _BL(items: [
            '高杆直球：母球跟进，走到袋口附近',
            '中杆直球：母球停住（定杆）或微微跟进',
            '低杆直球：母球回缩（拉杆/缩杆）',
          ]),
          _Tip('直球是最基本的进球方式，务必先把直球练到 95% 以上成功率再练薄球。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '薄球线路'),
        _InfoCard(children: [
          _BL(items: [
            '薄球时目标球偏离母球前进方向更大',
            '注意假想球位置偏移',
            '薄球越薄，给目标球的力越小，需要适当加大力度',
            '极薄球对精度要求极高，非必要不选极薄线路',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '翻袋与借力'),
        _InfoCard(children: [
          _P('目标球无法直接入袋时，可以利用库边反弹：'),
          SizedBox(height: 8),
          _BL(items: [
            '一库翻袋：目标球碰一次库边后入袋',
            '入射角 ≈ 反射角（近似规律）',
            '加塞可以改变反弹角度',
            '借力球：母球碰到一颗球后再碰目标球入袋',
          ]),
          _Tip('翻袋要考虑旋转的影响。干净的中杆击球，反射角度最可预测。'),
        ]),
        const _QA(items: [
          (q: '有多条进球线路时选哪条？', a: '优先选成功率最高、且母球能走到下一球理想位置的线路。直球和小角度球通常比薄球和翻袋更可靠。'),
          (q: '直球和翻袋怎么选？', a: '能直球就直球——成功率更高、母球路径更可预测。翻袋只在被挡或直球无法走位时使用，并预留旋转和力度的修正空间。'),
          (q: '什么时候该打安全球而不是强行进球？', a: '没有高成功率进球、或进球后母球会停在危险位置时。冒险进攻失败代价大于安全球时，防守更明智。'),
          (q: '翻袋线路怎么练？', a: '从中杆、一库、大角度练起，记住入射角≈反射角只是近似。先练定杆翻袋建立信心，再逐步加塞改变反弹角。'),
        ]),
      ]);
}

// ===========================================================================
// Content builders — 走位与加塞
// ===========================================================================
class _DeflectionAngle extends StatelessWidget {
  const _DeflectionAngle();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '分离角原理'),
        _InfoCard(children: [
          _P('母球撞击目标球后，两球的运动路径会形成一个夹角，叫分离角。'),
          SizedBox(height: 8),
          _DeflectionDiagramWidget(),
          SizedBox(height: 8),
          _BL(items: [
            '无旋转（中杆滑行）时：分离角 ≈ 90°',
            '这是台球走位的基础定律',
            '理想状态下：切角 + 母球偏转角 = 90°',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '分离角变化'),
        _InfoCard(children: [
          _P('实际打球中分离角会受旋转影响：'),
          SizedBox(height: 8),
          _BL(items: [
            '高杆（跟进旋转）→ 分离角 < 90°，母球追着目标球走',
            '低杆（回缩旋转）→ 分离角 > 90°，母球往回走',
            '中杆（滑行）→ 分离角 ≈ 90°',
            '力度越大，旋转影响越明显',
          ]),
          _Tip('核心概念：理解 90° 分离角是走位的起点，高低杆是在此基础上调整。'),
        ]),
        const _QA(items: [
          (q: '为什么 90° 分离角对走位很重要？', a: '它是中杆无旋转时的基准：知道切角就能预测母球偏转方向，从而规划下一球位置。所有高低杆走位都在此基础上调整。'),
          (q: '旋转怎样改变分离角？', a: '高杆（跟进）使分离角 < 90°，母球追着目标球走；低杆（回缩）使分离角 > 90°，母球往回走。力度越大，旋转影响越明显。'),
          (q: '分离角是不是永远正好 90°？', a: '不是。90° 是无旋转、中杆滑行的理想近似。实际打球中旋转、力度、摩擦都会改变分离角，高手正是利用这些变化控制走位。'),
          (q: '怎么用分离角规划下一球？', a: '击球前想象母球碰撞后的偏转路径，判断能否到达下一球理想区域。切角大时母球偏转也大，需提前算好停球位置。'),
        ]),
      ]);
}

class _HighMidLow extends StatelessWidget {
  const _HighMidLow();
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionHeader(title: '击球点位'),
        const _InfoCard(children: [
          _P('球杆击打母球的不同位置会产生不同的旋转效果：'),
          SizedBox(height: 12),
          _SpinDiagramWidgetVertical(),
          SizedBox(height: 12),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '高杆（跟进球）'),
        const _InfoCard(children: [
          _BL(items: [
            '击球点在母球中心偏上',
            '母球带前旋，碰到目标球后继续向前',
            '适合需要母球跟进到某个位置的走位',
            '力度越大，跟进越远',
          ]),
          _Tip('练习要领：出杆要穿透、送杆充分。高杆的关键不是打得高，而是送杆要长。'),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '中杆（定杆/滑行）'),
        const _InfoCard(children: [
          _BL(items: [
            '击球点在母球正中心',
            '母球不带旋转，滑行撞击',
            '近距离：母球撞后停住（定杆效果）',
            '远距离：因摩擦力会转为微弱前旋',
          ]),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '低杆（缩杆/拉杆）'),
        const _InfoCard(children: [
          _BL(items: [
            '击球点在母球中心偏下',
            '母球带回旋，碰到目标球后回缩',
            '距离越近、力度越大，缩杆效果越明显',
            '需要良好的出杆质量和皮头状态',
          ]),
          _Tip('缩杆的关键：快速出杆 + 快速收杆。出杆速度比力度重要。'),
        ]),
        const SizedBox(height: 12),
        const _SectionHeader(title: '高/中/低杆路线对比'),
        SizedBox(height: 110, width: double.infinity, child: CustomPaint(painter: _FollowStopDrawPathPainter())),
        const _QA(items: [
          (q: '缩杆至少需要多远的距离？', a: '近台 30 cm 以内效果最明显；超过一杆长距离，缩杆效果会大幅减弱。远距离缩杆需要更大力度和更好的皮头状态。'),
          (q: '为什么皮头状态影响高低杆？', a: '皮头磨损或沾灰会导致打滑，低杆尤其容易"溜杆"无法产生回缩旋转。保持皮头清洁、适当打磨，是稳定高低杆的前提。'),
          (q: '怎么练习高低杆的一致性？', a: '固定距离和力度，只改变击球点：中心、偏上、偏下各练 20 杆。观察母球停位差异，建立"击球点→效果"的肌肉记忆。'),
          (q: '高杆和低杆可以混用吗？', a: '每一杆只选一种主效果。需要跟进用高杆，需要回缩用低杆，需要定杆用中杆。混用击球点会导致旋转冲突、走位不可预测。'),
        ]),
      ]);
}

class _SideSpin extends StatelessWidget {
  const _SideSpin();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '左右塞基础'),
        _InfoCard(children: [
          _P('在母球左侧或右侧击打，会给母球加上侧旋（塞），影响碰库后的反弹角度。'),
          SizedBox(height: 8),
          _SideSpinDiagramWidget(),
          SizedBox(height: 8),
          _BL(items: [
            '左塞（左旋）：母球碰库后偏左反弹',
            '右塞（右旋）：母球碰库后偏右反弹',
            '不加塞时碰库角度遵循"入射角 = 反射角"',
            '加塞后反弹角度会改变',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '让点与偏移'),
        _InfoCard(children: [
          _P('加塞会导致两个重要偏差：'),
          SizedBox(height: 8),
          _BL(items: [
            '让点（squirt/deflection）：出杆瞬间母球偏离球杆方向',
            '弧线（swerve/curve）：母球在台面上走弧线而非直线',
            '这两个偏差方向相反，部分抵消',
            '加塞越多，偏差越大，进球难度越高',
          ]),
          _Tip('初学者建议：先学会不加塞的走位，80% 的局面不需要加塞就能解决。'
              '只在必须改变碰库反弹角度时才加塞。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '常用塞法'),
        _InfoCard(children: [
          _BL(items: [
            '顺塞：母球行进方向的同侧塞，碰库后角度变大',
            '逆塞：母球行进方向的反侧塞，碰库后角度变小',
            '高低杆 + 塞 = 组合旋转，效果复杂但强大',
          ]),
        ]),
        const _QA(items: [
          (q: '什么时候该加塞、什么时候不加？', a: '80% 的局面中杆不加塞就能解决。只在必须改变碰库反弹角度、或需要特殊弧线走位时才加塞。'),
          (q: '怎么补偿加塞的让点（squirt）？', a: '加左塞时瞄准略偏右，加右塞时略偏左。让点量与加塞程度和球杆有关，需通过反复练习建立个人补偿量。'),
          (q: '顺塞和逆塞实战中怎么用？', a: '顺塞：母球行进方向的同侧塞，碰库后角度变大，适合"放大"反弹角。逆塞：反侧塞，碰库后角度变小，适合"收紧"反弹角。'),
          (q: '加塞后进球变难怎么办？', a: '减少加塞量，或改用高低杆走位代替侧旋。初学者先练无塞走位，加塞是进阶技能，不是每杆必备。'),
        ]),
      ]);
}

class _PositionPlan extends StatelessWidget {
  const _PositionPlan();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '走位思维'),
        _InfoCard(children: [
          _P('走位是台球的灵魂。进球只是基础，控制母球到达下一球的理想位置才是高手和新手的分水岭。'),
          SizedBox(height: 8),
          _BL(items: [
            '每一杆先想下一球在哪里',
            '母球到达的位置要让下一球有简单的进球角度',
            '避免母球停在需要大角度或极薄球的位置',
          ]),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '走位区域'),
        _InfoCard(children: [
          _P('不要追求母球停在精确的某个点，而是停在一个"区域"内：'),
          SizedBox(height: 8),
          _PositionZoneDiagramWidget(),
          SizedBox(height: 8),
          _BL(items: [
            '理想区域：下一球是直球或小角度球的位置范围',
            '可接受区域：下一球能进但角度不理想',
            '危险区域：下一球极难或无法进球',
            '区域越大越好——给自己留容错空间',
          ]),
          _Tip('高手的秘诀：永远给自己留"犯错的余地"。'
              '与其追求精确走位到 1 个点，不如规划一个 30cm 的安全区域。'),
        ]),
        const _QA(items: [
          (q: '走位应该提前想几球？', a: '至少想 2–3 球，清台时想 3–4 球。不必规划全部，但关键球和下一球必须有明确计划。'),
          (q: '走位计划被打乱了怎么办？', a: '立即重新评估：当前最佳进球选择是什么？母球能走到哪？灵活调整比死守原计划更重要。'),
          (q: '什么时候"区域走位"就够了？', a: '下一球角度宽容、有多条备选线路时，停在理想区域内即可。只有下一球角度苛刻、或需要精确碰库时，才追求精确停点。'),
          (q: '如何避免走到"死球"位置？', a: '击球前反向思考：这杆打完后母球最坏会停在哪？如果最坏情况无法接受，换线路或打安全球。'),
        ]),
      ]);
}

// ===========================================================================
// Content builders — 开球与战术
// ===========================================================================
class _BreakShot extends StatelessWidget {
  const _BreakShot();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '开球基本要求'),
        _InfoCard(children: [
          _BL(items: [
            '母球放在开球线后（通常偏中或偏左/右）',
            '必须至少 4 颗球碰库或有球入袋',
            '追求散布均匀 + 有球入袋',
            '母球应控制在台面中心区域',
          ]),
        ]),
        SizedBox(height: 12),
        _BreakShotDiagramWidget(),
        SizedBox(height: 16),
        _SectionHeader(title: '开球技巧'),
        _InfoCard(children: [
          _BL(items: [
            '瞄准三角架的首颗球正面（全厚击打）',
            '击球点在母球中心偏上一点点（避免跳球）',
            '全力出杆但保持动作平稳',
            '送杆要完整，不要"刹车"',
            '开球后母球停在台面中央是理想结果',
          ]),
          _Tip('开球不是比谁力气大，而是比谁发力质量好。'
              '松弛、协调的发力比蛮力更有效。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '常见开球阵位'),
        _InfoCard(children: [
          _BL(items: [
            '正中开球：母球在开球线正中，最常见',
            '偏位开球：母球偏左/右，增大 8 号球入袋概率',
            '二排球开球：瞄准三角形第二排球，特殊战术',
          ]),
        ]),
        const _QA(items: [
          (q: '开球时母球放哪里最好？', a: '开球线正中或略偏左/右均可。正中散布均匀，偏位可增大特定袋口入球概率。避免贴库或过于靠边，否则发力受限。'),
          (q: '开球应该用多大力？', a: '全力但动作协调——不是蛮力戳球。松弛、完整的送杆比单纯用力更有效。目标是散布均匀且有球入袋。'),
          (q: '开球后应该做什么？', a: '观察台面：哪些球可打、球堆是否散开、母球停位是否安全。如果有球入袋且局面好，立即规划清台顺序；否则考虑防守。'),
          (q: '开球没进球算失败吗？', a: '不算。开球的首要目标是合法开球（4 球碰库或入袋）+ 球堆散开。没进球但局面占优，依然是好开球。'),
        ]),
      ]);
}

class _RunOut extends StatelessWidget {
  const _RunOut();
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionHeader(title: '清台前的规划'),
        const _InfoCard(children: [
          _P('接过球权后，不要急着打第一球。先观察全局，在脑中规划 3-4 球的顺序。'),
          SizedBox(height: 8),
          _BL(items: [
            '从后往前想：先想 8 号球打哪个袋、倒数第 2 球在哪',
            '找到"关键球"：位置不好或被挡住的难球',
            '优先处理关键球，把容易的球留到后面',
            '避免提前打掉对方球的"屏障"',
          ]),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '清台顺序原则'),
        const _InfoCard(children: [
          _BL(items: [
            '1. 难球先打：位置不利的球先解决',
            '2. 近库球优先：贴库球难度大，有机会就打',
            '3. 对方屏障最后动：挡住对方球的己方球留着',
            '4. 8 号路径保持畅通：不要用其他球挡住 8 号的进球路径',
            '5. 保持连贯性：每一球走位到下一球',
          ]),
          _Tip('一句话总结：先难后易，保持连贯，最后打 8。'),
        ]),
        const SizedBox(height: 12),
        SizedBox(height: 130, width: double.infinity, child: CustomPaint(painter: _ClearanceOrderPainter())),
        const _QA(items: [
          (q: '怎么识别"关键球"？', a: '位置差、被挡、贴库、或角度极难的那颗球就是关键球。它若留到最后可能断台，应优先在局面好时解决。'),
          (q: '8 号球路径被挡住了怎么办？', a: '提前用其他球让路或借位，把挡路的球先打掉。清台过程中始终留意 8 号能否从当前母球位置直达目标袋。'),
          (q: '什么时候可以偏离原定顺序？', a: '当原计划走位失败、出现更好的机会、或关键球位置恶化时。灵活调整比死守顺序更重要，但调整后要重新规划后续。'),
          (q: '清台时要不要先打对方的球？', a: '通常不主动打，除非它是障碍或能帮你让路。打掉对方球可能帮对手解困，除非规则允许且对你有利。'),
        ]),
      ]);
}

class _Safety extends StatelessWidget {
  const _Safety();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '什么时候打安全球'),
        _InfoCard(children: [
          _BL(items: [
            '没有高成功率的进球选择时',
            '进球后无法走到好的下一球位置时',
            '对方局面很差，打安全球能锁住优势',
            '台面球堆紧密，冒险进攻不划算时',
          ]),
        ]),
        SizedBox(height: 12),
        _SafetyDiagramWidget(),
        SizedBox(height: 16),
        _SectionHeader(title: '安全球战术'),
        _InfoCard(children: [
          _BL(items: [
            '贴库：将母球或目标球贴到库边，增加对方进球难度',
            '做斯诺克：用其他球挡住对方目标球与母球之间的路线',
            '拆散球堆后将母球走到安全位置',
            '把对方的球推到不利位置（如贴库、被挡）',
          ]),
          _Tip('安全球不是"认输"，而是最聪明的策略。'
              '世界冠军也经常打安全球，这是比赛中赢得优势的重要手段。'),
        ]),
        const _QA(items: [
          (q: '打安全球是不是"胆小"？', a: '不是。安全球是战术选择，在进攻成功率低时主动交换球权、迫使对手犯错。高手和冠军都频繁使用。'),
          (q: '怎么练习安全球？', a: '设定局面：无直球可打时，练习贴库、做斯诺克、把母球藏在球堆后面。重点评估：对方下一杆有多难。'),
          (q: '什么时候防守比进攻更好？', a: '进球成功率低于 50%、或进球后母球会送给对方好机会时。比分领先时更倾向防守，落后时可适当冒险。'),
          (q: '安全球打不好怎么办？', a: '降低力度、追求精确控制而非大力。贴库时母球越贴库对方越难打；做斯诺克时确保目标球完全被挡。'),
        ]),
      ]);
}

// ===========================================================================
// Content builder — 分级练球指南
// ===========================================================================
class _PracticeGuide extends StatelessWidget {
  const _PracticeGuide();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionHeader(title: '入门级（直球与定杆）'),
      const _InfoCard(children: [
        _P('先把直球练到 90% 以上进球率，这是一切的基础。'),
        SizedBox(height: 4),
        _BL(items: [
          '中杆直球：母球与目标球一条线，中杆击打',
          '定杆：击球后母球停住不动',
          '不同距离：近台 → 中台 → 远台',
          '四个袋口都要练，培养方向感',
        ]),
      ]),
      const SizedBox(height: 6),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'straight_line')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'stop_shot')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'short_straight')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'pocket_practice')),

      const SizedBox(height: 16),
      const _SectionHeader(title: '五分球水平测试'),
      const _InfoCard(children: [
        _P('经典五分球是中式八球最常用的水平评估方法：'),
        SizedBox(height: 4),
        _BL(items: [
          '5 颗球放在固定位置，从开球区出发',
          '连续进完 5 球不犯规 = 得 5 分',
          '任何失误（未进/犯规）= 0 分，重来',
          '打 10 局计总分（满分 50 分）',
        ]),
        _Tip('评级：0-10 入门 | 11-25 初级 | 26-35 中级 | 36-45 高级 | 46-50 专业'),
      ]),
      const SizedBox(height: 6),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'five_ball_test')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'five_ball_l')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'five_ball_scatter')),

      const SizedBox(height: 16),
      const _SectionHeader(title: '初级（切角与进袋）'),
      const _InfoCard(children: [
        _P('掌握不同角度的切球，练习中袋和长台。'),
        SizedBox(height: 4),
        _BL(items: [
          '从小切角（15°）开始，逐步增大到 45°、60°',
          '薄球：理解 "看多少" 的概念',
          '中袋进球角度更刁，需要更高精度',
          '长台直球考验瞄准稳定性',
        ]),
      ]),
      const SizedBox(height: 6),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'cut_angles')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'thin_cut')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'mid_pocket')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'long_pot')),

      const SizedBox(height: 16),
      const _SectionHeader(title: '中级（走位与力度控制）'),
      const _InfoCard(children: [
        _P('学会用高杆跟进、低杆缩杆和力度控制走位。'),
        SizedBox(height: 4),
        _BL(items: [
          '高杆：不同力度的跟进距离',
          '低杆：不同距离的缩杆效果',
          '区域控制：停球到指定区域',
          '定杆走位：用力度差异控制走位',
          '加塞：改变碰库反弹角',
        ]),
      ]),
      const SizedBox(height: 6),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'follow_draw')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'position_play')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'zone_control')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'stun_run')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'side_spin_basic')),

      const SizedBox(height: 16),
      const _SectionHeader(title: '高级（翻袋、战术与清台）'),
      const _InfoCard(children: [
        _P('翻袋、解球、防守、连续清台——综合实战能力。'),
        SizedBox(height: 4),
        _BL(items: [
          '一库/两库翻袋进球',
          '解球：被斯诺克后的逃脱路线',
          '安全球：把对方球藏起来',
          '5 球清台 → 7 球清台 → 残局',
        ]),
      ]),
      const SizedBox(height: 6),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'bank_shot')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'bank_two_rail')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'snooker_escape')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'safety')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'clearance_5')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'clearance')),
      _PresetButton(preset: BallPreset.presets.firstWhere((p) => p.id == 'endgame')),

      const SizedBox(height: 16),
      const _Tip('提示：每个阶段至少练习 1-2 周再进入下一级。基本功扎实了，进步速度会越来越快。'),
    ]);
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.preset});
  final BallPreset preset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: Icon(preset.icon, size: 16),
          label: Text('${preset.name} — 开始练习',
              style: const TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF66BB6A),
            side: const BorderSide(color: Color(0x4466BB6A)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GameScreen(
                  gameMode: GameMode.practice,
                  preset: preset,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===========================================================================
// Content builders — App 操作指南
// ===========================================================================
class _AppAiming extends StatelessWidget {
  const _AppAiming();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '瞄准操作'),
        _InfoCard(children: [
          _BL(items: [
            '点击或拖动球台任意位置来调整瞄准方向',
            '白球与目标球的连线构成你的击球轨迹',
            '松手后方向固定，可以继续调整力度',
          ]),
          SizedBox(height: 12),
          _AimDiagramWidget(),
          SizedBox(height: 12),
        ]),
        _LegendRow(color: Color(0xFF66BB6A), label: '绿色虚线 = 白球轨迹（瞄准方向）'),
        _LegendRow(color: Color(0xFFFFEB3B), label: '黄色虚线 = 目标球预测路径（进球线）'),
        _LegendRow(color: Color(0xFF00BFFF), label: '蓝色虚线 = 白球偏转路径（分离角）'),
        _LegendRow(color: Color(0x99FFFFFF), label: '半透明圈 = 假想球（白球碰撞位置）'),
        _LegendRow(color: Color(0xFFFF5722), label: '红色圆点 = 接触点'),
        const _QA(items: [
          (q: '为什么瞄准线有时会消失？', a: '击球后或球运动中辅助线会隐藏；也可在设置中关闭了辅助线。等球停稳、重新瞄准时线条会恢复显示。'),
          (q: '怎么微调瞄准方向？', a: '点击或拖动球台任意位置调整方向，小幅度拖动可精细修正。松手后方向固定，再调力度和加塞。'),
          (q: '不同颜色的线各代表什么？', a: '绿色=白球轨迹，黄色=目标球进球线，蓝色=白球分离路径，半透明圈=假想球，红点=接触点。'),
          (q: '辅助线准吗，能完全依赖吗？', a: '辅助线基于理想物理模型，实际受旋转、力度、台面影响会有偏差。用来学习和验证瞄准，实战仍需培养肉眼判断。'),
        ]),
      ]);
}

class _AppControls extends StatelessWidget {
  const _AppControls();
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionHeader(title: '力度控制'),
        const _InfoCard(children: [
          _P('屏幕右侧为力度条，从底部绿色（轻击）到顶部红色（全力）。'),
          SizedBox(height: 8),
          _BL(items: [
            '点击力度条任意位置 → 直接设定力量',
            '上下拖动力度条 → 微调',
            '调好后点击右下角红色按钮击球',
            '等所有球停止运动后才能下一杆',
          ]),
        ]),
        const SizedBox(height: 16),
        const _SectionHeader(title: '加塞控件'),
        const _InfoCard(children: [
          _P('屏幕左侧的白色圆盘控制加塞（击球点偏移），红点代表球杆击打白球的位置。'),
          SizedBox(height: 12),
          _SpinDiagramWidget(),
          SizedBox(height: 12),
          _BL(items: [
            '红点偏左 → 白球碰后向左偏',
            '红点偏右 → 白球碰后向右偏',
            '红点居中 → 无旋转（中杆）',
          ]),
        ]),
        const _QA(items: [
          (q: '怎么把加塞重置到中心？', a: '点击加塞圆盘正中心，或双击圆盘，红点会回到母球中心，即中杆无旋转状态。'),
          (q: '练习时用多大力度合适？', a: '2–3 档（中轻到中力）最适合练习瞄准和走位，控制精度高。开球和极限长台再用到 4–5 档。'),
          (q: '力度和加塞能同时调整吗？', a: '可以。先定瞄准方向，再设力度和加塞，三者独立。击球前确认三项都符合你的计划。'),
          (q: '击球按钮在哪，怎么操作？', a: '右下角红色击球按钮。设定力度后点击即可出杆；所有球停止后才能进行下一杆。'),
        ]),
      ]);
}

class _AppSettings extends StatelessWidget {
  const _AppSettings();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SectionHeader(title: '放球操作'),
        _InfoCard(children: [
          _BL(items: [
            '标准模式开局：长按白球拖到开球线后任意位置',
            '白球落袋后：长按白球拖到台面任意位置',
            '练习模式：长按任意球拖动到任意位置',
          ]),
          SizedBox(height: 8),
          _P('长按约 0.4 秒开始拖动，球会变为半透明表示正在移动。'),
        ]),
        SizedBox(height: 16),
        _SectionHeader(title: '辅助线设置'),
        _InfoCard(children: [
          _P('游戏内右上角有两个控制按钮：'),
          SizedBox(height: 8),
          _BL(items: [
            '「隐藏/显示辅助线」→ 快速开关所有辅助线',
            '⚙ 图标 → 进入详细设置，可独立控制：',
          ]),
          SizedBox(height: 8),
          _BL(items: [
            '瞄准辅助线（白球轨迹 + 假想球 + 接触点）',
            '进球预测线（目标球路径）',
            '切角角度（弧线 + 数值）',
            '分离角线（白球偏转路径）',
            '角度三角形（直角三角形 + 倍数比）',
          ]),
        ]),
        const _QA(items: [
          (q: '初学者应该开哪些辅助线？', a: '建议全开：瞄准线、进球预测线、假想球和分离角线。它们帮助理解瞄准原理，熟练后可逐步关闭挑战自己。'),
          (q: '怎么关闭所有辅助线进入挑战模式？', a: '点击右上角「隐藏/显示辅助线」按钮一键开关；或进入 ⚙ 设置逐项关闭各项辅助线。'),
          (q: '练习模式和标准模式放球有什么区别？', a: '标准模式只能在开球线后放白球（开局）或台面任意位置（落袋后）；练习模式可长按拖动任意球到任意位置。'),
          (q: '长按拖动球要按多久？', a: '约 0.4 秒。球变为半透明表示进入拖动状态，松手后放置在新位置。'),
        ]),
      ]);
}

// ===========================================================================
// Custom Paint Diagrams (preserved from original)
// ===========================================================================
class _BallChartWidget extends StatelessWidget {
  const _BallChartWidget();
  static const _ballColors = <int, Color>{
    1: Color(0xFFF9D923), 2: Color(0xFF1565C0), 3: Color(0xFFD32F2F), 4: Color(0xFF7B1FA2),
    5: Color(0xFFFF8F00), 6: Color(0xFF2E7D32), 7: Color(0xFF880E4F), 8: Color(0xFF1A1A1A),
    9: Color(0xFFF9D923), 10: Color(0xFF1565C0), 11: Color(0xFFD32F2F), 12: Color(0xFF7B1FA2),
    13: Color(0xFFFF8F00), 14: Color(0xFF2E7D32), 15: Color(0xFF880E4F),
  };
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        width: double.infinity,
        child: CustomPaint(painter: _BallChartPainter(_ballColors)),
      );
}

class _BallChartPainter extends CustomPainter {
  _BallChartPainter(this.colors);
  final Map<int, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = (size.width - 20) / 15;
    final r = (spacing * 0.4).clamp(8.0, 14.0);
    final startX = (size.width - 15 * spacing) / 2 + spacing / 2;
    for (var i = 1; i <= 15; i++) {
      final x = startX + (i - 1) * spacing;
      final y = size.height / 2;
      final color = colors[i]!;
      final isStripe = i >= 9;
      if (isStripe) {
        canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white);
        canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: r * 2, height: r * 0.9), Paint()..color = color);
      } else {
        canvas.drawCircle(Offset(x, y), r, Paint()..color = color);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TableDiagramWidget extends StatelessWidget {
  const _TableDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 160,
        width: double.infinity,
        child: CustomPaint(painter: _TableDiagramPainter()),
      );
}

class _TableDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final maxH = size.height - 16;
    final w0 = size.width * 0.85;
    final h = math.min(w0 / 2, maxH);
    final w = h * 2;
    final ox = (size.width - w) / 2;
    final oy = (size.height - h) / 2;
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 4, 4), Paint()..color = const Color(0xFF1B6B1F));
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 4, 4), Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 4);
    final pp = Paint()..color = const Color(0xFF0D0D0D);
    const pr = 5.0;
    for (final p in [Offset(ox, oy), Offset(ox + w / 2, oy), Offset(ox + w, oy), Offset(ox, oy + h), Offset(ox + w / 2, oy + h), Offset(ox + w, oy + h)]) {
      canvas.drawCircle(p, pr, pp);
    }
    final hsx = ox + w / 4;
    canvas.drawLine(Offset(hsx, oy + 6), Offset(hsx, oy + h - 6), Paint()..color = Colors.white24..strokeWidth = 1);
    canvas.drawCircle(Offset(ox + w * 3 / 4, oy + h / 2), 3, Paint()..color = Colors.white38);
    _lbl(canvas, '开球线', Offset(hsx - 12, oy + h - 14), Colors.white54);
    _lbl(canvas, '置球点', Offset(ox + w * 3 / 4 - 12, oy + h - 14), Colors.white54);
    _lbl(canvas, '底袋', Offset(ox - 2, oy - 10), Colors.white38);
    _lbl(canvas, '中袋', Offset(ox + w / 2 - 8, oy - 10), Colors.white38);
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AimDiagramWidget extends StatelessWidget {
  const _AimDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 160, width: double.infinity, child: CustomPaint(painter: _AimDiagramPainter()));
}

class _AimDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final maxH = size.height - 8;
    final w0 = size.width * 0.88;
    final h = math.min(w0 / 2.2, maxH);
    final w = h * 2.2;
    final ox = (size.width - w) / 2;
    final oy = (size.height - h) / 2;
    final r = (h * 0.08).clamp(6.0, 12.0);

    // Table
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF1B6B1F));
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 3);

    // Pocket (top-right)
    final pocket = Offset(ox + w - 6, oy + 6);
    canvas.drawCircle(pocket, r * 1.3, Paint()..color = const Color(0xFF111111));

    // Object ball
    final obj = Offset(ox + w * 0.58, oy + h * 0.42);
    canvas.drawCircle(obj, r, Paint()..color = const Color(0xFFF9D923));
    _lbl(canvas, '目标球', Offset(obj.dx + r + 4, obj.dy - 5), const Color(0xAAF9D923));

    // O → Pocket direction
    final opDir = pocket - obj;
    final opLen = opDir.distance;
    final opNorm = opLen > 0 ? opDir / opLen : Offset.zero;

    // Ghost ball: one diameter behind object along O→Pocket line
    final ghost = obj - opNorm * (r * 2);

    // Cue ball
    final cue = Offset(ox + w * 0.18, oy + h * 0.7);

    // Contact point on object ball surface
    final contact = obj - opNorm * r;

    // Cue ball separation path (blue dashed, 90° from pocket line)
    final sepDir = Offset(-opNorm.dy, opNorm.dx);
    final sepEnd = ghost + sepDir * (r * 6);

    // Draw lines
    _dashed(canvas, obj + opNorm * r, pocket, const Color(0xFFFFEB3B));
    _dashed(canvas, cue, ghost, const Color(0xFF66BB6A));
    _dashed(canvas, ghost, sepEnd, const Color(0xFF00BFFF));

    // Ghost ball
    canvas.drawCircle(ghost, r, Paint()..color = const Color(0x2200E676));
    canvas.drawCircle(ghost, r, Paint()..color = const Color(0x8800E676)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _lbl(canvas, '假想球', Offset(ghost.dx - r - 30, ghost.dy - 5), const Color(0xAA00E676));

    // Cue ball
    canvas.drawCircle(cue, r, Paint()..color = Colors.white);
    _lbl(canvas, '母球', Offset(cue.dx - 10, cue.dy + r + 4), Colors.white54);

    // Contact point
    canvas.drawCircle(contact, 3, Paint()..color = const Color(0xFFFF5722));

    // Angle arc between aim line and pocket line
    final aimDir = ghost - cue;
    final aimLen = aimDir.distance;
    if (aimLen > 1) {
      final aimNorm = aimDir / aimLen;
      final cutAngle = math.acos((aimNorm.dx * (-opNorm.dx) + aimNorm.dy * (-opNorm.dy)).clamp(-1.0, 1.0));
      if (cutAngle > 0.05) {
        final arcR = r * 3;
        final baseAngle = math.atan2(-opNorm.dy, -opNorm.dx);
        final aimAngle = math.atan2(aimNorm.dy, aimNorm.dx);
        var sweep = aimAngle - baseAngle;
        if (sweep > math.pi) sweep -= 2 * math.pi;
        if (sweep < -math.pi) sweep += 2 * math.pi;
        canvas.drawArc(
          Rect.fromCircle(center: ghost, radius: arcR),
          baseAngle, sweep, false,
          Paint()..color = Colors.white54..style = PaintingStyle.stroke..strokeWidth = 1.0,
        );
        final deg = (cutAngle * 180 / math.pi).round();
        final mid = baseAngle + sweep / 2;
        final lp = ghost + Offset(math.cos(mid), math.sin(mid)) * (arcR + 10);
        _lbl(canvas, '$deg°', lp, Colors.white70);
      }
    }

    // Labels for lines
    final aimMid = Offset((cue.dx + ghost.dx) / 2, (cue.dy + ghost.dy) / 2);
    _lbl(canvas, '瞄准线', Offset(aimMid.dx - 6, aimMid.dy - 14), const Color(0xFF66BB6A));
    _lbl(canvas, '目标球路径', Offset(obj.dx + (pocket.dx - obj.dx) * 0.35, obj.dy + (pocket.dy - obj.dy) * 0.35 + 8), const Color(0xAAFFEB3B));
    _lbl(canvas, '母球分离', Offset(sepEnd.dx + 2, sepEnd.dy - 6), const Color(0xAA00BFFF));
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    final d = b - a;
    final l = d.distance;
    if (l < 1) return;
    final s = d / l;
    var t = 0.0;
    while (t < l) {
      final e = math.min(t + 5, l);
      c.drawLine(a + s * t, a + s * e, p);
      t += 9;
    }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpinDiagramWidget extends StatelessWidget {
  const _SpinDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 110, width: double.infinity, child: CustomPaint(painter: _SpinDiagramPainter()));
}

class _SpinDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = (size.width / 12).clamp(16.0, 30.0);
    final dotOff = r * 0.5;
    final dotR = r * 0.16;
    void draw(double cx, double cy, double dx, double dy, String label) {
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white12);
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);
      canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), Paint()..color = Colors.white38..strokeWidth = 0.5);
      canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), Paint()..color = Colors.white38..strokeWidth = 0.5);
      canvas.drawCircle(Offset(cx + dx, cy + dy), dotR, Paint()..color = Colors.red);
      final tp = TextPainter(text: TextSpan(text: label, style: const TextStyle(color: Colors.white54, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy + r + 4));
    }

    final sp = size.width / 4;
    final cy = size.height / 2 - 4;
    draw(sp, cy, 0, 0, '中杆');
    draw(sp * 2, cy, -dotOff, 0, '左塞');
    draw(sp * 3, cy, dotOff, 0, '右塞');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpinDiagramWidgetVertical extends StatelessWidget {
  const _SpinDiagramWidgetVertical();
  @override
  Widget build(BuildContext context) => SizedBox(height: 110, width: double.infinity, child: CustomPaint(painter: _SpinVerticalPainter()));
}

class _SpinVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = (size.width / 12).clamp(16.0, 30.0);
    final dotOff = r * 0.45;
    final dotR = r * 0.16;
    void draw(double cx, double cy, double dx, double dy, String label) {
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white12);
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);
      canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), Paint()..color = Colors.white38..strokeWidth = 0.5);
      canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), Paint()..color = Colors.white38..strokeWidth = 0.5);
      canvas.drawCircle(Offset(cx + dx, cy + dy), dotR, Paint()..color = Colors.red);
      final tp = TextPainter(text: TextSpan(text: label, style: const TextStyle(color: Colors.white54, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy + r + 4));
    }

    final sp = size.width / 4;
    final cy = size.height / 2 - 4;
    draw(sp, cy, 0, -dotOff, '高杆');
    draw(sp * 2, cy, 0, 0, '中杆');
    draw(sp * 3, cy, 0, dotOff, '低杆');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CutAngleDiagramWidget extends StatelessWidget {
  const _CutAngleDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 110, width: double.infinity, child: CustomPaint(painter: _CutAngleDiagramPainter()));
}

class _CutAngleDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.drawCircle(Offset(cx, cy), 10, Paint()..color = Colors.white10..style = PaintingStyle.stroke..strokeWidth = 1.5);
    final objX = cx + 25.0;
    final objY = cy - 8.0;
    canvas.drawCircle(Offset(objX, objY), 10, Paint()..color = const Color(0x55FFEB3B));
    final aimFrom = Offset(cx - 80, cy + 10);
    _dashed(canvas, aimFrom, Offset(cx, cy), const Color(0xFF66BB6A));
    canvas.drawLine(Offset(cx, cy), Offset(objX, objY), Paint()..color = Colors.white54..strokeWidth = 1);
    final od = Offset(objX - cx, objY - cy);
    final on2 = od / od.distance;
    _dashed(canvas, Offset(objX, objY), Offset(objX + on2.dx * 60, objY + on2.dy * 60), const Color(0xFFFFEB3B));
    final ad = Offset(cx - aimFrom.dx, cy - aimFrom.dy);
    final a1 = math.atan2(-ad.dy, -ad.dx);
    final a2 = math.atan2(objY - cy, objX - cx);
    var sw = a2 - a1;
    if (sw > math.pi) sw -= 2 * math.pi;
    if (sw < -math.pi) sw += 2 * math.pi;
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: 20), a1, sw, false, Paint()..color = Colors.orangeAccent..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _lbl(canvas, '切角', Offset(cx + 8, cy + 14), Colors.orangeAccent);
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    final d = b - a;
    final l = d.distance;
    if (l < 1) return;
    final s = d / l;
    var t = 0.0;
    while (t < l) {
      final e = math.min(t + 4, l);
      c.drawLine(a + s * t, a + s * e, p);
      t += 7;
    }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 11, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TriangleDiagramWidget extends StatelessWidget {
  const _TriangleDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: _TriangleDiagramPainter()));
}

class _TriangleDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const cutDeg = 30.0;
    const cutRad = cutDeg * math.pi / 180;
    const triSize = 80.0;
    final a = Offset(cx - 40, cy + 20);
    final b = Offset(a.dx + triSize * math.cos(cutRad), a.dy - triSize * math.sin(cutRad));
    final foot = Offset(b.dx, a.dy);
    final path = Path()..moveTo(a.dx, a.dy)..lineTo(b.dx, b.dy)..lineTo(foot.dx, foot.dy)..close();
    canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.04));
    final ep = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawLine(a, b, ep..color = const Color(0xFF66BB6A));
    canvas.drawLine(a, foot, ep..color = const Color(0xFFFFEB3B));
    canvas.drawLine(foot, b, ep..color = const Color(0xFF00BFFF));
    const sq = 8.0;
    canvas.drawLine(Offset(foot.dx - sq, foot.dy), Offset(foot.dx - sq, foot.dy - sq), Paint()..color = Colors.white30..strokeWidth = 1);
    canvas.drawLine(Offset(foot.dx - sq, foot.dy - sq), Offset(foot.dx, foot.dy - sq), Paint()..color = Colors.white30..strokeWidth = 1);
    final sinA = math.sin(cutRad);
    final cosA = math.cos(cutRad);
    _lbl(canvas, '斜${(1 / sinA).toStringAsFixed(1)}', ((a + b) / 2) + const Offset(-30, -10), const Color(0xFF66BB6A));
    _lbl(canvas, '长${(cosA / sinA).toStringAsFixed(1)}', ((a + foot) / 2) + const Offset(-8, 4), const Color(0xFFFFEB3B));
    _lbl(canvas, '短1.0', ((foot + b) / 2) + const Offset(4, -6), const Color(0xFF00BFFF));
    _lbl(canvas, '30°', a + const Offset(20, -16), Colors.orangeAccent);
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 12, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DeflectionDiagramWidget extends StatelessWidget {
  const _DeflectionDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: _DeflectionDiagramPainter()));
}

class _DeflectionDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.42;
    final cy = size.height * 0.52;
    const br = 9.0;

    // Object ball path toward pocket (upper-right)
    final objDir = Offset(55, -38);
    final objAngle = math.atan2(objDir.dy, objDir.dx);

    // Cue ball approach at 30° cut angle relative to object path
    const cutDeg = 30.0;
    final cutRad = cutDeg * math.pi / 180;
    final approachAngle = objAngle + math.pi + cutRad;
    final cueBefore = Offset(cx + math.cos(approachAngle) * 75, cy + math.sin(approachAngle) * 75);
    canvas.drawCircle(cueBefore, br, Paint()..color = Colors.white);
    _lbl(canvas, '母球', Offset(cueBefore.dx - 28, cueBefore.dy + 12), Colors.white54);

    // Object ball at collision
    canvas.drawCircle(Offset(cx, cy), br, Paint()..color = const Color(0xFFF9D923));
    _lbl(canvas, '目标球', Offset(cx + 10, cy + 12), const Color(0xAAF9D923));

    // Approach line (green)
    _dashed(canvas, cueBefore, Offset(cx, cy), const Color(0xFF66BB6A));

    // Object ball path toward pocket (yellow)
    final objEnd = Offset(cx, cy) + objDir;
    _dashed(canvas, Offset(cx, cy), objEnd, const Color(0xFFFFEB3B));
    canvas.drawCircle(objEnd, 5, Paint()..color = const Color(0xFF0D0D0D));
    _lbl(canvas, '袋口', Offset(objEnd.dx - 8, objEnd.dy - 16), Colors.white38);

    // Cue ball deflection (~90° from object path, blue)
    final cueAngle = objAngle + math.pi / 2;
    final cueEnd = Offset(cx + math.cos(cueAngle) * 55, cy + math.sin(cueAngle) * 55);
    _dashed(canvas, Offset(cx, cy), cueEnd, const Color(0xFF00BFFF));

    // 90° arc between outgoing paths
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: 22),
      objAngle,
      math.pi / 2,
      false,
      Paint()..color = Colors.orangeAccent..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    _lbl(canvas, '90°', Offset(cx + 10, cy - 6), Colors.orangeAccent);

    // Cut angle hint
    _lbl(canvas, '切角≈30°', Offset(cueBefore.dx + 12, cueBefore.dy - 8), Colors.white38);
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    final d = b - a;
    final l = d.distance;
    if (l < 1) return;
    final s = d / l;
    var t = 0.0;
    while (t < l) {
      final e = math.min(t + 4, l);
      c.drawLine(a + s * t, a + s * e, p);
      t += 7;
    }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SideSpinDiagramWidget extends StatelessWidget {
  const _SideSpinDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: _SideSpinDiagramPainter()));
}

class _SideSpinDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.88;
    final ox = (size.width - w) / 2;
    final cushionY = size.height * 0.22;

    // Cushion
    canvas.drawRect(
      Rect.fromLTWH(ox, cushionY - 4, w, 8),
      Paint()..color = const Color(0xFF4E342E),
    );
    _lbl(canvas, '库边', Offset(ox + w - 28, cushionY - 18), Colors.white38);

    // Incoming path (shared approach)
    final hitX = ox + w * 0.55;
    final hit = Offset(hitX, cushionY + 4);
    final approach = Offset(hitX - 35, size.height - 14);
    canvas.drawLine(approach, hit, Paint()..color = Colors.white54..strokeWidth = 1);
    canvas.drawCircle(approach, 7, Paint()..color = Colors.white);
    _lbl(canvas, '母球', Offset(approach.dx - 14, approach.dy + 10), Colors.white54);

    // Derive incoming angle from the drawn approach line
    final inDir = hit - approach;
    final inAngleFromHoriz = math.atan2(-inDir.dy, inDir.dx);
    final reflectedAngle = math.pi - inAngleFromHoriz;

    void drawRebound(double angleOffset, Color color, String label, double labelX) {
      final outAngle = reflectedAngle + angleOffset;
      final outDir = Offset(math.cos(outAngle), -math.sin(outAngle));
      final end = hit + outDir * 70;
      canvas.drawLine(hit, end, Paint()..color = color..strokeWidth = 2);
      canvas.drawCircle(end, 5, Paint()..color = color.withValues(alpha: 0.5));
      _lbl(canvas, label, Offset(labelX, end.dy + 2), color);
    }

    // No spin: mirror reflection (offset=0)
    drawRebound(0, const Color(0xFF66BB6A), '无塞', ox + w * 0.38);
    // Left spin: narrower rebound angle
    drawRebound(-0.35, const Color(0xFF00BFFF), '左塞', ox + w * 0.08);
    // Right spin: wider rebound angle
    drawRebound(0.35, const Color(0xFFE53935), '右塞', ox + w * 0.62);
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BreakShotDiagramWidget extends StatelessWidget {
  const _BreakShotDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: _BreakShotDiagramPainter()));
}

class _BreakShotDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final maxH = size.height - 8;
    final w0 = size.width * 0.88;
    final h = math.min(w0 / 2, maxH);
    final w = h * 2;
    final ox = (size.width - w) / 2;
    final oy = (size.height - h) / 2;

    // Table
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF1B6B1F));
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 3);

    // Head string
    final hsx = ox + w / 4;
    canvas.drawLine(Offset(hsx, oy + 4), Offset(hsx, oy + h - 4), Paint()..color = Colors.white24..strokeWidth = 1);

    // Foot spot / rack center
    final rackCx = ox + w * 0.72;
    final rackCy = oy + h / 2;

    // Triangle rack (simplified)
    final tri = Path()
      ..moveTo(rackCx, rackCy - 14)
      ..lineTo(rackCx - 12, rackCy + 10)
      ..lineTo(rackCx + 12, rackCy + 10)
      ..close();
    canvas.drawPath(tri, Paint()..color = Colors.white12..style = PaintingStyle.stroke..strokeWidth = 1);
    for (final p in [
      Offset(rackCx, rackCy - 14),
      Offset(rackCx - 7, rackCy + 2),
      Offset(rackCx + 7, rackCy + 2),
      Offset(rackCx - 12, rackCy + 10),
      Offset(rackCx, rackCy + 10),
      Offset(rackCx + 12, rackCy + 10),
    ]) {
      canvas.drawCircle(p, 4, Paint()..color = const Color(0x88F9D923));
    }
    _lbl(canvas, '三角架', Offset(rackCx - 16, rackCy + 18), Colors.white38);

    // Three cue ball positions on head string
    final positions = [
      (Offset(hsx, oy + h / 2), '正中'),
      (Offset(hsx - 18, oy + h / 2), '偏左'),
      (Offset(hsx + 18, oy + h / 2), '偏右'),
    ];
    for (final (pos, label) in positions) {
      canvas.drawCircle(pos, 5, Paint()..color = Colors.white.withValues(alpha: label == '正中' ? 1.0 : 0.45));
      if (label == '正中') {
        canvas.drawCircle(pos, 5, Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);
      }
      _lbl(canvas, label, Offset(pos.dx - 12, pos.dy + 10), Colors.white54);
    }

    // Arrow from center cue to rack
    final cueCenter = Offset(hsx, oy + h / 2);
    _arrow(canvas, cueCenter, Offset(rackCx - 14, rackCy), const Color(0xFF66BB6A));
    _lbl(canvas, '开球方向', Offset((cueCenter.dx + rackCx) / 2 - 20, cueCenter.dy - 18), const Color(0xFF66BB6A));
    _lbl(canvas, '开球线', Offset(hsx - 16, oy + h - 12), Colors.white38);
  }

  void _arrow(Canvas c, Offset from, Offset to, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    c.drawLine(from, to, p);
    final d = to - from;
    final len = d.distance;
    if (len < 1) return;
    final dir = d / len;
    final perp = Offset(-dir.dy, dir.dx);
    final tip = to;
    final base = tip - dir * 8;
    c.drawPath(
      Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(base.dx + perp.dx * 4, base.dy + perp.dy * 4)
        ..lineTo(base.dx - perp.dx * 4, base.dy - perp.dy * 4)
        ..close(),
      Paint()..color = cl,
    );
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SafetyDiagramWidget extends StatelessWidget {
  const _SafetyDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: _SafetyDiagramPainter()));
}

class _SafetyDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final maxH = size.height - 8;
    final w0 = size.width * 0.9;
    final h = math.min(w0 * 0.45, maxH);
    final w = h / 0.45;
    final ox = (size.width - w) / 2;
    final oy = (size.height - h) / 2 + 4;

    // Table edge
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF1B6B1F));
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Cushion (left)
    canvas.drawRect(Rect.fromLTWH(ox - 2, oy, 6, h), Paint()..color = const Color(0xFF4E342E));

    const br = 8.0;
    final cueBall = Offset(ox + w * 0.18, oy + h * 0.65);
    final blocker = Offset(ox + w * 0.42, oy + h * 0.45);
    final objBall = Offset(ox + w * 0.62, oy + h * 0.38);
    final safePos = Offset(ox + w * 0.78, oy + h * 0.72);

    // Balls
    canvas.drawCircle(cueBall, br, Paint()..color = Colors.white);
    _lbl(canvas, '母球', Offset(cueBall.dx - 12, cueBall.dy + 12), Colors.white54);

    canvas.drawCircle(blocker, br, Paint()..color = const Color(0xFF1565C0));
    _lbl(canvas, '障碍球', Offset(blocker.dx - 16, blocker.dy - 18), Colors.white38);

    canvas.drawCircle(objBall, br, Paint()..color = const Color(0xFFF9D923));
    _lbl(canvas, '目标球', Offset(objBall.dx + 4, objBall.dy - 16), const Color(0xAAF9D923));

    // Blocked line of sight (dashed red)
    _dashed(canvas, cueBall, objBall, const Color(0x55E53935));

    // Safety path (green dashed arrow)
    _dashed(canvas, cueBall, safePos, const Color(0xFF66BB6A));
    _arrowHead(canvas, cueBall, safePos, const Color(0xFF66BB6A));
    canvas.drawCircle(safePos, 6, Paint()..color = const Color(0x4466BB6A)..style = PaintingStyle.fill);
    canvas.drawCircle(safePos, 6, Paint()..color = const Color(0xFF66BB6A)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _lbl(canvas, '安全球', Offset(safePos.dx - 18, safePos.dy + 12), const Color(0xFF66BB6A));

    // Snooker indicator from opponent view
    canvas.drawLine(blocker, objBall, Paint()..color = Colors.white.withValues(alpha: 0.12)..strokeWidth = 1);
    _lbl(canvas, '对方视角被挡', Offset(ox + w * 0.38, oy + h - 12), const Color(0xFFE53935));
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    final d = b - a;
    final l = d.distance;
    if (l < 1) return;
    final s = d / l;
    var t = 0.0;
    while (t < l) {
      final e = math.min(t + 4, l);
      c.drawLine(a + s * t, a + s * e, p);
      t += 7;
    }
  }

  void _arrowHead(Canvas c, Offset from, Offset to, Color cl) {
    final d = to - from;
    final len = d.distance;
    if (len < 1) return;
    final dir = d / len;
    final perp = Offset(-dir.dy, dir.dx);
    final tip = to;
    final base = tip - dir * 7;
    c.drawPath(
      Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(base.dx + perp.dx * 3.5, base.dy + perp.dy * 3.5)
        ..lineTo(base.dx - perp.dx * 3.5, base.dy - perp.dy * 3.5)
        ..close(),
      Paint()..color = cl,
    );
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PositionZoneDiagramWidget extends StatelessWidget {
  const _PositionZoneDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 120, width: double.infinity, child: CustomPaint(painter: _PositionZoneDiagramPainter()));
}

class _PositionZoneDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final maxH = size.height - 8;
    final w0 = size.width * 0.9;
    final h = math.min(w0 * 0.42, maxH);
    final w = h / 0.42;
    final ox = (size.width - w) / 2;
    final oy = (size.height - h) / 2 + 6;

    // Mini table corner
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF1B6B1F));
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(ox + w, oy), 5, Paint()..color = const Color(0xFF0D0D0D));

    const br = 8.0;
    final objBall = Offset(ox + w * 0.82, oy + h * 0.28);
    final cueBefore = Offset(ox + w * 0.35, oy + h * 0.55);
    final collision = Offset(ox + w * 0.68, oy + h * 0.42);

    // Zones (where cue ball could stop for next shot)
    final zoneCenter = Offset(ox + w * 0.38, oy + h * 0.72);
    canvas.drawOval(
      Rect.fromCenter(center: zoneCenter, width: 90, height: 36),
      Paint()..color = const Color(0x33E53935),
    );
    canvas.drawOval(
      Rect.fromCenter(center: zoneCenter, width: 62, height: 26),
      Paint()..color = const Color(0x44FFEB3B),
    );
    canvas.drawOval(
      Rect.fromCenter(center: zoneCenter, width: 34, height: 16),
      Paint()..color = const Color(0x5566BB6A),
    );

    // Shot lines
    canvas.drawCircle(cueBefore, br, Paint()..color = Colors.white);
    _dashed(canvas, cueBefore, collision, const Color(0xFF66BB6A));
    canvas.drawCircle(objBall, br, Paint()..color = const Color(0xFFF9D923));
    _dashed(canvas, collision, Offset(ox + w - 4, oy + 4), const Color(0xFFFFEB3B));

    // Next ball hint
    canvas.drawCircle(Offset(ox + w * 0.12, oy + h * 0.55), 6, Paint()..color = const Color(0x88D32F2F));
    _lbl(canvas, '下一球', Offset(ox + w * 0.04, oy + h * 0.68), Colors.white38);

    _lbl(canvas, '理想区域', Offset(zoneCenter.dx - 48, zoneCenter.dy - 28), const Color(0xFF66BB6A));
    _lbl(canvas, '可接受', Offset(zoneCenter.dx + 38, zoneCenter.dy - 8), const Color(0xFFFFEB3B));
    _lbl(canvas, '危险区域', Offset(zoneCenter.dx + 42, zoneCenter.dy + 18), const Color(0xFFE53935));
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    final d = b - a;
    final l = d.distance;
    if (l < 1) return;
    final s = d / l;
    var t = 0.0;
    while (t < l) {
      final e = math.min(t + 4, l);
      c.drawLine(a + s * t, a + s * e, p);
      t += 7;
    }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PottingLinesDiagramWidget extends StatelessWidget {
  const _PottingLinesDiagramWidget();
  @override
  Widget build(BuildContext context) => SizedBox(height: 130, width: double.infinity, child: CustomPaint(painter: _PottingLinesDiagramPainter()));
}

class _PottingLinesDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final maxH = size.height - 8;
    final w0 = size.width * 0.92;
    final h = math.min(w0 / 2, maxH);
    final w = h * 2;
    final ox = (size.width - w) / 2;
    final oy = (size.height - h) / 2;

    // Table
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF1B6B1F));
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, w, h), 3, 3), Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 3);
    const pr = 4.0;
    for (final p in [Offset(ox, oy), Offset(ox + w, oy), Offset(ox, oy + h), Offset(ox + w, oy + h)]) {
      canvas.drawCircle(p, pr, Paint()..color = const Color(0xFF0D0D0D));
    }

    const br = 6.0;
    final pocket = Offset(ox + w, oy);

    void drawLine(Offset obj, Offset cue, String label, Color color) {
      canvas.drawCircle(obj, br, Paint()..color = const Color(0xFFF9D923));
      canvas.drawCircle(cue, br - 1, Paint()..color = Colors.white.withValues(alpha: 0.7));
      _dashed(canvas, cue, obj, color.withValues(alpha: 0.5));
      _dashed(canvas, obj, pocket, color);
      _lbl(canvas, label, Offset((cue.dx + obj.dx) / 2 - 16, (cue.dy + obj.dy) / 2 - 14), color);
    }

    // Direct pot (bottom area, straight line)
    drawLine(
      Offset(ox + w * 0.78, oy + h * 0.55),
      Offset(ox + w * 0.55, oy + h * 0.55),
      '直球',
      const Color(0xFF66BB6A),
    );

    // Medium cut (center)
    drawLine(
      Offset(ox + w * 0.72, oy + h * 0.38),
      Offset(ox + w * 0.38, oy + h * 0.62),
      '小切角',
      const Color(0xFFFFEB3B),
    );

    // Thin cut (upper area)
    drawLine(
      Offset(ox + w * 0.65, oy + h * 0.22),
      Offset(ox + w * 0.22, oy + h * 0.48),
      '薄球',
      const Color(0xFF00BFFF),
    );

    _lbl(canvas, '底袋', Offset(ox + w - 22, oy - 2), Colors.white38);
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    final d = b - a;
    final l = d.distance;
    if (l < 1) return;
    final s = d / l;
    var t = 0.0;
    while (t < l) {
      final e = math.min(t + 4, l);
      c.drawLine(a + s * t, a + s * e, p);
      t += 7;
    }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---- Stance & Grip diagrams ----

class _StancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.45;
    final tableY = h * 0.38;

    canvas.drawRect(Rect.fromLTWH(0, tableY, w, 6), Paint()..color = const Color(0xFF4E342E));
    canvas.drawRect(Rect.fromLTWH(0, tableY + 6, w, h - tableY - 6),
        Paint()..color = const Color(0xFF1B5E20).withValues(alpha: 0.15));
    canvas.drawCircle(Offset(cx + 40, tableY + 16), 6, Paint()..color = Colors.white70);
    canvas.drawLine(Offset(cx - 80, tableY + 4), Offset(cx + 38, tableY + 16),
        Paint()..color = const Color(0xFFD4A373)..strokeWidth = 2.5);

    final headCx = cx - 10.0;
    final headCy = tableY - 28.0;
    canvas.drawCircle(Offset(headCx, headCy), 10,
        Paint()..color = const Color(0xFF90A4AE)..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(headCx, headCy + 8), 2, Paint()..color = const Color(0xFFFF5722));

    final hip = Offset(cx - 55, h * 0.72);
    canvas.drawLine(Offset(headCx, headCy + 10), hip, Paint()..color = const Color(0xFF90A4AE)..strokeWidth = 2);
    canvas.drawLine(Offset(headCx + 8, headCy + 22), Offset(cx + 10, tableY + 2),
        Paint()..color = const Color(0xFF90A4AE)..strokeWidth = 2);
    final gripPt = Offset(cx - 60, tableY + 2);
    canvas.drawLine(Offset(headCx - 12, headCy + 22), gripPt,
        Paint()..color = const Color(0xFF90A4AE)..strokeWidth = 2);
    canvas.drawLine(gripPt, gripPt + const Offset(0, 20),
        Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 1.5);

    final frontFoot = Offset(cx - 20, h - 8);
    final backFoot = Offset(cx - 90, h - 8);
    canvas.drawLine(hip, frontFoot, Paint()..color = const Color(0xFF90A4AE)..strokeWidth = 2);
    canvas.drawLine(hip, backFoot, Paint()..color = const Color(0xFF90A4AE)..strokeWidth = 2);
    canvas.drawLine(backFoot + const Offset(0, 4), frontFoot + const Offset(0, 4),
        Paint()..color = Colors.white24..strokeWidth = 1);
    _lbl(canvas, '≈肩宽', Offset((backFoot.dx + frontFoot.dx) / 2 - 12, h - 6), Colors.white38);
    _lbl(canvas, '下巴贴杆', Offset(headCx + 14, headCy + 2), const Color(0xFFFF5722));
    _lbl(canvas, '前臂垂直', gripPt + const Offset(4, 8), const Color(0xFF66BB6A));
    _dashed(canvas, Offset(headCx, headCy - 4), Offset(cx + 40, tableY + 16), Colors.white24);
    _lbl(canvas, '视线', Offset(headCx + 14, headCy - 12), Colors.white38);
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1;
    final d = b - a; final l = d.distance; if (l < 1) return; final s = d / l;
    var t = 0.0; while (t < l) { final e = math.min(t + 4, l); c.drawLine(a + s * t, a + s * e, p); t += 7; }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 9)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h * 0.40;

    canvas.drawLine(Offset(cx - 130, cy), Offset(cx + 130, cy),
        Paint()..color = const Color(0xFFD4A373)..strokeWidth = 4);
    canvas.drawCircle(Offset(cx + 130, cy), 3, Paint()..color = const Color(0xFF42A5F5));

    final balancePt = Offset(cx + 20, cy);
    canvas.drawLine(balancePt + const Offset(0, -6), balancePt + const Offset(0, 6),
        Paint()..color = Colors.white38..strokeWidth = 1);
    _lbl(canvas, '重心', balancePt + const Offset(-8, -16), Colors.white38);

    final gripX = cx - 25.0;
    const skinColor = Color(0xFFE8B89D);
    const skinDark = Color(0xFFD4A080);
    // Palm behind the cue
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(gripX, cy + 10), width: 34, height: 20),
        const Radius.circular(5)),
      Paint()..color = skinColor.withValues(alpha: 0.5));
    // Fingers wrapping around the cue (4 rounded rects curving over the top)
    for (var i = 0; i < 4; i++) {
      final fx = gripX - 11.0 + i * 7.5;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(fx, cy - 10, 6, 14),
          const Radius.circular(3)),
        Paint()..color = skinColor);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(fx, cy - 10, 6, 14),
          const Radius.circular(3)),
        Paint()..color = skinDark..style = PaintingStyle.stroke..strokeWidth = 0.8);
    }
    // Thumb on the side
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(gripX + 10, cy - 6, 8, 12),
        const Radius.circular(3)),
      Paint()..color = skinColor);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(gripX + 10, cy - 6, 8, 12),
        const Radius.circular(3)),
      Paint()..color = skinDark..style = PaintingStyle.stroke..strokeWidth = 0.8);

    canvas.drawLine(Offset(gripX - 16, cy + 28), Offset(gripX + 16, cy + 28),
        Paint()..color = const Color(0xFFFF9800)..strokeWidth = 1.5);
    _lbl(canvas, '握杆位', Offset(gripX - 12, cy + 32), const Color(0xFFFF9800));

    final distArrowY = cy - 22.0;
    canvas.drawLine(Offset(gripX, distArrowY), Offset(balancePt.dx, distArrowY),
        Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 1);
    canvas.drawLine(Offset(gripX, distArrowY - 4), Offset(gripX, distArrowY + 4),
        Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 1);
    canvas.drawLine(Offset(balancePt.dx, distArrowY - 4), Offset(balancePt.dx, distArrowY + 4),
        Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 1);
    _lbl(canvas, '10-15cm', Offset((gripX + balancePt.dx) / 2 - 16, distArrowY - 14), const Color(0xFF66BB6A));
    _lbl(canvas, '轻握 — 像握牙刷', Offset(w * 0.62, h * 0.82), Colors.white38);
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FollowStopDrawPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const r = 7.0;
    final cy = h * 0.5;
    final objX = w * 0.45;
    final cueX = w * 0.15;

    canvas.drawCircle(Offset(objX, cy), r, Paint()..color = const Color(0xFFF9D923));
    _lbl(canvas, '目标球', Offset(objX - 12, cy + r + 4), const Color(0xAAF9D923));
    canvas.drawCircle(Offset(cueX, cy), r, Paint()..color = Colors.white);
    _lbl(canvas, '母球', Offset(cueX - 8, cy + r + 4), Colors.white54);
    canvas.drawLine(Offset(cueX + r, cy), Offset(objX - r, cy), Paint()..color = Colors.white24..strokeWidth = 1.5);
    _dashed(canvas, Offset(objX + r, cy), Offset(w * 0.88, cy), const Color(0xFFFFEB3B));
    _lbl(canvas, '进袋', Offset(w * 0.84, cy - 14), const Color(0xAAF9D923));

    final followEnd = Offset(w * 0.72, cy - 20);
    canvas.drawLine(Offset(objX, cy), followEnd, Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 2);
    canvas.drawCircle(followEnd, 5, Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.5));
    _lbl(canvas, '高杆(跟进)', followEnd + const Offset(4, -12), const Color(0xFF66BB6A));

    canvas.drawCircle(Offset(objX + 4, cy), 5, Paint()..color = const Color(0xFF42A5F5).withValues(alpha: 0.5));
    _lbl(canvas, '中杆(定杆)', Offset(objX - 8, cy - 18), const Color(0xFF42A5F5));

    final drawEnd = Offset(w * 0.22, cy + 15);
    canvas.drawLine(Offset(objX, cy), drawEnd, Paint()..color = const Color(0xFFE53935)..strokeWidth = 2);
    canvas.drawCircle(drawEnd, 5, Paint()..color = const Color(0xFFE53935).withValues(alpha: 0.5));
    _lbl(canvas, '低杆(拉杆)', drawEnd + const Offset(-30, 6), const Color(0xFFE53935));
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1.5;
    final d = b - a; final l = d.distance; if (l < 1) return; final s = d / l;
    var t = 0.0; while (t < l) { final e = math.min(t + 4, l); c.drawLine(a + s * t, a + s * e, p); t += 7; }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClearanceOrderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final maxH = h - 8;
    final tw0 = w * 0.88;
    final th = math.min(tw0 / 2, maxH);
    final tw = th * 2;
    final ox = (w - tw) / 2;
    final oy = (h - th) / 2;

    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, tw, th), 3, 3), Paint()..color = const Color(0xFF1B6B1F));
    canvas.drawRRect(RRect.fromRectXY(Rect.fromLTWH(ox, oy, tw, th), 3, 3),
        Paint()..color = const Color(0xFF4E342E)..style = PaintingStyle.stroke..strokeWidth = 3);

    const pr = 4.0;
    final pp = Paint()..color = const Color(0xFF0D0D0D);
    for (final p in [Offset(ox, oy), Offset(ox + tw, oy), Offset(ox, oy + th), Offset(ox + tw, oy + th)]) {
      canvas.drawCircle(p, pr, pp);
    }

    const balls = [
      (0.25, 0.65, '①', Color(0xFFE53935)),
      (0.55, 0.75, '②', Color(0xFFFF9800)),
      (0.40, 0.35, '③', Color(0xFFFDD835)),
      (0.70, 0.30, '④', Color(0xFF66BB6A)),
      (0.80, 0.55, '⑤', Color(0xFF42A5F5)),
      (0.85, 0.25, '⑥', Color(0xFF7E57C2)),
      (0.15, 0.30, '8', Color(0xFF1A1A1A)),
    ];

    const r = 6.0;
    Offset? prevCenter;
    for (final b in balls) {
      final bx = ox + tw * b.$1;
      final by = oy + th * b.$2;
      final center = Offset(bx, by);
      final color = b.$4;
      final isEight = b.$3 == '8';

      canvas.drawCircle(center, r, Paint()..color = color);
      if (isEight) {
        canvas.drawCircle(center, r + 2, Paint()..color = const Color(0xFFE91E63)..style = PaintingStyle.stroke..strokeWidth = 1);
      }
      final tp = TextPainter(
        text: TextSpan(text: b.$3, style: TextStyle(color: isEight ? Colors.white : Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(bx - tp.width / 2, by - tp.height / 2));

      if (prevCenter != null && !isEight) _dashed(canvas, prevCenter, center, Colors.white30);
      if (!isEight) prevCenter = center;
    }
    if (prevCenter != null) {
      _dashed(canvas, prevCenter, Offset(ox + tw * 0.15, oy + th * 0.30), const Color(0xFFE91E63));
    }
    _lbl(canvas, '关键球', Offset(ox + tw * 0.78, oy + th * 0.58), Colors.white38);
  }

  void _dashed(Canvas c, Offset a, Offset b, Color cl) {
    final p = Paint()..color = cl..strokeWidth = 1;
    final d = b - a; final l = d.distance; if (l < 1) return; final s = d / l;
    var t = 0.0; while (t < l) { final e = math.min(t + 4, l); c.drawLine(a + s * t, a + s * e, p); t += 7; }
  }

  void _lbl(Canvas c, String t, Offset p, Color cl) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: cl, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
