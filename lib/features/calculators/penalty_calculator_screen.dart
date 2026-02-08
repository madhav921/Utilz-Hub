import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Penalty / fine percentage calculator.
class PenaltyCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const PenaltyCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<PenaltyCalculatorScreen> createState() => _PenaltyCalculatorScreenState();
}

class _PenaltyCalculatorScreenState extends State<PenaltyCalculatorScreen> {
  final _amountCtrl = TextEditingController();
  double _penaltyRate = 2;
  double _days = 30;

  double get _amount => double.tryParse(_amountCtrl.text) ?? 0;
  bool get _valid => _amount > 0;
  double get _dailyRate => _penaltyRate / 365;
  double get _penalty => _amount * _dailyRate / 100 * _days;
  double get _total => _amount + _penalty;

  Map<String, String> get _exportData => _valid
      ? {
          'Principal': '₹${_amount.toStringAsFixed(0)}',
          'Penalty Rate': '${_penaltyRate.toStringAsFixed(1)}% p.a.',
          'Days Overdue': '${_days.round()}',
          'Penalty Amount': '₹${_penalty.toStringAsFixed(2)}',
          'Total Due': '₹${_total.toStringAsFixed(2)}',
        }
      : {};

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Penalty Calculator',
      accentColor: c,
      toolId: 'penalty_calculator',
      categoryName: 'Business & Tax',
      infoText: 'Calculate penalty / fine on overdue amounts',
      exportData: _exportData,
      children: [
        TextField(
          controller: _amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Original Amount',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        SliderInput(
          label: 'Penalty Rate (per annum)',
          value: _penaltyRate, min: 0.5, max: 36, divisions: 71,
          suffix: '%', accentColor: c, decimals: 1,
          onChanged: (v) => setState(() => _penaltyRate = v),
        ),
        SliderInput(
          label: 'Days Overdue',
          value: _days, min: 1, max: 730, divisions: 729,
          suffix: 'days', accentColor: c, decimals: 0,
          onChanged: (v) => setState(() => _days = v),
        ),
        const SizedBox(height: 16),
        if (_valid)
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ResultRow(label: 'Daily Rate', value: '${_dailyRate.toStringAsFixed(4)}%'),
                ResultRow(label: 'Penalty', value: '₹${_penalty.toStringAsFixed(2)}'),
                const Divider(),
                ResultRow(label: 'Total Due', value: '₹${_total.toStringAsFixed(2)}', isBold: true),
              ]),
            ),
          ),
      ],
    );
  }
}
