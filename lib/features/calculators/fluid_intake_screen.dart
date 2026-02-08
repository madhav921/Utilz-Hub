import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Daily fluid/water intake calculator.
class FluidIntakeScreen extends StatefulWidget {
  final Color categoryColor;
  const FluidIntakeScreen({super.key, required this.categoryColor});

  @override
  State<FluidIntakeScreen> createState() => _FluidIntakeScreenState();
}

class _FluidIntakeScreenState extends State<FluidIntakeScreen> {
  double _weight = 70;
  int _activity = 1; // 0=sedentary, 1=moderate, 2=active, 3=athlete
  bool _hot = false;

  static const _actLabels = ['Sedentary', 'Moderate', 'Active', 'Athlete'];
  static const _actFactors = [30.0, 35.0, 40.0, 45.0]; // mL per kg

  double get _baseMl => _weight * _actFactors[_activity];
  double get _adjustedMl => _hot ? _baseMl * 1.15 : _baseMl;
  double get _liters => _adjustedMl / 1000;
  double get _glasses => _adjustedMl / 250;
  double get _oz => _adjustedMl / 29.574;

  Map<String, String> get _exportData => {
    'Weight': '${_weight.round()} kg',
    'Activity': _actLabels[_activity],
    'Hot Climate': _hot ? 'Yes (+15%)' : 'No',
    'Daily Intake': '${_liters.toStringAsFixed(1)} L',
    'Glasses (250 mL)': _glasses.toStringAsFixed(0),
    'Fluid Ounces': '${_oz.toStringAsFixed(0)} oz',
  };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Fluid Intake',
      accentColor: c,
      toolId: 'fluid_intake',
      categoryName: 'Health & Body',
      infoText: 'Recommended daily water intake',
      exportData: _exportData,
      children: [
        SliderInput(label: 'Body Weight', value: _weight, min: 20, max: 150, divisions: 130, suffix: 'kg', accentColor: c, decimals: 0, onChanged: (v) => setState(() => _weight = v)),
        const SizedBox(height: 8),
        const Text('Activity Level', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Center(
          child: SegmentedButton<int>(
            segments: List.generate(4, (i) => ButtonSegment(value: i, label: Text(_actLabels[i]))),
            selected: {_activity},
            onSelectionChanged: (v) => setState(() => _activity = v.first),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Hot / humid climate'),
          subtitle: const Text('+15% adjustment'),
          value: _hot,
          activeTrackColor: c.withAlpha(100),
          onChanged: (v) => setState(() => _hot = v),
        ),
        const SizedBox(height: 12),
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text('${_liters.toStringAsFixed(1)} L', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: c)),
              const Text('recommended daily intake'),
              const Divider(height: 24),
              ResultRow(label: 'Milliliters', value: '${_adjustedMl.toStringAsFixed(0)} mL'),
              ResultRow(label: 'Glasses (250 mL)', value: '~${_glasses.round()}'),
              ResultRow(label: 'Fluid ounces', value: '${_oz.toStringAsFixed(0)} oz'),
            ]),
          ),
        ),
      ],
    );
  }
}
