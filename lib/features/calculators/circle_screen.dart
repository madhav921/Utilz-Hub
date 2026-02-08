import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// Circle area, circumference, diameter & sector calculations.
class CircleScreen extends StatefulWidget {
  final Color categoryColor;
  const CircleScreen({super.key, required this.categoryColor});

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  double _radius = 5;

  double get _diameter => _radius * 2;
  double get _circumference => 2 * math.pi * _radius;
  double get _area => math.pi * _radius * _radius;

  Map<String, String> get _exportData => {
        'Radius': '${_radius.toStringAsFixed(2)} units',
        'Diameter': '${_diameter.toStringAsFixed(4)} units',
        'Circumference': '${_circumference.toStringAsFixed(4)} units',
        'Area': '${_area.toStringAsFixed(4)} sq units',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Circle Calculator',
      accentColor: c,
      infoText: 'Enter the radius to compute all circle properties.',
      exportData: _exportData,
      children: [
        SliderInput(
          label: 'Radius',
          value: _radius,
          min: 0.1,
          max: 1000,
          suffix: 'units',
          accentColor: c,
          onChanged: (v) => setState(() => _radius = v),
        ),
        const SizedBox(height: 24),
        Card(
          color: c.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ResultRow(
                    label: 'Diameter', value: _diameter.toStringAsFixed(4)),
                const Divider(),
                ResultRow(
                    label: 'Circumference (2πr)',
                    value: _circumference.toStringAsFixed(4)),
                const Divider(),
                ResultRow(
                    label: 'Area (πr²)',
                    value: _area.toStringAsFixed(4)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Visual
        Center(
          child: CustomPaint(
            size: const Size(160, 160),
            painter: _CirclePainter(c),
          ),
        ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;
  _CirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, strokePaint);

    // Radius line
    canvas.drawLine(
      center,
      Offset(center.dx + radius, center.dy),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
