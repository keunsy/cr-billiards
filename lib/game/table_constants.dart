import 'package:flame/extensions.dart';

/// Standard Chinese 8-ball table dimensions (1 unit ≈ 1 cm).
/// Ref: World Chinese Billiards Association official specs.
class TableConstants {
  // Playing surface: 2540mm × 1270mm
  static const double length = 254.0;
  static const double width = 127.0;
  static const double halfLength = length / 2;
  static const double halfWidth = width / 2;

  // Ball: slightly enlarged for mobile visibility (real 57.15mm = 2.8575)
  static const double ballRadius = 3.5;
  static const double ballDiameter = ballRadius * 2;

  // Pocket openings scaled to keep relative difficulty similar
  static const double cornerPocketRadius = 5.0;
  static const double sidePocketRadius = 5.4;

  // Cushion rubber elasticity — ref: tailuge/billiards ee=0.85, Mathavan model
  static const double cushionRestitution = 0.78;
  static const double cushionFriction = 0.20;

  // Head string at 1/4 table length from head rail
  static const double headStringX = -halfLength + length / 4;
  // Foot spot at 1/4 table length from foot rail
  static const double footSpotX = halfLength - length / 4;

  // Pseudo-3D Y compression
  static const double perspectiveYScale = 0.85;

  // Max impulse
  static const double maxShotPower = 4500.0;

  // Rail (cushion) width for visual rendering
  static const double railWidth = 8.0;

  // Pocket centers: corners sit at the actual corner with slight inset,
  // side pockets sit at the midpoint with slight inset toward the table.
  static final List<Vector2> pocketCenters = List.unmodifiable([
        Vector2(-halfLength + 3.0, -halfWidth + 3.0), // top-left corner
        Vector2(0, -halfWidth + 2.5),                  // top-side
        Vector2(halfLength - 3.0, -halfWidth + 3.0),   // top-right corner
        Vector2(-halfLength + 3.0, halfWidth - 3.0),   // bottom-left corner
        Vector2(0, halfWidth - 2.5),                    // bottom-side
        Vector2(halfLength - 3.0, halfWidth - 3.0),     // bottom-right corner
      ]);

  static double pocketRadiusAt(int index) {
    return (index == 1 || index == 4) ? sidePocketRadius : cornerPocketRadius;
  }
}
