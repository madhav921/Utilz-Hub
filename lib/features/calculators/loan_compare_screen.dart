import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';


/// Compare two loan options side by side.
class LoanCompareScreen extends StatefulWidget {
  final Color categoryColor;
  const LoanCompareScreen({super.key, required this.categoryColor});

  @override
  State<LoanCompareScreen> createState() => _LoanCompareScreenState();
}

class _LoanCompareScreenState extends State<LoanCompareScreen> {
  // Loan A
  double _principalA = 1000000;
  double _rateA = 8.5;
  double _yearsA = 20;

  // Loan B
  double _principalB = 1000000;
  double _rateB = 9.5;
  double _yearsB = 15;

  _LoanResult _calc(double principal, double rate, double years) {
    final months = years * 12;
    final r = rate / 100 / 12;
    final emi = r == 0
        ? principal / months
        : principal * r * math.pow(1 + r, months) / (math.pow(1 + r, months) - 1);
    final total = emi * months;
    return _LoanResult(emi: emi, total: total, interest: total - principal);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    final a = _calc(_principalA, _rateA, _yearsA);
    final b = _calc(_principalB, _rateB, _yearsB);

    return CalculatorScaffold(
      title: 'Loan Compare',
      accentColor: c,
      infoText: 'Compare two loan options to find the better deal.',
      exportData: {
        '── Loan A ──': '',
        'Principal A': '₹${_principalA.toStringAsFixed(0)}',
        'Rate A': '${_rateA.toStringAsFixed(2)}%',
        'Tenure A': '${_yearsA.toStringAsFixed(0)} yrs',
        'EMI A': '₹${a.emi.toStringAsFixed(0)}',
        'Total Interest A': '₹${a.interest.toStringAsFixed(0)}',
        '── Loan B ──': '',
        'Principal B': '₹${_principalB.toStringAsFixed(0)}',
        'Rate B': '${_rateB.toStringAsFixed(2)}%',
        'Tenure B': '${_yearsB.toStringAsFixed(0)} yrs',
        'EMI B': '₹${b.emi.toStringAsFixed(0)}',
        'Total Interest B': '₹${b.interest.toStringAsFixed(0)}',
      },
      children: [
        _loanCard('Loan A', _principalA, _rateA, _yearsA, c.withValues(alpha: 0.9),
            (p, r, y) {
          setState(() {
            _principalA = p;
            _rateA = r;
            _yearsA = y;
          });
        }),
        const SizedBox(height: 12),
        _loanCard('Loan B', _principalB, _rateB, _yearsB, Colors.orange,
            (p, r, y) {
          setState(() {
            _principalB = p;
            _rateB = r;
            _yearsB = y;
          });
        }),
        const SizedBox(height: 20),
        _comparisonCard(a, b, c),
      ],
    );
  }

  Widget _loanCard(
    String title,
    double principal,
    double rate,
    double years,
    Color color,
    void Function(double, double, double) onChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 12),
            SliderInput(
              label: 'Principal',
              value: principal,
              min: 100000,
              max: 10000000,
              suffix: '₹',
              accentColor: color,
              onChanged: (v) => onChanged(v, rate, years),
            ),
            SliderInput(
              label: 'Rate',
              value: rate,
              min: 1,
              max: 20,
              divisions: 190,
              suffix: '%',
              decimals: 2,
              accentColor: color,
              onChanged: (v) => onChanged(principal, v, years),
            ),
            SliderInput(
              label: 'Tenure',
              value: years,
              min: 1,
              max: 30,
              divisions: 29,
              suffix: 'yrs',
              accentColor: color,
              onChanged: (v) => onChanged(principal, rate, v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _comparisonCard(_LoanResult a, _LoanResult b, Color c) {
    final better = a.interest < b.interest ? 'Loan A' : 'Loan B';
    final savings = (a.interest - b.interest).abs();

    return Card(
      color: c.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c)),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(child: _columnResult('Loan A', a, c)),
                Container(width: 1, height: 100, color: Colors.grey.withValues(alpha: 0.3)),
                Expanded(child: _columnResult('Loan B', b, Colors.orange)),
              ],
            ),
            const Divider(height: 20),
            Text(
              '$better saves ₹${savings.toStringAsFixed(0)} in interest',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _columnResult(String title, _LoanResult r, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          Text('EMI: ₹${r.emi.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
          Text('Interest: ₹${r.interest.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
          Text('Total: ₹${r.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _LoanResult {
  final double emi;
  final double total;
  final double interest;
  const _LoanResult({required this.emi, required this.total, required this.interest});
}
