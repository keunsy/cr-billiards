import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cr_billiards/main.dart';
import 'package:cr_billiards/game/table_constants.dart';
import 'package:cr_billiards/rules/game_rules.dart';
import 'package:cr_billiards/rules/foul_detector.dart';
import 'package:cr_billiards/game/systems/ball_placement.dart';
import 'package:flame/extensions.dart';

void main() {
  testWidgets('App loads main menu', (WidgetTester tester) async {
    await tester.pumpWidget(const BilliardsApp());
    expect(find.text('中式八球'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Main menu has all buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const BilliardsApp());
    expect(find.text('标准开局'), findsOneWidget);
    expect(find.text('自由练习'), findsOneWidget);
    expect(find.text('操作教程'), findsOneWidget);
    expect(find.text('桌球教程'), findsOneWidget);
    expect(find.text('规则说明'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });

  test('TableConstants has valid dimensions', () {
    expect(TableConstants.length, 254.0);
    expect(TableConstants.width, 127.0);
    expect(TableConstants.ballRadius, closeTo(2.8575, 0.001));
    expect(TableConstants.maxShotPower, 4500.0);
    expect(TableConstants.pocketCenters.length, 6);
    expect(TableConstants.cushionRestitution, 0.78);
    expect(TableConstants.cushionFriction, 0.20);
  });

  test('GameRules clone creates independent copy', () {
    final rules = GameRules();
    rules.pocketedSolids.addAll([1, 2, 3]);
    rules.pocketedStripes.addAll([9, 10]);
    rules.eightBallPocketed = true;

    final clone = rules.clone();
    expect(clone.pocketedSolids, [1, 2, 3]);
    expect(clone.pocketedStripes, [9, 10]);
    expect(clone.eightBallPocketed, isTrue);

    // Modify original, clone should be unaffected
    rules.pocketedSolids.add(4);
    rules.eightBallPocketed = false;
    expect(clone.pocketedSolids, [1, 2, 3]);
    expect(clone.eightBallPocketed, isTrue);
  });

  test('GameRules tracks premature 8-ball', () {
    final rules = GameRules();
    expect(rules.isEightBallPremature(), isFalse);

    rules.eightBallPocketed = true;
    expect(rules.isEightBallPremature(), isTrue);

    // Clear all solids — still premature because stripes not done
    rules.pocketedSolids.addAll([1, 2, 3, 4, 5, 6, 7]);
    expect(rules.isEightBallPremature(), isFalse);
  });

  test('FoulDetector identifies scratch', () {
    final analysis = ShotAnalysis();
    analysis.cueBallPocketed = true;
    analysis.cueBallHitAnyBall = true;
    final result = FoulDetector.analyze(analysis);
    expect(result.isFoul, isTrue);
    expect(result.foulType, FoulType.scratch);
  });

  test('FoulDetector identifies no ball hit', () {
    final analysis = ShotAnalysis();
    analysis.cueBallHitAnyBall = false;
    final result = FoulDetector.analyze(analysis);
    expect(result.isFoul, isTrue);
    expect(result.foulType, FoulType.noBallHit);
  });

  test('FoulDetector identifies no cushion foul', () {
    final analysis = ShotAnalysis();
    analysis.cueBallHitAnyBall = true;
    analysis.anyBallHitCushion = false;
    // No balls pocketed, no cushion hit
    final result = FoulDetector.analyze(analysis);
    expect(result.isFoul, isTrue);
    expect(result.foulType, FoulType.noCushion);
  });

  test('FoulDetector recognizes clean shot', () {
    final analysis = ShotAnalysis();
    analysis.cueBallHitAnyBall = true;
    analysis.anyBallHitCushion = true;
    final result = FoulDetector.analyze(analysis);
    expect(result.isFoul, isFalse);
  });

  test('BallPlacement clamps to table bounds', () {
    final farPos = Vector2(999, 999);
    final clamped = BallPlacement.clampToTable(farPos);
    final maxX = TableConstants.halfLength - TableConstants.ballRadius - 1;
    final maxY = TableConstants.halfWidth - TableConstants.ballRadius - 1;
    expect(clamped.x, closeTo(maxX, 0.01));
    expect(clamped.y, closeTo(maxY, 0.01));
  });

  test('GameRules reset clears all state', () {
    final rules = GameRules();
    rules.pocketedSolids.addAll([1, 2]);
    rules.pocketedStripes.addAll([9]);
    rules.eightBallPocketed = true;
    rules.lastFoul = const FoulResult(
      isFoul: true,
      foulType: FoulType.scratch,
      description: 'test',
    );

    rules.reset();
    expect(rules.pocketedSolids, isEmpty);
    expect(rules.pocketedStripes, isEmpty);
    expect(rules.eightBallPocketed, isFalse);
    expect(rules.lastFoul, isNull);
  });
}
