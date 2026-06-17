import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';

import '../billiards_game.dart';

class SpinIndicator extends StatefulWidget {
  const SpinIndicator({super.key, required this.game});

  final BilliardsGame game;

  @override
  State<SpinIndicator> createState() => _SpinIndicatorState();
}

class _SpinIndicatorState extends State<SpinIndicator>
    with SingleTickerProviderStateMixin {
  Offset _hitPoint = Offset.zero;
  bool _expanded = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    const ballR = 44.0;
    final so = widget.game.spinOffset;
    _hitPoint = Offset(so.x * ballR, so.y * ballR);
    widget.game.spinNotifier.addListener(_syncFromGame);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    widget.game.spinNotifier.removeListener(_syncFromGame);
    _animController.dispose();
    super.dispose();
  }

  void _syncFromGame() {
    if (mounted) {
      setState(() {
        const ballR = 44.0;
        final so = widget.game.spinOffset;
        _hitPoint = Offset(so.x * ballR, so.y * ballR);
      });
    }
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  void _onPan(Offset local) {
    const padSize = 100.0;
    const ballR = 44.0;
    const center = Offset(padSize / 2, padSize / 2);
    final delta = local - center;
    final clamped = _clampToCircle(delta, ballR - 4);
    setState(() => _hitPoint = clamped);
    widget.game.setSpinOffset(Vector2(clamped.dx, clamped.dy) / ballR);
  }

  void _resetSpin() {
    setState(() => _hitPoint = Offset.zero);
    widget.game.setSpinOffset(Vector2.zero());
  }

  Offset _clampToCircle(Offset v, double maxR) {
    final len = v.distance;
    if (len <= maxR || len == 0) return v;
    return Offset(v.dx / len * maxR, v.dy / len * maxR);
  }

  bool get _hasSpin => _hitPoint.distance > 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.up,
      children: [
        GestureDetector(
          onTap: _toggle,
          onDoubleTap: _resetSpin,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
              border: Border.all(
                color: _hasSpin
                    ? const Color(0xFFFF5722)
                    : Colors.white38,
                width: _hasSpin ? 1.5 : 1,
              ),
            ),
            child: CustomPaint(
              painter: _MiniSpinPainter(hitPoint: _hitPoint),
            ),
          ),
        ),
        FadeTransition(
          opacity: _fadeAnim,
          child: _expanded
              ? _buildExpandedPanel()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildExpandedPanel() {
    const padSize = 100.0;
    const ballR = 44.0;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '加塞',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Listener(
            onPointerDown: (_) {},
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => _onPan(d.localPosition),
              onPanDown: (d) => _onPan(d.localPosition),
              onPanUpdate: (d) => _onPan(d.localPosition),
              child: SizedBox(
                width: padSize,
                height: padSize,
                child: CustomPaint(
                  painter: _SpinPainter(hitPoint: _hitPoint, ballRadius: ballR),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _resetSpin,
            child: const Text(
              '重置',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSpinPainter extends CustomPainter {
  _MiniSpinPainter({required this.hitPoint});

  final Offset hitPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const r = 14.0;

    canvas.drawCircle(
      center,
      r,
      Paint()..color = const Color(0xDDF5F5F0),
    );

    if (hitPoint.distance > 0.5) {
      final scale = r / 44.0;
      final dot = center + hitPoint * scale;
      canvas.drawCircle(dot, 2.5, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniSpinPainter old) => old.hitPoint != hitPoint;
}

class _SpinPainter extends CustomPainter {
  _SpinPainter({required this.hitPoint, required this.ballRadius});

  final Offset hitPoint;
  final double ballRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(
      center,
      ballRadius,
      Paint()..color = const Color(0xFFF5F5F5),
    );
    canvas.drawCircle(
      center,
      ballRadius,
      Paint()
        ..color = const Color(0x44000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Crosshair
    const crossLen = 6.0;
    final crossPaint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(center.dx - crossLen, center.dy),
        Offset(center.dx + crossLen, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy - crossLen),
        Offset(center.dx, center.dy + crossLen), crossPaint);

    final dot = center + hitPoint;
    canvas.drawCircle(dot, 4, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant _SpinPainter oldDelegate) {
    return oldDelegate.hitPoint != hitPoint;
  }
}
