import 'package:flutter/material.dart';

import '../billiards_game.dart';

class PowerGauge extends StatefulWidget {
  const PowerGauge({super.key, required this.game});

  final BilliardsGame game;

  @override
  State<PowerGauge> createState() => _PowerGaugeState();
}

class _PowerGaugeState extends State<PowerGauge>
    with SingleTickerProviderStateMixin {
  double _power = 0.5;
  late final AnimationController _shootAnim;

  @override
  void initState() {
    super.initState();
    widget.game.powerNotifier.addListener(_syncFromGame);
    _power = widget.game.power;
    _shootAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    widget.game.powerNotifier.removeListener(_syncFromGame);
    _shootAnim.dispose();
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
    _shootAnim.reverse().then((_) => _shootAnim.forward());
    await widget.game.shoot();
  }

  @override
  Widget build(BuildContext context) {
    final canShoot = widget.game.canAim;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        final shootBtnSize = maxH < 300 ? 38.0 : 50.0;
        final barWidth = maxH < 300 ? 28.0 : 38.0;
        final barHeight = (maxH - shootBtnSize - 30).clamp(60.0, 300.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                '${(_power * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 5),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                final localY = details.localPosition.dy;
                final newPower =
                    1.0 - (localY / barHeight).clamp(0.0, 1.0);
                _updatePower(newPower);
              },
              onPanStart: (_) {},
              onPanUpdate: (details) {
                _updatePower(
                    _power - details.delta.dy / (barHeight * 0.5));
              },
              child: Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(barWidth / 3),
                  border: Border.all(color: Colors.white24, width: 1),
                  color: Colors.black.withValues(alpha: 0.45),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      width: barWidth,
                      height: barHeight * _power,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(barWidth / 3),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF4CAF50),
                            Color(0xFFCDDC39),
                            Color(0xFFFF9800),
                            Color(0xFFE53935),
                          ],
                          stops: [0.0, 0.35, 0.65, 1.0],
                        ),
                      ),
                    ),
                    // Power level indicator bar
                    Positioned(
                      bottom: barHeight * _power - 1.5,
                      child: Container(
                        width: barWidth + 4,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Scale marks
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
            const SizedBox(height: 8),

            // Shoot button with scale animation
            ScaleTransition(
              scale: _shootAnim,
              child: SizedBox(
                width: shootBtnSize,
                height: shootBtnSize,
                child: ElevatedButton(
                  onPressed: canShoot ? _shoot : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canShoot
                        ? const Color(0xFFE53935)
                        : const Color(0xFF555555),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    elevation: canShoot ? 4 : 1,
                    shadowColor: canShoot
                        ? const Color(0xFFE53935).withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: shootBtnSize < 44 ? 20 : 24,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
