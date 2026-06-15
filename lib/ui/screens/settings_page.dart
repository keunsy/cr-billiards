import 'package:flutter/material.dart';

import '../settings/game_settings.dart';

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
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        title: const Text('设置'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
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
          const Divider(color: Colors.white12, height: 32),
          _buildSwitch(
            title: '音效',
            subtitle: '击球和碰撞音效',
            value: _settings.soundEnabled,
            onChanged: _settings.setSoundEnabled,
          ),
          const SizedBox(height: 16),
          Text(
            '音量',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
          ),
          Slider(
            value: _settings.volume,
            onChanged: _settings.setVolume,
            activeColor: const Color(0xFF81C784),
          ),
          Text(
            '${(_settings.volume * 100).round()}%',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
          ),
          const SizedBox(height: 32),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {
                _settings.reset();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('设置已重置')),
                );
              },
              icon: const Icon(Icons.restore),
              label: const Text('重置设置'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF5350),
                side: const BorderSide(color: Color(0xFFEF5350)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
      value: value,
      onChanged: onChanged,
      activeTrackColor: const Color(0xFF81C784),
      contentPadding: EdgeInsets.zero,
    );
  }
}
