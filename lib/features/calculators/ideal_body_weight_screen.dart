import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_with_input.dart';

/// Ideal Body Weight (IBW) Calculator using multiple formulas.
class IdealBodyWeightScreen extends StatefulWidget {
  final Color categoryColor;
  const IdealBodyWeightScreen({super.key, required this.categoryColor});

  @override
  State<IdealBodyWeightScreen> createState() => _IdealBodyWeightScreenState();
}

class _IdealBodyWeightScreenState extends State<IdealBodyWeightScreen> {
  double _heightCm = 170;
  String _gender = 'Male';

  double get _heightInches => _heightCm / 2.54;
  double get _inchesOver5Ft =>
      (_heightInches - 60).clamp(0, double.infinity);

  /// Devine Formula
  double get _devine => _gender == 'Male'
      ? 50 + 2.3 * _inchesOver5Ft
      : 45.5 + 2.3 * _inchesOver5Ft;

  /// Robinson Formula
  double get _robinson => _gender == 'Male'
      ? 52 + 1.9 * _inchesOver5Ft
      : 49 + 1.7 * _inchesOver5Ft;

  /// Miller Formula
  double get _miller => _gender == 'Male'
      ? 56.2 + 1.41 * _inchesOver5Ft
      : 53.1 + 1.36 * _inchesOver5Ft;

  /// Hamwi Formula
  double get _hamwi => _gender == 'Male'
      ? 48 + 2.7 * _inchesOver5Ft
      : 45.5 + 2.2 * _inchesOver5Ft;

  double get _average =>
      (_devine + _robinson + _miller + _hamwi) / 4;

  Map<String, String> get _exportData => {
        'Height': '${_heightCm.toStringAsFixed(0)} cm',
        'Gender': _gender,
        'Devine': '${_devine.toStringAsFixed(1)} kg',
        'Robinson': '${_robinson.toStringAsFixed(1)} kg',
        'Miller': '${_miller.toStringAsFixed(1)} kg',
        'Hamwi': '${_hamwi.toStringAsFixed(1)} kg',
        'Average': '${_average.toStringAsFixed(1)} kg',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Ideal Body Weight',
      accentColor: c,
      toolId: 'ideal_body_weight',
      categoryName: 'Health & Body',
      infoText:
          'Estimates your ideal weight using 4 established medical formulas.',
      exportData: _exportData,
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Male', label: Text('Male')),
            ButtonSegment(value: 'Female', label: Text('Female')),
          ],
          selected: {_gender},
          onSelectionChanged: (v) => setState(() => _gender = v.first),
        ),
        const SizedBox(height: 16),
        _label('Height (cm)', c),
        SliderWithInput(
          value: _heightCm,
          min: 120,
          max: 220,
          divisions: 100,
          activeColor: c,
          onChanged: (v) => setState(() => _heightCm = v),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ideal Weight Estimates',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c)),
                const Divider(),
                ResultRow(
                    label: 'Devine',
                    value: '${_devine.toStringAsFixed(1)} kg'),
                ResultRow(
                    label: 'Robinson',
                    value: '${_robinson.toStringAsFixed(1)} kg'),
                ResultRow(
                    label: 'Miller',
                    value: '${_miller.toStringAsFixed(1)} kg'),
                ResultRow(
                    label: 'Hamwi',
                    value: '${_hamwi.toStringAsFixed(1)} kg'),
                const Divider(),
                ResultRow(
                  label: 'Average',
                  value: '${_average.toStringAsFixed(1)} kg',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text, Color c) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: c)),
      );
}
