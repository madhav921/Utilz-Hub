import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Screen DPI & resolution calculator.
class ScreenDpiScreen extends StatefulWidget {
  final Color categoryColor;
  const ScreenDpiScreen({super.key, required this.categoryColor});

  @override
  State<ScreenDpiScreen> createState() => _ScreenDpiScreenState();
}

class _ScreenDpiScreenState extends State<ScreenDpiScreen> {
  final _wCtrl = TextEditingController();
  final _hCtrl = TextEditingController();
  final _diagCtrl = TextEditingController();

  int get _w => int.tryParse(_wCtrl.text) ?? 0;
  int get _h => int.tryParse(_hCtrl.text) ?? 0;
  double get _diag => double.tryParse(_diagCtrl.text) ?? 0;
  bool get _valid => _w > 0 && _h > 0 && _diag > 0;

  double get _diagPx {
    final d = _w.toDouble() * _w.toDouble() + _h.toDouble() * _h.toDouble();
    return d > 0 ? d.toDouble().sqrt() : 0;
  }

  double get _ppi => _diag > 0 ? _diagPx / _diag : 0;
  double get _megapixels => (_w * _h) / 1e6;
  String get _aspect {
    if (_w == 0 || _h == 0) return '-';
    int g = _gcd(_w, _h);
    return '${_w ~/ g}:${_h ~/ g}';
  }

  int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

  Map<String, String> get _exportData => _valid
      ? {'Resolution': '$_w × $_h', 'Screen Size': '${_diag.toStringAsFixed(1)}"', 'PPI': _ppi.toStringAsFixed(0), 'Megapixels': '${_megapixels.toStringAsFixed(2)} MP', 'Aspect Ratio': _aspect}
      : {};

  @override
  void dispose() { _wCtrl.dispose(); _hCtrl.dispose(); _diagCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Screen DPI',
      accentColor: c, toolId: 'screen_dpi', categoryName: 'Digital Tools',
      infoText: 'PPI = diagonal pixels ÷ screen inches', exportData: _exportData,
      children: [
        Row(children: [
          Expanded(child: TextField(controller: _wCtrl, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Width', suffixText: 'px', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            onChanged: (_) => setState(() {}))),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('×')),
          Expanded(child: TextField(controller: _hCtrl, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Height', suffixText: 'px', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            onChanged: (_) => setState(() {}))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: _diagCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Screen Diagonal', suffixText: 'inches', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text('${_ppi.toStringAsFixed(0)} PPI', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: c)),
            const Text('pixels per inch'),
            const Divider(),
            ResultRow(label: 'Resolution', value: '$_w × $_h'),
            ResultRow(label: 'Megapixels', value: '${_megapixels.toStringAsFixed(2)} MP'),
            ResultRow(label: 'Aspect Ratio', value: _aspect),
            ResultRow(label: 'Diagonal Pixels', value: _diagPx.toStringAsFixed(0)),
          ]))),
      ],
    );
  }
}

extension on double {
  double sqrt() => this > 0 ? _sqrt(this) : 0;
  static double _sqrt(double v) {
    double x = v;
    for (int i = 0; i < 20; i++) { x = (x + v / x) / 2; }
    return x;
  }
}
