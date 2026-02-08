import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Unit Cost per Area Calculator (₹/sq.ft, ₹/sq.m, etc.).
class UnitCostAreaScreen extends StatefulWidget {
  final Color categoryColor;
  const UnitCostAreaScreen({super.key, required this.categoryColor});

  @override
  State<UnitCostAreaScreen> createState() => _UnitCostAreaScreenState();
}

class _UnitCostAreaScreenState extends State<UnitCostAreaScreen> {
  final _priceCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  String _areaUnit = 'sq.ft';

  static const _unitToSqFt = {
    'sq.ft': 1.0,
    'sq.m': 10.7639,
    'sq.yd': 9.0,
    'acre': 43560.0,
    'hectare': 107639.0,
  };

  Map<String, double> _calculate() {
    final price = double.tryParse(_priceCtrl.text);
    final area = double.tryParse(_areaCtrl.text);
    if (price == null || area == null || area == 0) return {};

    final areaInSqFt = area * (_unitToSqFt[_areaUnit] ?? 1);
    final costPerSqFt = price / areaInSqFt;

    return {
      for (final entry in _unitToSqFt.entries)
        entry.key: costPerSqFt * entry.value,
    };
  }

  Map<String, String> get _exportData {
    final r = _calculate();
    if (r.isEmpty) return {};
    return r.map((k, v) => MapEntry('Per $k', '₹${v.toStringAsFixed(2)}'));
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    final results = _calculate();

    return CalculatorScaffold(
      title: 'Cost per Area',
      accentColor: c,
      toolId: 'unit_cost_area',
      categoryName: 'Real Estate & Vehicle',
      infoText:
          'Calculate price per unit area across different measurement units.',
      exportData: _exportData,
      children: [
        TextField(
          controller: _priceCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Total Price',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _areaCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Total Area',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _areaUnit,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: _unitToSqFt.keys
                    .map(
                        (u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setState(() => _areaUnit = v!),
              ),
            ),
          ],
        ),
        if (results.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cost Breakdown',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: c)),
                  const Divider(),
                  ...results.entries.map((e) => ResultRow(
                        label: 'Per ${e.key}',
                        value: '₹${e.value.toStringAsFixed(2)}',
                        isBold: e.key == _areaUnit,
                      )),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
