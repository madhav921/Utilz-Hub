import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Pipe diameter ↔ flow rate calculator (Hazen-Williams approximation).
class PipeFlowScreen extends StatefulWidget {
  final Color categoryColor;
  const PipeFlowScreen({super.key, required this.categoryColor});

  @override
  State<PipeFlowScreen> createState() => _PipeFlowScreenState();
}

class _PipeFlowScreenState extends State<PipeFlowScreen> {
  final _diaCtrl = TextEditingController();
  final _velCtrl = TextEditingController(text: '1.5');

  double get _dia => double.tryParse(_diaCtrl.text) ?? 0; // mm
  double get _vel => double.tryParse(_velCtrl.text) ?? 0; // m/s
  bool get _valid => _dia > 0 && _vel > 0;

  double get _radiusM => _dia / 2000;
  double get _areaM2 => pi * _radiusM * _radiusM;
  double get _flowM3s => _areaM2 * _vel;
  double get _flowLps => _flowM3s * 1000;
  double get _flowLpm => _flowLps * 60;
  double get _flowGpm => _flowLpm * 0.264172;

  Map<String, String> get _exportData => _valid
      ? {
          'Diameter': '${_dia.toStringAsFixed(1)} mm',
          'Velocity': '${_vel.toStringAsFixed(2)} m/s',
          'Flow (L/min)': _flowLpm.toStringAsFixed(2),
          'Flow (L/s)': _flowLps.toStringAsFixed(3),
          'Flow (GPM)': _flowGpm.toStringAsFixed(2),
        }
      : {};

  @override
  void dispose() {
    _diaCtrl.dispose();
    _velCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Pipe Flow Rate',
      accentColor: c,
      toolId: 'pipe_flow',
      categoryName: 'Engineering',
      infoText: 'Q = A × v (flow = area × velocity)',
      exportData: _exportData,
      children: [
        TextField(controller: _diaCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Inner Diameter', suffixText: 'mm', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _velCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Flow Velocity', suffixText: 'm/s', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            ResultRow(label: 'Cross-section area', value: '${(_areaM2 * 1e6).toStringAsFixed(1)} mm²'),
            const Divider(),
            ResultRow(label: 'Liters / minute', value: _flowLpm.toStringAsFixed(2), isBold: true),
            ResultRow(label: 'Liters / second', value: _flowLps.toStringAsFixed(3)),
            ResultRow(label: 'Gallons / minute', value: _flowGpm.toStringAsFixed(2)),
            ResultRow(label: 'm³ / second', value: _flowM3s.toStringAsFixed(6)),
          ]))),
      ],
    );
  }
}
