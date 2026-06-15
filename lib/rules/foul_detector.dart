import '../game/components/ball.dart';

enum FoulType {
  none,
  scratch,
  noBallHit,
  noCushion,
}

class FoulResult {
  const FoulResult({
    required this.isFoul,
    required this.foulType,
    required this.description,
  });

  final bool isFoul;
  final FoulType foulType;
  final String description;

  static const none = FoulResult(
    isFoul: false,
    foulType: FoulType.none,
    description: '',
  );
}

/// Data collected during a single shot for foul analysis.
class ShotAnalysis {
  ShotAnalysis();

  Ball? firstBallHit;
  bool cueBallHitAnyBall = false;
  bool anyBallHitCushion = false;
  final List<int> pocketedBallNumbers = [];
  bool cueBallPocketed = false;

  void reset() {
    firstBallHit = null;
    cueBallHitAnyBall = false;
    anyBallHitCushion = false;
    pocketedBallNumbers.clear();
    cueBallPocketed = false;
  }
}

class FoulDetector {
  FoulDetector._();

  static FoulResult analyze(ShotAnalysis analysis) {
    if (analysis.cueBallPocketed) {
      return const FoulResult(
        isFoul: true,
        foulType: FoulType.scratch,
        description: '犯规：白球落袋',
      );
    }

    if (!analysis.cueBallHitAnyBall) {
      return const FoulResult(
        isFoul: true,
        foulType: FoulType.noBallHit,
        description: '犯规：白球未击中任何球',
      );
    }

    if (analysis.pocketedBallNumbers.isEmpty && !analysis.anyBallHitCushion) {
      return const FoulResult(
        isFoul: true,
        foulType: FoulType.noCushion,
        description: '犯规：无球落袋且无任何球碰库',
      );
    }

    return FoulResult.none;
  }
}
