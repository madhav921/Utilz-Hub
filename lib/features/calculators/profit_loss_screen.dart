import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Profit & Loss calculator.
class ProfitLossScreen extends StatefulWidget {
  final Color categoryColor;
  const ProfitLossScreen({super.key, required this.categoryColor});

  @override
  State<ProfitLossScreen> createState() => _ProfitLossScreenState();
}

class _ProfitLossScreenState extends State<ProfitLossScreen> {
  final _costController = TextEditingController();
  final _revenueController = TextEditingController();

  double get _cost => double.tryParse(_costController.text) ?? 0;
  double get _revenue => double.tryParse(_revenueController.text) ?? 0;
  double get _profit => _revenue - _cost;
  double get _marginPercent => _revenue > 0 ? (_profit / _revenue) * 100 : 0;
  bool get _isProfit => _profit >= 0;

  Map<String, String>? get _exportData {
    if (_cost <= 0 && _revenue <= 0) return null;
    return {
      'Cost Price': '₹${_cost.toStringAsFixed(2)}',
      'Revenue': '₹${_revenue.toStringAsFixed(2)}',
      _isProfit ? 'Profit' : 'Loss':
          '₹${_profit.abs().toStringAsFixed(2)}',
      'Margin': '${_marginPercent.toStringAsFixed(2)}%',
    };
  }

  @override
  void dispose() {
    _costController.dispose();
    _revenueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Profit & Loss',
      accentColor: c,
      infoText: 'Calculate profit, loss, and margin percentage.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _costController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Cost Price',
                    prefixIcon: const Icon(Icons.shopping_bag_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _revenueController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Selling Price / Revenue',
                    prefixIcon: const Icon(Icons.point_of_sale),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        ),
        if (_cost > 0 || _revenue > 0) ...[
          const SizedBox(height: 20),
          Card(
            color: (_isProfit ? Colors.green : Colors.red).withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(_isProfit ? 'Profit' : 'Loss',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(
                    '₹${_profit.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: _isProfit ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_marginPercent.toStringAsFixed(2)}% margin',
                    style: TextStyle(
                      fontSize: 16,
                      color: _isProfit ? Colors.green : Colors.red,
                    ),
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
                  ResultRow.currency('Cost', _cost),
                  ResultRow.currency('Revenue', _revenue),
                  const Divider(height: 20),
                  ResultRow.currency(
                    _isProfit ? 'Profit' : 'Loss',
                    _profit.abs(),
                    color: _isProfit ? Colors.green : Colors.red,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
