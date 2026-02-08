import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Percentage wastage calculator.
class WastageCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const WastageCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<WastageCalculatorScreen> createState() => _WastageCalculatorScreenState();
}

class _WastageCalculatorScreenState extends State<WastageCalculatorScreen> {
  final _totalCtrl = TextEditingController();
  final _usedCtrl = TextEditingController();

  double get _total => double.tryParse(_totalCtrl.text) ?? 0;
  double get _used => double.tryParse(_usedCtrl.text) ?? 0;
  bool get _valid => _total > 0 && _used >= 0 && _used <= _total;
  double get _wasted => _total - _used;
  double get _pct => _total > 0 ? (_wasted / _total) * 100 : 0;
  double get _efficiency => 100 - _pct;

  Map<String, String> get _exportData => _valid
      ? {'Total': _total.toStringAsFixed(2), 'Used': _used.toStringAsFixed(2), 'Wasted': _wasted.toStringAsFixed(2), 'Wastage %': '${_pct.toStringAsFixed(1)}%', 'Efficiency': '${_efficiency.toStringAsFixed(1)}%'}
      : {};

  @override
  void dispose() { _totalCtrl.dispose(); _usedCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Wastage Calculator',
      accentColor: c, toolId: 'wastage_calculator', categoryName: 'Engineering',
      infoText: 'Calculate material wastage percentage', exportData: _exportData,
      children: [
        TextField(controller: _totalCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Total Material', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _usedCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Material Used', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text('${_pct.toStringAsFixed(1)}%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: _pct > 15 ? Colors.red : c)),
            const Text('wastage'),
            const Divider(),
            ResultRow(label: 'Wasted', value: _wasted.toStringAsFixed(2)),
            ResultRow(label: 'Efficiency', value: '${_efficiency.toStringAsFixed(1)}%'),
          ]))),
      ],
    );
  }
}
