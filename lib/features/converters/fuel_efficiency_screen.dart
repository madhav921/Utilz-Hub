import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Fuel Efficiency Converter: km/l ↔ l/100km ↔ mpg (US) ↔ mpg (UK).
class FuelEfficiencyScreen extends StatefulWidget {
  final Color categoryColor;
  const FuelEfficiencyScreen({super.key, required this.categoryColor});

  @override
  State<FuelEfficiencyScreen> createState() => _FuelEfficiencyScreenState();
}

class _FuelEfficiencyScreenState extends State<FuelEfficiencyScreen> {
  final _ctrl = TextEditingController();
  String _from = 'km/l';
  static const _units = ['km/l', 'l/100km', 'mpg (US)', 'mpg (UK)'];

  // Convert everything to km/l as base, then to all others
  double _toKmPerL(double v) {
    switch (_from) {
      case 'l/100km':
        return v == 0 ? 0 : 100 / v;
      case 'mpg (US)':
        return v * 0.425144;
      case 'mpg (UK)':
        return v * 0.354006;
      default:
        return v; // km/l
    }
  }

  Map<String, double> _convert() {
    final v = double.tryParse(_ctrl.text) ?? 0;
    final kmpl = _toKmPerL(v);
    return {
      'km/l': kmpl,
      'l/100km': kmpl == 0 ? 0 : 100 / kmpl,
      'mpg (US)': kmpl / 0.425144,
      'mpg (UK)': kmpl / 0.354006,
    };
  }

  Map<String, String> get _exportData {
    final r = _convert();
    return r.map((k, v) => MapEntry(k, v.toStringAsFixed(2)));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    final results = _convert();
    return CalculatorScaffold(
      title: 'Fuel Efficiency',
      accentColor: c,
      toolId: 'fuel_efficiency',
      categoryName: 'Unit Converters',
      infoText: '1 mpg (US) ≈ 0.425 km/l  •  1 mpg (UK) ≈ 0.354 km/l',
      exportData: _exportData,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _from,
          decoration: InputDecoration(
            labelText: 'Convert from',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: _units
              .map((u) => DropdownMenuItem(value: u, child: Text(u)))
              .toList(),
          onChanged: (v) => setState(() => _from = v!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Value',
            suffixText: _from,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: results.entries
                  .map((e) => ResultRow(
                        label: e.key,
                        value: e.value.toStringAsFixed(2),
                        isBold: e.key != _from,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
