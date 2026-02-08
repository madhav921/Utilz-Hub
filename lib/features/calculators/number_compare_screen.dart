import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Kid-friendly number comparison tool (>, <, =).
class NumberCompareScreen extends StatefulWidget {
  final Color categoryColor;
  const NumberCompareScreen({super.key, required this.categoryColor});

  @override
  State<NumberCompareScreen> createState() => _NumberCompareScreenState();
}

class _NumberCompareScreenState extends State<NumberCompareScreen>
    with SingleTickerProviderStateMixin {
  final _aCtrl = TextEditingController();
  final _bCtrl = TextEditingController();
  late AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.8,
      upperBound: 1.2,
    );
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    _bounce.dispose();
    super.dispose();
  }

  String _symbol = '';
  String _message = '';

  void _compare() {
    final a = double.tryParse(_aCtrl.text);
    final b = double.tryParse(_bCtrl.text);
    if (a == null || b == null) {
      setState(() {
        _symbol = '?';
        _message = 'Enter two numbers';
      });
      return;
    }
    setState(() {
      if (a > b) {
        _symbol = '>';
        _message = '${a.toStringAsFixed(1)} is GREATER than ${b.toStringAsFixed(1)}';
      } else if (a < b) {
        _symbol = '<';
        _message = '${a.toStringAsFixed(1)} is LESS than ${b.toStringAsFixed(1)}';
      } else {
        _symbol = '=';
        _message = 'Both numbers are EQUAL!';
      }
    });
    _bounce.forward(from: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Number Compare',
      accentColor: c,
      toolId: 'number_compare',
      categoryName: 'Math & Numbers',
      infoText: 'Enter two numbers to compare them!',
      exportData: _symbol.isNotEmpty ? {'Number A': _aCtrl.text, 'Number B': _bCtrl.text, 'Result': _message} : {},
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _aCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'First Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                onChanged: (_) => _compare(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _symbol.isEmpty ? 'vs' : _symbol,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: _symbol == '>' ? Colors.green : _symbol == '<' ? Colors.red : c,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _bCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Second Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                onChanged: (_) => _compare(),
              ),
            ),
          ],
        ),
        if (_message.isNotEmpty) ...[
          const SizedBox(height: 24),
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: c),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
