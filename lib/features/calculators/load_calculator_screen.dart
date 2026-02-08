import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Basic load / force calculator (Force = mass × g, stress, etc.).
class LoadCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const LoadCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<LoadCalculatorScreen> createState() => _LoadCalculatorScreenState();
}

class _LoadCalculatorScreenState extends State<LoadCalculatorScreen> {
  final _massCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  double get _mass => double.tryParse(_massCtrl.text) ?? 0;
  double get _area => double.tryParse(_areaCtrl.text) ?? 0; // cm²
  bool get _valid => _mass > 0;

  double get _forceN => _mass * 9.80665;
  double get _forceKN => _forceN / 1000;
  double get _forceLbf => _forceN * 0.224809;
  double get _stressMPa => _area > 0 ? _forceN / (_area * 1e-4) / 1e6 : 0;
  double get _stressPSI => _stressMPa * 145.038;

  Map<String, String> get _exportData => _valid
      ? {
          'Mass': '${_mass.toStringAsFixed(1)} kg',
          'Force': '${_forceN.toStringAsFixed(2)} N',
          'Force (kN)': _forceKN.toStringAsFixed(3),
          'Force (lbf)': _forceLbf.toStringAsFixed(2),
          if (_area > 0) 'Stress': '${_stressMPa.toStringAsFixed(2)} MPa',
        }
      : {};

  @override
  void dispose() { _massCtrl.dispose(); _areaCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Load Calculator',
      accentColor: c, toolId: 'load_calculator', categoryName: 'Engineering',
      infoText: 'Force = mass × g (9.81 m/s²)', exportData: _exportData,
      children: [
        TextField(controller: _massCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Mass', suffixText: 'kg', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _areaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Cross-section Area (optional)', suffixText: 'cm²', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            ResultRow(label: 'Force (N)', value: _forceN.toStringAsFixed(2), isBold: true),
            ResultRow(label: 'Force (kN)', value: _forceKN.toStringAsFixed(3)),
            ResultRow(label: 'Force (lbf)', value: _forceLbf.toStringAsFixed(2)),
            if (_area > 0) ...[const Divider(), ResultRow(label: 'Stress (MPa)', value: _stressMPa.toStringAsFixed(2), isBold: true), ResultRow(label: 'Stress (PSI)', value: _stressPSI.toStringAsFixed(2))],
          ]))),
      ],
    );
  }
}
