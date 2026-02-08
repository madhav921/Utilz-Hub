import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Material quantity estimator (bricks, cement, sand, etc.).
class MaterialEstimatorScreen extends StatefulWidget {
  final Color categoryColor;
  const MaterialEstimatorScreen({super.key, required this.categoryColor});

  @override
  State<MaterialEstimatorScreen> createState() => _MaterialEstimatorScreenState();
}

class _MaterialEstimatorScreenState extends State<MaterialEstimatorScreen> {
  final _areaCtrl = TextEditingController();
  int _type = 0;
  double _wastage = 5;

  static const _types = ['Bricks', 'Cement Bags', 'Sand (cft)', 'Tiles', 'Paint (L)'];

  double get _area => double.tryParse(_areaCtrl.text) ?? 0;
  bool get _valid => _area > 0;

  double get _baseQty {
    switch (_type) {
      case 0: return _area * 50;     // ~50 bricks per m² for 9" wall
      case 1: return _area * 0.5;    // ~0.5 cement bags per m²
      case 2: return _area * 1.25;   // ~1.25 cft sand per m²
      case 3: return _area * 11;     // ~11 tiles (12"×12") per m²
      case 4: return _area * 0.14;   // ~0.14 L per m² per coat
      default: return 0;
    }
  }

  double get _withWastage => _baseQty * (1 + _wastage / 100);

  Map<String, String> get _exportData => _valid
      ? {
          'Area': '${_area.toStringAsFixed(1)} m²',
          'Material': _types[_type],
          'Base Qty': _baseQty.toStringAsFixed(1),
          'Wastage': '${_wastage.toStringAsFixed(0)}%',
          'Total Required': _withWastage.toStringAsFixed(0),
        }
      : {};

  @override
  void dispose() { _areaCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Material Estimator',
      accentColor: c, toolId: 'material_estimator', categoryName: 'Engineering',
      infoText: 'Estimate material quantity from area', exportData: _exportData,
      children: [
        TextField(controller: _areaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Wall / Floor Area', suffixText: 'm²', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _type,
          decoration: InputDecoration(labelText: 'Material Type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          items: List.generate(_types.length, (i) => DropdownMenuItem(value: i, child: Text(_types[i]))),
          onChanged: (v) => setState(() => _type = v!),
        ),
        SliderInput(label: 'Wastage', value: _wastage, min: 0, max: 25, divisions: 25, suffix: '%', accentColor: c, decimals: 0, onChanged: (v) => setState(() => _wastage = v)),
        const SizedBox(height: 16),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            ResultRow(label: 'Base Quantity', value: _baseQty.toStringAsFixed(1)),
            ResultRow(label: 'Wastage (+${_wastage.toStringAsFixed(0)}%)', value: (_withWastage - _baseQty).toStringAsFixed(1)),
            const Divider(),
            ResultRow(label: 'Total Required', value: _withWastage.toStringAsFixed(0), isBold: true),
          ]))),
      ],
    );
  }
}
