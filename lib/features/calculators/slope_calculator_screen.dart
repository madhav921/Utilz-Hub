import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Angle & slope calculator (rise/run, degrees, grade %).
class SlopeCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const SlopeCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<SlopeCalculatorScreen> createState() => _SlopeCalculatorScreenState();
}

class _SlopeCalculatorScreenState extends State<SlopeCalculatorScreen> {
  final _riseCtrl = TextEditingController();
  final _runCtrl = TextEditingController();

  double get _rise => double.tryParse(_riseCtrl.text) ?? 0;
  double get _run => double.tryParse(_runCtrl.text) ?? 0;
  bool get _valid => _run > 0;
  double get _slope => _rise / _run;
  double get _degrees => atan(_slope) * 180 / pi;
  double get _grade => _slope * 100;
  double get _ratio => _run / (_rise == 0 ? 1 : _rise);

  Map<String, String> get _exportData => _valid
      ? {'Rise': _riseCtrl.text, 'Run': _runCtrl.text, 'Slope': _slope.toStringAsFixed(4), 'Angle': '${_degrees.toStringAsFixed(2)}°', 'Grade': '${_grade.toStringAsFixed(1)}%', 'Ratio': '1:${_ratio.toStringAsFixed(1)}'}
      : {};

  @override
  void dispose() { _riseCtrl.dispose(); _runCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Slope Calculator',
      accentColor: c, toolId: 'slope_calculator', categoryName: 'Geometry',
      infoText: 'Slope = Rise ÷ Run', exportData: _exportData,
      children: [
        TextField(controller: _riseCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: InputDecoration(labelText: 'Rise (vertical)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _runCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Run (horizontal)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            ResultRow(label: 'Slope', value: _slope.toStringAsFixed(4)),
            ResultRow(label: 'Angle', value: '${_degrees.toStringAsFixed(2)}°', isBold: true),
            ResultRow(label: 'Grade', value: '${_grade.toStringAsFixed(1)}%'),
            ResultRow(label: 'Ratio', value: '1 : ${_ratio.toStringAsFixed(1)}'),
            ResultRow(label: 'Hypotenuse', value: sqrt(_rise * _rise + _run * _run).toStringAsFixed(3)),
          ]))),
      ],
    );
  }
}
