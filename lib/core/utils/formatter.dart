import 'package:intl/intl.dart';

/// Format numbers for display
class NumberFormatter {
  /// Format a number with appropriate precision
  static String format(double value, {int maxDecimals = 6}) {
    if (value.isNaN || value.isInfinite) {
      return 'Error';
    }

    // Remove trailing zeros
    String result = value.toStringAsFixed(maxDecimals);
    result = result.replaceAll(RegExp(r'\.?0+$'), '');
    
    // If empty after removing zeros, return "0"
    if (result.isEmpty || result == '-') {
      return '0';
    }

    return result;
  }

  /// Format currency
  static String formatCurrency(double value, {String symbol = '₹'}) {
    final formatter = NumberFormat('#,##,##0.00', 'en_IN');
    return '$symbol${formatter.format(value)}';
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Parse input string to double
  static double? parseInput(String input) {
    if (input.isEmpty) return null;
    
    // Remove commas and spaces
    final cleaned = input.replaceAll(RegExp(r'[,\s]'), '');
    
    try {
      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }

  /// Validate numeric input
  static bool isValidNumber(String input) {
    if (input.isEmpty) return false;
    final cleaned = input.replaceAll(RegExp(r'[,\s]'), '');
    return double.tryParse(cleaned) != null;
  }
}
