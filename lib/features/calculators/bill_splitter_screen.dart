import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// Split bills among multiple people with individual item support.
class BillSplitterScreen extends StatefulWidget {
  final Color categoryColor;
  const BillSplitterScreen({super.key, required this.categoryColor});

  @override
  State<BillSplitterScreen> createState() => _BillSplitterScreenState();
}

class _BillSplitterScreenState extends State<BillSplitterScreen> {
  final _billController = TextEditingController();
  double _tipPercent = 10;
  int _people = 2;

  double get _bill => double.tryParse(_billController.text) ?? 0;
  double get _tipAmount => _bill * (_tipPercent / 100);
  double get _total => _bill + _tipAmount;
  double get _perPerson => _people > 0 ? _total / _people : 0;

  Map<String, String>? get _exportData {
    if (_bill <= 0) return null;
    return {
      'Bill Amount': '₹${_bill.toStringAsFixed(2)}',
      'Tip (${_tipPercent.toStringAsFixed(0)}%)':
          '₹${_tipAmount.toStringAsFixed(2)}',
      'Total': '₹${_total.toStringAsFixed(2)}',
      'People': '$_people',
      'Per Person': '₹${_perPerson.toStringAsFixed(2)}',
    };
  }

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Bill Splitter',
      accentColor: c,
      infoText: 'Split bills evenly among friends with optional tip.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _billController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Total Bill',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SliderInput(
                  label: 'Tip',
                  value: _tipPercent,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  suffix: '%',
                  accentColor: c,
                  onChanged: (v) => setState(() => _tipPercent = v),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('People',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: c)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed:
                              _people > 1 ? () => setState(() => _people--) : null,
                        ),
                        Text('$_people',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: c)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed:
                              _people < 50 ? () => setState(() => _people++) : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_bill > 0) ...[
          const SizedBox(height: 20),
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Per Person', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(
                    '₹${_perPerson.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: c),
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
                  ResultRow.currency('Bill', _bill),
                  ResultRow.currency('Tip', _tipAmount, color: Colors.green),
                  const Divider(height: 20),
                  ResultRow.currency('Total', _total,
                      color: c, isBold: true),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
