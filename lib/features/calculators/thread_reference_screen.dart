import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Common thread size reference chart.
class ThreadReferenceScreen extends StatefulWidget {
  final Color categoryColor;
  const ThreadReferenceScreen({super.key, required this.categoryColor});

  @override
  State<ThreadReferenceScreen> createState() => _ThreadReferenceScreenState();
}

class _ThreadReferenceScreenState extends State<ThreadReferenceScreen> {
  int _tab = 0; // 0=metric, 1=imperial
  String _search = '';

  static const _metric = [
    ['M3', '3.0', '0.5', '2.5'],['M4', '4.0', '0.7', '3.3'],['M5', '5.0', '0.8', '4.2'],
    ['M6', '6.0', '1.0', '5.0'],['M8', '8.0', '1.25', '6.75'],['M10', '10.0', '1.5', '8.5'],
    ['M12', '12.0', '1.75', '10.25'],['M14', '14.0', '2.0', '12.0'],['M16', '16.0', '2.0', '14.0'],
    ['M18', '18.0', '2.5', '15.5'],['M20', '20.0', '2.5', '17.5'],['M24', '24.0', '3.0', '21.0'],
    ['M30', '30.0', '3.5', '26.5'],['M36', '36.0', '4.0', '32.0'],
  ];

  static const _imperial = [
    ['1/4"-20', '6.35', '1.27', 'UNC'],['1/4"-28', '6.35', '0.91', 'UNF'],
    ['5/16"-18', '7.94', '1.41', 'UNC'],['3/8"-16', '9.53', '1.59', 'UNC'],
    ['3/8"-24', '9.53', '1.06', 'UNF'],['7/16"-14', '11.11', '1.81', 'UNC'],
    ['1/2"-13', '12.70', '1.95', 'UNC'],['1/2"-20', '12.70', '1.27', 'UNF'],
    ['5/8"-11', '15.88', '2.31', 'UNC'],['3/4"-10', '19.05', '2.54', 'UNC'],
    ['7/8"-9', '22.23', '2.82', 'UNC'],['1"-8', '25.40', '3.18', 'UNC'],
  ];

  List<List<String>> get _filtered {
    final data = _tab == 0 ? _metric : _imperial;
    if (_search.isEmpty) return data;
    return data.where((r) => r.any((c) => c.toLowerCase().contains(_search.toLowerCase()))).toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Thread Sizes',
      accentColor: c,
      toolId: 'thread_reference',
      categoryName: 'Engineering',
      infoText: 'Common bolt/screw thread reference',
      exportData: const {'Type': 'Reference chart'},
      children: [
        Center(child: SegmentedButton<int>(
          segments: const [ButtonSegment(value: 0, label: Text('Metric')), ButtonSegment(value: 1, label: Text('Imperial'))],
          selected: {_tab}, onSelectionChanged: (v) => setState(() => _tab = v.first),
        )),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(labelText: 'Search', prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: 8),
        Card(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          columns: _tab == 0
              ? const [DataColumn(label: Text('Size')), DataColumn(label: Text('OD mm'), numeric: true), DataColumn(label: Text('Pitch mm'), numeric: true), DataColumn(label: Text('Tap Drill mm'), numeric: true)]
              : const [DataColumn(label: Text('Size')), DataColumn(label: Text('OD mm'), numeric: true), DataColumn(label: Text('Pitch mm'), numeric: true), DataColumn(label: Text('Type'))],
          rows: _filtered.map((r) => DataRow(cells: r.map((c) => DataCell(Text(c))).toList())).toList(),
        ))),
      ],
    );
  }
}
