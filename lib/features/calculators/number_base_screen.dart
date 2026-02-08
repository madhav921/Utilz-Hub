import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Number base converter: Decimal ↔ Binary ↔ Octal ↔ Hexadecimal.
class NumberBaseScreen extends StatefulWidget {
  final Color categoryColor;
  const NumberBaseScreen({super.key, required this.categoryColor});

  @override
  State<NumberBaseScreen> createState() => _NumberBaseScreenState();
}

class _NumberBaseScreenState extends State<NumberBaseScreen> {
  final _controller = TextEditingController();
  int _inputBase = 10;

  int? get _decimalValue {
    if (_controller.text.isEmpty) return null;
    return int.tryParse(_controller.text, radix: _inputBase);
  }

  String _toBase(int base) {
    final v = _decimalValue;
    if (v == null) return '';
    return v.toRadixString(base).toUpperCase();
  }

  Map<String, String>? get _exportData {
    if (_decimalValue == null) return null;
    return {
      'Input': _controller.text,
      'Input Base': _inputBase.toString(),
      'Decimal (10)': _toBase(10),
      'Binary (2)': _toBase(2),
      'Octal (8)': _toBase(8),
      'Hexadecimal (16)': _toBase(16),
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Number Base Converter',
      accentColor: c,
      infoText: 'Convert between decimal, binary, octal, and hexadecimal.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input Base',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: c)),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 2, label: Text('BIN')),
                    ButtonSegment(value: 8, label: Text('OCT')),
                    ButtonSegment(value: 10, label: Text('DEC')),
                    ButtonSegment(value: 16, label: Text('HEX')),
                  ],
                  selected: {_inputBase},
                  onSelectionChanged: (s) =>
                      setState(() => _inputBase = s.first),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        ),
        if (_decimalValue != null) ...[
          const SizedBox(height: 20),
          _baseCard('Decimal (10)', _toBase(10), Icons.looks_one, c),
          _baseCard('Binary (2)', _toBase(2), Icons.looks_two, Colors.green),
          _baseCard('Octal (8)', _toBase(8), Icons.looks_3, Colors.orange),
          _baseCard(
              'Hexadecimal (16)', _toBase(16), Icons.looks_4, Colors.purple),
        ],
      ],
    );
  }

  Widget _baseCard(String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 13)),
        subtitle: SelectableText(
          value,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
