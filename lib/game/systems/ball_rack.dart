import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';

import '../components/ball.dart';
import '../table_constants.dart';

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
        final x = TableConstants.footSpotX - row * rowSpacing;
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
