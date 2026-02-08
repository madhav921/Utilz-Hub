import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Basic income tax estimator (old & new regime – India).
class TaxEstimatorScreen extends StatefulWidget {
  final Color categoryColor;
  const TaxEstimatorScreen({super.key, required this.categoryColor});

  @override
  State<TaxEstimatorScreen> createState() => _TaxEstimatorScreenState();
}

class _TaxEstimatorScreenState extends State<TaxEstimatorScreen> {
  final _incomeCtrl = TextEditingController();
  int _regime = 0; // 0=new, 1=old

  double get _income => double.tryParse(_incomeCtrl.text) ?? 0;
  bool get _valid => _income > 0;

  double get _tax {
    if (!_valid) return 0;
    return _regime == 0 ? _newRegimeTax(_income) : _oldRegimeTax(_income);
  }

  double _newRegimeTax(double inc) {
    // FY 2025-26 new regime slabs
    final slabs = [
      [400000, 0.0],
      [400000, 0.05],
      [400000, 0.10],
      [400000, 0.15],
      [400000, 0.20],
      [double.infinity, 0.30],
    ];
    double tax = 0, remaining = inc;
    for (final s in slabs) {
      final slab = s[0];
      final rate = s[1];
      if (remaining <= 0) break;
      final taxable = remaining > slab ? slab : remaining;
      tax += taxable * rate;
      remaining -= taxable;
    }
    return tax;
  }

  double _oldRegimeTax(double inc) {
    // Old regime with standard deduction 50k
    final taxable = inc - 50000;
    if (taxable <= 250000) return 0;
    double tax = 0, remaining = taxable - 250000;
    if (remaining > 0) {
      final s1 = remaining > 250000 ? 250000.0 : remaining;
      tax += s1 * 0.05;
      remaining -= s1;
    }
    if (remaining > 0) {
      final s2 = remaining > 500000 ? 500000.0 : remaining;
      tax += s2 * 0.20;
      remaining -= s2;
    }
    if (remaining > 0) tax += remaining * 0.30;
    return tax;
  }

  double get _cess => _tax * 0.04;
  double get _totalTax => _tax + _cess;
  double get _effective => _valid ? (_totalTax / _income) * 100 : 0;

  Map<String, String> get _exportData => _valid
      ? {
          'Income': '₹${_income.toStringAsFixed(0)}',
          'Regime': _regime == 0 ? 'New' : 'Old',
          'Tax': '₹${_tax.toStringAsFixed(0)}',
          'Cess (4%)': '₹${_cess.toStringAsFixed(0)}',
          'Total Tax': '₹${_totalTax.toStringAsFixed(0)}',
          'Effective Rate': '${_effective.toStringAsFixed(1)}%',
        }
      : {};

  @override
  void dispose() {
    _incomeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Tax Estimator',
      accentColor: c,
      toolId: 'tax_estimator',
      categoryName: 'Business & Tax',
      infoText: 'Approximate tax for Indian income slabs',
      exportData: _exportData,
      children: [
        TextField(
          controller: _incomeCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Annual Income',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Center(
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('New Regime')),
              ButtonSegment(value: 1, label: Text('Old Regime')),
            ],
            selected: {_regime},
            onSelectionChanged: (v) => setState(() => _regime = v.first),
          ),
        ),
        const SizedBox(height: 20),
        if (_valid) ...[
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ResultRow(label: 'Tax', value: '₹${_tax.toStringAsFixed(0)}'),
                ResultRow(label: 'Health & Education Cess (4%)', value: '₹${_cess.toStringAsFixed(0)}'),
                const Divider(),
                ResultRow(label: 'Total Tax', value: '₹${_totalTax.toStringAsFixed(0)}', isBold: true),
                ResultRow(label: 'Effective Rate', value: '${_effective.toStringAsFixed(1)}%'),
                ResultRow(label: 'Post-Tax Income', value: '₹${(_income - _totalTax).toStringAsFixed(0)}'),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}
