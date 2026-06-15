import 'foul_detector.dart';

/// Practice-mode rules tracker — informational fouls and pocketed balls.
class GameRules {
  final List<int> pocketedSolids = [];
  final List<int> pocketedStripes = [];
  bool eightBallPocketed = false;
  FoulResult? lastFoul;

  GameRules clone() {
    return GameRules()
      ..pocketedSolids.addAll(pocketedSolids)
      ..pocketedStripes.addAll(pocketedStripes)
      ..eightBallPocketed = eightBallPocketed
      ..lastFoul = lastFoul;
  }

  void onShotComplete(ShotAnalysis analysis, FoulResult foul) {
    lastFoul = foul.isFoul ? foul : null;

    for (final number in analysis.pocketedBallNumbers) {
      if (number >= 1 && number <= 7 && !pocketedSolids.contains(number)) {
        pocketedSolids.add(number);
        pocketedSolids.sort();
      } else if (number >= 9 && number <= 15 && !pocketedStripes.contains(number)) {
        pocketedStripes.add(number);
        pocketedStripes.sort();
      } else if (number == 8) {
        eightBallPocketed = true;
      }
    }
  }

  /// True when 8-ball was pocketed before all group balls are cleared.
  bool isEightBallPremature() {
    if (!eightBallPocketed) return false;
    final allSolidsIn = pocketedSolids.length >= 7;
    final allStripesIn = pocketedStripes.length >= 7;
    return !allSolidsIn && !allStripesIn;
  }

  void reset() {
    pocketedSolids.clear();
    pocketedStripes.clear();
    eightBallPocketed = false;
    lastFoul = null;
  }
}
