import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// Mortgage / home loan calculator with amortization summary.
class MortgageScreen extends StatefulWidget {
  final Color categoryColor;
  const MortgageScreen({super.key, required this.categoryColor});

  @override
  State<MortgageScreen> createState() => _MortgageScreenState();
}

class _MortgageScreenState extends State<MortgageScreen> {
  double _homePrice = 5000000;
  double _downPayment = 20; // percent
  double _rate = 8.5;
  double _years = 20;

  double get _loanAmount => _homePrice * (1 - _downPayment / 100);
  double get _months => _years * 12;
  double get _monthlyRate => _rate / 100 / 12;

  double get _emi {
    if (_monthlyRate == 0) return _loanAmount / _months;
    final r = _monthlyRate;
    final n = _months;
    return _loanAmount * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
  }

  double get _totalPayment => _emi * _months;
  double get _totalInterest => _totalPayment - _loanAmount;

  Map<String, String> get _exportData => {
        'Home Price': '₹${_homePrice.toStringAsFixed(0)}',
        'Down Payment': '${_downPayment.toStringAsFixed(0)}%  (₹${(_homePrice * _downPayment / 100).toStringAsFixed(0)})',
        'Loan Amount': '₹${_loanAmount.toStringAsFixed(0)}',
        'Interest Rate': '${_rate.toStringAsFixed(2)}% p.a.',
        'Tenure': '${_years.toStringAsFixed(0)} years',
        'Monthly EMI': '₹${_emi.toStringAsFixed(0)}',
        'Total Interest': '₹${_totalInterest.toStringAsFixed(0)}',
        'Total Payment': '₹${_totalPayment.toStringAsFixed(0)}',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Mortgage Calculator',
      accentColor: c,
      infoText: 'Calculate home loan EMI with down payment.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SliderInput(
                  label: 'Home Price',
                  value: _homePrice,
                  min: 500000,
                  max: 50000000,
                  suffix: '₹',
                  accentColor: c,
                  onChanged: (v) => setState(() => _homePrice = v),
                ),
                const SizedBox(height: 16),
                SliderInput(
                  label: 'Down Payment',
                  value: _downPayment,
                  min: 0,
                  max: 90,
                  divisions: 90,
                  suffix: '%',
                  accentColor: c,
                  onChanged: (v) => setState(() => _downPayment = v),
                ),
                const SizedBox(height: 16),
                SliderInput(
                  label: 'Interest Rate',
                  value: _rate,
                  min: 1,
                  max: 20,
                  divisions: 190,
                  suffix: '%',
                  decimals: 2,
                  accentColor: c,
                  onChanged: (v) => setState(() => _rate = v),
                ),
                const SizedBox(height: 16),
                SliderInput(
                  label: 'Loan Tenure',
                  value: _years,
                  min: 1,
                  max: 30,
                  divisions: 29,
                  suffix: 'years',
                  accentColor: c,
                  onChanged: (v) => setState(() => _years = v),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Monthly EMI', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('₹${_emi.toStringAsFixed(0)}',
                    style: TextStyle(
                        fontSize: 42, fontWeight: FontWeight.bold, color: c)),
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
                ResultRow.currency('Loan Amount', _loanAmount),
                ResultRow.currency('Total Interest', _totalInterest,
                    color: Colors.orange),
                const Divider(height: 20),
                ResultRow.currency('Total Payment', _totalPayment,
                    color: c, isBold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
