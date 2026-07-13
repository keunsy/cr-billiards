import 'package:flutter/material.dart';

import '../settings/game_settings.dart';

const _kSettingsBg = Color(0xFF0E1E16);
const _kCardBg = Color(0xFF162B20);
const _kAccent = Color(0xFF81C784);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settings = GameSettings.instance;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSettingsBg,
      appBar: AppBar(
        backgroundColor: _kSettingsBg,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          '设置',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _SectionCard(
            title: '辅助线',
            icon: Icons.visibility_outlined,
            children: [
              _buildSwitch(
                title: '瞄准辅助线',
                subtitle: '白球轨迹、幻影球、接触点',
                value: _settings.guidelineEnabled,
                onChanged: _settings.setGuidelineEnabled,
              ),
              _buildSwitch(
                title: '进球预测线',
                subtitle: '目标球被击中后的预测路径',
                value: _settings.objectPathEnabled,
                onChanged: _settings.setObjectPathEnabled,
              ),
              _buildSwitch(
                title: '切角角度',
                subtitle: '显示切角弧线和角度数值',
                value: _settings.angleDisplayEnabled,
                onChanged: _settings.setAngleDisplayEnabled,
              ),
              _buildSwitch(
                title: '分离角线',
                subtitle: '白球碰撞后的偏转路径',
                value: _settings.deflectionLineEnabled,
                onChanged: _settings.setDeflectionLineEnabled,
              ),
              _buildSwitch(
                title: '角度三角形',
                subtitle: '直角三角形及边长倍数比',
                value: _settings.triangleEnabled,
                onChanged: _settings.setTriangleEnabled,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: '音频',
            icon: Icons.volume_up_outlined,
            children: [
              _buildSwitch(
                title: '音效',
                subtitle: '击球和碰撞音效',
                value: _settings.soundEnabled,
                onChanged: _settings.setSoundEnabled,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '音量',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(_settings.volume * 100).round()}%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 13,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 7),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 14),
                  activeTrackColor: _kAccent,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: _kAccent,
                  overlayColor: _kAccent.withValues(alpha: 0.15),
                ),
                child: Slider(
                  value: _settings.volume,
                  onChanged: _settings.setVolume,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: () {
                _settings.reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('设置已重置'),
                    backgroundColor: _kCardBg,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              icon: const Icon(Icons.restore, size: 16),
              label: const Text('重置所有设置'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF5350),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 12,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeTrackColor: _kAccent,
      inactiveTrackColor: Colors.white12,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: _kAccent),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
