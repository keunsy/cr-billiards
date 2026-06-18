import 'package:flame/extensions.dart';

import '../components/ball.dart';
import '../table_constants.dart';

/// Handles dragging balls to reposition them on the table.
class BallPlacement {
  BallPlacement(this._onReposition);

  final void Function(Ball ball, Vector2 position) _onReposition;

  Ball? _draggingBall;
  bool _behindHeadString = false;
  List<Ball> _allBalls = [];

  Ball? get draggingBall => _draggingBall;
  bool get isDragging => _draggingBall != null;

  bool canStartPlacement({
    required bool practiceMode,
    required bool placingBall,
  }) =>
      practiceMode || placingBall;

  bool canDragBall(Ball ball, {required bool practiceMode, required bool placingBall}) {
    if (practiceMode) return true;
    if (placingBall && ball.isCueBall) return true;
    return false;
  }

  void onDragUpdate(Vector2 worldPos) {
    if (_draggingBall != null) {
      var clamped = _behindHeadString
          ? clampBehindHeadString(worldPos)
          : clampToTable(worldPos);
      clamped = _avoidOverlap(clamped, _draggingBall!);
      _draggingBall!.setPosition(clamped);
    }
  }

  void onDragEnd() {
    if (_draggingBall != null) {
      final ball = _draggingBall!;
      ball.setDragging(false);
      _onReposition(ball, ball.body.position.clone());
    }
    _draggingBall = null;
    _behindHeadString = false;
  }

  void onLongPress(
    Vector2 worldPos,
    List<Ball> balls, {
    required bool practiceMode,
    required bool placingBall,
    bool behindHeadString = false,
  }) {
    if (!canStartPlacement(practiceMode: practiceMode, placingBall: placingBall)) return;
    if (_draggingBall != null) return;

    _allBalls = balls;
    for (final ball in balls) {
      if (!canDragBall(ball, practiceMode: practiceMode, placingBall: placingBall)) continue;
      if (_isNearBall(worldPos, ball)) {
        _draggingBall = ball;
        _behindHeadString = behindHeadString;
        ball.setDragging(true);
        var clamped = behindHeadString
            ? clampBehindHeadString(worldPos)
            : clampToTable(worldPos);
        clamped = _avoidOverlap(clamped, ball);
        ball.setPosition(clamped);
        break;
      }
    }
  }

  void cancel() {
    _draggingBall?.setDragging(false);
    _draggingBall = null;
    _behindHeadString = false;
  }

  bool _isNearBall(Vector2 worldPos, Ball ball) {
    if (ball.isPocketed && !ball.isCueBall) return false;
    if (ball.isPocketed) return true;
    return (worldPos - ball.body.position).length <= TableConstants.ballRadius * 5.0;
  }

  static Vector2 clampToTable(Vector2 pos) {
    const hw = TableConstants.halfLength - TableConstants.ballRadius - 1;
    const hh = TableConstants.halfWidth - TableConstants.ballRadius - 1;
    return Vector2(
      pos.x.clamp(-hw, hw),
      pos.y.clamp(-hh, hh),
    );
  }

  /// Clamp position to the area behind the head string (for opening break).
  static Vector2 clampBehindHeadString(Vector2 pos) {
    const maxX = TableConstants.headStringX;
    const minX = -TableConstants.halfLength + TableConstants.ballRadius + 1;
    const hh = TableConstants.halfWidth - TableConstants.ballRadius - 1;
    return Vector2(
      pos.x.clamp(minX, maxX),
      pos.y.clamp(-hh, hh),
    );
  }

  /// Push position away from other balls to avoid overlap.
  Vector2 _avoidOverlap(Vector2 pos, Ball dragBall) {
    const minDist = TableConstants.ballDiameter + 0.2;
    var result = pos.clone();
    for (final other in _allBalls) {
      if (identical(other, dragBall)) continue;
      if (other.isPocketed || !other.isVisible) continue;
      final delta = result - other.body.position;
      final dist = delta.length;
      if (dist < minDist && dist > 0.01) {
        final push = delta / dist * (minDist - dist);
        result += push;
      }
    }
    return result;
  }
}
