import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../game/billiards_game.dart';
import '../../game/components/spin_indicator.dart';
import '../../game/input/power_gauge.dart';
import '../widgets/scoreboard.dart';
import 'settings_page.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.gameMode,
  });

  final GameMode gameMode;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BilliardsGame _game;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _game = BilliardsGame(gameMode: widget.gameMode);
    _game.rulesNotifier.addListener(_onGameUpdate);
    _game.stateNotifier.addListener(_onGameUpdate);
  }

  @override
  void dispose() {
    _game.rulesNotifier.removeListener(_onGameUpdate);
    _game.stateNotifier.removeListener(_onGameUpdate);
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  void _onGameUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isCompact = mq.size.height < 500;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Game canvas — absorbs all touch by default
          GameWidget(game: _game),

          // Layer 2: Overlay UI — each element positioned independently
          // IgnorePointer on the outer SafeArea so blank areas pass through
          SafeArea(
            child: IgnorePointer(
              ignoring: true,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Top-left: back button + status
                      Positioned(
                        top: 4,
                        left: 6,
                        child: IgnorePointer(
                          ignoring: false,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _TinyIconButton(
                                icon: Icons.arrow_back,
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 4),
                              if (_game.state == GameState.placingBall)
                                _StatusChip(
                                  text: _game.isPlaceBehindHeadString
                                      ? '长按白球拖放（开球线后）'
                                      : '长按白球拖放',
                                )
                              else if (widget.gameMode == GameMode.practice)
                                const _StatusChip(text: '长按任意球可拖动'),
                            ],
                          ),
                        ),
                      ),

                      // Top-right: toolbar buttons
                      Positioned(
                        top: 4,
                        right: 6,
                        child: IgnorePointer(
                          ignoring: false,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _TinyIconButton(
                                icon: _game.guidelineEnabled
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                onPressed: () {
                                  _game.toggleGuideline();
                                  setState(() {});
                                },
                              ),
                              const SizedBox(width: 4),
                              _TinyIconButton(
                                icon: Icons.tune,
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SettingsPage()),
                                  );
                                  _game.applySettings();
                                  setState(() {});
                                },
                              ),
                              if (widget.gameMode == GameMode.practice) ...[
                                const SizedBox(width: 4),
                                _TinyIconButton(
                                  icon: Icons.undo,
                                  onPressed: _game.canUndo
                                      ? () {
                                          _game.undoLastShot();
                                          setState(() {});
                                        }
                                      : null,
                                ),
                              ],
                              const SizedBox(width: 4),
                              _TinyIconButton(
                                icon: Icons.refresh,
                                onPressed: () {
                                  if (widget.gameMode == GameMode.standard) {
                                    _game.resetStandard();
                                  } else {
                                    _game.resetFreePlay();
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right side: power gauge
                      Positioned(
                        right: 6,
                        top: isCompact ? 36 : 44,
                        bottom: 8,
                        child: IgnorePointer(
                          ignoring: false,
                          child: PowerGauge(game: _game),
                        ),
                      ),

                      // Bottom-left: spin indicator
                      Positioned(
                        left: 6,
                        bottom: 8,
                        child: IgnorePointer(
                          ignoring: false,
                          child: SpinIndicator(game: _game),
                        ),
                      ),

                      // Top center: scoreboard (only when showing foul info)
                      Positioned(
                        top: isCompact ? 30 : 36,
                        left: 60,
                        right: 60,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Scoreboard(rules: _game.rules),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white60, fontSize: 10),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _TinyIconButton extends StatelessWidget {
  const _TinyIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon,
            color: enabled ? Colors.white : Colors.white24,
            size: 18),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: enabled ? Colors.black45 : Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
