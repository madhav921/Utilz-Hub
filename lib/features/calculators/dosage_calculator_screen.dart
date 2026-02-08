import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Drug dosage calculator (mg/kg, mg/m²).
class DosageCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const DosageCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<DosageCalculatorScreen> createState() => _DosageCalculatorScreenState();
}

class _DosageCalculatorScreenState extends State<DosageCalculatorScreen> {
  final _weightCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();
  final _concCtrl = TextEditingController();
  int _mode = 0; // 0=mg/kg, 1=total→per-kg

  double get _weight => double.tryParse(_weightCtrl.text) ?? 0;
  double get _dose => double.tryParse(_doseCtrl.text) ?? 0;
  double get _conc => double.tryParse(_concCtrl.text) ?? 0;
  bool get _valid => _weight > 0 && _dose > 0;

  double get _totalDose => _mode == 0 ? _dose * _weight : _dose;
  double get _perKg => _mode == 0 ? _dose : (_weight > 0 ? _dose / _weight : 0);
  double get _volumeML => _conc > 0 ? _totalDose / _conc : 0;

  Map<String, String> get _exportData => _valid
      ? {
          'Weight': '${_weight.toStringAsFixed(1)} kg',
          'Dose/kg': '${_perKg.toStringAsFixed(2)} mg/kg',
          'Total Dose': '${_totalDose.toStringAsFixed(2)} mg',
          if (_volumeML > 0) 'Volume': '${_volumeML.toStringAsFixed(2)} mL',
        }
      : {};

  @override
  void dispose() {
    _weightCtrl.dispose();
    _doseCtrl.dispose();
    _concCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Dosage Calculator',
      accentColor: c,
      toolId: 'dosage_calculator',
      categoryName: 'Health & Body',
      infoText: 'Calculate drug dose by body weight',
      exportData: _exportData,
      children: [
        Center(
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('mg/kg → Total')),
              ButtonSegment(value: 1, label: Text('Total → mg/kg')),
            ],
            selected: {_mode},
            onSelectionChanged: (v) => setState(() => _mode = v.first),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _weightCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Patient Weight',
            suffixText: 'kg',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _doseCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: _mode == 0 ? 'Dose per kg' : 'Total Dose',
            suffixText: _mode == 0 ? 'mg/kg' : 'mg',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _concCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Concentration (optional)',
            suffixText: 'mg/mL',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        if (_valid)
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ResultRow(label: 'Dose/kg', value: '${_perKg.toStringAsFixed(2)} mg/kg'),
                ResultRow(label: 'Total Dose', value: '${_totalDose.toStringAsFixed(2)} mg', isBold: true),
                if (_volumeML > 0) ResultRow(label: 'Volume to give', value: '${_volumeML.toStringAsFixed(2)} mL', isBold: true),
              ]),
            ),
          ),
      ],
    );
  }
}
