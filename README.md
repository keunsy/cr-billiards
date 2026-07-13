# 中式八球 (Chinese Eight Ball)

一款基于 Flutter + Flame 引擎的 2D 中式八球台球模拟游戏，内置完整物理引擎（Forge2D）、犯规检测、辅助瞄准系统及台球教学模块。

## 功能

- **标准开局** — 完整中式八球规则，含开球、犯规判定、黑八胜负逻辑
- **自由练习** — 自由摆球、无限击打、撤销上一杆
- **瞄准辅助** — 辅助线、入射角显示、目标球路径预测、偏转线、三角瞄准系统
- **旋转控制** — 母球加塞（左/右旋）与跟球/缩球控制
- **力度控制** — 可调节击球力度
- **桌球教程** — 基础技巧与进阶打法教学
- **理论实验室** — 物理模拟与角度分析交互工具
- **音效系统** — 击球、进袋、碰库、犯规等音效

## 技术栈

| 组件 | 技术 |
|------|------|
| 框架 | Flutter (Dart SDK ^3.12.1) |
| 游戏引擎 | Flame ^1.37.0 |
| 物理引擎 | Forge2D (via flame_forge2d ^0.19.2) |
| 音频 | flame_audio ^2.12.1 |

## 快速开始

```bash
# 克隆项目
git clone https://github.com/keunsy/cr-billiards.git
cd cr-billiards

# 安装依赖
flutter pub get

# 运行（推荐横屏设备/模拟器）
flutter run
```

## 项目结构

```
lib/
├── main.dart                  # 应用入口
├── audio/                     # 音效管理
├── game/
│   ├── billiards_game.dart    # 游戏主逻辑
│   ├── table_constants.dart   # 球台参数
│   ├── components/            # 球、球杆、辅助线、袋口、球台
│   ├── input/                 # 瞄准控制、力度条
│   └── systems/               # 摆球、开球排列
├── rules/                     # 犯规检测、规则引擎
└── ui/
    ├── screens/               # 主菜单、游戏界面、教程、理论实验室、设置
    ├── settings/              # 游戏设置
    └── widgets/               # 记分板
```

## License

MIT
