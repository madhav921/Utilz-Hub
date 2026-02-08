import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Efficiency calculator (input vs output, thermal, electrical).
class EfficiencyCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const EfficiencyCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<EfficiencyCalculatorScreen> createState() => _EfficiencyCalculatorScreenState();
}

class _EfficiencyCalculatorScreenState extends State<EfficiencyCalculatorScreen> {
  final _inputCtrl = TextEditingController();
  final _outputCtrl = TextEditingController();

  double get _input => double.tryParse(_inputCtrl.text) ?? 0;
  double get _output => double.tryParse(_outputCtrl.text) ?? 0;
  bool get _valid => _input > 0 && _output >= 0;
  double get _efficiency => _input > 0 ? (_output / _input) * 100 : 0;
  double get _loss => _input - _output;
  double get _lossPct => 100 - _efficiency;

  Map<String, String> get _exportData => _valid
      ? {'Input': _input.toStringAsFixed(2), 'Output': _output.toStringAsFixed(2), 'Efficiency': '${_efficiency.toStringAsFixed(2)}%', 'Loss': _loss.toStringAsFixed(2), 'Loss %': '${_lossPct.toStringAsFixed(2)}%'}
      : {};

  @override
  void dispose() { _inputCtrl.dispose(); _outputCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Efficiency',
      accentColor: c, toolId: 'efficiency_calculator', categoryName: 'Engineering',
      infoText: 'η = (Output ÷ Input) × 100%', exportData: _exportData,
      children: [
        TextField(controller: _inputCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Input (energy / power / work)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _outputCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Output (useful)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text('${_efficiency.toStringAsFixed(1)}%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: _efficiency >= 80 ? Colors.green : _efficiency >= 50 ? c : Colors.red)),
            const Text('efficiency'),
            const Divider(),
            ResultRow(label: 'Energy Loss', value: _loss.toStringAsFixed(2)),
            ResultRow(label: 'Loss %', value: '${_lossPct.toStringAsFixed(1)}%'),
          ]))),
      ],
    );
  }
}
