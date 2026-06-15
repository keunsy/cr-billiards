import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../game/billiards_game.dart';
import 'game_screen.dart';
import 'rules_page.dart';
import 'settings_page.dart';
import 'billiard_guide_page.dart';
import 'theory_lab_page.dart';
import 'tutorial_page.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Allow all orientations on the menu screen
    SystemChrome.setPreferredOrientations([]);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D2818),
              Color(0xFF1B4332),
              Color(0xFF2D6A4F),
              Color(0xFF1B4332),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape = constraints.maxWidth > constraints.maxHeight;
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              const SizedBox(height: 24),
              ..._buildButtonList(context),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(compact: true),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _LandscapeMenuButton(
                  label: '标准开局',
                  icon: Icons.sports_esports,
                  onPressed: () => _startGame(context, GameMode.standard),
                ),
                _LandscapeMenuButton(
                  label: '自由练习',
                  icon: Icons.open_with,
                  onPressed: () => _startGame(context, GameMode.practice),
                ),
                _LandscapeMenuButton(
                  label: '操作教程',
                  icon: Icons.school_outlined,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TutorialPage())),
                ),
                _LandscapeMenuButton(
                  label: '桌球教程',
                  icon: Icons.auto_stories_outlined,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BilliardGuidePage())),
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
                  label: '规则说明',
                  icon: Icons.menu_book_outlined,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RulesPage())),
                ),
                _LandscapeMenuButton(
                  label: '设置',
                  icon: Icons.settings_outlined,
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
            fontSize: compact ? 24 : 36,
            fontWeight: FontWeight.w300,
            letterSpacing: compact ? 8 : 12,
            color: const Color(0xFFE8F5E9),
            shadows: const [
              Shadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 8),
            ],
          ),
        ),
        SizedBox(height: compact ? 2 : 4),
        Text(
          'Chinese Eight Ball',
          style: TextStyle(
            fontSize: compact ? 10 : 12,
            letterSpacing: 3,
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildButtonList(BuildContext context) {
    return [
      _MenuButton(
        label: '标准开局',
        icon: Icons.sports_esports,
        onPressed: () => _startGame(context, GameMode.standard),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '自由练习',
        icon: Icons.open_with,
        onPressed: () => _startGame(context, GameMode.practice),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '操作教程',
        icon: Icons.school_outlined,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const TutorialPage())),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '桌球教程',
        icon: Icons.auto_stories_outlined,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BilliardGuidePage())),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '理论实验室',
        icon: Icons.science_outlined,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const TheoryLabPage())),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '规则说明',
        icon: Icons.menu_book_outlined,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const RulesPage())),
      ),
      const SizedBox(height: 10),
      _MenuButton(
        label: '设置',
        icon: Icons.settings_outlined,
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

class _MenuButton extends StatelessWidget {
  const _MenuButton({
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
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label:
            Text(label, style: const TextStyle(fontSize: 15, letterSpacing: 2)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.35),
          foregroundColor: const Color(0xFFE8F5E9),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white12),
          ),
          elevation: 0,
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
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label:
            Text(label, style: const TextStyle(fontSize: 13, letterSpacing: 1)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.35),
          foregroundColor: const Color(0xFFE8F5E9),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
