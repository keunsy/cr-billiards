import 'package:flutter/material.dart';

import '../billiards_game.dart';

class PowerGauge extends StatefulWidget {
  const PowerGauge({super.key, required this.game});

  final BilliardsGame game;

  @override
  State<PowerGauge> createState() => _PowerGaugeState();
}

class _PowerGaugeState extends State<PowerGauge> {
  double _power = 0.5;

  @override
  void initState() {
    super.initState();
    widget.game.powerNotifier.addListener(_syncFromGame);
    _power = widget.game.power;
  }

  @override
  void dispose() {
    widget.game.powerNotifier.removeListener(_syncFromGame);
    super.dispose();
  }

  void _syncFromGame() {
    if (mounted) {
      setState(() => _power = widget.game.power);
    }
  }

  void _updatePower(double value) {
    setState(() => _power = value.clamp(0.0, 1.0));
    widget.game.setPower(_power);
  }

  Future<void> _shoot() async {
    if (!widget.game.canAim) return;
    await widget.game.shoot();
  }

  @override
  Widget build(BuildContext context) {
    final canShoot = widget.game.canAim;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        final shootBtnSize = maxH < 300 ? 40.0 : 48.0;
        final barWidth = maxH < 300 ? 32.0 : 38.0;
        final barHeight = (maxH - shootBtnSize - 30).clamp(60.0, 300.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Power percentage label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${(_power * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Power bar
            GestureDetector(
              onTapDown: (details) {
                final localY = details.localPosition.dy;
                final newPower = 1.0 - (localY / barHeight).clamp(0.0, 1.0);
                _updatePower(newPower);
              },
              onVerticalDragUpdate: (details) {
                _updatePower(_power - details.delta.dy / (barHeight * 0.5));
              },
              child: Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(barWidth / 4),
                  border: Border.all(color: Colors.white30, width: 1),
                  color: Colors.black38,
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      width: barWidth,
                      height: barHeight * _power,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(barWidth / 4),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF4CAF50),
                            Color(0xFFFFEB3B),
                            Color(0xFFFF9800),
                            Color(0xFFF44336),
                          ],
                          stops: [0.0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: barHeight * _power - 1.5,
                      child: Container(
                        width: barWidth,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black54, blurRadius: 2),
                          ],
                        ),
                      ),
                    ),
                    ...List.generate(4, (i) {
                      final y = barHeight * (1 - (i + 1) / 5);
                      return Positioned(
                        top: y - 0.5,
                        child: Container(
                          width: 8,
                          height: 1,
                          color: Colors.white24,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Shoot button
            SizedBox(
              width: shootBtnSize,
              height: shootBtnSize,
              child: ElevatedButton(
                onPressed: canShoot ? _shoot : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canShoot ? const Color(0xFFE53935) : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  elevation: canShoot ? 3 : 1,
                ),
                child: Icon(Icons.sports_bar,
                    size: shootBtnSize < 44 ? 18 : 22),
              ),
            ),
          ],
        );
      },
    );
  }
}
