import 'package:flutter/material.dart';

/// Reusable labeled slider widget for numeric input.
///
/// Used across multiple calculator screens to reduce code duplication.
/// Displays a label, current value with suffix, and an interactive slider.
class SliderInput extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final Color accentColor;
  final ValueChanged<double> onChanged;
  final int decimals;

  const SliderInput({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions = 100,
    this.suffix = '',
    required this.accentColor,
    required this.onChanged,
    this.decimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            Text(
              '${value.toStringAsFixed(decimals)} $suffix'.trim(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          activeColor: accentColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
