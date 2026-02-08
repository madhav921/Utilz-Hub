import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Water tank capacity calculator for common shapes.
class TankCapacityScreen extends StatefulWidget {
  final Color categoryColor;
  const TankCapacityScreen({super.key, required this.categoryColor});

  @override
  State<TankCapacityScreen> createState() => _TankCapacityScreenState();
}

class _TankCapacityScreenState extends State<TankCapacityScreen> {
  int _shape = 0; // 0=cylinder, 1=rectangular
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  final _ctrl3 = TextEditingController();

  bool get _valid {
    final a = double.tryParse(_ctrl1.text) ?? 0;
    final b = double.tryParse(_ctrl2.text) ?? 0;
    return a > 0 && b > 0 && (_shape == 0 || (double.tryParse(_ctrl3.text) ?? 0) > 0);
  }

  double get _volumeL {
    final a = double.tryParse(_ctrl1.text) ?? 0;
    final b = double.tryParse(_ctrl2.text) ?? 0;
    final c = double.tryParse(_ctrl3.text) ?? 0;
    if (_shape == 0) {
      // Cylinder: diameter(cm) × height(cm) → liters
      final r = a / 2 / 100; // m
      return pi * r * r * (b / 100) * 1000;
    } else {
      // Rectangular: L × W × H (cm) → liters
      return a * b * c / 1000;
    }
  }

  double get _gallons => _volumeL * 0.264172;

  Map<String, String> get _exportData => _valid
      ? {
          'Shape': _shape == 0 ? 'Cylinder' : 'Rectangular',
          'Capacity (L)': _volumeL.toStringAsFixed(1),
          'Capacity (gal)': _gallons.toStringAsFixed(1),
        }
      : {};

  @override
  void dispose() { _ctrl1.dispose(); _ctrl2.dispose(); _ctrl3.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Tank Capacity',
      accentColor: c, toolId: 'tank_capacity', categoryName: 'Engineering',
      infoText: 'Calculate water tank volume in liters', exportData: _exportData,
      children: [
        Center(child: SegmentedButton<int>(
          segments: const [ButtonSegment(value: 0, label: Text('Cylinder'), icon: Icon(Icons.circle_outlined)), ButtonSegment(value: 1, label: Text('Rectangular'), icon: Icon(Icons.crop_square))],
          selected: {_shape}, onSelectionChanged: (v) { _ctrl1.clear(); _ctrl2.clear(); _ctrl3.clear(); setState(() => _shape = v.first); },
        )),
        const SizedBox(height: 16),
        if (_shape == 0) ...[
          _field(_ctrl1, 'Diameter', 'cm'),
          const SizedBox(height: 12),
          _field(_ctrl2, 'Height', 'cm'),
        ] else ...[
          _field(_ctrl1, 'Length', 'cm'),
          const SizedBox(height: 12),
          _field(_ctrl2, 'Width', 'cm'),
          const SizedBox(height: 12),
          _field(_ctrl3, 'Height', 'cm'),
        ],
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text('${_volumeL.toStringAsFixed(1)} L', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: c)),
            const Text('capacity'),
            const Divider(),
            ResultRow(label: 'US Gallons', value: _gallons.toStringAsFixed(1)),
            ResultRow(label: 'Cubic meters', value: (_volumeL / 1000).toStringAsFixed(3)),
          ]))),
      ],
    );
  }

  Widget _field(TextEditingController ctrl, String label, String unit) => TextField(
    controller: ctrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(labelText: label, suffixText: unit, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
    onChanged: (_) => setState(() {}),
  );
}
