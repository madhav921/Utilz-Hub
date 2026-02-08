import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Wood volume calculator (board feet, cubic meters).
class WoodVolumeScreen extends StatefulWidget {
  final Color categoryColor;
  const WoodVolumeScreen({super.key, required this.categoryColor});

  @override
  State<WoodVolumeScreen> createState() => _WoodVolumeScreenState();
}

class _WoodVolumeScreenState extends State<WoodVolumeScreen> {
  final _lCtrl = TextEditingController();
  final _wCtrl = TextEditingController();
  final _tCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');

  double get _l => double.tryParse(_lCtrl.text) ?? 0; // ft
  double get _w => double.tryParse(_wCtrl.text) ?? 0; // in
  double get _t => double.tryParse(_tCtrl.text) ?? 0; // in
  int get _qty => int.tryParse(_qtyCtrl.text) ?? 1;
  bool get _valid => _l > 0 && _w > 0 && _t > 0;

  double get _boardFeet => (_t * _w * _l * 12) / 144 * _qty; // standard board foot
  double get _cubicFeet => (_t / 12) * (_w / 12) * _l * _qty;
  double get _cubicMeters => _cubicFeet * 0.0283168;

  Map<String, String> get _exportData => _valid
      ? {
          'Dimensions': '$_t″ × $_w″ × $_l′',
          'Quantity': '$_qty',
          'Board Feet': _boardFeet.toStringAsFixed(2),
          'Cubic Feet': _cubicFeet.toStringAsFixed(3),
          'Cubic Meters': _cubicMeters.toStringAsFixed(4),
        }
      : {};

  @override
  void dispose() { _lCtrl.dispose(); _wCtrl.dispose(); _tCtrl.dispose(); _qtyCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Wood Volume',
      accentColor: c, toolId: 'wood_volume', categoryName: 'Engineering',
      infoText: 'Board feet = T(in) × W(in) × L(ft) / 12', exportData: _exportData,
      children: [
        TextField(controller: _tCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Thickness', suffixText: 'inches', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _wCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Width', suffixText: 'inches', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _lCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Length', suffixText: 'feet', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        TextField(controller: _qtyCtrl, keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Quantity', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            ResultRow(label: 'Board Feet', value: _boardFeet.toStringAsFixed(2), isBold: true),
            ResultRow(label: 'Cubic Feet', value: _cubicFeet.toStringAsFixed(3)),
            ResultRow(label: 'Cubic Meters', value: _cubicMeters.toStringAsFixed(4)),
          ]))),
      ],
    );
  }
}
