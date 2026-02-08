import 'package:flutter/material.dart';

/// Reusable row for displaying label-value pairs in result breakdowns.
///
/// Supports optional color, bold text, and custom value string.
class ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;
  final double fontSize;

  const ResultRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.isBold = false,
    this.fontSize = 15,
  });

  /// Convenience constructor for currency values.
  factory ResultRow.currency(
    String label,
    double amount, {
    Color? color,
    bool isBold = false,
    String symbol = '₹',
  }) {
    return ResultRow(
      label: label,
      value: '$symbol${amount.toStringAsFixed(2)}',
      color: color,
      isBold: isBold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize + 1,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
