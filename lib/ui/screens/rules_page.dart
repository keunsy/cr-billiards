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
          _RuleSection(
            title: '比赛方式',
            content:
                '中式八球比赛使用16个球：1个白球（母球）和15个目标球（1-7号为全色球，9-15号为花色球，8号为黑色球）。'
                '比赛双方轮流击球，先将己方所属球组全部合法击入袋中，再合法将8号球击入袋中者获胜。',
          ),
          _RuleSection(
            title: '器材',
            content:
                '标准比赛使用中式八球专用球台，内径长254cm、宽127cm。'
                '球直径约57.15mm，重量约170g。球杆长度不限，但击球时不得使用除球杆以外的任何辅助工具。',
          ),
          _RuleSection(
            title: '摆球',
            content:
                '15个目标球呈三角形摆放在置球点，8号球置于三角架中心，'
                '一条底边的两端分别放置一个全色球和一个花色球，其余球位置随机摆放。'
                '白球置于开球区（开球线后）任意位置。',
          ),
          _RuleSection(
            title: '开球',
            content:
                '开球时白球必须先击中三角形内的目标球。'
                '开球时若有4个或以上目标球入袋，或开球后仍有球在运动，开球有效。'
                '开球犯规时，对方获得线后自由球（开球线后放置白球）。'
                '开球时8号球入袋，8号球重置于置球点，原杆继续或对方选择开球。',
          ),
          _RuleSection(
            title: '确定花色',
            content:
                '开球后，一方在合法击球过程中首次将某一组球（全色或花色）击入袋中，'
                '该组球即归该方所有，另一方则拥有另一组球。'
                '若开球时同时击入全色和花色球，击球方任选一组作为自己的球组。',
          ),
          _RuleSection(
            title: '击球',
            content:
                '击球时白球必须先接触己方球组中的球（或开球时接触三角形内任意球）。'
                '合法击球后，必须有任意一颗球入袋，或白球及至少一颗目标球触碰库边。'
                '击球过程中，白球与目标球均不得跳离台面（明显跳球为犯规）。'
                '击球时不得推杆（白球与球杆接触时间过长导致白球被推动）。',
          ),
          _RuleSection(
            title: '犯规',
            content:
                '常见犯规包括：白球落袋（洗球）；白球未先击中合法目标球；'
                '白球未击中任何球；无球入袋且无球碰库；白球跳出台面；'
                '目标球飞出台面；击球时球杆或身体触碰球；'
                '连续两次击打白球；在台面上放置或移动任何物品影响击球。'
                '犯规后，对方获得全台自由球（可在台面任意位置放置白球）。',
          ),
          _RuleSection(
            title: '输局',
            content:
                '下列情况直接判负：己方球组未全部入袋时，8号球先入袋或飞出界；'
                '击8号球时白球落袋；击8号球时犯规；'
                '击8号球时8号球未入袋且白球落袋；'
                '故意违反规则或严重违反体育道德。',
          ),
          _RuleSection(
            title: '胜负判定',
            content:
                '一方在己方所有球组全部合法入袋后，合法将8号球击入指定袋口，即赢得该局比赛。'
                '若8号球与最后一颗己方球同时入袋，只要白球未落袋且击球合法，则击球方获胜。'
                '比赛通常采用若干局定胜负制，具体局数由赛前约定。',
          ),
        ],
      ),
    );
  }
}

class _RuleSection extends StatelessWidget {
  const _RuleSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF81C784),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
