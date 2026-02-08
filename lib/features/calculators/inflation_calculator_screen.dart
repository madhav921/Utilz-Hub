import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_with_input.dart';

/// Inflation-Adjusted Value Calculator.
class InflationCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const InflationCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<InflationCalculatorScreen> createState() =>
      _InflationCalculatorScreenState();
}

class _InflationCalculatorScreenState
    extends State<InflationCalculatorScreen> {
  double _amount = 100000;
  double _inflationRate = 6.0;
  int _years = 10;

  double get _futureValue =>
      _amount * math.pow(1 + _inflationRate / 100, _years);
  double get _presentValue =>
      _amount / math.pow(1 + _inflationRate / 100, _years);
  double get _purchasingPowerLoss =>
      (1 - (_amount / _futureValue)) * 100;

  Map<String, String> get _exportData => {
        'Current Amount': '₹${_amount.toStringAsFixed(0)}',
        'Inflation Rate': '${_inflationRate.toStringAsFixed(1)}%',
        'Years': '$_years',
        'Future Cost': '₹${_futureValue.toStringAsFixed(0)}',
        'Present Worth': '₹${_presentValue.toStringAsFixed(0)}',
        'Purchasing Power Loss': '${_purchasingPowerLoss.toStringAsFixed(1)}%',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Inflation Calculator',
      accentColor: c,
      toolId: 'inflation_calculator',
      categoryName: 'Finance & Loans',
      infoText:
          'See how inflation erodes value over time, or what today\'s money will cost in the future.',
      exportData: _exportData,
      children: [
        _label('Amount (₹)', c),
        SliderWithInput(
          value: _amount,
          min: 1000,
          max: 10000000,
          divisions: 100,
          activeColor: c,
          onChanged: (v) => setState(() => _amount = v),
        ),
        const SizedBox(height: 12),
        _label('Expected Inflation Rate (% p.a.)', c),
        SliderWithInput(
          value: _inflationRate,
          min: 1,
          max: 20,
          divisions: 190,
          activeColor: c,
          decimalPlaces: 1,
          onChanged: (v) => setState(() => _inflationRate = v),
        ),
        const SizedBox(height: 12),
        _label('Time Horizon (years)', c),
        SliderWithInput(
          value: _years.toDouble(),
          min: 1,
          max: 50,
          divisions: 49,
          activeColor: c,
          onChanged: (v) => setState(() => _years = v.toInt()),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('After $_years years',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c)),
                const Divider(),
                ResultRow(
                  label: 'Future Cost of ₹${_amount.toStringAsFixed(0)}',
                  value: '₹${_futureValue.toStringAsFixed(0)}',
                  isBold: true,
                ),
                ResultRow(
                  label: 'Today\'s ₹${_amount.toStringAsFixed(0)} will be worth',
                  value: '₹${_presentValue.toStringAsFixed(0)}',
                ),
                ResultRow(
                  label: 'Purchasing Power Loss',
                  value: '${_purchasingPowerLoss.toStringAsFixed(1)}%',
                  color: Colors.red,
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
