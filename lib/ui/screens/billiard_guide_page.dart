import 'dart:math' as math;

import 'package:flutter/material.dart';

class BilliardGuidePage extends StatelessWidget {
  const BilliardGuidePage({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _SectionHeader(number: 1, title: '台球运动简介'),
          _InfoCard(children: [
            _Paragraph(
              '台球（Billiards / Pool）起源于 15 世纪欧洲，是一项用球杆击球、'
              '利用母球撞击目标球入袋的精准运动。主要分为三大类：',
            ),
            SizedBox(height: 8),
            _BulletList(items: [
              '斯诺克（Snooker）：22 球，红球和彩球交替击打，规则最复杂',
              '美式花球（8-Ball / 9-Ball）：使用更大的球袋，节奏更快',
              '中式八球（Chinese 8-Ball）：融合美式规则与斯诺克球台，是国内最流行的台球运动',
            ]),
            SizedBox(height: 8),
            _Paragraph(
              '本教程主要讲解中式八球相关技术，大部分原理同样适用于美式花球和斯诺克。',
            ),
          ]),

          // ========== 基础篇 ==========
          SizedBox(height: 32),
          _PartTitle(text: '基础篇'),

          SizedBox(height: 16),
          _SectionHeader(number: 2, title: '正确的握杆姿势'),
          _InfoCard(children: [
            _Paragraph(
              '握杆是打好台球的第一步。错误的握杆会直接影响出杆的稳定性和准确性。',
            ),
            SizedBox(height: 12),
            _Heading('后手（握杆手）'),
            _BulletList(items: [
              '用拇指、食指和中指自然握住球杆后部',
              '握杆位置大约在球杆重心后方 15-20cm 处',
              '握力适中，不宜太紧（约"握鸡蛋"的力度）',
              '手腕自然放松，出杆时保持垂直运动',
              '大臂静止不动，仅靠前臂摆动来击球',
            ]),
            SizedBox(height: 12),
            _Heading('前手（架杆手）'),
            _BulletList(items: [
              '手掌平放在台面上，五指张开形成稳定支撑',
              '拇指紧贴食指第二关节，形成 V 型槽',
              '球杆在 V 型槽中滑动，保证方向一致',
              '手指关节自然弯曲，手桥要稳不能晃动',
              '架杆点距白球约 15-25cm',
            ]),
            SizedBox(height: 12),
            _StanceDiagramWidget(),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 3, title: '站姿与身体对线'),
          _InfoCard(children: [
            _Paragraph(
              '良好的站姿是准度的基础。身体对线错误，瞄再准也打不进。',
            ),
            SizedBox(height: 12),
            _StanceTopViewWidget(),
            SizedBox(height: 12),
            _Heading('站姿要点'),
            _BulletList(items: [
              '右手击球者：右脚在前，略内扣，左脚在后自然张开',
              '身体前倾，下巴尽量贴近球杆（"脸贴杆"）',
              '球杆应在下巴正下方，眼睛沿球杆方向看出去',
              '重心放在前脚（约 60%-70%）',
              '双脚距离约与肩同宽，保持自然放松',
              '身体中线（鼻子→下巴→球杆）要在同一竖直平面内',
            ]),
            SizedBox(height: 12),
            _Heading('身体对线方法'),
            _NumberedList(items: [
              '站在球的正后方，面朝目标球方向',
              '确认瞄准线：白球→目标球→袋口',
              '沿瞄准线方向迈出前脚（右脚），脚尖指向目标',
              '保持视线不变地弯腰下去，下巴贴杆',
              '此时球杆方向应自然对准目标',
            ]),
            SizedBox(height: 12),
            _StanceSideViewWidget(),
            SizedBox(height: 8),
            _Paragraph(
              '小贴士：很多人弯腰后身体会歪，导致对线跑偏。练习时可以让朋友站在身后检查你的球杆是否在身体中线上。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 4, title: '出杆基本功'),
          _InfoCard(children: [
            _Heading('出杆的四个阶段'),
            SizedBox(height: 8),
            _NumberedList(items: [
              '预备：身体就位，瞄准目标，放松呼吸',
              '试杆：前后匀速小幅拉送 3-5 次，找准节奏和方向',
              '拉杆：最后一次向后拉杆，动作平稳',
              '出杆：加速前送，穿透白球，自然随势（follow through）',
            ]),
            SizedBox(height: 12),
            _Heading('常见错误'),
            _BulletList(items: [
              '出杆时抬头（最常见！）→ 眼睛要盯着接触点到球离杆后才抬头',
              '握杆太紧 → 手腕僵硬，出杆歪斜',
              '出杆减速/戳球 → 要"送"不要"戳"，杆头穿过白球的位置',
              '身体晃动 → 除前臂外全身静止',
            ]),
          ]),

          // ========== 瞄准篇 ==========
          SizedBox(height: 32),
          _PartTitle(text: '瞄准篇'),

          SizedBox(height: 16),
          _SectionHeader(number: 5, title: '假想球瞄准法（Ghost Ball）'),
          _InfoCard(children: [
            _Paragraph(
              '最基础也最重要的瞄准方法。核心思想：想象一个白球（假想球）正好贴在目标球上、'
              '位于球袋连线方向上。你的任务就是把真正的白球打到假想球的位置。',
            ),
            SizedBox(height: 12),
            _GhostBallDiagramWidget(),
            SizedBox(height: 12),
            _NumberedList(items: [
              '先确定目标球到袋口的连线方向',
              '沿这条连线，在目标球背面一个球直径处找到"假想球"位置',
              '假想球的球心就是你要把白球打到的位置',
              '瞄准假想球球心出杆',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '假想球法是所有瞄准体系的根基。优点是直觉好理解；缺点是当角度较大时，'
              '因为"假想球"只存在于脑海中，容易偏差。所以需要配合其他方法辅助。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 6, title: '接触点瞄准法（Contact Point）'),
          _InfoCard(children: [
            _Paragraph(
              '不去想"假想球"，而是直接寻找白球碰到目标球时的接触点。',
            ),
            SizedBox(height: 12),
            _ContactPointDiagramWidget(),
            SizedBox(height: 12),
            _NumberedList(items: [
              '画出目标球到袋口的连线',
              '连线延长到目标球表面的背面，那个点就是接触点',
              '瞄准白球的前缘（不是球心）打向接触点',
              '注意：白球的前缘到球心有一个球半径的偏差，初学者容易瞄偏',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '接触点法的好处是可以直接在目标球上"看到"一个实际的点，'
              '比假想球更容易定位。但需要习惯"球心 vs 球缘"的差异。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 7, title: '切角与厚薄'),
          _InfoCard(children: [
            _Paragraph(
              '切角（Cut Angle）即白球入射方向与球心连线的夹角。切角决定了碰撞后目标球的偏移方向。'
              '厚薄是切角的另一种直觉表达。',
            ),
            SizedBox(height: 12),
            _ThicknessChartWidget(),
            SizedBox(height: 12),
            _BulletList(items: [
              '切角 0° = 正面碰（全厚），目标球直线前进',
              '切角 15° ≈ 3/4 厚',
              '切角 30° ≈ 半球',
              '切角 45° ≈ 1/4 厚',
              '切角 60° = 极薄球，非常难打准',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '厚度（fullness）的直觉理解：从瞄准方向看过去，白球和目标球的"重叠程度"。\n\n'
              '• 全厚 = 完全重叠（正撞）\n'
              '• 半球 = 白球球心对准目标球边缘\n'
              '• 1/4 厚 = 只擦到目标球约 1/4 的宽度\n\n'
              '厚度越薄（切角越大），角度越难控制，需要更多练习。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 8, title: '半球法（Half-Ball）'),
          _InfoCard(children: [
            _Paragraph(
              '半球是最常用的参考角度。当白球球心对准目标球的边缘时，就是半球。',
            ),
            SizedBox(height: 12),
            _HalfBallDiagramWidget(),
            SizedBox(height: 12),
            _BulletList(items: [
              '半球 = 切角约 30°，厚度约 50%',
              '目标球偏转角度约 30°',
              '白球偏转角度约 60°（中杆下）',
              '这是实战中出现频率最高的角度之一',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '掌握半球后，以此为基准上下调整：\n'
              '• 比半球"厚一点" → 3/4 厚（瞄向球心和边缘中点）\n'
              '• 比半球"薄一点" → 1/4 厚（白球只碰到边缘 1/4 处）',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 9, title: '平行线法（Parallel Aim）'),
          _InfoCard(children: [
            _Paragraph(
              '适用于远距离薄球瞄准，利用平行移动来简化角度判断。',
            ),
            SizedBox(height: 12),
            _ParallelAimDiagramWidget(),
            SizedBox(height: 12),
            _NumberedList(items: [
              '画出目标球球心到袋口的连线（进球线）',
              '将这条线平移一个球的半径到目标球外侧',
              '白球打向这条平行线上对应的位置',
              '平行线法不需要找"假想球"，只需要找"平行线上的点"',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '优点：远距离时比假想球法更精确，因为平行线可以延伸到桌面上直接对比。'
              '\n缺点：近距离时没必要用，增加思考时间。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 10, title: '直角三角形法与倍数记忆'),
          _InfoCard(children: [
            _Paragraph(
              '将碰撞几何抽象为直角三角形，用边长比例快速判断角度。',
            ),
            SizedBox(height: 12),
            _TriangleAimDiagramWidget(),
            SizedBox(height: 12),
            _BulletList(items: [
              '斜边 = 白球瞄准方向（入射线）',
              '长边 = 目标球运动方向（球心连线/碰撞法线）',
              '短边 = 白球偏转方向（碰撞切线）',
            ]),
            SizedBox(height: 12),
            _Heading('常用角度倍数表'),
            _BulletList(items: [
              '15° → 斜3.9 : 长3.7 : 短1.0',
              '30° → 斜2.0 : 长1.7 : 短1.0',
              '45° → 斜1.4 : 长1.0 : 短1.0',
              '60° → 斜1.2 : 长0.6 : 短1.0',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '实战技巧：30° 时斜边约是短边的 2 倍 → 如果白球到碰撞点的距离约是"偏移量"的 2 倍，就是半球角度。'
              '这比精确计算更实用。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 11, title: '分段瞄准法与"对点"'),
          _InfoCard(children: [
            _Paragraph(
              '当以上方法都不够直觉时，可以在球台上"找参考点"来辅助瞄准。',
            ),
            SizedBox(height: 12),
            _Heading('钻石点（菱形点）'),
            _BulletList(items: [
              '球台库边上通常有标记点（钻石点/菱形点），将球台等分',
              '利用钻石点做参考，可以快速估算翻袋路线',
              '例如：从第 2 个钻石点打向对面第 5 个钻石点的球路，碰库后会到达某个固定位置',
              '这在做安全球和翻袋时非常实用',
            ]),
            SizedBox(height: 12),
            _Heading('瞄准流程总结'),
            _NumberedList(items: [
              '确定进球线（目标球→袋口）',
              '选择瞄准方法（假想球 / 接触点 / 平行线 / 三角形）',
              '找到白球需要打到的位置',
              '站位、对线、试杆',
              '确认后出杆，眼睛盯住接触点',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '不同方法适合不同角度和距离，成熟的球手会混合使用多种方法。'
              '初学建议先熟练假想球法 + 半球参考，再学习平行线法和三角形法。',
            ),
          ]),

          // ========== 白球控制篇 ==========
          SizedBox(height: 32),
          _PartTitle(text: '白球控制篇'),

          SizedBox(height: 16),
          _SectionHeader(number: 12, title: '杆法（击球点位）'),
          _InfoCard(children: [
            _Paragraph(
              '杆法是控制白球碰撞后走位的核心手段。不同的击球点会产生截然不同的效果。',
            ),
            SizedBox(height: 12),
            _StrikeDiagramWidget(),
            SizedBox(height: 16),
            _Heading('中杆'),
            _BulletList(items: [
              '击打白球正中心',
              '碰撞后白球自然滑行，速度逐渐衰减',
              '最基础、最安全的杆法',
            ]),
            SizedBox(height: 12),
            _Heading('高杆（跟球/推杆）'),
            _BulletList(items: [
              '击打白球中心偏上部（约上方 1/3 处）',
              '白球产生前旋（topspin），碰撞后继续向前',
              '力量越大、击点越高，跟球距离越远',
              '适用于：需要白球跟随目标球前进的场景',
            ]),
            SizedBox(height: 12),
            _Heading('低杆（拉杆/缩杆）'),
            _BulletList(items: [
              '击打白球中心偏下部（约下方 1/3 处）',
              '白球产生后旋（backspin），碰撞后向后退回',
              '需要较大力量和较快的杆速才能有效',
              '适用于：白球需要回退、远离目标球方向的场景',
            ]),
            SizedBox(height: 12),
            _Heading('左/右塞（侧旋）'),
            _BulletList(items: [
              '击打白球左侧或右侧',
              '白球产生侧旋（english/side spin）',
              '碰库后会改变反弹角度（塞越大，变化越大）',
              '同时会有少量的"让点"效应（throw）',
              '与高低杆组合使用，控制更灵活',
            ]),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 13, title: '分离角原理'),
          _InfoCard(children: [
            _Paragraph(
              '碰撞后白球和目标球的夹角叫分离角。理解分离角是走位的关键。',
            ),
            SizedBox(height: 12),
            _SeparationAngleDiagramWidget(),
            SizedBox(height: 12),
            _Heading('中杆（无旋转）分离角规律'),
            _Paragraph(
              '分离角指的是碰撞后白球和目标球运动方向之间的夹角。'
              '在中杆（无旋转）下：',
            ),
            SizedBox(height: 6),
            _BulletList(items: [
              '白球和目标球的出射方向夹角 ≈ 90°（几乎总是成立）',
              '切角越小（越正），白球偏转越大；切角越大（越薄），白球偏转越小',
              '正面碰（切角0°）时白球停住，目标球直走',
            ]),
            SizedBox(height: 12),
            _Heading('不同杆法对分离角的影响'),
            _BulletList(items: [
              '高杆 → 两球夹角 < 90°（白球被"拉向"目标球方向）',
              '低杆 → 两球夹角 > 90°（白球向后退）',
              '中杆 → 两球夹角 ≈ 90°',
              '强烈跟球 → 夹角可以非常小，甚至"穿越"目标球位置',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '实战中，先确认当前球的切角大小，再选择杆法，才能精确控制白球走位。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 14, title: '库边反射（翻袋）'),
          _InfoCard(children: [
            _Paragraph(
              '球碰到库边后会反弹。在理想情况下（无旋转），入射角 = 反射角。',
            ),
            SizedBox(height: 12),
            _CushionDiagramWidget(),
            SizedBox(height: 12),
            _BulletList(items: [
              '无塞：入射角 ≈ 反射角',
              '顺塞（球旋转方向与反弹方向一致）→ 反射角变大，球弹得更"开"',
              '逆塞（旋转方向与反弹方向相反）→ 反射角变小，球弹得更"收"',
              '库边摩擦力会"吃"掉一部分速度，实际角度略小于理论值',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '翻袋是实战中非常重要的技术。当目标球靠近库边、直接进袋困难时，'
              '可以利用一库甚至两库反射来进球。关键在于找到正确的反射点。',
            ),
          ]),

          // ========== 实战策略篇 ==========
          SizedBox(height: 32),
          _PartTitle(text: '实战策略篇'),

          SizedBox(height: 16),
          _SectionHeader(number: 15, title: '走位思路'),
          _InfoCard(children: [
            _Paragraph(
              '"进球是手段，走位才是目的。"高手和新手的最大区别不在于准度，而在于走位意识。',
            ),
            SizedBox(height: 12),
            _Heading('走位三原则'),
            _NumberedList(items: [
              '打到哪，比打进更重要 — 每一杆都要规划白球停在哪里',
              '简单角度优先 — 走到下一颗球的简单进攻位置',
              '留有余地 — 走位不要追求极限，留容错空间',
            ]),
            SizedBox(height: 12),
            _Heading('走位要素'),
            _BulletList(items: [
              '力度：决定白球走多远',
              '杆法：决定白球碰后怎么走（前进/后退/停住）',
              '加塞：决定碰库后的反弹角度',
              '切角：决定分离角大小和白球初始偏转方向',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '每次出杆前的思考顺序：\n'
              '① 这颗球怎么进？ → ② 白球会走到哪？ → ③ 下一颗球能不能打？ → 如果不能，调整力度或杆法。',
            ),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 16, title: '清台策略（中式八球）'),
          _InfoCard(children: [
            _Paragraph(
              '中式八球的清台不是随便打进就行，需要提前规划整个顺序。',
            ),
            SizedBox(height: 12),
            _Heading('清台四步法'),
            _NumberedList(items: [
              '识别关键球 — 找出位置最差、最难打的球（通常是贴库球或被挡住的球）',
              '逆向规划 — 从关键球往回推：打关键球时白球要在哪？→ 那上一颗球怎么走过去？',
              '确定顺序 — 先打简单球，最后处理关键球；把 8 号球留到最后一颗好打的位置',
              '执行与调整 — 按计划打，走位偏差时及时调整后续顺序',
            ]),
            SizedBox(height: 12),
            _Heading('常见陷阱'),
            _BulletList(items: [
              '只顾进球不想走位 → 越打越难',
              '忽略关键球 → 打到最后发现有球打不进',
              '走位不留退路 → 一旦偏差就连锁崩盘',
              '急于打 8 号 → 己方球没清完就冒险，容易犯规',
            ]),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 17, title: '防守与安全球'),
          _InfoCard(children: [
            _Paragraph(
              '打不进时，最好的选择不是碰运气，而是做安全球（Safety）。',
            ),
            SizedBox(height: 12),
            _Heading('安全球的目标'),
            _BulletList(items: [
              '让白球停在对方很难进攻的位置',
              '最好让白球躲到自己的球后面',
              '或者让白球和目标球距离很远（远台难度大）',
              '或者让白球贴库（出杆受限）',
            ]),
            SizedBox(height: 12),
            _Heading('常用安全球技术'),
            _BulletList(items: [
              '碰球后让白球贴到远端库边',
              '轻推目标球到库边，白球留在另一端',
              '借力：利用碰撞让目标球挡住白球的进攻路线',
              '贴球做斯诺克：让白球紧贴障碍球，对方看不到目标球',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '中式八球有"无球入袋且无球碰库即犯规"的规则，所以做安全球时至少要保证有一颗球碰库。',
            ),
          ]),

          // ========== 进阶篇 ==========
          SizedBox(height: 32),
          _PartTitle(text: '进阶篇'),

          SizedBox(height: 16),
          _SectionHeader(number: 18, title: '组合球与传球'),
          _InfoCard(children: [
            _Heading('组合球（Combination）'),
            _Paragraph(
              '当目标球无法直接进袋时，利用另一颗球作为"跳板"——先打白球撞 A 球，'
              'A 球再撞 B 球入袋。',
            ),
            SizedBox(height: 8),
            _BulletList(items: [
              '组合球的关键：A 球和 B 球的连线必须指向袋口',
              '组合球精度衰减很快，距离越远越难',
              '优先选择 A-B 距离很近的组合球',
            ]),
            SizedBox(height: 12),
            _Heading('传球（Carom / Billiard）'),
            _Paragraph(
              '白球碰目标球后反弹，再去撞另一颗球入袋。或者白球碰库后去撞目标球。',
            ),
            SizedBox(height: 8),
            _BulletList(items: [
              '传球主要靠对白球碰撞后走位的精确控制',
              '常见场景：白球碰 A 球后走位去碰 B 球入袋',
              '高阶技术，需要大量实战积累手感',
            ]),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 19, title: '开球技术'),
          _InfoCard(children: [
            _Paragraph(
              '开球是每局的第一杆，好的开球能在一开始就建立优势。',
            ),
            SizedBox(height: 12),
            _Heading('中式八球开球要点'),
            _BulletList(items: [
              '白球放在开球线后（通常在中线偏左或偏右一个球位）',
              '瞄准三角阵的第一颗球（正前方）的正中心',
              '使用大力正面击打（全力或 80% 力），确保球散开',
              '适当高杆可以让白球碰后停在球台中部',
              '开球时须保证至少 4 颗球碰库，否则犯规',
            ]),
            SizedBox(height: 12),
            _Heading('开球常见目标'),
            _NumberedList(items: [
              '散球充分 — 尽量让球分散开',
              '进球 — 能在开球直接打进更好',
              '白球控制 — 白球留在球台中部，不要落袋',
              '不碰 8 号球进袋 — 某些规则下直接判负',
            ]),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 20, title: '塞球（Side Spin）进阶'),
          _InfoCard(children: [
            _Paragraph(
              '加塞是高阶走位的核心武器，但也是最容易"跑偏"的技术。',
            ),
            SizedBox(height: 12),
            _Heading('塞球对瞄准的影响'),
            _BulletList(items: [
              '让点效应（Squirt/Deflection）：出杆瞬间白球不会沿球杆方向走，而是向塞的反方向偏移',
              '弧线效应（Swerve/Curve）：白球在台面上会画弧线',
              '碰撞转移（Throw）：碰到目标球时，塞会让目标球偏移',
            ]),
            SizedBox(height: 12),
            _Heading('如何补偿塞球偏移'),
            _BulletList(items: [
              '经验法：靠大量练习积累不同塞量的偏移量感觉',
              '反向瞄准法：加右塞时，瞄准点向左偏移半个球左右',
              '减少塞量：实战中尽量用小塞解决问题，大塞风险高',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '塞球的核心应用场景是碰库走位。通过加塞改变白球碰库后的反弹角度，'
              '实现普通杆法无法到达的位置。',
            ),
          ]),

          // ========== 心理与训练 ==========
          SizedBox(height: 32),
          _PartTitle(text: '训练与心态'),

          SizedBox(height: 16),
          _SectionHeader(number: 21, title: '训练方法'),
          _InfoCard(children: [
            _Heading('直球训练'),
            _Paragraph(
              '在球台中线上摆一颗目标球，白球在不同距离正面直线击打进袋。'
              '这是检验出杆直不直的最好方法。',
            ),
            SizedBox(height: 12),
            _Heading('角度球训练'),
            _BulletList(items: [
              '固定目标球在袋口前方，白球放在不同角度位置',
              '从小角度（15°）开始练，逐渐增加到 45°、60°',
              '每个角度至少连续命中 5 球才算过关',
            ]),
            SizedBox(height: 12),
            _Heading('走位训练'),
            _BulletList(items: [
              '白球进一颗球后要求停在指定区域',
              '单颗球+不同杆法练习：中杆/高杆/低杆各停哪里',
              '连续清 3-5 颗球练习：规划+执行',
            ]),
            SizedBox(height: 12),
            _Heading('综合训练'),
            _BulletList(items: [
              '随机摆球清台：模拟实战',
              '安全球对练：双人轮流做安全球',
              '限时训练：培养在压力下的稳定性',
            ]),
          ]),

          SizedBox(height: 24),
          _SectionHeader(number: 22, title: '比赛心态'),
          _InfoCard(children: [
            _BulletList(items: [
              '专注当前这一杆 — 不要想比分，不要想上一杆的失误',
              '打自己的节奏 — 不要被对手的节奏带走',
              '有把握才进攻 — 没有好的进攻机会就做防守，不要赌运气',
              '接受失误 — 失误是正常的，重要的是快速调整',
              '赛前热身 — 至少打 15 分钟直球和角度球找手感',
              '保持呼吸 — 出杆前深呼吸，不要憋气',
            ]),
            SizedBox(height: 12),
            _Paragraph(
              '"台球是一项 90% 心理、10% 技术的运动。" — 这句话夸张了一点，'
              '但确实说明了心态的重要性。技术练到一定程度后，决定胜负的往往是心理素质。',
            ),
          ]),

          SizedBox(height: 48),
          Center(
            child: Text(
              '勤加练习，享受台球的乐趣！',
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
            child: Text('$number',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Color(0xFF81C784),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _PartTitle extends StatelessWidget {
  const _PartTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white12)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text,
              style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4)),
        ),
        const Expanded(child: Divider(color: Colors.white12)),
      ],
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
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
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
      style: TextStyle(
          color: Colors.white.withValues(alpha: 0.85),
          fontSize: 14,
          height: 1.7),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 15,
              fontWeight: FontWeight.bold)),
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
                    Text('• ',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14)),
                    Expanded(
                        child: Text(item,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                height: 1.5))),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _NumberedList extends StatelessWidget {
  const _NumberedList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .asMap()
          .entries
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 22,
                      child: Text('${e.key + 1}.',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                        child: Text(e.value,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                height: 1.5))),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

// ============ Custom Paint Diagrams ============

class _StanceDiagramWidget extends StatelessWidget {
  const _StanceDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100, child: CustomPaint(painter: _StanceDiagramPainter()));
  }
}

class _StanceDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // V-bridge hand (left)
    final bridgeX = cx - 60.0;
    final bridgeY = cy + 5.0;
    final handPaint = Paint()..color = const Color(0x44FFFFFF)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawOval(Rect.fromCenter(center: Offset(bridgeX, bridgeY), width: 30, height: 18), handPaint);
    _drawLabel(canvas, '手桥 (V型)', Offset(bridgeX - 22, bridgeY + 14), Colors.white38);

    // Cue stick line
    final cuePaint = Paint()..color = const Color(0xFF8D6E63)..strokeWidth = 2.5;
    canvas.drawLine(Offset(cx - 100, cy), Offset(cx + 90, cy), cuePaint);

    // Cue tip
    canvas.drawCircle(Offset(cx + 90, cy), 2, Paint()..color = const Color(0xFF00BCD4));

    // White ball at tip
    canvas.drawCircle(Offset(cx + 100, cy), 6, Paint()..color = Colors.white);
    _drawLabel(canvas, '白球', Offset(cx + 92, cy + 10), Colors.white54);

    // Rear hand
    final rearX = cx - 30.0;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(rearX, cy), width: 24, height: 16),
      Paint()..color = const Color(0x44FFFFFF)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );
    _drawLabel(canvas, '后手', Offset(rearX - 10, cy + 14), Colors.white38);

    // Distance labels
    final distPaint = Paint()..color = Colors.white24..strokeWidth = 0.8;
    canvas.drawLine(Offset(bridgeX, cy - 20), Offset(cx + 90, cy - 20), distPaint);
    _drawLabel(canvas, '15-25cm', Offset(cx + 8, cy - 32), Colors.white30);
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

class _GhostBallDiagramWidget extends StatelessWidget {
  const _GhostBallDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 120, child: CustomPaint(painter: _GhostBallDiagramPainter()));
  }
}

class _GhostBallDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 10.0;

    // Pocket
    canvas.drawCircle(Offset(cx + 120, cy - 30), 14, Paint()..color = const Color(0xFF0D0D0D));
    _drawLabel(canvas, '袋口', Offset(cx + 108, cy - 52), Colors.white38);

    // Object ball
    final objPos = Offset(cx + 30, cy);
    canvas.drawCircle(objPos, r, Paint()..color = const Color(0xFFF9D923));
    _drawLabel(canvas, '目标球', Offset(cx + 16, cy + 14), const Color(0xAAF9D923));

    // Line from object to pocket
    canvas.drawLine(objPos, Offset(cx + 120, cy - 30),
        Paint()..color = Colors.white12..strokeWidth = 1);

    // Ghost ball position (on the line from pocket through object ball, one diameter behind)
    final toPocket = Offset(cx + 120 - objPos.dx, cy - 30 - objPos.dy);
    final d = toPocket.distance;
    final norm = d > 0.01 ? toPocket / d : const Offset(1, 0);
    final ghostPos = Offset(objPos.dx - norm.dx * r * 2, objPos.dy - norm.dy * r * 2);

    canvas.drawCircle(ghostPos, r,
        Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1.5);
    _drawLabel(canvas, '假想球', Offset(ghostPos.dx - 14, ghostPos.dy + 14), Colors.white54);

    // Cue ball (further back)
    final cuePos = Offset(cx - 80, cy + 15);
    canvas.drawCircle(cuePos, r, Paint()..color = Colors.white);
    _drawLabel(canvas, '白球', Offset(cuePos.dx - 10, cuePos.dy + 14), Colors.white54);

    // Aim line: cue → ghost
    _drawDashed(canvas, cuePos, ghostPos, const Color(0xFF66BB6A));

    // Arrow from ghost center pointing to object ball center
    canvas.drawLine(ghostPos, objPos,
        Paint()..color = Colors.white30..strokeWidth = 1);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + 4.0, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += 7.0;
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

class _ThicknessChartWidget extends StatelessWidget {
  const _ThicknessChartWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 80, child: CustomPaint(painter: _ThicknessChartPainter()));
  }
}

class _ThicknessChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const r = 12.0;
    final labels = ['全厚 0°', '3/4 15°', '半球 30°', '1/4 45°', '极薄 60°'];
    final thicknesses = [1.0, 0.75, 0.5, 0.25, 0.1];
    final spacing = size.width / (labels.length + 1);

    for (var i = 0; i < labels.length; i++) {
      final x = spacing * (i + 1);
      final y = size.height / 2 - 8;

      // Target ball
      canvas.drawCircle(Offset(x, y), r, Paint()..color = const Color(0x55F9D923));
      canvas.drawCircle(Offset(x, y), r,
          Paint()..color = const Color(0xAAF9D923)..style = PaintingStyle.stroke..strokeWidth = 1);

      // White ball overlap area (simplified)
      final overlap = thicknesses[i];
      final offset = r * 2 * (1 - overlap);
      final cueX = x - offset;
      canvas.drawCircle(Offset(cueX, y), r,
          Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1.2);

      // Label
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: const TextStyle(color: Colors.white54, fontSize: 9)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y + r + 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StrikeDiagramWidget extends StatelessWidget {
  const _StrikeDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 110, child: CustomPaint(painter: _StrikeDiagramPainter()));
  }
}

class _StrikeDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const r = 32.0;

    void drawStrikePoint(
        double cx, double cy, double dx, double dy, String label, Color dotColor) {
      // Ball outline
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white10);
      canvas.drawCircle(Offset(cx, cy), r,
          Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);

      // Cross lines
      canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy),
          Paint()..color = Colors.white10..strokeWidth = 0.5);
      canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r),
          Paint()..color = Colors.white10..strokeWidth = 0.5);

      // Strike point
      canvas.drawCircle(Offset(cx + dx, cy + dy), 5, Paint()..color = dotColor);

      // Label
      final tp = TextPainter(
        text: TextSpan(text: label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy + r + 6));
    }

    final spacing = size.width / 6;
    drawStrikePoint(spacing, 48, 0, -14, '高杆', const Color(0xFF4CAF50));
    drawStrikePoint(spacing * 2, 48, 0, 0, '中杆', Colors.white);
    drawStrikePoint(spacing * 3, 48, 0, 14, '低杆', const Color(0xFF2196F3));
    drawStrikePoint(spacing * 4, 48, -14, 0, '左塞', const Color(0xFFFF9800));
    drawStrikePoint(spacing * 5, 48, 14, 0, '右塞', const Color(0xFFE91E63));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeparationAngleDiagramWidget extends StatelessWidget {
  const _SeparationAngleDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 130, child: CustomPaint(painter: _SeparationAngleDiagramPainter()));
  }
}

class _SeparationAngleDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 8.0;

    // Collision point
    final collPt = Offset(cx, cy);

    // Object ball direction (30° cut → object goes along center line)
    const cutAngle = 30.0 * math.pi / 180;
    final objDir = Offset(math.cos(-cutAngle), math.sin(-cutAngle));
    final objEnd = collPt + objDir * 70;

    // White ball incoming direction (from lower left)
    final aimDir = Offset(1, 0);
    final aimStart = collPt - aimDir * 80;

    // White ball deflection (~90° from object direction in center-ball)
    final sepDir = Offset(math.sin(cutAngle), math.cos(cutAngle));
    final sepEnd = collPt + sepDir * 50;

    // Draw incoming line (green dashed)
    _drawDashed(canvas, aimStart, collPt, const Color(0xFF66BB6A));

    // Object ball
    canvas.drawCircle(collPt + objDir * (r * 2.5), r, Paint()..color = const Color(0x88F9D923));

    // Object path (yellow dashed)
    _drawDashed(canvas, collPt, objEnd, const Color(0xFFFFEB3B));
    _drawLabel(canvas, '目标球', Offset(objEnd.dx + 4, objEnd.dy - 6), const Color(0xAAF9D923));

    // Separation line (blue dashed)
    _drawDashed(canvas, collPt, sepEnd, const Color(0xFF00BFFF));
    _drawLabel(canvas, '白球偏转', Offset(sepEnd.dx + 4, sepEnd.dy - 4), const Color(0xAA00BFFF));

    // White ball
    canvas.drawCircle(aimStart, r, Paint()..color = Colors.white);
    _drawLabel(canvas, '白球', Offset(aimStart.dx - 10, aimStart.dy + 12), Colors.white54);

    // 90° arc between object path and separation
    final arcAngle1 = math.atan2(objDir.dy, objDir.dx);
    final arcAngle2 = math.atan2(sepDir.dy, sepDir.dx);
    var sweep = arcAngle2 - arcAngle1;
    if (sweep < 0) sweep += 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: collPt, radius: 22),
      arcAngle1, sweep, false,
      Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 1.2,
    );
    _drawLabel(canvas, '≈90°', Offset(collPt.dx + 6, collPt.dy + 10), Colors.white54);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + 4.0, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += 7.0;
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

class _CushionDiagramWidget extends StatelessWidget {
  const _CushionDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100, child: CustomPaint(painter: _CushionDiagramPainter()));
  }
}

class _CushionDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.8;
    final ox = (size.width - w) / 2;
    const cushionY = 20.0;

    canvas.drawLine(Offset(ox, cushionY), Offset(ox + w, cushionY),
        Paint()..color = const Color(0xFF4E342E)..strokeWidth = 4);

    final hitX = ox + w * 0.45;
    canvas.drawLine(Offset(hitX, cushionY), Offset(hitX, cushionY + 60),
        Paint()..color = Colors.white12..strokeWidth = 0.8);
    _drawLabel(canvas, '法线', Offset(hitX + 3, cushionY + 50), Colors.white24);

    const inAngle = 40.0 * math.pi / 180;
    final inStart = Offset(hitX - 60 * math.sin(inAngle), cushionY + 60 * math.cos(inAngle));
    canvas.drawCircle(inStart, 6, Paint()..color = Colors.white);
    _drawDashed(canvas, inStart, Offset(hitX, cushionY), const Color(0xFF66BB6A));
    _drawLabel(canvas, '入射', Offset(inStart.dx - 20, inStart.dy - 12), const Color(0xAA66BB6A));

    final outEnd = Offset(hitX + 60 * math.sin(inAngle), cushionY + 60 * math.cos(inAngle));
    _drawDashed(canvas, Offset(hitX, cushionY), outEnd, Colors.white54);
    _drawLabel(canvas, '无塞反射', Offset(outEnd.dx + 4, outEnd.dy - 6), Colors.white38);

    const widerAngle = 55.0 * math.pi / 180;
    final outWider = Offset(hitX + 50 * math.sin(widerAngle), cushionY + 50 * math.cos(widerAngle));
    _drawDashed(canvas, Offset(hitX, cushionY), outWider, const Color(0xAAFF9800));
    _drawLabel(canvas, '顺塞', Offset(outWider.dx + 4, outWider.dy - 2), const Color(0xAAFF9800));

    const tighterAngle = 25.0 * math.pi / 180;
    final outTighter = Offset(hitX + 50 * math.sin(tighterAngle), cushionY + 50 * math.cos(tighterAngle));
    _drawDashed(canvas, Offset(hitX, cushionY), outTighter, const Color(0xAA2196F3));
    _drawLabel(canvas, '逆塞', Offset(outTighter.dx + 4, outTighter.dy - 6), const Color(0xAA2196F3));

    _drawAngleArc(canvas, Offset(hitX, cushionY), math.pi / 2, inAngle, 18, Colors.white24);
  }

  void _drawAngleArc(Canvas canvas, Offset center, double startNormal, double halfAngle, double radius, Color color) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startNormal - halfAngle, halfAngle, false,
      Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startNormal, halfAngle, false,
      Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1,
    );
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + 4.0, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += 7.0;
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

// ============ New Diagram Widgets ============

class _StanceTopViewWidget extends StatelessWidget {
  const _StanceTopViewWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 110, child: CustomPaint(painter: _StanceTopViewPainter()));
  }
}

class _StanceTopViewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cue direction line (center line)
    canvas.drawLine(Offset(cx - 100, cy), Offset(cx + 80, cy),
        Paint()..color = Colors.white12..strokeWidth = 0.8);

    // Feet (top view - ovals)
    // Right foot (front, slightly turned in)
    final rfCenter = Offset(cx + 10, cy + 18);
    canvas.save();
    canvas.translate(rfCenter.dx, rfCenter.dy);
    canvas.rotate(-0.15);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 14, height: 28),
        Paint()..color = const Color(0x33FFFFFF));
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 14, height: 28),
        Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 1);
    canvas.restore();
    _drawLabel(canvas, '右脚(前)', Offset(rfCenter.dx + 10, rfCenter.dy + 4), Colors.white38);

    // Left foot (back, angled out)
    final lfCenter = Offset(cx - 30, cy - 20);
    canvas.save();
    canvas.translate(lfCenter.dx, lfCenter.dy);
    canvas.rotate(0.5);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 14, height: 28),
        Paint()..color = const Color(0x22FFFFFF));
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 14, height: 28),
        Paint()..color = Colors.white24..style = PaintingStyle.stroke..strokeWidth = 1);
    canvas.restore();
    _drawLabel(canvas, '左脚(后)', Offset(lfCenter.dx - 30, lfCenter.dy - 8), Colors.white38);

    // Body center line (dotted vertical)
    _drawDashed(canvas, Offset(cx - 10, cy - 40), Offset(cx - 10, cy + 40), Colors.white10);
    _drawLabel(canvas, '身体中线', Offset(cx - 10, cy - 48), const Color(0x33FFFFFF));

    // Cue stick
    canvas.drawLine(Offset(cx - 80, cy), Offset(cx + 70, cy),
        Paint()..color = const Color(0xFF8D6E63)..strokeWidth = 2);

    // White ball
    canvas.drawCircle(Offset(cx + 70, cy), 5, Paint()..color = Colors.white);

    // Shoulder width indicator
    canvas.drawLine(Offset(cx - 30, cy - 35), Offset(cx + 10, cy - 35),
        Paint()..color = const Color(0x26FFFFFF)..strokeWidth = 0.8);
    _drawLabel(canvas, '≈肩宽', Offset(cx - 16, cy - 48), Colors.white24);

    // Weight distribution arrow
    _drawLabel(canvas, '60-70%', Offset(cx + 12, cy + 30), const Color(0x5566BB6A));
    _drawLabel(canvas, '30-40%', Offset(lfCenter.dx - 14, lfCenter.dy + 20), const Color(0x55FFEB3B));
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 0.8;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + 3.0, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += 6.0;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StanceSideViewWidget extends StatelessWidget {
  const _StanceSideViewWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100, child: CustomPaint(painter: _StanceSideViewPainter()));
  }
}

class _StanceSideViewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    const tableY = 55.0;

    // Table surface
    canvas.drawLine(Offset(cx - 60, tableY), Offset(cx + 100, tableY),
        Paint()..color = const Color(0xFF2E7D32)..strokeWidth = 3);

    // Cue on table
    canvas.drawLine(Offset(cx - 50, tableY - 2), Offset(cx + 80, tableY - 2),
        Paint()..color = const Color(0xFF8D6E63)..strokeWidth = 2);

    // White ball
    canvas.drawCircle(Offset(cx + 80, tableY - 6), 4, Paint()..color = Colors.white);

    // Chin (head) position
    canvas.drawCircle(Offset(cx + 10, tableY - 16), 8,
        Paint()..color = Colors.white12..style = PaintingStyle.stroke..strokeWidth = 1);
    _drawLabel(canvas, '下巴贴杆', Offset(cx - 2, tableY - 35), Colors.white38);

    // Eye line
    _drawDashed(canvas, Offset(cx + 10, tableY - 16), Offset(cx + 80, tableY - 6), const Color(0x5566BB6A));
    _drawLabel(canvas, '视线', Offset(cx + 40, tableY - 24), const Color(0x7766BB6A));

    // Rear arm
    canvas.drawLine(Offset(cx - 40, tableY - 30), Offset(cx - 10, tableY - 4),
        Paint()..color = Colors.white24..strokeWidth = 1.5);
    _drawLabel(canvas, '前臂摆动', Offset(cx - 55, tableY - 38), Colors.white30);

    // Upper arm (stays still)
    canvas.drawLine(Offset(cx - 40, tableY - 30), Offset(cx - 40, tableY - 60),
        Paint()..color = const Color(0x26FFFFFF)..strokeWidth = 1.5);
    _drawLabel(canvas, '大臂不动', Offset(cx - 62, tableY - 68), Colors.white24);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + 3.0, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += 6.0;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContactPointDiagramWidget extends StatelessWidget {
  const _ContactPointDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 120, child: CustomPaint(painter: _ContactPointDiagramPainter()));
  }
}

class _ContactPointDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 12.0;

    // Pocket
    canvas.drawCircle(Offset(cx + 130, cy - 20), 12, Paint()..color = const Color(0xFF0D0D0D));
    _drawLabel(canvas, '袋口', Offset(cx + 120, cy - 40), Colors.white38);

    // Object ball
    final objPos = Offset(cx + 20, cy);
    canvas.drawCircle(objPos, r, Paint()..color = const Color(0xFFF9D923));

    // Line from pocket through object ball
    final toObj = Offset(objPos.dx - (cx + 130), objPos.dy - (cy - 20));
    final d0 = toObj.distance;
    final norm = d0 > 0.01 ? toObj / d0 : const Offset(1, 0);

    // Contact point (on back surface of object ball)
    final contactPt = Offset(objPos.dx + norm.dx * r, objPos.dy + norm.dy * r);
    canvas.drawCircle(contactPt, 3.5, Paint()..color = const Color(0xFFFF5722));
    _drawLabel(canvas, '接触点', Offset(contactPt.dx + 6, contactPt.dy + 2), const Color(0xCCFF5722));

    // Aim line to pocket through object
    canvas.drawLine(objPos, Offset(cx + 130, cy - 20),
        Paint()..color = Colors.white12..strokeWidth = 0.8);

    // Cue ball
    final cuePos = Offset(cx - 80, cy + 10);
    canvas.drawCircle(cuePos, r, Paint()..color = Colors.white);
    _drawLabel(canvas, '白球', Offset(cuePos.dx - 10, cuePos.dy + 16), Colors.white54);

    // Aim line from cue to contact point
    _drawDashed(canvas, cuePos, contactPt, const Color(0xFF66BB6A));

    // Show "球缘" vs "球心" distinction
    final cueFrontEdge = Offset(
      cuePos.dx + (contactPt.dx - cuePos.dx) / (contactPt - cuePos).distance * r,
      cuePos.dy + (contactPt.dy - cuePos.dy) / (contactPt - cuePos).distance * r,
    );
    canvas.drawCircle(cueFrontEdge, 2, Paint()..color = const Color(0xFF66BB6A));
    _drawLabel(canvas, '球缘对准接触点', Offset(cx - 50, cy - 20), const Color(0x8866BB6A));
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + 4.0, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += 7.0;
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

class _HalfBallDiagramWidget extends StatelessWidget {
  const _HalfBallDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100, child: CustomPaint(painter: _HalfBallDiagramPainter()));
  }
}

class _HalfBallDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 14.0;

    // Object ball
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0x88F9D923));
    canvas.drawCircle(Offset(cx, cy), r,
        Paint()..color = const Color(0xAAF9D923)..style = PaintingStyle.stroke..strokeWidth = 1);
    _drawLabel(canvas, '目标球', Offset(cx - 14, cy + r + 4), const Color(0xAAF9D923));

    // Object ball center marker
    canvas.drawCircle(Offset(cx, cy), 2, Paint()..color = const Color(0xCCF9D923));

    // White ball at half-ball position (center aligned with edge of object)
    final cueCx = cx - r * 2;
    canvas.drawCircle(Offset(cueCx, cy - r), r,
        Paint()..color = Colors.white30..style = PaintingStyle.stroke..strokeWidth = 1.2);
    _drawLabel(canvas, '白球(球心对边缘)', Offset(cueCx - 36, cy - r - 18), Colors.white54);

    // White ball center dot
    canvas.drawCircle(Offset(cueCx, cy - r), 2, Paint()..color = Colors.white70);

    // Horizontal line at object ball edge level
    canvas.drawLine(Offset(cueCx, cy - r), Offset(cx, cy - r),
        Paint()..color = const Color(0x33FFFFFF)..strokeWidth = 0.8);

    // The key: white ball center = object ball edge
    canvas.drawCircle(Offset(cx, cy - r), 3, Paint()..color = Colors.orangeAccent);
    _drawLabel(canvas, '白球球心\n= 目标球边缘', Offset(cx + 6, cy - r - 12), Colors.orangeAccent);

    // Cut angle arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: 24),
      -math.pi, 0.53, false,
      Paint()..color = Colors.orangeAccent..style = PaintingStyle.stroke..strokeWidth = 1.2,
    );
    _drawLabel(canvas, '≈30°', Offset(cx - 34, cy - 30), Colors.orangeAccent);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParallelAimDiagramWidget extends StatelessWidget {
  const _ParallelAimDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 120, child: CustomPaint(painter: _ParallelAimDiagramPainter()));
  }
}

class _ParallelAimDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 10.0;

    // Pocket
    canvas.drawCircle(Offset(cx + 110, cy - 30), 12, Paint()..color = const Color(0xFF0D0D0D));

    // Object ball
    final objPos = Offset(cx + 10, cy + 5);
    canvas.drawCircle(objPos, r, Paint()..color = const Color(0x88F9D923));
    canvas.drawCircle(objPos, r,
        Paint()..color = const Color(0xAAF9D923)..style = PaintingStyle.stroke..strokeWidth = 1);

    // Line 1: object center → pocket (main aim line)
    final toPocket = Offset(cx + 110 - objPos.dx, cy - 30 - objPos.dy);
    final d1 = toPocket.distance;
    final norm = d1 > 0.01 ? toPocket / d1 : const Offset(1, 0);
    canvas.drawLine(objPos, Offset(cx + 110, cy - 30),
        Paint()..color = const Color(0x26FFFFFF)..strokeWidth = 1);
    _drawLabel(canvas, '进球线', Offset(cx + 50, cy - 26), Colors.white30);

    // Perpendicular direction for parallel offset
    final perp = Offset(-norm.dy, norm.dx);

    // Line 2: parallel line offset by one ball radius
    final p1 = objPos + perp * r - norm * 30;
    final p2 = objPos + perp * r + norm * 100;
    _drawDashed(canvas, p1, p2, const Color(0xFF66BB6A));
    _drawLabel(canvas, '平行线 (偏移1个球半径)', Offset(cx + 30, cy + 20), const Color(0x8866BB6A));

    // Offset distance marker
    canvas.drawLine(objPos, objPos + perp * r,
        Paint()..color = Colors.orangeAccent..strokeWidth = 0.8);
    _drawLabel(canvas, 'R', Offset(objPos.dx + perp.dx * r / 2 + 2, objPos.dy + perp.dy * r / 2 - 12), Colors.orangeAccent);

    // Cue ball
    final cuePos = Offset(cx - 80, cy + 25);
    canvas.drawCircle(cuePos, r, Paint()..color = Colors.white);
    _drawLabel(canvas, '白球', Offset(cuePos.dx - 10, cuePos.dy + 14), Colors.white54);

    // Aim toward point on parallel line
    final aimTarget = objPos + perp * r;
    _drawDashed(canvas, cuePos, aimTarget, Colors.white30);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    final delta = to - from;
    final len = delta.distance;
    if (len < 1) return;
    final step = delta / len;
    var t = 0.0;
    while (t < len) {
      final end = math.min(t + 4.0, len);
      canvas.drawLine(from + step * t, from + step * end, paint);
      t += 7.0;
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 9)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TriangleAimDiagramWidget extends StatelessWidget {
  const _TriangleAimDiagramWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 130, child: CustomPaint(painter: _TriangleAimDiagramPainter()));
  }
}

class _TriangleAimDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    const cutDeg = 30.0;
    const cutRad = cutDeg * math.pi / 180;
    const triSize = 90.0;
    final a = Offset(cx - 50, cy + 25);
    final b = Offset(a.dx + triSize * math.cos(cutRad), a.dy - triSize * math.sin(cutRad));
    final foot = Offset(b.dx, a.dy);

    // Fill triangle
    final path = Path()..moveTo(a.dx, a.dy)..lineTo(b.dx, b.dy)..lineTo(foot.dx, foot.dy)..close();
    canvas.drawPath(path, Paint()..color = Colors.white.withValues(alpha: 0.04));

    // Edges with colors
    final edgePaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawLine(a, b, edgePaint..color = const Color(0xFF66BB6A));
    canvas.drawLine(a, foot, edgePaint..color = const Color(0xFFFFEB3B));
    canvas.drawLine(foot, b, edgePaint..color = const Color(0xFF00BFFF));

    // Right angle marker
    const sq = 8.0;
    canvas.drawLine(Offset(foot.dx - sq, foot.dy), Offset(foot.dx - sq, foot.dy - sq),
        Paint()..color = Colors.white30..strokeWidth = 1);
    canvas.drawLine(Offset(foot.dx - sq, foot.dy - sq), Offset(foot.dx, foot.dy - sq),
        Paint()..color = Colors.white30..strokeWidth = 1);

    // Labels with ratio
    final sinA = math.sin(cutRad);
    final cosA = math.cos(cutRad);
    _drawLabel(canvas, '斜边 ${(1/sinA).toStringAsFixed(1)}',
        Offset((a.dx + b.dx) / 2 - 32, (a.dy + b.dy) / 2 - 14), const Color(0xFF66BB6A));
    _drawLabel(canvas, '长边 ${(cosA/sinA).toStringAsFixed(1)}',
        Offset((a.dx + foot.dx) / 2 - 10, a.dy + 6), const Color(0xFFFFEB3B));
    _drawLabel(canvas, '短边 1.0',
        Offset(foot.dx + 4, (foot.dy + b.dy) / 2 - 6), const Color(0xFF00BFFF));
    _drawLabel(canvas, '30°', Offset(a.dx + 24, a.dy - 18), Colors.orangeAccent);

    // Table with angles listed
    final tableX = cx + 60.0;
    final tableY = cy - 40.0;
    _drawLabel(canvas, '角度    斜  :  长  :  短', Offset(tableX, tableY), Colors.white38);
    _drawLabel(canvas, '15°   3.9 : 3.7 : 1.0', Offset(tableX, tableY + 14), Colors.white30);
    _drawLabel(canvas, '30°   2.0 : 1.7 : 1.0', Offset(tableX, tableY + 28), const Color(0x80FFFFFF));
    _drawLabel(canvas, '45°   1.4 : 1.0 : 1.0', Offset(tableX, tableY + 42), Colors.white30);
    _drawLabel(canvas, '60°   1.2 : 0.6 : 1.0', Offset(tableX, tableY + 56), Colors.white30);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace')),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
