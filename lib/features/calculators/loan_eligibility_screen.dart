import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_with_input.dart';

/// Loan Eligibility Calculator — how much loan you qualify for.
class LoanEligibilityScreen extends StatefulWidget {
  final Color categoryColor;
  const LoanEligibilityScreen({super.key, required this.categoryColor});

  @override
  State<LoanEligibilityScreen> createState() =>
      _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState extends State<LoanEligibilityScreen> {
  double _income = 50000;
  double _existingEmi = 0;
  double _rate = 9.0;
  int _tenureMonths = 240;
  final double _emiFraction = 0.5; // banks allow up to 50% of income as EMI

  double get _maxEmi => (_income - _existingEmi) * _emiFraction;

  double get _eligibleAmount {
    final mr = _rate / 12 / 100;
    if (mr == 0 || _maxEmi <= 0) return 0;
    return _maxEmi *
        (math.pow(1 + mr, _tenureMonths) - 1) /
        (mr * math.pow(1 + mr, _tenureMonths));
  }

  Map<String, String> get _exportData => {
        'Monthly Income': '₹${_income.toStringAsFixed(0)}',
        'Existing EMIs': '₹${_existingEmi.toStringAsFixed(0)}',
        'Max EMI (${(_emiFraction * 100).toInt()}%)':
            '₹${_maxEmi.toStringAsFixed(0)}',
        'Interest Rate': '${_rate.toStringAsFixed(1)}%',
        'Tenure': '${(_tenureMonths / 12).toStringAsFixed(0)} years',
        'Eligible Loan': '₹${_eligibleAmount.toStringAsFixed(0)}',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Loan Eligibility',
      accentColor: c,
      toolId: 'loan_eligibility',
      categoryName: 'Real Estate & Vehicle',
      infoText:
          'Estimate the maximum loan amount you can qualify for based on income.',
      exportData: _exportData,
      children: [
        _label('Monthly Income (₹)', c),
        SliderWithInput(
          value: _income,
          min: 10000,
          max: 500000,
          divisions: 98,
          activeColor: c,
          onChanged: (v) => setState(() => _income = v),
        ),
        const SizedBox(height: 12),
        _label('Existing EMIs (₹/month)', c),
        SliderWithInput(
          value: _existingEmi,
          min: 0,
          max: _income * 0.8,
          divisions: 80,
          activeColor: c,
          onChanged: (v) => setState(() => _existingEmi = v),
        ),
        const SizedBox(height: 12),
        _label('Interest Rate (% p.a.)', c),
        SliderWithInput(
          value: _rate,
          min: 5,
          max: 20,
          divisions: 150,
          activeColor: c,
          decimalPlaces: 1,
          onChanged: (v) => setState(() => _rate = v),
        ),
        const SizedBox(height: 12),
        _label('Tenure (years)', c),
        SliderWithInput(
          value: _tenureMonths.toDouble(),
          min: 12,
          max: 360,
          divisions: 29,
          activeColor: c,
          onChanged: (v) =>
              setState(() => _tenureMonths = (v / 12).round() * 12),
        ),
        const SizedBox(height: 20),
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('You may be eligible for',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('₹',
                        style: TextStyle(fontSize: 24)),
                    Text(
                      _eligibleAmount.toStringAsFixed(0),
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: c),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ResultRow(
                  label: 'Max EMI Allowed',
                  value: '₹${_maxEmi.toStringAsFixed(0)} / month',
                ),
                ResultRow(
                  label: 'Tenure',
                  value:
                      '${(_tenureMonths / 12).toStringAsFixed(0)} years',
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
