import 'dart:async' as async;
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:forge2d/forge2d.dart' as f2d;

import '../../audio/audio_manager.dart';
import '../../rules/foul_detector.dart';
import '../../rules/game_rules.dart';
import '../../ui/settings/game_settings.dart';
import 'components/ball.dart';
import 'components/cue_stick.dart';
import 'components/guideline.dart';
import 'components/pocket.dart';
import 'components/table.dart';
import 'input/aim_controller.dart';
import 'systems/ball_placement.dart';
import 'systems/ball_rack.dart';
import 'table_constants.dart';

enum GameState { aiming, shooting, ballsMoving, placingBall }

enum GameMode { standard, practice }

class BilliardsGame extends Forge2DGame with TapCallbacks, DragCallbacks {
  BilliardsGame({
    this.gameMode = GameMode.standard,
    bool enablePracticeMode = false,
  })  : practiceMode = gameMode == GameMode.practice || enablePracticeMode,
        super(
          gravity: Vector2.zero(),
          zoom: 3.2,
        );

  final GameMode gameMode;
  final bool practiceMode;

  GameState state = GameState.aiming;
  final List<Ball> balls = [];
  Ball? cueBall;

  Vector2 aimDirection = Vector2(1, 0);
  double power = 0.5;
  Vector2 spinOffset = Vector2.zero();

  bool guidelineEnabled = true;
  bool angleDisplayEnabled = true;

  final ValueNotifier<double> powerNotifier = ValueNotifier(0.5);
  final ValueNotifier<Vector2> spinNotifier = ValueNotifier(Vector2.zero());
  final ValueNotifier<GameRules> rulesNotifier = ValueNotifier(GameRules());
  final ValueNotifier<GameState> stateNotifier = ValueNotifier(GameState.aiming);

  GameRules get rules => rulesNotifier.value;
  final ShotAnalysis _shotAnalysis = ShotAnalysis();
  late BallPlacement _ballPlacement;
  bool _trackingShot = false;
  double _shotGraceTimer = 0;
  double _ballsMovingTimer = 0;
  bool _placeBehindHeadString = false;

  // Undo support (practice mode only): snapshot of all ball states before each shot
  List<_BallSnapshot>? _undoSnapshot;
  bool get canUndo => practiceMode && _undoSnapshot != null && state == GameState.aiming;

  bool get isPlaceBehindHeadString => _placeBehindHeadString;

  late CueStick _cueStick;
  late Guideline _guideline;
  late Table _table;
  late AimController _aimController;

  async.Timer? _longPressTimer;
  Vector2? _longPressWorldPos;

  bool get canAim =>
      state == GameState.aiming &&
      cueBall != null &&
      cueBall!.isMounted &&
      !cueBall!.isPocketed &&
      !_ballPlacement.isDragging;

  bool get canPlaceBalls =>
      state != GameState.ballsMoving &&
      state != GameState.shooting &&
      _ballPlacement.canStartPlacement(
        practiceMode: practiceMode,
        placingBall: state == GameState.placingBall,
      );

  @override
  Color backgroundColor() => const Color(0xFF263238);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    f2d.maxTranslation = 20.0;
    f2d.maxTranslationSquared = 20.0 * 20.0;

    final settings = GameSettings.instance;
    guidelineEnabled = settings.guidelineEnabled;
    angleDisplayEnabled = settings.angleDisplayEnabled;

    _ballPlacement = BallPlacement(repositionBall);

    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position = Vector2.zero();

    _table = Table(world: world);
    world.add(_table);

    for (var i = 0; i < TableConstants.pocketCenters.length; i++) {
      final center = TableConstants.pocketCenters[i];
      world.add(Pocket(
        index: i,
        center: center,
        radius: TableConstants.pocketRadiusAt(i),
        onBallPocketed: _onBallPocketed,
      ));
    }

    _cueStick = CueStick();
    world.add(_cueStick);

    if (gameMode == GameMode.standard) {
      _setupStandardBalls();
    } else {
      _setupPracticeBalls();
    }

    _guideline = Guideline(balls: balls);
    world.add(_guideline);

    _aimController = AimController(this);
  }

  Vector2 inputToWorld(Vector2 canvasPosition) {
    final worldPos = screenToWorld(canvasPosition);
    worldPos.y /= TableConstants.perspectiveYScale;
    return worldPos;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_ballPlacement.isDragging) return;
    final worldPos = inputToWorld(event.canvasPosition);
    if (canPlaceBalls) {
      _longPressWorldPos = worldPos.clone();
      _longPressTimer?.cancel();
      final delay = state == GameState.placingBall
          ? const Duration(milliseconds: 50)
          : const Duration(milliseconds: 400);
      _longPressTimer = async.Timer(delay, () {
        if (_longPressWorldPos != null) {
          _ballPlacement.onLongPress(
            _longPressWorldPos!,
            balls,
            practiceMode: practiceMode,
            placingBall: state == GameState.placingBall,
            behindHeadString: _placeBehindHeadString,
          );
        }
      });
    }
    if (state == GameState.placingBall && !practiceMode) return;
    _aimController.updateFromCanvasPoint(event.canvasPosition);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _cancelLongPressTimer();
    if (_ballPlacement.isDragging) {
      _ballPlacement.onDragEnd();
      if (state == GameState.placingBall && cueBall != null && !cueBall!.isPocketed) {
        _finishCueBallPlacement();
      }
    }
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _cancelLongPressTimer();
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final savedPos = _longPressWorldPos;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    if (_ballPlacement.isDragging) return;
    if (canPlaceBalls && savedPos != null) {
      _ballPlacement.onLongPress(
        savedPos,
        balls,
        practiceMode: practiceMode,
        placingBall: state == GameState.placingBall,
        behindHeadString: _placeBehindHeadString,
      );
    }
    _longPressWorldPos = null;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_ballPlacement.isDragging) {
      _ballPlacement.onDragUpdate(inputToWorld(event.canvasEndPosition));
      return;
    }
    if (state == GameState.placingBall) return;
    _aimController.updateFromCanvasPoint(event.canvasEndPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _cancelLongPressTimer();
    _ballPlacement.onDragEnd();
    if (state == GameState.placingBall && cueBall != null && !cueBall!.isPocketed) {
      _finishCueBallPlacement();
    }
  }

  void _cancelLongPressTimer() {
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _longPressWorldPos = null;
  }

  void _setupStandardBalls() {
    _setupBalls();
    _placeBehindHeadString = true;
    state = GameState.placingBall;
    _setState(GameState.placingBall);
    _guideline.enabled = false;
  }

  void _setupPracticeBalls() => _setupBalls();

  void _setupBalls() {
    _clearAllBalls();
    cueBall = BallRack.createCueBall();
    world.add(cueBall!);
    balls.add(cueBall!);

    final racked = BallRack.createRackedBalls(world: world);
    for (final ball in racked) {
      world.add(ball);
      balls.add(ball);
    }
    _wireShotListeners();
  }

  void _clearAllBalls() {
    for (final ball in List<Ball>.from(balls)) {
      ball.removeFromParent();
    }
    balls.clear();
    cueBall = null;
  }

  void _wireShotListeners() {
    for (final ball in balls) {
      ball.onContact = _onBallContact;
    }
  }

  void _onBallContact(Ball self, Object other) {
    if (!_trackingShot) return;

    if (other is Ball) {
      final speed = (self.body.linearVelocity - other.body.linearVelocity).length;
      AudioManager.instance.playBallCollision(speed: speed);
      if (self.isCueBall) {
        _shotAnalysis.cueBallHitAnyBall = true;
        _shotAnalysis.firstBallHit ??= other;
      } else if (other.isCueBall) {
        _shotAnalysis.cueBallHitAnyBall = true;
        _shotAnalysis.firstBallHit ??= self;
      }
    } else if (other is CushionSegment) {
      AudioManager.instance.playCushionHit(speed: self.body.linearVelocity.length);
      _shotAnalysis.anyBallHitCushion = true;
    } else {
      // fixture.userData might be the cushionMarker
      if (identical(other, CushionSegment.cushionMarker)) {
        AudioManager.instance.playCushionHit(speed: self.body.linearVelocity.length);
        _shotAnalysis.anyBallHitCushion = true;
      }
    }
  }

  void _onBallPocketed(Ball ball, [Pocket? pocket]) {
    if (ball.isPocketed) return;
    ball.isPocketed = true;

    if (state == GameState.ballsMoving || state == GameState.shooting) {
      _shotAnalysis.pocketedBallNumbers.add(ball.number);
      if (ball.isCueBall) {
        _shotAnalysis.cueBallPocketed = true;
      }
    }

    AudioManager.instance.playBallPocketed();
    ball.pocket();
    if (ball.isCueBall) {
      _placeBehindHeadString = false;
      state = GameState.placingBall;
      _setState(GameState.placingBall);
      _cueStick.hide();
      _guideline.enabled = false;
      ball.restoreForPlacement(Vector2(TableConstants.headStringX, 0));
    }
  }


  void _finishCueBallPlacement() {
    _placeBehindHeadString = false;
    state = GameState.aiming;
    _setState(GameState.aiming);
    _updateAimVisuals();
  }

  void setAimDirection(Vector2 direction) {
    if (!canAim) return;
    aimDirection = direction.normalized();
    _updateAimVisuals();
  }

  void setPower(double value) {
    power = value.clamp(0.0, 1.0);
    powerNotifier.value = power;
  }

  void setSpinOffset(Vector2 offset) {
    spinOffset = offset.clone();
    spinNotifier.value = spinOffset;
  }

  void toggleGuideline() {
    guidelineEnabled = !guidelineEnabled;
    GameSettings.instance.setGuidelineEnabled(guidelineEnabled);
    _guideline.enabled = guidelineEnabled;
  }

  void applySettings() {
    final settings = GameSettings.instance;
    guidelineEnabled = settings.guidelineEnabled;
    angleDisplayEnabled = settings.angleDisplayEnabled;
    _guideline.enabled = guidelineEnabled;
    _guideline.showAngle = angleDisplayEnabled;
    _guideline.showObjectPath = settings.objectPathEnabled;
    _guideline.showDeflection = settings.deflectionLineEnabled;
    _guideline.showTriangle = settings.triangleEnabled;
  }

  Future<void> shoot() async {
    if (!canAim || cueBall == null) return;

    if (practiceMode) {
      _undoSnapshot = balls.map((b) => _BallSnapshot(
        number: b.number,
        position: b.body.position.clone(),
        isPocketed: b.isPocketed,
        isVisible: b.isVisible,
      )).toList();
    }

    _beginShotTracking();
    state = GameState.shooting;
    _setState(GameState.shooting);
    final cue = cueBall!;
    final dir = aimDirection.normalized();

    await _cueStick.animateStrike(power);

    final impulseStrength = power * TableConstants.maxShotPower;
    AudioManager.instance.playCueHit(power: power);
    cue.body.applyLinearImpulse(dir * impulseStrength);

    final perp = Vector2(-dir.y, dir.x);
    cue.body.applyLinearImpulse(perp * spinOffset.x * impulseStrength * 0.08);

    cue.body.angularVelocity = spinOffset.x * 12 - spinOffset.y * 8;

    _cueStick.hide();
    _guideline.enabled = false;
    _shotGraceTimer = 0.15;
    _ballsMovingTimer = 0;
    state = GameState.ballsMoving;
    _setState(GameState.ballsMoving);
  }

  void _beginShotTracking() {
    _shotAnalysis.reset();
    _trackingShot = true;
  }

  void _endShotTracking() {
    _trackingShot = false;
    final foul = FoulDetector.analyze(_shotAnalysis);
    if (foul.isFoul) AudioManager.instance.playFoul();
    rules.onShotComplete(_shotAnalysis, foul);
    rulesNotifier.value = rules.clone();
  }

  void resetStandard() {
    rules.reset();
    rulesNotifier.value = GameRules();
    _ballPlacement.cancel();
    state = GameState.aiming;
    _setState(GameState.aiming);
    _setupStandardBalls();
    _updateAimVisuals();
  }

  void resetFreePlay() {
    rules.reset();
    rulesNotifier.value = GameRules();
    _ballPlacement.cancel();
    _undoSnapshot = null;
    state = GameState.aiming;
    _setState(GameState.aiming);
    _setupPracticeBalls();
    _updateAimVisuals();
  }

  void undoLastShot() {
    if (!canUndo || _undoSnapshot == null) return;
    for (final snap in _undoSnapshot!) {
      final ball = balls.firstWhere((b) => b.number == snap.number);
      if (snap.isPocketed) {
        ball.pocket();
      } else {
        ball.reposition(snap.position);
      }
    }
    _undoSnapshot = null;
    state = GameState.aiming;
    _setState(GameState.aiming);
    _updateAimVisuals();
  }

  void repositionBall(Ball ball, Vector2 newPosition) {
    final clamped = BallPlacement.clampToTable(newPosition);
    ball.reposition(clamped);
    if (ball.isCueBall && state == GameState.placingBall) {
      _finishCueBallPlacement();
    }
  }

  void _updateAimVisuals() {
    if (cueBall == null || cueBall!.isPocketed || !cueBall!.isMounted) return;
    final pos = cueBall!.body.position;
    final angle = math.atan2(aimDirection.y, aimDirection.x);
    _cueStick.showAiming(pos, angle);
    final settings = GameSettings.instance;
    _guideline.cueBallPosition = pos.clone();
    _guideline.aimDirection = aimDirection.clone();
    _guideline.enabled = guidelineEnabled;
    _guideline.showAngle = angleDisplayEnabled;
    _guideline.showObjectPath = settings.objectPathEnabled;
    _guideline.showDeflection = settings.deflectionLineEnabled;
    _guideline.showTriangle = settings.triangleEnabled;
  }

  void _setState(GameState newState) {
    stateNotifier.value = newState;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Distance-based pocket detection — catches balls that the sensor
    // might miss due to physics step ordering or high-speed tunneling.
    // Also runs during placingBall, because other balls may still be moving
    // after the cue ball was pocketed.
    if (state != GameState.aiming) {
      _checkPocketProximity();
    }

    if (state == GameState.ballsMoving || (state == GameState.placingBall && _trackingShot)) {
      _ballsMovingTimer += dt;
      if (_shotGraceTimer > 0) {
        _shotGraceTimer -= dt;
      } else if (!_anyBallMoving() || _ballsMovingTimer > 15.0) {
        if (_ballsMovingTimer > 15.0) {
          _forceStopAllBalls();
        }
        if (_trackingShot) {
          _endShotTracking();
        }
        if (state == GameState.ballsMoving) {
          state = GameState.aiming;
          _setState(GameState.aiming);
          _updateAimVisuals();
        }
      }
    } else if (state == GameState.aiming) {
      _updateAimVisuals();
    }
  }

  void _checkPocketProximity() {
    for (final ball in balls) {
      if (ball.isPocketed || !ball.isVisible) continue;
      final pos = ball.body.position;
      for (var i = 0; i < TableConstants.pocketCenters.length; i++) {
        final pocketCenter = TableConstants.pocketCenters[i];
        final dist = (pos - pocketCenter).length;
        final threshold = TableConstants.pocketRadiusAt(i) * 0.7;
        if (dist < threshold) {
          _onBallPocketed(ball);
          break;
        }
      }
    }
  }

  bool _anyBallMoving() {
    for (final ball in balls) {
      if (ball.isMoving) return true;
    }
    return false;
  }

  void _forceStopAllBalls() {
    for (final ball in balls) {
      if (!ball.isPocketed && ball.body.isActive) {
        ball.body.linearVelocity = Vector2.zero();
        ball.body.angularVelocity = 0;
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _fitCamera(size);
  }

  void _fitCamera(Vector2 size) {
    // Reserve space for overlay UI to keep table visually centered
    const uiLeftPx = 50.0;  // spin indicator
    const uiRightPx = 55.0; // power gauge + shoot button
    const uiTopPx = 40.0;   // toolbar + scoreboard
    const uiBottomPx = 8.0;

    final usableW = size.x - uiLeftPx - uiRightPx;
    final usableH = size.y - uiTopPx - uiBottomPx;

    final tableW = TableConstants.length + 20;
    final tableH = (TableConstants.width + 20) * TableConstants.perspectiveYScale;
    final scaleX = usableW / tableW;
    final scaleY = usableH / tableH;
    final zoom = math.min(scaleX, scaleY) * 0.95;
    camera.viewfinder.zoom = zoom;

    // Offset camera so table centers within the usable area
    final offsetXPx = (uiLeftPx - uiRightPx) / 2;
    final offsetYPx = (uiTopPx - uiBottomPx) / 2;
    camera.viewfinder.position = Vector2(
      -offsetXPx / zoom,
      -offsetYPx / zoom,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.scale(1, TableConstants.perspectiveYScale);
    super.render(canvas);
    canvas.restore();
  }

  @override
  void onRemove() {
    _cancelLongPressTimer();
    powerNotifier.dispose();
    spinNotifier.dispose();
    rulesNotifier.dispose();
    stateNotifier.dispose();
    super.onRemove();
  }
}

class _BallSnapshot {
  _BallSnapshot({
    required this.number,
    required this.position,
    required this.isPocketed,
    required this.isVisible,
  });

  final int number;
  final Vector2 position;
  final bool isPocketed;
  final bool isVisible;
}
