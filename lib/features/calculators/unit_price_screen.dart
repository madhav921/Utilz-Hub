import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Compare unit prices of two products.
class UnitPriceScreen extends StatefulWidget {
  final Color categoryColor;
  const UnitPriceScreen({super.key, required this.categoryColor});

  @override
  State<UnitPriceScreen> createState() => _UnitPriceScreenState();
}

class _UnitPriceScreenState extends State<UnitPriceScreen> {
  final _priceA = TextEditingController();
  final _qtyA = TextEditingController();
  final _priceB = TextEditingController();
  final _qtyB = TextEditingController();

  double get _unitA {
    final p = double.tryParse(_priceA.text) ?? 0;
    final q = double.tryParse(_qtyA.text) ?? 0;
    return q > 0 ? p / q : 0;
  }

  double get _unitB {
    final p = double.tryParse(_priceB.text) ?? 0;
    final q = double.tryParse(_qtyB.text) ?? 0;
    return q > 0 ? p / q : 0;
  }

  String get _winner {
    if (_unitA == 0 || _unitB == 0) return '';
    if (_unitA < _unitB) return 'Product A is cheaper';
    if (_unitB < _unitA) return 'Product B is cheaper';
    return 'Both are the same price';
  }

  Map<String, String>? get _exportData {
    if (_unitA <= 0 && _unitB <= 0) return null;
    return {
      'Product A Price': '₹${_priceA.text}',
      'Product A Qty': _qtyA.text,
      'Unit Price A': '₹${_unitA.toStringAsFixed(2)}',
      'Product B Price': '₹${_priceB.text}',
      'Product B Qty': _qtyB.text,
      'Unit Price B': '₹${_unitB.toStringAsFixed(2)}',
      'Winner': _winner,
    };
  }

  @override
  void dispose() {
    _priceA.dispose();
    _qtyA.dispose();
    _priceB.dispose();
    _qtyB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Unit Price Compare',
      accentColor: c,
      infoText: 'Compare price per unit of two products.',
      exportData: _exportData,
      children: [
        _productCard('Product A', _priceA, _qtyA, _unitA, c),
        const SizedBox(height: 12),
        _productCard('Product B', _priceB, _qtyB, _unitB, Colors.orange),
        if (_unitA > 0 && _unitB > 0) ...[
          const SizedBox(height: 20),
          Card(
            color: Colors.green.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.green, size: 40),
                  const SizedBox(height: 8),
                  Text(_winner,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  const SizedBox(height: 4),
                  Text(
                    'Savings: ₹${(_unitA - _unitB).abs().toStringAsFixed(2)} per unit',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _productCard(String title, TextEditingController priceCtrl,
      TextEditingController qtyCtrl, double unitPrice, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Price (₹)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: qtyCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            if (unitPrice > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Unit price: ₹${unitPrice.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
