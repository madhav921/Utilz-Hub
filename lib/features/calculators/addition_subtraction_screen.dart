import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Kid-friendly addition & subtraction practice tool.
class AdditionSubtractionScreen extends StatefulWidget {
  final Color categoryColor;
  const AdditionSubtractionScreen({super.key, required this.categoryColor});

  @override
  State<AdditionSubtractionScreen> createState() => _AdditionSubtractionScreenState();
}

class _AdditionSubtractionScreenState extends State<AdditionSubtractionScreen> {
  final _aCtrl = TextEditingController();
  final _bCtrl = TextEditingController();
  bool _isAdd = true;

  double? get _a => double.tryParse(_aCtrl.text);
  double? get _b => double.tryParse(_bCtrl.text);
  bool get _hasResult => _a != null && _b != null;
  double get _result => _isAdd ? (_a! + _b!) : (_a! - _b!);

  String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  void _generate() {
    final r = Random();
    _aCtrl.text = r.nextInt(100).toString();
    _bCtrl.text = r.nextInt(100).toString();
    setState(() {});
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Add & Subtract',
      accentColor: c,
      toolId: 'addition_subtraction',
      categoryName: 'Math & Numbers',
      infoText: 'Practice addition & subtraction!',
      exportData: _hasResult
          ? {'A': _aCtrl.text, 'B': _bCtrl.text, 'Operation': _isAdd ? '+' : '−', 'Result': _fmt(_result)}
          : {},
      children: [
        // Toggle
        Center(
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Addition +'), icon: Icon(Icons.add)),
              ButtonSegment(value: false, label: Text('Subtraction −'), icon: Icon(Icons.remove)),
            ],
            selected: {_isAdd},
            onSelectionChanged: (v) => setState(() => _isAdd = v.first),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                (s) => s.contains(WidgetState.selected) ? c.withValues(alpha: 0.2) : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _aCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number A',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(_isAdd ? '+' : '−',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: c)),
            ),
            Expanded(
              child: TextField(
                controller: _bCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number B',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_hasResult)
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Answer', style: TextStyle(fontSize: 14)),
                  Text(_fmt(_result),
                      style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: c)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _generate,
          icon: const Icon(Icons.casino),
          label: const Text('Random Numbers'),
          style: FilledButton.styleFrom(backgroundColor: c),
        ),
      ],
    );
  }
}
