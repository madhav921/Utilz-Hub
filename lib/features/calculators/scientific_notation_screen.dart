import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Convert between standard and scientific notation.
class ScientificNotationScreen extends StatefulWidget {
  final Color categoryColor;
  const ScientificNotationScreen({super.key, required this.categoryColor});

  @override
  State<ScientificNotationScreen> createState() =>
      _ScientificNotationScreenState();
}

class _ScientificNotationScreenState extends State<ScientificNotationScreen> {
  final _controller = TextEditingController();
  bool _toScientific = true;

  String get _result {
    final text = _controller.text.trim();
    if (text.isEmpty) return '';

    if (_toScientific) {
      // Standard → Scientific
      final value = double.tryParse(text);
      if (value == null) return 'Invalid number';
      if (value == 0) return '0 × 10⁰';
      final exp = value.abs() < 1
          ? -(value.abs().toString().indexOf(RegExp(r'[1-9]')) -
              value.abs().toString().indexOf('.'))
          : value.abs().toStringAsFixed(0).length - 1;
      final mantissa = value / _pow10(exp);
      return '${mantissa.toStringAsFixed(4)} × 10^$exp';
    } else {
      // Scientific → Standard
      // Supports formats like "1.23e5" or "1.23 x 10^5"
      final cleaned =
          text.replaceAll('×', 'e').replaceAll('x', 'e').replaceAll('^', '');
      final value = double.tryParse(cleaned);
      if (value == null) return 'Invalid notation';
      if (value == value.roundToDouble() && value.abs() < 1e15) {
        return value.toStringAsFixed(0);
      }
      return value.toStringAsFixed(6);
    }
  }

  double _pow10(int exp) {
    double result = 1;
    for (int i = 0; i < exp.abs(); i++) {
      result *= 10;
    }
    return exp >= 0 ? result : 1 / result;
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
      title: 'Scientific Notation',
      accentColor: c,
      infoText: _toScientific
          ? 'Enter a standard number to convert to scientific notation.'
          : 'Enter scientific notation (e.g., 1.23e5) to convert to standard.',
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                    value: true, label: Text('To Scientific')),
                ButtonSegment(
                    value: false, label: Text('To Standard')),
              ],
              selected: {_toScientific},
              onSelectionChanged: (s) =>
                  setState(() => _toScientific = s.first),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: _toScientific
                    ? 'Enter number (e.g., 123456)'
                    : 'Enter notation (e.g., 1.23e5)',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    _toScientific ? 'Scientific Notation' : 'Standard Form',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _result,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: c),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
