import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Ohm's law calculator (V = I × R).
class OhmsLawScreen extends StatefulWidget {
  final Color categoryColor;
  const OhmsLawScreen({super.key, required this.categoryColor});

  @override
  State<OhmsLawScreen> createState() => _OhmsLawScreenState();
}

class _OhmsLawScreenState extends State<OhmsLawScreen> {
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  int _solve = 0; // 0=V, 1=I, 2=R, 3=P

  static const _labels = ['Voltage (V)', 'Current (I)', 'Resistance (R)', 'Power (P)'];
  static const _units = ['V', 'A', 'Ω', 'W'];

  String get _in1Label => _solve == 0 ? 'Current' : _solve == 1 ? 'Voltage' : _solve == 2 ? 'Voltage' : 'Voltage';
  String get _in2Label => _solve == 0 ? 'Resistance' : _solve == 1 ? 'Resistance' : _solve == 2 ? 'Current' : 'Current';
  String get _in1Unit => _solve == 0 ? 'A' : _solve == 1 ? 'V' : _solve == 2 ? 'V' : 'V';
  String get _in2Unit => _solve == 0 ? 'Ω' : _solve == 1 ? 'Ω' : _solve == 2 ? 'A' : 'A';

  double get _v1 => double.tryParse(_ctrl1.text) ?? 0;
  double get _v2 => double.tryParse(_ctrl2.text) ?? 0;
  bool get _valid => _v1 > 0 && _v2 > 0;

  double get _result {
    switch (_solve) {
      case 0: return _v1 * _v2;         // V = I × R
      case 1: return _v2 > 0 ? _v1 / _v2 : 0; // I = V / R
      case 2: return _v2 > 0 ? _v1 / _v2 : 0; // R = V / I
      case 3: return _v1 * _v2;         // P = V × I
      default: return 0;
    }
  }

  // Derived values
  double get _voltage => _solve == 0 ? _result : (_solve == 1 || _solve == 2) ? _v1 : _v1;
  double get _current => _solve == 1 ? _result : _solve == 0 ? _v1 : _v2;
  double get _resistance => _solve == 2 ? _result : _solve == 0 ? _v2 : _v2;
  double get _power => _voltage * _current;

  Map<String, String> get _exportData => _valid
      ? {'Voltage': '${_voltage.toStringAsFixed(3)} V', 'Current': '${_current.toStringAsFixed(3)} A', 'Resistance': '${_resistance.toStringAsFixed(3)} Ω', 'Power': '${_power.toStringAsFixed(3)} W'}
      : {};

  @override
  void dispose() { _ctrl1.dispose(); _ctrl2.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: "Ohm's Law",
      accentColor: c, toolId: 'ohms_law', categoryName: 'Engineering',
      infoText: 'V = I × R  |  P = V × I', exportData: _exportData,
      children: [
        const Text('Solve for:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Center(child: SegmentedButton<int>(
          segments: List.generate(4, (i) => ButtonSegment(value: i, label: Text(_units[i]))),
          selected: {_solve}, onSelectionChanged: (v) { _ctrl1.clear(); _ctrl2.clear(); setState(() => _solve = v.first); },
        )),
        const SizedBox(height: 16),
        TextField(controller: _ctrl1, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: _in1Label, suffixText: _in1Unit, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _ctrl2, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: _in2Label, suffixText: _in2Unit, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text('${_result.toStringAsFixed(3)} ${_units[_solve]}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: c)),
            Text(_labels[_solve]),
            const Divider(),
            ResultRow(label: 'Voltage', value: '${_voltage.toStringAsFixed(3)} V'),
            ResultRow(label: 'Current', value: '${_current.toStringAsFixed(3)} A'),
            ResultRow(label: 'Resistance', value: '${_resistance.toStringAsFixed(3)} Ω'),
            ResultRow(label: 'Power', value: '${_power.toStringAsFixed(3)} W'),
          ]))),
      ],
    );
  }
}
