import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// Rectangle / Square calculator — area, perimeter, diagonal.
class RectangleScreen extends StatefulWidget {
  final Color categoryColor;
  const RectangleScreen({super.key, required this.categoryColor});

  @override
  State<RectangleScreen> createState() => _RectangleScreenState();
}

class _RectangleScreenState extends State<RectangleScreen> {
  double _length = 10;
  double _width = 6;

  double get _perimeter => 2 * (_length + _width);
  double get _area => _length * _width;

  double get _diagonalSqrt {
    // manual sqrt using Dart
    final val = _length * _length + _width * _width;
    return _sqrt(val);
  }

  double _sqrt(double val) {
    if (val <= 0) return 0;
    double guess = val / 2;
    for (int i = 0; i < 50; i++) {
      guess = (guess + val / guess) / 2;
    }
    return guess;
  }

  bool get _isSquare => (_length - _width).abs() < 0.001;

  Map<String, String> get _exportData => {
        'Length': '${_length.toStringAsFixed(2)} units',
        'Width': '${_width.toStringAsFixed(2)} units',
        'Perimeter': '${_perimeter.toStringAsFixed(4)} units',
        'Area': '${_area.toStringAsFixed(4)} sq units',
        'Diagonal': '${_diagonalSqrt.toStringAsFixed(4)} units',
        'Shape': _isSquare ? 'Square' : 'Rectangle',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Rectangle Calculator',
      accentColor: c,
      infoText: 'Set length and width to compute properties.',
      exportData: _exportData,
      children: [
        SliderInput(
          label: 'Length',
          value: _length,
          min: 0.1,
          max: 500,
          suffix: 'units',
          accentColor: c,
          onChanged: (v) => setState(() => _length = v),
        ),
        const SizedBox(height: 8),
        SliderInput(
          label: 'Width',
          value: _width,
          min: 0.1,
          max: 500,
          suffix: 'units',
          accentColor: c,
          onChanged: (v) => setState(() => _width = v),
        ),
        if (_isSquare) ...[
          const SizedBox(height: 8),
          Chip(
            avatar: Icon(Icons.square_outlined, color: c),
            label: const Text('This is a Square!'),
            backgroundColor: c.withValues(alpha: 0.1),
          ),
        ],
        const SizedBox(height: 24),
        Card(
          color: c.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ResultRow(
                    label: 'Perimeter (2(l+w))',
                    value: _perimeter.toStringAsFixed(4)),
                const Divider(),
                ResultRow(
                    label: 'Area (l × w)',
                    value: _area.toStringAsFixed(4)),
                const Divider(),
                ResultRow(
                    label: 'Diagonal (√(l²+w²))',
                    value: _diagonalSqrt.toStringAsFixed(4)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
