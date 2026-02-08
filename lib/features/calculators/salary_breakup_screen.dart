import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Salary breakup calculator (CTC → in-hand).
class SalaryBreakupScreen extends StatefulWidget {
  final Color categoryColor;
  const SalaryBreakupScreen({super.key, required this.categoryColor});

  @override
  State<SalaryBreakupScreen> createState() => _SalaryBreakupScreenState();
}

class _SalaryBreakupScreenState extends State<SalaryBreakupScreen> {
  final _ctcCtrl = TextEditingController();

  double get _ctc => double.tryParse(_ctcCtrl.text) ?? 0;
  bool get _valid => _ctc > 0;

  // Standard India-style breakup (customizable)
  double get _basic => _ctc * 0.40;
  double get _hra => _basic * 0.50;
  double get _da => _basic * 0.10;
  double get _special => _ctc - _basic - _hra - _da - _pf - _insurance;
  double get _pf => _basic * 0.12;
  double get _insurance => 1800; // annual medical insurance
  double get _professionalTax => 2400; // annual
  double get _totalDeductions => _pf + _insurance + _professionalTax;
  double get _annual => _ctc - _totalDeductions;
  double get _monthly => _annual / 12;

  Map<String, String> get _exportData => _valid
      ? {
          'CTC': '₹${_ctc.toStringAsFixed(0)}',
          'Basic': '₹${_basic.toStringAsFixed(0)}',
          'HRA': '₹${_hra.toStringAsFixed(0)}',
          'PF (12%)': '₹${_pf.toStringAsFixed(0)}',
          'In-Hand (annual)': '₹${_annual.toStringAsFixed(0)}',
          'In-Hand (monthly)': '₹${_monthly.toStringAsFixed(0)}',
        }
      : {};

  @override
  void dispose() {
    _ctcCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Salary Breakup',
      accentColor: c,
      toolId: 'salary_breakup',
      categoryName: 'Business & Tax',
      infoText: 'Enter annual CTC for approximate breakup',
      exportData: _exportData,
      children: [
        TextField(
          controller: _ctcCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Annual CTC',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        if (_valid) ...[
          _section('Earnings', [
            ResultRow(label: 'Basic (40%)', value: '₹${_basic.toStringAsFixed(0)}'),
            ResultRow(label: 'HRA (50% of Basic)', value: '₹${_hra.toStringAsFixed(0)}'),
            ResultRow(label: 'DA (10% of Basic)', value: '₹${_da.toStringAsFixed(0)}'),
            ResultRow(label: 'Special Allowance', value: '₹${_special.toStringAsFixed(0)}'),
          ], c),
          const SizedBox(height: 12),
          _section('Deductions', [
            ResultRow(label: 'PF (12% of Basic)', value: '₹${_pf.toStringAsFixed(0)}'),
            ResultRow(label: 'Medical Insurance', value: '₹${_insurance.toStringAsFixed(0)}'),
            ResultRow(label: 'Professional Tax', value: '₹${_professionalTax.toStringAsFixed(0)}'),
            ResultRow(label: 'Total Deductions', value: '₹${_totalDeductions.toStringAsFixed(0)}', isBold: true),
          ], Colors.red),
          const SizedBox(height: 12),
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow(label: 'In-Hand (Annual)', value: '₹${_annual.toStringAsFixed(0)}', isBold: true),
                  const Divider(),
                  ResultRow(label: 'In-Hand (Monthly)', value: '₹${_monthly.toStringAsFixed(0)}', isBold: true),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _section(String title, List<Widget> rows, Color accent) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: accent)),
            const Divider(),
            ...rows,
          ],
        ),
      ),
    );
  }
}
