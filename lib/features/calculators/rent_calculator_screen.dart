import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Rent affordability & comparison calculator.
class RentCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const RentCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<RentCalculatorScreen> createState() => _RentCalculatorScreenState();
}

class _RentCalculatorScreenState extends State<RentCalculatorScreen> {
  final _rentCtrl = TextEditingController();
  final _depositCtrl = TextEditingController();
  final _maintenanceCtrl = TextEditingController();
  int _months = 12; // lease period

  double get _rent => double.tryParse(_rentCtrl.text) ?? 0;
  double get _deposit => double.tryParse(_depositCtrl.text) ?? 0;
  double get _maintenance => double.tryParse(_maintenanceCtrl.text) ?? 0;
  bool get _valid => _rent > 0;

  double get _monthlyTotal => _rent + _maintenance;
  double get _annualRent => _monthlyTotal * 12;
  double get _leaseTotal => _monthlyTotal * _months + _deposit;
  double get _depositOpportunityCost => _deposit * 0.07 * (_months / 12); // 7% assumed

  Map<String, String> get _exportData => _valid
      ? {
          'Monthly Rent': '₹${_rent.toStringAsFixed(0)}',
          'Maintenance': '₹${_maintenance.toStringAsFixed(0)}',
          'Monthly Total': '₹${_monthlyTotal.toStringAsFixed(0)}',
          'Deposit': '₹${_deposit.toStringAsFixed(0)}',
          'Lease Period': '$_months months',
          'Annual Rent': '₹${_annualRent.toStringAsFixed(0)}',
          'Total Lease Cost': '₹${_leaseTotal.toStringAsFixed(0)}',
          'Deposit Opp. Cost': '₹${_depositOpportunityCost.toStringAsFixed(0)}',
        }
      : {};

  @override
  void dispose() {
    _rentCtrl.dispose();
    _depositCtrl.dispose();
    _maintenanceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Rent Calculator',
      accentColor: c,
      toolId: 'rent_calculator',
      categoryName: 'Real Estate & Vehicle',
      infoText: 'Compare rental costs & total lease outflow',
      exportData: _exportData,
      children: [
        TextField(
          controller: _rentCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Monthly Rent',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _maintenanceCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Monthly Maintenance',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _depositCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Security Deposit',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _months,
          decoration: InputDecoration(
            labelText: 'Lease Period',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [6, 11, 12, 24, 36, 48, 60]
              .map((m) => DropdownMenuItem(value: m, child: Text('$m months')))
              .toList(),
          onChanged: (v) => setState(() => _months = v!),
        ),
        const SizedBox(height: 20),
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              ResultRow(label: 'Monthly Total', value: '₹${_monthlyTotal.toStringAsFixed(0)}'),
              ResultRow(label: 'Annual Rent', value: '₹${_annualRent.toStringAsFixed(0)}'),
              ResultRow(label: 'Deposit', value: '₹${_deposit.toStringAsFixed(0)}'),
              ResultRow(label: 'Deposit Opp. Cost (@7%)', value: '₹${_depositOpportunityCost.toStringAsFixed(0)}'),
              const Divider(),
              ResultRow(label: 'Total Lease Cost', value: '₹${_leaseTotal.toStringAsFixed(0)}', isBold: true),
            ]),
          ),
        ),
      ],
    );
  }
}
