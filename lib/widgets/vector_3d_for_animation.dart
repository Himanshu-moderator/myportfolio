import 'dart:math';
import 'dart:ui';

class Vector3 {
  double x, y, z;
  Vector3(this.x, this.y, this.z);

  // Rotation methods
  Vector3 rotateX(double angle) {
    final double newY = y * cos(angle) - z * sin(angle);
    final double newZ = y * sin(angle) + z * cos(angle);
    return Vector3(x, newY, newZ);
  }

  Vector3 rotateY(double angle) {
    final double newX = x * cos(angle) + z * sin(angle);
    final double newZ = -x * sin(angle) + z * cos(angle);
    return Vector3(newX, y, newZ);
  }

  Vector3 rotateZ(double angle) {
    final double newX = x * cos(angle) - y * sin(angle);
    final double newY = x * sin(angle) + y * cos(angle);
    return Vector3(newX, newY, z);
  }

  // Vector operations
  Vector3 operator -(Vector3 other) {
    return Vector3(x - other.x, y - other.y, z - other.z);
  }

  Vector3 operator +(Vector3 other) {
    return Vector3(x + other.x, y + other.y, z + other.y);
  }

  Vector3 operator *(double scalar) {
    return Vector3(x * scalar, y * scalar, z * scalar);
  }

  double get magnitude => sqrt(x * x + y * y + z * z);

  Vector3 normalize() {
    if (magnitude == 0) return Vector3(0, 0, 0);
    return Vector3(x / magnitude, y / magnitude, z / magnitude);
  }

  // Simple perspective projection
  Offset project(double focalLength, double scale) {
    final double depth = focalLength + z;
    if (depth <= 0) return Offset.zero;
    return Offset(
      x * (focalLength / depth) * scale,
      y * (focalLength / depth) * scale,
    );
  }

  // Static linear interpolation (lerp) method for Vector3
  static Vector3 lerp(Vector3 a, Vector3 b, double t) {
    return Vector3(
      a.x + (b.x - a.x) * t,
      a.y + (b.y - a.y) * t,
      a.z + (b.z - a.z) * t,
    );
  }
}
