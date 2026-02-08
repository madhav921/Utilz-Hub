import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Markup & Margin calculator — shows the difference between the two.
class MarkupMarginScreen extends StatefulWidget {
  final Color categoryColor;
  const MarkupMarginScreen({super.key, required this.categoryColor});

  @override
  State<MarkupMarginScreen> createState() => _MarkupMarginScreenState();
}

class _MarkupMarginScreenState extends State<MarkupMarginScreen> {
  final _costController = TextEditingController();
  final _sellingController = TextEditingController();

  double get _cost => double.tryParse(_costController.text) ?? 0;
  double get _selling => double.tryParse(_sellingController.text) ?? 0;
  double get _profit => _selling - _cost;
  double get _markup => _cost > 0 ? (_profit / _cost) * 100 : 0;
  double get _margin => _selling > 0 ? (_profit / _selling) * 100 : 0;

  Map<String, String>? get _exportData {
    if (_cost <= 0 || _selling <= 0) return null;
    return {
      'Cost Price': '₹${_cost.toStringAsFixed(2)}',
      'Selling Price': '₹${_selling.toStringAsFixed(2)}',
      'Profit': '₹${_profit.toStringAsFixed(2)}',
      'Markup': '${_markup.toStringAsFixed(2)}%',
      'Margin': '${_margin.toStringAsFixed(2)}%',
    };
  }

  @override
  void dispose() {
    _costController.dispose();
    _sellingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Markup & Margin',
      accentColor: c,
      infoText:
          'Markup = profit ÷ cost × 100\nMargin = profit ÷ selling price × 100',
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
                  controller: _sellingController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Selling Price',
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
        if (_cost > 0 && _selling > 0) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Markup',
                            style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('${_markup.toStringAsFixed(2)}%',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  color: c.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Margin',
                            style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('${_margin.toStringAsFixed(2)}%',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: c)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow.currency('Cost', _cost),
                  ResultRow.currency('Selling', _selling),
                  ResultRow.currency('Profit', _profit, color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
