import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Angle converter: degree ↔ radian ↔ gradian ↔ turn.
class AngleConverterScreen extends StatefulWidget {
  final Color categoryColor;
  const AngleConverterScreen({super.key, required this.categoryColor});

  @override
  State<AngleConverterScreen> createState() => _AngleConverterScreenState();
}

class _AngleConverterScreenState extends State<AngleConverterScreen> {
  final _ctrl = TextEditingController();
  String _from = 'Degree';
  static const _units = ['Degree', 'Radian', 'Gradian', 'Turn'];

  double _toRadians(double v) {
    switch (_from) {
      case 'Radian': return v;
      case 'Gradian': return v * pi / 200;
      case 'Turn': return v * 2 * pi;
      default: return v * pi / 180;
    }
  }

  Map<String, double> _convert() {
    final v = double.tryParse(_ctrl.text) ?? 0;
    final rad = _toRadians(v);
    return {
      'Degree': rad * 180 / pi,
      'Radian': rad,
      'Gradian': rad * 200 / pi,
      'Turn': rad / (2 * pi),
    };
  }

  Map<String, String> get _exportData {
    final r = _convert();
    return r.map((k, v) => MapEntry(k, v.toStringAsFixed(6)));
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
      title: 'Angle Converter',
      accentColor: c,
      toolId: 'angle_converter',
      categoryName: 'Unit Converters',
      infoText: '360° = 2π rad = 400 grad = 1 turn',
      exportData: _exportData,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _from,
          decoration: InputDecoration(
            labelText: 'Convert from',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
          onChanged: (v) => setState(() => _from = v!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: InputDecoration(
            labelText: 'Value',
            suffixText: _from == 'Degree' ? '°' : _from == 'Radian' ? 'rad' : _from,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: results.entries.map((e) =>
                ResultRow(label: e.key, value: e.value.toStringAsFixed(6), isBold: e.key != _from),
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
