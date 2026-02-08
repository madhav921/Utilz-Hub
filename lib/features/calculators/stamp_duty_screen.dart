import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Basic stamp duty estimator.
class StampDutyScreen extends StatefulWidget {
  final Color categoryColor;
  const StampDutyScreen({super.key, required this.categoryColor});

  @override
  State<StampDutyScreen> createState() => _StampDutyScreenState();
}

class _StampDutyScreenState extends State<StampDutyScreen> {
  final _valueCtrl = TextEditingController();
  double _rate = 5; // %
  double _regRate = 1; // registration %

  double get _propValue => double.tryParse(_valueCtrl.text) ?? 0;
  bool get _valid => _propValue > 0;
  double get _stampDuty => _propValue * _rate / 100;
  double get _registration => _propValue * _regRate / 100;
  double get _total => _stampDuty + _registration;

  Map<String, String> get _exportData => _valid
      ? {
          'Property Value': '₹${_propValue.toStringAsFixed(0)}',
          'Stamp Duty (${_rate.toStringAsFixed(1)}%)': '₹${_stampDuty.toStringAsFixed(0)}',
          'Registration (${_regRate.toStringAsFixed(1)}%)': '₹${_registration.toStringAsFixed(0)}',
          'Total': '₹${_total.toStringAsFixed(0)}',
        }
      : {};

  @override
  void dispose() {
    _valueCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Stamp Duty',
      accentColor: c,
      toolId: 'stamp_duty',
      categoryName: 'Business & Tax',
      infoText: 'Estimate stamp duty & registration charges',
      exportData: _exportData,
      children: [
        TextField(
          controller: _valueCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Property / Agreement Value',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        SliderInput(
          label: 'Stamp Duty Rate',
          value: _rate, min: 0.5, max: 15, divisions: 29,
          suffix: '%', accentColor: c, decimals: 1,
          onChanged: (v) => setState(() => _rate = v),
        ),
        SliderInput(
          label: 'Registration Rate',
          value: _regRate, min: 0, max: 5, divisions: 10,
          suffix: '%', accentColor: c, decimals: 1,
          onChanged: (v) => setState(() => _regRate = v),
        ),
        const SizedBox(height: 16),
        if (_valid)
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ResultRow(label: 'Stamp Duty', value: '₹${_stampDuty.toStringAsFixed(0)}'),
                ResultRow(label: 'Registration', value: '₹${_registration.toStringAsFixed(0)}'),
                const Divider(),
                ResultRow(label: 'Total Charges', value: '₹${_total.toStringAsFixed(0)}', isBold: true),
              ]),
            ),
          ),
      ],
    );
  }
}
