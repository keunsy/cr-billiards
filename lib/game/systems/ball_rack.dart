import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../components/ball.dart';
import '../table_constants.dart';

// ---------------------------------------------------------------------------
// Practice Presets
// ---------------------------------------------------------------------------
class BallPreset {
  const BallPreset({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.balls,
    this.cueBallPosition,
  });

  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  // (number, x, y) — x/y in table coordinates
  final List<(int number, double x, double y)> balls;
  final (double x, double y)? cueBallPosition;

  static const hw = TableConstants.halfLength;
  static const hh = TableConstants.halfWidth;

  static final List<BallPreset> presets = [
    // ======== 单球角度练习（最基础）========
    // 目标球(hw-30, -hh+25) 打右上角袋口(hw-3, -hh+3)
    // 母球位置按假想球中心精确计算（距假想球 70cm）
    BallPreset(
      id: 'single_straight',
      name: '单球直球',
      subtitle: '0° 切角，正对底袋',
      icon: Icons.gps_fixed,
      balls: [(1, hw - 30, -hh + 25)],
      cueBallPosition: (38.3, 9.3),
    ),
    BallPreset(
      id: 'single_15',
      name: '单球 15° 切角',
      subtitle: '小角度薄切，体会假想球偏移',
      icon: Icons.gps_fixed,
      balls: [(1, hw - 30, -hh + 25)],
      cueBallPosition: (28.7, -6.2),
    ),
    BallPreset(
      id: 'single_30',
      name: '单球 30° 切角',
      subtitle: '中等角度，半球厚度',
      icon: Icons.gps_fixed,
      balls: [(1, hw - 30, -hh + 25)],
      cueBallPosition: (23.5, -23.7),
    ),
    BallPreset(
      id: 'single_45',
      name: '单球 45° 切角',
      subtitle: '大角度，1/4 球厚度',
      icon: Icons.gps_fixed,
      balls: [(1, hw - 30, -hh + 25)],
      cueBallPosition: (22.9, -42.0),
    ),
    BallPreset(
      id: 'single_60',
      name: '单球 60° 极薄切',
      subtitle: '极薄球感训练',
      icon: Icons.gps_fixed,
      balls: [(1, hw - 30, -hh + 25)],
      cueBallPosition: (27.1, -59.8),
    ),
    // ======== 五分球水平测试 ========
    BallPreset(
      id: 'five_ball_test',
      name: '五分球测试（经典阵）',
      subtitle: '连进 5 球不犯规 = 5 分，10 局满分 50',
      icon: Icons.star,
      balls: [
        (1, 63.5, 0.0),      // 置球点，直球方向
        (2, 30.0, -25.0),     // 左侧中台，小切角
        (3, 80.0, 30.0),      // 右侧远台
        (4, -20.0, 20.0),     // 底部左半台
        (5, 50.0, -40.0),     // 上部远端
      ],
      cueBallPosition: (-63.5, 0),
    ),
    BallPreset(
      id: 'five_ball_l',
      name: '五分球（L 阵）',
      subtitle: '球沿 L 形分布，练走位衔接',
      icon: Icons.star_half,
      balls: [
        (1, 70.0, -30.0),     // 右上
        (2, 70.0, 0.0),       // 右中
        (3, 70.0, 30.0),      // 右下
        (4, 40.0, 30.0),      // 中下
        (5, 10.0, 30.0),      // 左下
      ],
      cueBallPosition: (-40, 0),
    ),
    BallPreset(
      id: 'five_ball_scatter',
      name: '五分球（散布阵）',
      subtitle: '球分散全台，考验全面走位能力',
      icon: Icons.star_outline,
      balls: [
        (1, 80.0, -35.0),     // 右上远角
        (2, -40.0, -25.0),    // 左上
        (3, 50.0, 20.0),      // 中台偏右
        (4, -60.0, 40.0),     // 左下远角
        (5, 20.0, -10.0),     // 中台偏左
      ],
      cueBallPosition: (-63.5, 0),
    ),
    // ======== 入门级 ========
    BallPreset(
      id: 'straight_line',
      name: '直线球练习',
      subtitle: '5 颗球沿中心线排列，最基础的直球',
      icon: Icons.linear_scale,
      balls: [for (var i = 0; i < 5; i++) (i + 1, 20.0 + i * 20, 0.0)],
      cueBallPosition: (-40, 0),
    ),
    BallPreset(
      id: 'stop_shot',
      name: '定杆练习',
      subtitle: '6 颗近距离球，练习中杆定位',
      icon: Icons.stop_circle_outlined,
      balls: [for (var i = 0; i < 6; i++) (i + 1, 20.0 + i * 18, 0.0)],
      cueBallPosition: (-20, 0),
    ),
    BallPreset(
      id: 'short_straight',
      name: '短台直线',
      subtitle: '3 颗球近距离直线，入门热身',
      icon: Icons.drag_handle,
      balls: [(1, 15.0, 0.0), (2, 35.0, 0.0), (3, 55.0, 0.0)],
      cueBallPosition: (-15, 0),
    ),
    BallPreset(
      id: 'pocket_practice',
      name: '四袋口练习',
      subtitle: '每个底袋口各一球，练习不同方向进袋',
      icon: Icons.crop_square,
      balls: [
        (1, 100.0, -45.0),
        (2, 100.0, 45.0),
        (3, -100.0, -45.0),
        (4, -100.0, 45.0),
      ],
      cueBallPosition: (0, 0),
    ),
    // ======== 初级 ========
    BallPreset(
      id: 'cut_angles',
      name: '切角练习',
      subtitle: '5 颗不同角度，练习厚薄球',
      icon: Icons.architecture,
      balls: [
        (1, 40.0, 0.0), (2, 40.0, -20.0), (3, 40.0, 20.0),
        (4, 60.0, -30.0), (5, 60.0, 30.0),
      ],
      cueBallPosition: (-40, 0),
    ),
    BallPreset(
      id: 'thin_cut',
      name: '薄球练习',
      subtitle: '大角度薄切，练习极薄球感',
      icon: Icons.tonality,
      balls: [
        (1, 60.0, -40.0), (2, 60.0, 40.0),
        (3, -20.0, -40.0), (4, -20.0, 40.0),
      ],
      cueBallPosition: (0, 0),
    ),
    BallPreset(
      id: 'mid_pocket',
      name: '中袋练习',
      subtitle: '3 颗球对准中袋，练中袋角度',
      icon: Icons.adjust,
      balls: [
        (1, 20.0, -30.0), (2, -20.0, -25.0), (3, 0.0, -20.0),
      ],
      cueBallPosition: (0, 20),
    ),
    BallPreset(
      id: 'long_pot',
      name: '长台直球',
      subtitle: '远距离直球进袋，练瞄准稳定性',
      icon: Icons.straighten,
      balls: [(1, 90.0, 0.0), (2, 90.0, -20.0), (3, 90.0, 20.0)],
      cueBallPosition: (-60, 0),
    ),
    // ======== 中级 ========
    BallPreset(
      id: 'follow_draw',
      name: '跟杆缩杆练习',
      subtitle: '高低杆走位控制',
      icon: Icons.swap_vert,
      balls: [(1, 30.0, 0.0), (9, 30.0, -25.0), (2, 30.0, 25.0)],
      cueBallPosition: (-30, 0),
    ),
    BallPreset(
      id: 'position_play',
      name: '走位练习',
      subtitle: '连续 3 球走位规划',
      icon: Icons.route,
      balls: [(1, 50.0, -15.0), (2, 20.0, 20.0), (3, -30.0, -10.0)],
      cueBallPosition: (-50, 0),
    ),
    BallPreset(
      id: 'zone_control',
      name: '区域控制',
      subtitle: '4 球连续走位，练习停球区域',
      icon: Icons.grid_on,
      balls: [
        (1, 40.0, 20.0), (2, 60.0, -10.0),
        (3, 20.0, -30.0), (4, -10.0, 10.0),
      ],
      cueBallPosition: (-40, 0),
    ),
    BallPreset(
      id: 'stun_run',
      name: '定杆走位',
      subtitle: '用中杆力度控制走位距离',
      icon: Icons.swap_horiz,
      balls: [
        (1, 25.0, -15.0), (2, 45.0, 10.0), (3, 65.0, -20.0),
      ],
      cueBallPosition: (-20, 0),
    ),
    BallPreset(
      id: 'side_spin_basic',
      name: '加塞入门',
      subtitle: '利用加塞改变碰库反弹角',
      icon: Icons.sync_alt,
      balls: [(1, 0.0, -30.0), (2, 40.0, -30.0)],
      cueBallPosition: (0, 20),
    ),
    // ======== 高级 ========
    BallPreset(
      id: 'bank_shot',
      name: '翻袋练习',
      subtitle: '一库翻袋进球',
      icon: Icons.flip,
      balls: [(1, 0.0, -25.0), (2, -30.0, -25.0), (3, 30.0, -25.0)],
      cueBallPosition: (0, 25),
    ),
    BallPreset(
      id: 'bank_two_rail',
      name: '两库翻袋',
      subtitle: '两库反弹进球路线',
      icon: Icons.redo,
      balls: [(1, -40.0, 0.0), (2, 30.0, -20.0)],
      cueBallPosition: (-60, 30),
    ),
    BallPreset(
      id: 'safety',
      name: '安全球练习',
      subtitle: '藏球与防守',
      icon: Icons.shield,
      balls: [
        (1, 30.0, 10.0), (8, 50.0, 0.0),
        (9, 0.0, -20.0), (10, -20.0, 15.0),
      ],
      cueBallPosition: (-40, 0),
    ),
    BallPreset(
      id: 'snooker_escape',
      name: '解球练习',
      subtitle: '被斯诺克后的解球路线',
      icon: Icons.lock_open,
      balls: [
        (1, 60.0, 0.0), (9, 40.0, -5.0), (10, 40.0, 5.0),
      ],
      cueBallPosition: (-40, 0),
    ),
    BallPreset(
      id: 'clearance_5',
      name: '5 球清台',
      subtitle: '5 颗球 + 8 号，规划清台顺序',
      icon: Icons.format_list_numbered,
      balls: [
        (1, -20.0, -20.0), (2, 10.0, 15.0), (3, 40.0, -10.0),
        (4, 60.0, 25.0), (5, 80.0, -15.0), (8, 90.0, 0.0),
      ],
      cueBallPosition: (-50, 0),
    ),
    BallPreset(
      id: 'clearance',
      name: '7 球清台',
      subtitle: '7 颗球 + 8 号完整清台',
      icon: Icons.playlist_add_check,
      balls: [
        (1, -40.0, -20.0), (2, -20.0, 15.0), (3, 10.0, -25.0),
        (4, 30.0, 10.0), (5, 50.0, -15.0), (6, 60.0, 20.0),
        (7, 70.0, -5.0), (8, 80.0, 0.0),
      ],
      cueBallPosition: (-60, 0),
    ),
    BallPreset(
      id: 'endgame',
      name: '残局练习',
      subtitle: '3 球 + 8 号，模拟比赛尾声',
      icon: Icons.emoji_events,
      balls: [
        (5, 20.0, -25.0), (6, -30.0, 20.0), (7, 60.0, 10.0),
        (8, 40.0, -5.0),
      ],
      cueBallPosition: (-40, -15),
    ),
  ];
}

class BallRack {
  BallRack._();

  static List<Ball> createRackedBalls({
    required Forge2DWorld world,
  }) {
    final positions = _rackPositions();
    final numbers = _rackNumbers();

    return List.generate(15, (i) {
      return Ball(
        number: numbers[i],
        position: positions[i],
      );
    });
  }

  static Ball createCueBall() {
    return Ball(
      number: 0,
      position: Vector2(TableConstants.headStringX - 20, 0),
    );
  }

  static List<Vector2> _rackPositions() {
    final d = TableConstants.ballDiameter + 0.12;
    final rowSpacing = d * math.sqrt(3) / 2;
    final positions = <Vector2>[];

    for (var row = 0; row < 5; row++) {
      for (var col = 0; col <= row; col++) {
        final x = TableConstants.footSpotX + row * rowSpacing;
        final y = (col - row / 2.0) * d;
        positions.add(Vector2(x, y));
      }
    }
    return positions;
  }

  static List<int> _rackNumbers() {
    final solids = [1, 2, 3, 4, 5, 6, 7];
    final stripes = [9, 10, 11, 12, 13, 14, 15];
    solids.shuffle();
    stripes.shuffle();

    final rack = List<int>.filled(15, 0);

    int flatIndex(int row, int col) {
      var idx = 0;
      for (var r = 0; r < row; r++) {
        idx += r + 1;
      }
      return idx + col;
    }

    rack[flatIndex(2, 1)] = 8;
    rack[flatIndex(4, 0)] = solids.removeLast();
    rack[flatIndex(4, 4)] = stripes.removeLast();

    final remaining = <int>[];
    var pickSolid = true;
    while (solids.isNotEmpty || stripes.isNotEmpty) {
      if (pickSolid && solids.isNotEmpty) {
        remaining.add(solids.removeAt(0));
      } else if (!pickSolid && stripes.isNotEmpty) {
        remaining.add(stripes.removeAt(0));
      } else if (solids.isNotEmpty) {
        remaining.add(solids.removeAt(0));
      } else if (stripes.isNotEmpty) {
        remaining.add(stripes.removeAt(0));
      }
      pickSolid = !pickSolid;
    }
    remaining.shuffle();

    var fillIdx = 0;
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col <= row; col++) {
        final idx = flatIndex(row, col);
        if (rack[idx] != 0) continue;
        rack[idx] = remaining[fillIdx++];
      }
    }

    return rack;
  }
}
