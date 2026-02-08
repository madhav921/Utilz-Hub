import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// 3D volume calculator — Sphere, Cylinder, Cone, Cube.
class Volume3DScreen extends StatefulWidget {
  final Color categoryColor;
  const Volume3DScreen({super.key, required this.categoryColor});

  @override
  State<Volume3DScreen> createState() => _Volume3DScreenState();
}

enum _Shape { sphere, cylinder, cone, cube }

class _Volume3DScreenState extends State<Volume3DScreen> {
  _Shape _shape = _Shape.sphere;
  double _radius = 5;
  double _height = 10;
  double _side = 5;

  Map<String, double> get _results {
    switch (_shape) {
      case _Shape.sphere:
        final v = (4 / 3) * math.pi * math.pow(_radius, 3);
        final sa = 4 * math.pi * _radius * _radius;
        return {'Volume': v, 'Surface Area': sa};
      case _Shape.cylinder:
        final v = math.pi * _radius * _radius * _height;
        final sa = 2 * math.pi * _radius * (_radius + _height);
        return {'Volume': v, 'Surface Area': sa};
      case _Shape.cone:
        final v = (1 / 3) * math.pi * _radius * _radius * _height;
        final slant = math.sqrt(_radius * _radius + _height * _height);
        final sa = math.pi * _radius * (slant + _radius);
        return {'Volume': v, 'Slant Height': slant, 'Surface Area': sa};
      case _Shape.cube:
        final v = _side * _side * _side;
        final sa = 6 * _side * _side;
        final diag = _side * math.sqrt(3);
        return {'Volume': v, 'Surface Area': sa, 'Space Diagonal': diag};
    }
  }

  Map<String, String> get _exportData {
    final r = _results;
    return {
      'Shape': _shape.name[0].toUpperCase() + _shape.name.substring(1),
      ...r.map((k, v) => MapEntry(k, v.toStringAsFixed(4))),
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: '3D Volumes',
      accentColor: c,
      infoText: 'Choose a shape and adjust dimensions.',
      exportData: _exportData,
      children: [
        // Shape selector
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<_Shape>(
              segments: const [
                ButtonSegment(
                    value: _Shape.sphere,
                    icon: Icon(Icons.circle_outlined),
                    label: Text('Sphere')),
                ButtonSegment(
                    value: _Shape.cylinder,
                    icon: Icon(Icons.vertical_align_center),
                    label: Text('Cylinder')),
                ButtonSegment(
                    value: _Shape.cone,
                    icon: Icon(Icons.change_history),
                    label: Text('Cone')),
                ButtonSegment(
                    value: _Shape.cube,
                    icon: Icon(Icons.square_outlined),
                    label: Text('Cube')),
              ],
              selected: {_shape},
              onSelectionChanged: (s) => setState(() => _shape = s.first),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Inputs based on shape
        if (_shape == _Shape.cube)
          SliderInput(
            label: 'Side',
            value: _side,
            min: 0.1,
            max: 200,
            suffix: 'units',
            accentColor: c,
            onChanged: (v) => setState(() => _side = v),
          )
        else ...[
          SliderInput(
            label: 'Radius',
            value: _radius,
            min: 0.1,
            max: 200,
            suffix: 'units',
            accentColor: c,
            onChanged: (v) => setState(() => _radius = v),
          ),
          if (_shape != _Shape.sphere) ...[
            const SizedBox(height: 8),
            SliderInput(
              label: 'Height',
              value: _height,
              min: 0.1,
              max: 200,
              suffix: 'units',
              accentColor: c,
              onChanged: (v) => setState(() => _height = v),
            ),
          ],
        ],

        const SizedBox(height: 24),

        // Results
        Card(
          color: c.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _results.entries
                  .expand((e) => [
                        ResultRow(
                          label: e.key,
                          value: e.value.toStringAsFixed(4),
                        ),
                        if (e.key != _results.keys.last) const Divider(),
                      ])
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
