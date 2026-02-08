import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Converts fractions to decimals and vice-versa.
class FractionDecimalScreen extends StatefulWidget {
  final Color categoryColor;
  const FractionDecimalScreen({super.key, required this.categoryColor});

  @override
  State<FractionDecimalScreen> createState() => _FractionDecimalScreenState();
}

class _FractionDecimalScreenState extends State<FractionDecimalScreen> {
  final _numCtrl = TextEditingController();
  final _denCtrl = TextEditingController();
  final _decCtrl = TextEditingController();
  bool _fracMode = true; // true = fraction→decimal, false = decimal→fraction

  @override
  void dispose() {
    _numCtrl.dispose();
    _denCtrl.dispose();
    _decCtrl.dispose();
    super.dispose();
  }

  // ── Fraction → Decimal ─────────────────────────────────
  String _toDecimal() {
    final n = int.tryParse(_numCtrl.text);
    final d = int.tryParse(_denCtrl.text);
    if (n == null || d == null || d == 0) return '';
    return (n / d).toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  // ── Decimal → Fraction ─────────────────────────────────
  String _toFraction() {
    final v = double.tryParse(_decCtrl.text);
    if (v == null) return '';
    final s = _decCtrl.text;
    final dotIdx = s.indexOf('.');
    if (dotIdx == -1) return '${v.toInt()} / 1';
    final decimals = s.length - dotIdx - 1;
    int den = 1;
    for (int i = 0; i < decimals; i++) {
      den *= 10;
    }
    int num = (v * den).round();
    final g = _gcd(num.abs(), den);
    return '${num ~/ g} / ${den ~/ g}';
  }

  int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  Map<String, String> get _exportData {
    if (_fracMode) {
      final d = _toDecimal();
      return d.isEmpty ? {} : {'Fraction': '${_numCtrl.text} / ${_denCtrl.text}', 'Decimal': d};
    } else {
      final f = _toFraction();
      return f.isEmpty ? {} : {'Decimal': _decCtrl.text, 'Fraction': f};
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Fraction ↔ Decimal',
      accentColor: c,
      toolId: 'fraction_decimal',
      categoryName: 'Math & Numbers',
      exportData: _exportData,
      children: [
        Center(
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Fraction → Decimal')),
              ButtonSegment(value: false, label: Text('Decimal → Fraction')),
            ],
            selected: {_fracMode},
            onSelectionChanged: (v) => setState(() => _fracMode = v.first),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                (s) => s.contains(WidgetState.selected) ? c.withValues(alpha: 0.2) : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_fracMode) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _numCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Numerator',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('/', style: TextStyle(fontSize: 40, color: c)),
              ),
              Expanded(
                child: TextField(
                  controller: _denCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Denominator',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_toDecimal().isNotEmpty)
            Card(
              color: c.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Decimal Value'),
                    Text(_toDecimal(),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: c)),
                  ],
                ),
              ),
            ),
        ] else ...[
          TextField(
            controller: _decCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Decimal number',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          if (_toFraction().isNotEmpty)
            Card(
              color: c.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Fraction'),
                    Text(_toFraction(),
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: c)),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }
}
