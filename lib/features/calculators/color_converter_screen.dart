import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Hex ↔ RGB ↔ HSL color converter.
class ColorConverterScreen extends StatefulWidget {
  final Color categoryColor;
  const ColorConverterScreen({super.key, required this.categoryColor});

  @override
  State<ColorConverterScreen> createState() => _ColorConverterScreenState();
}

class _ColorConverterScreenState extends State<ColorConverterScreen> {
  final _hexCtrl = TextEditingController(text: 'FF5722');
  double _r = 255, _g = 87, _b = 34;

  Color get _color => Color.fromARGB(255, _r.round(), _g.round(), _b.round());
  String get _hex => '${_r.round().toRadixString(16).padLeft(2, '0')}${_g.round().toRadixString(16).padLeft(2, '0')}${_b.round().toRadixString(16).padLeft(2, '0')}'.toUpperCase();

  // HSL conversion
  List<double> get _hsl {
    final r = _r / 255, g = _g / 255, b = _b / 255;
    final mx = [r, g, b].reduce((a, c) => a > c ? a : c);
    final mn = [r, g, b].reduce((a, c) => a < c ? a : c);
    final l = (mx + mn) / 2;
    if (mx == mn) return [0, 0, l * 100];
    final d = mx - mn;
    final s = l > 0.5 ? d / (2 - mx - mn) : d / (mx + mn);
    double h;
    if (mx == r) {
      h = (g - b) / d + (g < b ? 6 : 0);
    } else if (mx == g) {
      h = (b - r) / d + 2;
    } else {
      h = (r - g) / d + 4;
    }
    return [h * 60, s * 100, l * 100];
  }

  void _fromHex(String hex) {
    hex = hex.replaceAll('#', '').trim();
    if (hex.length == 3) hex = hex.split('').map((c) => '$c$c').join();
    if (hex.length != 6) return;
    final v = int.tryParse(hex, radix: 16);
    if (v == null) return;
    setState(() {
      _r = ((v >> 16) & 0xFF).toDouble();
      _g = ((v >> 8) & 0xFF).toDouble();
      _b = (v & 0xFF).toDouble();
    });
  }

  Map<String, String> get _exportData => {
    'HEX': '#$_hex',
    'RGB': 'rgb(${_r.round()}, ${_g.round()}, ${_b.round()})',
    'HSL': 'hsl(${_hsl[0].toStringAsFixed(0)}°, ${_hsl[1].toStringAsFixed(0)}%, ${_hsl[2].toStringAsFixed(0)}%)',
  };

  @override
  void dispose() { _hexCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    final hsl = _hsl;
    return CalculatorScaffold(
      title: 'Color Converter',
      accentColor: c, toolId: 'color_converter', categoryName: 'Digital Tools',
      exportData: _exportData,
      children: [
        // Color preview
        Container(
          height: 80,
          decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade400)),
        ),
        const SizedBox(height: 16),
        // Hex input
        TextField(controller: _hexCtrl,
          decoration: InputDecoration(labelText: 'HEX', prefixText: '#',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (v) { _fromHex(v); },
        ),
        const SizedBox(height: 12),
        // RGB sliders
        _slider('R', _r, Colors.red, (v) => setState(() { _r = v; _hexCtrl.text = _hex; })),
        _slider('G', _g, Colors.green, (v) => setState(() { _g = v; _hexCtrl.text = _hex; })),
        _slider('B', _b, Colors.blue, (v) => setState(() { _b = v; _hexCtrl.text = _hex; })),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
          ResultRow(label: 'HEX', value: '#$_hex', isBold: true),
          ResultRow(label: 'RGB', value: '${_r.round()}, ${_g.round()}, ${_b.round()}'),
          ResultRow(label: 'HSL', value: '${hsl[0].toStringAsFixed(0)}°, ${hsl[1].toStringAsFixed(0)}%, ${hsl[2].toStringAsFixed(0)}%'),
          ResultRow(label: 'CSS', value: 'rgb(${_r.round()}, ${_g.round()}, ${_b.round()})'),
        ]))),
      ],
    );
  }

  Widget _slider(String label, double value, Color clr, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: clr))),
        Expanded(child: Slider(value: value, min: 0, max: 255, divisions: 255, activeColor: clr, onChanged: onChanged)),
        SizedBox(
          width: 50,
          height: 32,
          child: TextField(
            key: ValueKey('$label${value.round()}'),
            controller: TextEditingController(text: '${value.round()}'),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onSubmitted: (t) {
              final v = double.tryParse(t);
              if (v != null) onChanged(v.clamp(0, 255));
            },
          ),
        ),
      ],
    );
  }
}
