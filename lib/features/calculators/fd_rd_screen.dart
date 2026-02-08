import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// Fixed Deposit / Recurring Deposit calculator.
class FdRdScreen extends StatefulWidget {
  final Color categoryColor;
  const FdRdScreen({super.key, required this.categoryColor});

  @override
  State<FdRdScreen> createState() => _FdRdScreenState();
}

class _FdRdScreenState extends State<FdRdScreen> {
  bool _isFD = true;
  double _principal = 100000;
  double _rate = 7.0;
  double _years = 5;
  final int _compounding = 4; // quarterly

  // ── FD calculation ─────────────────────────────────────
  double get _fdMaturity =>
      _principal * math.pow(1 + (_rate / 100) / _compounding, _compounding * _years);
  double get _fdInterest => _fdMaturity - _principal;

  // ── RD calculation (monthly deposits) ──────────────────
  double get _rdMonths => _years * 12;
  double get _rdTotalDeposit => _principal * _rdMonths;
  double get _rdMaturity {
    final r = _rate / 100 / _compounding;
    final n = _compounding * _years;
    // Approximate RD maturity using SIP-like formula
    double total = 0;
    for (int m = 0; m < _rdMonths; m++) {
      total += _principal * math.pow(1 + r, n - (m * _compounding / 12));
    }
    return total;
  }
  double get _rdInterest => _rdMaturity - _rdTotalDeposit;

  Map<String, String> get _exportData => _isFD
      ? {
          'Type': 'Fixed Deposit',
          'Principal': '₹${_principal.toStringAsFixed(0)}',
          'Rate': '${_rate.toStringAsFixed(2)}%',
          'Period': '${_years.toStringAsFixed(0)} years',
          'Interest': '₹${_fdInterest.toStringAsFixed(2)}',
          'Maturity': '₹${_fdMaturity.toStringAsFixed(2)}',
        }
      : {
          'Type': 'Recurring Deposit',
          'Monthly Deposit': '₹${_principal.toStringAsFixed(0)}',
          'Rate': '${_rate.toStringAsFixed(2)}%',
          'Period': '${_years.toStringAsFixed(0)} years',
          'Total Deposited': '₹${_rdTotalDeposit.toStringAsFixed(0)}',
          'Interest': '₹${_rdInterest.toStringAsFixed(2)}',
          'Maturity': '₹${_rdMaturity.toStringAsFixed(2)}',
        };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: _isFD ? 'FD Calculator' : 'RD Calculator',
      accentColor: c,
      infoText: _isFD
          ? 'Calculate Fixed Deposit maturity amount.'
          : 'Calculate Recurring Deposit maturity amount.',
      exportData: _exportData,
      children: [
        // FD / RD toggle
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Fixed Deposit')),
                ButtonSegment(value: false, label: Text('Recurring Deposit')),
              ],
              selected: {_isFD},
              onSelectionChanged: (s) => setState(() => _isFD = s.first),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SliderInput(
                  label: _isFD ? 'Principal Amount' : 'Monthly Deposit',
                  value: _principal,
                  min: 1000,
                  max: _isFD ? 10000000 : 500000,
                  suffix: '₹',
                  accentColor: c,
                  onChanged: (v) => setState(() => _principal = v),
                ),
                const SizedBox(height: 16),
                SliderInput(
                  label: 'Interest Rate (p.a.)',
                  value: _rate,
                  min: 1,
                  max: 15,
                  divisions: 140,
                  suffix: '%',
                  decimals: 2,
                  accentColor: c,
                  onChanged: (v) => setState(() => _rate = v),
                ),
                const SizedBox(height: 16),
                SliderInput(
                  label: 'Period',
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
        if (_isFD) _buildFDResult(c) else _buildRDResult(c),
      ],
    );
  }

  Widget _buildFDResult(Color c) {
    return Column(
      children: [
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Maturity Amount', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('₹${_fdMaturity.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold, color: c)),
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
                ResultRow.currency('Principal', _principal),
                ResultRow.currency('Interest', _fdInterest, color: Colors.green),
                const Divider(height: 20),
                ResultRow.currency('Maturity', _fdMaturity,
                    color: c, isBold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRDResult(Color c) {
    return Column(
      children: [
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Maturity Amount', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text('₹${_rdMaturity.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold, color: c)),
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
                ResultRow.currency('Total Deposited', _rdTotalDeposit),
                ResultRow.currency('Interest', _rdInterest, color: Colors.green),
                const Divider(height: 20),
                ResultRow.currency('Maturity', _rdMaturity,
                    color: c, isBold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
