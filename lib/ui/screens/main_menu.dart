import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../game/billiards_game.dart';
import 'game_screen.dart';
import 'settings_page.dart';
import 'theory_lab_page.dart';
import 'tutorial_page.dart';

const _kAccentGold = Color(0xFFD4AF37);
const _kBgDark = Color(0xFF0A1F14);
const _kBgMid = Color(0xFF153D2B);
const _kTextLight = Color(0xFFF0F7F2);

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([]);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.4,
            colors: [_kBgMid, _kBgDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape =
                    constraints.maxWidth > constraints.maxHeight;
                if (isLandscape) {
                  return _buildLandscape(context, constraints);
                }
                return _buildPortrait(context, constraints);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _BallCluster(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 32),
              ..._buildButtonList(context),
              const SizedBox(height: 28),
              Text(
                'v1.0',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.25),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _BallCluster(size: 60),
                const SizedBox(height: 8),
                _buildTitle(compact: true),
              ],
            ),
            const SizedBox(width: 48),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _LandscapeMenuButton(
                  label: '标准开局',
                  icon: Icons.play_circle_outline,
                  onPressed: () => _startGame(context, GameMode.standard),
                ),
                _LandscapeMenuButton(
                  label: '自由练习',
                  icon: Icons.grain,
                  onPressed: () => _startGame(context, GameMode.practice),
                ),
                _LandscapeMenuButton(
                  label: '桌球教程',
                  icon: Icons.menu_book_outlined,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TutorialPage())),
                ),
                _LandscapeMenuButton(
                  label: '理论实验室',
                  icon: Icons.science_outlined,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TheoryLabPage())),
                ),
                _LandscapeMenuButton(
                  label: '设置',
                  icon: Icons.tune_outlined,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsPage())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle({bool compact = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '中式八球',
          style: TextStyle(
            fontSize: compact ? 22 : 32,
            fontWeight: FontWeight.w300,
            letterSpacing: compact ? 6 : 10,
            color: _kTextLight,
            shadows: const [
              Shadow(
                  color: Colors.black54,
                  offset: Offset(0, 2),
                  blurRadius: 12),
            ],
          ),
        ),
        SizedBox(height: compact ? 2 : 6),
        Container(
          width: compact ? 40 : 56,
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, _kAccentGold, Colors.transparent],
            ),
          ),
        ),
        SizedBox(height: compact ? 4 : 8),
        Text(
          'CHINESE EIGHT BALL',
          style: TextStyle(
            fontSize: compact ? 9 : 11,
            letterSpacing: 4,
            fontWeight: FontWeight.w500,
            color: _kAccentGold.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildButtonList(BuildContext context) {
    return [
      _MenuButton(
        label: '标准开局',
        subtitle: '完整中式八球规则',
        icon: Icons.play_circle_outline,
        onPressed: () => _startGame(context, GameMode.standard),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '自由练习',
        subtitle: '自由摆球 · 无限击打',
        icon: Icons.grain,
        onPressed: () => _startGame(context, GameMode.practice),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '桌球教程',
        subtitle: '基础技巧与进阶打法',
        icon: Icons.menu_book_outlined,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const TutorialPage())),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '理论实验室',
        subtitle: '物理模拟与角度分析',
        icon: Icons.science_outlined,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const TheoryLabPage())),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '设置',
        subtitle: '辅助线 · 音效 · 偏好',
        icon: Icons.tune_outlined,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SettingsPage())),
      ),
    ];
  }

  void _startGame(BuildContext context, GameMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(gameMode: mode)),
    );
  }
}

class _BallCluster extends StatelessWidget {
  const _BallCluster({this.size = 90});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BallClusterPainter()),
    );
  }
}

class _BallClusterPainter extends CustomPainter {
  static const _ballColors = [
    Color(0xFFF9D923), // 1 yellow
    Color(0xFF1565C0), // 2 blue
    Color(0xFFD32F2F), // 3 red
    Color(0xFF7B1FA2), // 4 purple
    Color(0xFFFF8F00), // 5 orange
    Color(0xFF212121), // 8 black
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.16;
    final spacing = r * 2.15;

    final positions = [
      Offset(cx, cy - spacing * 0.5),
      Offset(cx - r * 1.1, cy + spacing * 0.35),
      Offset(cx + r * 1.1, cy + spacing * 0.35),
    ];

    for (var i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final color = _ballColors[i];

      // Shadow
      canvas.drawCircle(
        pos + const Offset(1, 2),
        r,
        Paint()
          ..color = Colors.black38
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // Ball body
      final gradient = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: [
          Color.lerp(color, Colors.white, 0.35)!,
          color,
          Color.lerp(color, Colors.black, 0.3)!,
        ],
        stops: const [0, 0.5, 1],
      );
      canvas.drawCircle(
        pos,
        r,
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(center: pos, radius: r),
          ),
      );

      // Specular highlight
      canvas.drawCircle(
        pos + Offset(-r * 0.25, -r * 0.25),
        r * 0.25,
        Paint()..color = Colors.white.withValues(alpha: 0.45),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: _kAccentGold.withValues(alpha: 0.08),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kAccentGold.withValues(alpha: 0.12),
                  ),
                  child: Icon(icon, size: 18, color: _kAccentGold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: _kTextLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LandscapeMenuButton extends StatelessWidget {
  const _LandscapeMenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          splashColor: _kAccentGold.withValues(alpha: 0.08),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: _kAccentGold),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      letterSpacing: 0.5,
                      color: _kTextLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
