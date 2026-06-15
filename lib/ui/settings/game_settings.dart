import 'package:flutter/foundation.dart';

/// In-memory game settings (can be persisted later).
class GameSettings extends ChangeNotifier {
  GameSettings._();
  static final GameSettings instance = GameSettings._();

  bool guidelineEnabled = true;
  bool objectPathEnabled = true;
  bool angleDisplayEnabled = true;
  bool deflectionLineEnabled = true;
  bool triangleEnabled = true;
  bool soundEnabled = true;
  double volume = 0.8;

  void setGuidelineEnabled(bool value) {
    guidelineEnabled = value;
    notifyListeners();
  }

  void setObjectPathEnabled(bool value) {
    objectPathEnabled = value;
    notifyListeners();
  }

  void setAngleDisplayEnabled(bool value) {
    angleDisplayEnabled = value;
    notifyListeners();
  }

  void setDeflectionLineEnabled(bool value) {
    deflectionLineEnabled = value;
    notifyListeners();
  }

  void setTriangleEnabled(bool value) {
    triangleEnabled = value;
    notifyListeners();
  }

  void setSoundEnabled(bool value) {
    soundEnabled = value;
    notifyListeners();
  }

  void setVolume(double value) {
    volume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void reset() {
    guidelineEnabled = true;
    objectPathEnabled = true;
    angleDisplayEnabled = true;
    deflectionLineEnabled = true;
    triangleEnabled = true;
    soundEnabled = true;
    volume = 0.8;
    notifyListeners();
  }
}
