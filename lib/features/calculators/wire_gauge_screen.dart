import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Wire gauge (AWG) reference chart with current ratings.
class WireGaugeScreen extends StatefulWidget {
  final Color categoryColor;
  const WireGaugeScreen({super.key, required this.categoryColor});

  @override
  State<WireGaugeScreen> createState() => _WireGaugeScreenState();
}

class _WireGaugeScreenState extends State<WireGaugeScreen> {
  String _search = '';

  // AWG gauge, diameter mm, area mm², max current (A) copper
  static const _data = [
    ['0000 (4/0)', '11.68', '107.2', '230'],
    ['000 (3/0)', '10.40', '85.0', '200'],
    ['00 (2/0)', '9.27', '67.4', '175'],
    ['0 (1/0)', '8.25', '53.5', '150'],
    ['1', '7.35', '42.4', '130'],
    ['2', '6.54', '33.6', '115'],
    ['4', '5.19', '21.2', '85'],
    ['6', '4.11', '13.3', '65'],
    ['8', '3.26', '8.37', '50'],
    ['10', '2.59', '5.26', '35'],
    ['12', '2.05', '3.31', '25'],
    ['14', '1.63', '2.08', '20'],
    ['16', '1.29', '1.31', '13'],
    ['18', '1.02', '0.82', '10'],
    ['20', '0.81', '0.52', '7'],
    ['22', '0.64', '0.33', '5'],
    ['24', '0.51', '0.20', '3.5'],
    ['26', '0.40', '0.13', '2.2'],
    ['28', '0.32', '0.08', '1.4'],
    ['30', '0.25', '0.05', '0.9'],
  ];

  List<List<String>> get _filtered => _search.isEmpty
      ? _data
      : _data.where((r) => r[0].toLowerCase().contains(_search.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Wire Gauge (AWG)',
      accentColor: c, toolId: 'wire_gauge', categoryName: 'Engineering',
      infoText: 'American Wire Gauge reference with current ratings',
      exportData: const {'Type': 'Reference chart'},
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Search gauge', prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: 8),
        Card(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          columns: const [
            DataColumn(label: Text('AWG')),
            DataColumn(label: Text('Dia (mm)'), numeric: true),
            DataColumn(label: Text('Area (mm²)'), numeric: true),
            DataColumn(label: Text('Max A'), numeric: true),
          ],
          rows: _filtered.map((r) => DataRow(cells: [
            DataCell(Text(r[0], style: const TextStyle(fontWeight: FontWeight.w600))),
            DataCell(Text(r[1])),
            DataCell(Text(r[2])),
            DataCell(Text('${r[3]} A')),
          ])).toList(),
        ))),
      ],
    );
  }
}
