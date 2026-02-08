import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Depreciation calculator – SLM, WDV, double-declining.
class DepreciationScreen extends StatefulWidget {
  final Color categoryColor;
  const DepreciationScreen({super.key, required this.categoryColor});

  @override
  State<DepreciationScreen> createState() => _DepreciationScreenState();
}

class _DepreciationScreenState extends State<DepreciationScreen> {
  final _costCtrl = TextEditingController();
  final _salvageCtrl = TextEditingController();
  double _years = 5;
  int _method = 0; // 0=SLM, 1=WDV, 2=DDB

  static const _methods = ['Straight-Line (SLM)', 'Written-Down (WDV)', 'Double Declining'];

  double get _cost => double.tryParse(_costCtrl.text) ?? 0;
  double get _salvage => double.tryParse(_salvageCtrl.text) ?? 0;
  bool get _valid => _cost > 0 && _years > 0;

  double get _annualSLM => _valid ? (_cost - _salvage) / _years : 0;
  double get _rateSLM => _valid ? (_annualSLM / _cost) * 100 : 0;

  List<List<double>> get _schedule {
    final rows = <List<double>>[];
    double bv = _cost;
    for (int y = 1; y <= _years.round(); y++) {
      double dep;
      switch (_method) {
        case 1: // WDV
          final rate = 1 - pow(_salvage / _cost, 1 / _years);
          dep = bv * rate;
          break;
        case 2: // DDB
          final rate = 2 / _years;
          dep = bv * rate;
          if (bv - dep < _salvage) dep = bv - _salvage;
          break;
        default: // SLM
          dep = _annualSLM;
      }
      if (dep < 0) dep = 0;
      bv -= dep;
      if (bv < _salvage) bv = _salvage;
      rows.add([y.toDouble(), dep, bv]);
    }
    return rows;
  }

  Map<String, String> get _exportData => _valid
      ? {
          'Cost': _costCtrl.text,
          'Salvage': _salvageCtrl.text,
          'Life': '${_years.round()} years',
          'Method': _methods[_method],
          'Annual (yr 1)': _schedule.isNotEmpty ? _schedule[0][1].toStringAsFixed(2) : '-',
        }
      : {};

  @override
  void dispose() {
    _costCtrl.dispose();
    _salvageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Depreciation',
      accentColor: c,
      toolId: 'depreciation',
      categoryName: 'Finance & Loans',
      exportData: _exportData,
      children: [
        TextField(
          controller: _costCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Asset Cost',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _salvageCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Salvage Value',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        SliderInput(
          label: 'Useful Life',
          value: _years,
          min: 1, max: 30, divisions: 29,
          suffix: 'yrs',
          accentColor: c,
          onChanged: (v) => setState(() => _years = v),
          decimals: 0,
        ),
        const SizedBox(height: 8),
        Center(
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('SLM')),
              ButtonSegment(value: 1, label: Text('WDV')),
              ButtonSegment(value: 2, label: Text('DDB')),
            ],
            selected: {_method},
            onSelectionChanged: (v) => setState(() => _method = v.first),
          ),
        ),
        const SizedBox(height: 16),
        if (_valid) ...[
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ResultRow(label: 'Method', value: _methods[_method]),
                  if (_method == 0) ResultRow(label: 'Annual Depreciation', value: '₹${_annualSLM.toStringAsFixed(2)}'),
                  if (_method == 0) ResultRow(label: 'Rate', value: '${_rateSLM.toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Year-wise Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Year')),
                  DataColumn(label: Text('Depreciation'), numeric: true),
                  DataColumn(label: Text('Book Value'), numeric: true),
                ],
                rows: _schedule.map((r) => DataRow(cells: [
                  DataCell(Text('${r[0].toInt()}')),
                  DataCell(Text('₹${r[1].toStringAsFixed(0)}')),
                  DataCell(Text('₹${r[2].toStringAsFixed(0)}')),
                ])).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
