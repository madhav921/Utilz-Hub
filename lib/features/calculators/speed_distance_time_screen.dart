import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Speed – Distance – Time calculator.
class SpeedDistanceTimeScreen extends StatefulWidget {
  final Color categoryColor;
  const SpeedDistanceTimeScreen({super.key, required this.categoryColor});

  @override
  State<SpeedDistanceTimeScreen> createState() => _SpeedDistanceTimeScreenState();
}

class _SpeedDistanceTimeScreenState extends State<SpeedDistanceTimeScreen> {
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  int _solveFor = 0; // 0=speed, 1=distance, 2=time

  static const _labels = ['Speed', 'Distance', 'Time'];
  static const _units = ['km/h', 'km', 'hours'];
  static const _icons = [Icons.speed, Icons.straighten, Icons.timer];

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    super.dispose();
  }

  String get _input1Label => _solveFor == 0 ? 'Distance' : _solveFor == 1 ? 'Speed' : 'Speed';
  String get _input2Label => _solveFor == 0 ? 'Time' : _solveFor == 1 ? 'Time' : 'Distance';
  String get _input1Unit => _solveFor == 0 ? 'km' : _solveFor == 1 ? 'km/h' : 'km/h';
  String get _input2Unit => _solveFor == 0 ? 'hours' : _solveFor == 1 ? 'hours' : 'km';

  double? get _v1 => double.tryParse(_ctrl1.text);
  double? get _v2 => double.tryParse(_ctrl2.text);
  bool get _hasResult => _v1 != null && _v2 != null && _v2! > 0;

  double get _result {
    if (!_hasResult) return 0;
    switch (_solveFor) {
      case 0: return _v1! / _v2!; // speed = distance / time
      case 1: return _v1! * _v2!; // distance = speed × time
      case 2: return _v2! / _v1!; // time = distance / speed
      default: return 0;
    }
  }

  Map<String, String> get _exportData => _hasResult
      ? {_input1Label: '$_v1 $_input1Unit', _input2Label: '$_v2 $_input2Unit', _labels[_solveFor]: '${_result.toStringAsFixed(2)} ${_units[_solveFor]}'}
      : {};

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Speed · Distance · Time',
      accentColor: c,
      toolId: 'speed_distance_time',
      categoryName: 'Math & Numbers',
      infoText: 'Speed = Distance ÷ Time',
      exportData: _exportData,
      children: [
        const Text('Solve for:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Center(
          child: SegmentedButton<int>(
            segments: List.generate(3, (i) => ButtonSegment(
              value: i,
              label: Text(_labels[i]),
              icon: Icon(_icons[i]),
            )),
            selected: {_solveFor},
            onSelectionChanged: (v) {
              _ctrl1.clear();
              _ctrl2.clear();
              setState(() => _solveFor = v.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                (s) => s.contains(WidgetState.selected) ? c.withValues(alpha: 0.2) : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _ctrl1,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: _input1Label,
            suffixText: _input1Unit,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl2,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: _input2Label,
            suffixText: _input2Unit,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        if (_hasResult) ...[
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(_labels[_solveFor], style: const TextStyle(fontSize: 14)),
                  Text('${_result.toStringAsFixed(2)} ${_units[_solveFor]}',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: c)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ResultRow(label: 'Formula', value: _solveFor == 0 ? 'D ÷ T' : _solveFor == 1 ? 'S × T' : 'D ÷ S'),
                  ResultRow(label: _input1Label, value: '${_v1!.toStringAsFixed(2)} $_input1Unit'),
                  ResultRow(label: _input2Label, value: '${_v2!.toStringAsFixed(2)} $_input2Unit'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
