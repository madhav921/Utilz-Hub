import 'dart:math' as math;

/// Mathematical helper functions
class MathHelpers {
  /// Round to specified decimal places
  static double roundTo(double value, int places) {
    final mod = math.pow(10.0, places);
    return (value * mod).round() / mod;
  }

  /// Check if value is valid (not NaN or infinite)
  static bool isValidNumber(double value) {
    return !value.isNaN && !value.isInfinite;
  }

  /// Safely divide with zero check
  static double safeDivide(double numerator, double denominator, {double defaultValue = 0.0}) {
    if (denominator == 0.0) return defaultValue;
    final result = numerator / denominator;
    return isValidNumber(result) ? result : defaultValue;
  }

  /// Calculate power safely
  static double safePower(double base, double exponent) {
    try {
      final result = math.pow(base, exponent).toDouble();
      return isValidNumber(result) ? result : 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Calculate percentage
  static double percentage(double value, double total) {
    return safeDivide(value * 100, total);
  }
}
