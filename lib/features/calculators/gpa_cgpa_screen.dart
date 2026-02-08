import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// GPA / CGPA calculator with percentage ↔ GPA conversion.
class GpaCgpaScreen extends StatefulWidget {
  final Color categoryColor;
  const GpaCgpaScreen({super.key, required this.categoryColor});

  @override
  State<GpaCgpaScreen> createState() => _GpaCgpaScreenState();
}

class _GpaCgpaScreenState extends State<GpaCgpaScreen> {
  int _mode = 0; // 0=CGPA calc, 1=% ↔ GPA
  int _semesters = 4;
  final List<TextEditingController> _gpaCtrl = List.generate(10, (_) => TextEditingController());
  final List<TextEditingController> _creditCtrl = List.generate(10, (_) => TextEditingController(text: '20'));
  final _pctCtrl = TextEditingController();
  double _scale = 10; // GPA scale (10 or 4)

  @override
  void dispose() {
    for (final c in _gpaCtrl) { c.dispose(); }
    for (final c in _creditCtrl) { c.dispose(); }
    _pctCtrl.dispose();
    super.dispose();
  }

  double get _cgpa {
    double totalWeighted = 0, totalCredits = 0;
    for (int i = 0; i < _semesters; i++) {
      final g = double.tryParse(_gpaCtrl[i].text) ?? 0;
      final c = double.tryParse(_creditCtrl[i].text) ?? 0;
      totalWeighted += g * c;
      totalCredits += c;
    }
    return totalCredits > 0 ? totalWeighted / totalCredits : 0;
  }

  double get _cgpaToPercent => _scale == 10 ? _cgpa * 9.5 : (_cgpa / 4.0) * 100;

  double get _percentToGpa {
    final p = double.tryParse(_pctCtrl.text) ?? 0;
    return _scale == 10 ? p / 9.5 : (p / 100) * 4.0;
  }

  Map<String, String> get _exportData {
    if (_mode == 0) {
      return {'CGPA': _cgpa.toStringAsFixed(2), 'Scale': '${_scale.toInt()}', 'Percentage': '${_cgpaToPercent.toStringAsFixed(1)}%', 'Semesters': '$_semesters'};
    } else {
      return {'Percentage': '${_pctCtrl.text}%', 'GPA (scale ${_scale.toInt()})': _percentToGpa.toStringAsFixed(2)};
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'GPA / CGPA',
      accentColor: c,
      toolId: 'gpa_cgpa',
      categoryName: 'Math & Numbers',
      exportData: _exportData,
      children: [
        Center(
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('CGPA Calculator')),
              ButtonSegment(value: 1, label: Text('% ↔ GPA')),
            ],
            selected: {_mode},
            onSelectionChanged: (v) => setState(() => _mode = v.first),
          ),
        ),
        const SizedBox(height: 8),
        // Scale toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Scale: '),
            ChoiceChip(label: const Text('10'), selected: _scale == 10,
              onSelected: (_) => setState(() => _scale = 10)),
            const SizedBox(width: 8),
            ChoiceChip(label: const Text('4.0'), selected: _scale == 4,
              onSelected: (_) => setState(() => _scale = 4)),
          ],
        ),
        const SizedBox(height: 16),
        if (_mode == 0) ..._buildCgpaCalc(c) else ..._buildPercentConvert(c),
      ],
    );
  }

  List<Widget> _buildCgpaCalc(Color c) {
    return [
      SliderInput(
        label: 'Semesters',
        value: _semesters.toDouble(),
        min: 1, max: 10, divisions: 9,
        accentColor: c,
        onChanged: (v) => setState(() => _semesters = v.round()),
        decimals: 0,
      ),
      const SizedBox(height: 8),
      ...List.generate(_semesters, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Text('Sem ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _gpaCtrl[i],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'GPA',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 70,
              child: TextField(
                controller: _creditCtrl[i],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Credits',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
      )),
      const SizedBox(height: 12),
      Card(
        color: c.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ResultRow(label: 'CGPA', value: _cgpa.toStringAsFixed(2), isBold: true),
              ResultRow(label: 'Percentage', value: '${_cgpaToPercent.toStringAsFixed(1)}%'),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPercentConvert(Color c) {
    return [
      TextField(
        controller: _pctCtrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Percentage',
          suffixText: '%',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 20),
      if (double.tryParse(_pctCtrl.text) != null)
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('GPA Equivalent'),
                Text(_percentToGpa.toStringAsFixed(2),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: c)),
                Text('on ${_scale.toInt()}-point scale',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
    ];
  }
}
