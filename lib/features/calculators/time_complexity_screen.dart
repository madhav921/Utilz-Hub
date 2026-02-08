import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Time complexity reference card for common algorithms.
class TimeComplexityScreen extends StatefulWidget {
  final Color categoryColor;
  const TimeComplexityScreen({super.key, required this.categoryColor});

  @override
  State<TimeComplexityScreen> createState() => _TimeComplexityScreenState();
}

class _TimeComplexityScreenState extends State<TimeComplexityScreen> {
  String _search = '';

  static const _data = [
    ['Array access', 'O(1)', 'O(1)', 'O(1)'],
    ['Array search', 'O(1)', 'O(n)', 'O(n)'],
    ['Array insert/delete', 'O(1)', 'O(n)', 'O(n)'],
    ['Binary search', 'O(1)', 'O(log n)', 'O(log n)'],
    ['Linked list access', 'O(1)', 'O(n)', 'O(n)'],
    ['Linked list insert', 'O(1)', 'O(1)', 'O(1)'],
    ['Stack push/pop', 'O(1)', 'O(1)', 'O(1)'],
    ['Queue enqueue/dequeue', 'O(1)', 'O(1)', 'O(1)'],
    ['Hash table lookup', 'O(1)', 'O(1)', 'O(n)'],
    ['BST search', 'O(1)', 'O(log n)', 'O(n)'],
    ['BST insert/delete', 'O(1)', 'O(log n)', 'O(n)'],
    ['Heap insert', 'O(1)', 'O(log n)', 'O(log n)'],
    ['Heap extract-min', 'O(1)', 'O(log n)', 'O(log n)'],
    ['Bubble sort', '-', 'O(n²)', 'O(n²)'],
    ['Selection sort', '-', 'O(n²)', 'O(n²)'],
    ['Insertion sort', '-', 'O(n²)', 'O(n²)'],
    ['Merge sort', '-', 'O(n log n)', 'O(n log n)'],
    ['Quick sort', '-', 'O(n log n)', 'O(n²)'],
    ['Heap sort', '-', 'O(n log n)', 'O(n log n)'],
    ['Counting sort', '-', 'O(n+k)', 'O(n+k)'],
    ['Radix sort', '-', 'O(nk)', 'O(nk)'],
    ['BFS / DFS', '-', 'O(V+E)', 'O(V+E)'],
    ['Dijkstra', '-', 'O(E log V)', 'O(E log V)'],
  ];

  List<List<String>> get _filtered => _search.isEmpty
      ? _data
      : _data.where((r) => r[0].toLowerCase().contains(_search.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Time Complexity',
      accentColor: c, toolId: 'time_complexity', categoryName: 'Digital Tools',
      infoText: 'Big-O reference for common algorithms',
      exportData: const {'Type': 'Reference chart'},
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Search algorithm', prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: 8),
        Card(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          columnSpacing: 16,
          columns: const [
            DataColumn(label: Text('Algorithm')),
            DataColumn(label: Text('Best')),
            DataColumn(label: Text('Average')),
            DataColumn(label: Text('Worst')),
          ],
          rows: _filtered.map((r) => DataRow(cells: [
            DataCell(Text(r[0], style: const TextStyle(fontWeight: FontWeight.w600))),
            DataCell(Text(r[1], style: const TextStyle(color: Colors.green))),
            DataCell(Text(r[2], style: const TextStyle(color: Colors.orange))),
            DataCell(Text(r[3], style: TextStyle(color: r[3].contains('n²') ? Colors.red : Colors.orange))),
          ])).toList(),
        ))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Complexity Order (fast → slow)', style: TextStyle(fontWeight: FontWeight.bold, color: c)),
            const SizedBox(height: 8),
            const Text('O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2ⁿ) < O(n!)', style: TextStyle(fontFamily: 'monospace', fontSize: 13)),
          ],
        ))),
      ],
    );
  }
}
