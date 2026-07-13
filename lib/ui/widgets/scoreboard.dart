import 'package:flutter/material.dart';

import '../../rules/game_rules.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({
    super.key,
    required this.rules,
  });

  final GameRules rules;

  static const Map<int, Color> _ballColors = {
    1: Color(0xFFF9D923),
    2: Color(0xFF1565C0),
    3: Color(0xFFD32F2F),
    4: Color(0xFF7B1FA2),
    5: Color(0xFFFF8F00),
    6: Color(0xFF2E7D32),
    7: Color(0xFF880E4F),
    8: Color(0xFF212121),
    9: Color(0xFFF9D923),
    10: Color(0xFF1565C0),
    11: Color(0xFFD32F2F),
    12: Color(0xFF7B1FA2),
    13: Color(0xFFFF8F00),
    14: Color(0xFF2E7D32),
    15: Color(0xFF880E4F),
  };

  @override
  Widget build(BuildContext context) {
    final hasFoul = rules.lastFoul != null;
    final premature = rules.isEightBallPremature();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                    7,
                    (i) => _ballDot(
                        i + 1, rules.pocketedSolids.contains(i + 1), false)),
                const SizedBox(width: 2),
                _dot8(rules.eightBallPocketed),
                const SizedBox(width: 2),
                ...List.generate(
                    7,
                    (i) => _ballDot(
                        i + 9, rules.pocketedStripes.contains(i + 9), true)),
              ],
            ),
            if (hasFoul) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7043).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  rules.lastFoul!.description,
                  style: const TextStyle(
                    color: Color(0xFFFF7043),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (premature) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '8号球过早入袋',
                  style: TextStyle(color: Color(0xFFE53935), fontSize: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _dot8(bool pocketed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pocketed
              ? const Color(0xFF212121).withValues(alpha: 0.3)
              : const Color(0xFF212121),
          border: Border.all(
            color: pocketed ? Colors.white12 : Colors.white54,
            width: 1,
          ),
          boxShadow: pocketed
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: pocketed
            ? null
            : const Center(
                child: Text('8',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
      ),
    );
  }

  Widget _ballDot(int number, bool pocketed, bool isStripe) {
    final color = _ballColors[number] ?? Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pocketed ? color.withValues(alpha: 0.25) : color,
          border: Border.all(
            color: pocketed ? Colors.white12 : Colors.white54,
            width: 1,
          ),
          boxShadow: pocketed
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: pocketed
            ? Center(
                child: Icon(Icons.close, size: 10, color: Colors.white38),
              )
            : Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: (number == 8 || (number >= 5 && !isStripe))
                        ? Colors.white
                        : Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
