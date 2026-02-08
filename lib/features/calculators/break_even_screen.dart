import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Break-even analysis calculator.
class BreakEvenScreen extends StatefulWidget {
  final Color categoryColor;
  const BreakEvenScreen({super.key, required this.categoryColor});

  @override
  State<BreakEvenScreen> createState() => _BreakEvenScreenState();
}

class _BreakEvenScreenState extends State<BreakEvenScreen> {
  final _fixedCostController = TextEditingController();
  final _variableCostController = TextEditingController();
  final _priceController = TextEditingController();

  double get _fixedCost => double.tryParse(_fixedCostController.text) ?? 0;
  double get _variableCost =>
      double.tryParse(_variableCostController.text) ?? 0;
  double get _price => double.tryParse(_priceController.text) ?? 0;
  double get _contribution => _price - _variableCost;
  double get _breakEvenUnits =>
      _contribution > 0 ? _fixedCost / _contribution : 0;
  double get _breakEvenRevenue => _breakEvenUnits * _price;

  Map<String, String>? get _exportData {
    if (_fixedCost <= 0 || _price <= 0) return null;
    return {
      'Fixed Costs': '₹${_fixedCost.toStringAsFixed(2)}',
      'Variable Cost / Unit': '₹${_variableCost.toStringAsFixed(2)}',
      'Selling Price / Unit': '₹${_price.toStringAsFixed(2)}',
      'Contribution / Unit': '₹${_contribution.toStringAsFixed(2)}',
      'Break-Even Units': _breakEvenUnits.toStringAsFixed(0),
      'Break-Even Revenue': '₹${_breakEvenRevenue.toStringAsFixed(2)}',
    };
  }

  @override
  void dispose() {
    _fixedCostController.dispose();
    _variableCostController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Break-Even Analysis',
      accentColor: c,
      infoText:
          'Find the number of units you need to sell to cover all costs.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field(_fixedCostController, 'Total Fixed Costs',
                    Icons.apartment),
                const SizedBox(height: 16),
                _field(_variableCostController, 'Variable Cost per Unit',
                    Icons.inventory_2_outlined),
                const SizedBox(height: 16),
                _field(
                    _priceController, 'Selling Price per Unit', Icons.sell),
              ],
            ),
          ),
        ),
        if (_fixedCost > 0 && _price > 0 && _contribution > 0) ...[
          const SizedBox(height: 20),
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Break-Even Point',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(
                    '${_breakEvenUnits.ceil()} units',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: c),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${_breakEvenRevenue.toStringAsFixed(2)} revenue',
                    style: TextStyle(fontSize: 16, color: c),
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
                  ResultRow.currency('Fixed Costs', _fixedCost),
                  ResultRow.currency('Variable / Unit', _variableCost),
                  ResultRow.currency('Price / Unit', _price),
                  const Divider(height: 20),
                  ResultRow.currency('Contribution / Unit', _contribution,
                      color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _field(
      TextEditingController ctrl, String label, IconData icon) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}
