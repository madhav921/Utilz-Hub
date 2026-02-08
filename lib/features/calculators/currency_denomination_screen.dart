import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Currency Denomination Splitter.
/// Splits a given amount into the fewest possible notes and coins.
class CurrencyDenominationScreen extends StatefulWidget {
  final Color categoryColor;
  const CurrencyDenominationScreen({super.key, required this.categoryColor});

  @override
  State<CurrencyDenominationScreen> createState() =>
      _CurrencyDenominationScreenState();
}

class _CurrencyDenominationScreenState
    extends State<CurrencyDenominationScreen> {
  final _ctrl = TextEditingController();

  String _currency = 'INR';
  static const _currencies = {
    'INR': [2000, 500, 200, 100, 50, 20, 10, 5, 2, 1],
    'USD': [100, 50, 20, 10, 5, 2, 1],
    'EUR': [500, 200, 100, 50, 20, 10, 5, 2, 1],
    'GBP': [50, 20, 10, 5, 2, 1],
  };

  static const _symbols = {
    'INR': '₹',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
  };

  Map<int, int> _split() {
    final amount = int.tryParse(_ctrl.text) ?? 0;
    final denoms = _currencies[_currency]!;
    final result = <int, int>{};
    var remaining = amount;
    for (final d in denoms) {
      if (remaining >= d) {
        result[d] = remaining ~/ d;
        remaining %= d;
      }
    }
    return result;
  }

  Map<String, String> get _exportData {
    final s = _split();
    if (s.isEmpty) return {};
    final sym = _symbols[_currency]!;
    return s.map(
        (k, v) => MapEntry('$sym$k', '$v note${v > 1 ? 's' : ''}'));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    final result = _split();
    final sym = _symbols[_currency]!;

    return CalculatorScaffold(
      title: 'Cash Denomination',
      accentColor: c,
      toolId: 'currency_denomination',
      categoryName: 'Finance & Loans',
      infoText:
          'Enter an amount to split into the fewest notes/coins.',
      exportData: _exportData,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _currency,
          decoration: InputDecoration(
            labelText: 'Currency',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: _currencies.keys
              .map((k) => DropdownMenuItem(value: k, child: Text(k)))
              .toList(),
          onChanged: (v) => setState(() => _currency = v!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            prefixText: '$sym ',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (result.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Denomination Split',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: c)),
                  const Divider(),
                  ...result.entries.map((e) => ResultRow(
                        label: '$sym${e.key}',
                        value: '× ${e.value}',
                        isBold: e.key >= 500,
                      )),
                  const Divider(),
                  ResultRow(
                    label: 'Total Notes/Coins',
                    value:
                        '${result.values.fold<int>(0, (a, b) => a + b)}',
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
