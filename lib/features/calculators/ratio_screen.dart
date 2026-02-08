import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Ratio calculator — simplify ratios and solve proportions.
class RatioScreen extends StatefulWidget {
  final Color categoryColor;
  const RatioScreen({super.key, required this.categoryColor});

  @override
  State<RatioScreen> createState() => _RatioScreenState();
}

class _RatioScreenState extends State<RatioScreen> {
  final _aController = TextEditingController();
  final _bController = TextEditingController();

  double get _a => double.tryParse(_aController.text) ?? 0;
  double get _b => double.tryParse(_bController.text) ?? 0;

  String get _simplifiedRatio {
    if (_a <= 0 || _b <= 0) return '';
    final g = _gcd(_a.round(), _b.round());
    return '${(_a / g).round()} : ${(_b / g).round()}';
  }

  double get _ratioDecimal => _b > 0 ? _a / _b : 0;

  int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  Map<String, String>? get _exportData {
    if (_a <= 0 || _b <= 0) return null;
    return {
      'A': _a.toStringAsFixed(2),
      'B': _b.toStringAsFixed(2),
      'Ratio': '${_a.toStringAsFixed(0)} : ${_b.toStringAsFixed(0)}',
      'Simplified': _simplifiedRatio,
      'Decimal': _ratioDecimal.toStringAsFixed(4),
      'A as % of B': '${(_a / _b * 100).toStringAsFixed(2)}%',
      'B as % of A': '${(_b / _a * 100).toStringAsFixed(2)}%',
    };
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Ratio Calculator',
      accentColor: c,
      infoText: 'Enter two values to simplify their ratio.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _aController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Value A',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(':',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: c)),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _bController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Value B',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_a > 0 && _b > 0) ...[
          const SizedBox(height: 20),
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Simplified Ratio',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(_simplifiedRatio,
                      style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: c)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow('Decimal', _ratioDecimal.toStringAsFixed(4)),
                  _infoRow('A as % of B',
                      '${(_a / _b * 100).toStringAsFixed(2)}%'),
                  _infoRow('B as % of A',
                      '${(_b / _a * 100).toStringAsFixed(2)}%'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
