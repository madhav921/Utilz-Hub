import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Body Surface Area (BSA) calculator – DuBois & Mosteller.
class BsaCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const BsaCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<BsaCalculatorScreen> createState() => _BsaCalculatorScreenState();
}

class _BsaCalculatorScreenState extends State<BsaCalculatorScreen> {
  final _htCtrl = TextEditingController();
  final _wtCtrl = TextEditingController();

  double get _ht => double.tryParse(_htCtrl.text) ?? 0;
  double get _wt => double.tryParse(_wtCtrl.text) ?? 0;
  bool get _valid => _ht > 0 && _wt > 0;

  double get _dubois => 0.007184 * pow(_ht, 0.725) * pow(_wt, 0.425);
  double get _mosteller => sqrt(_ht * _wt / 3600);

  Map<String, String> get _exportData => _valid
      ? {
          'Height': '${_ht.toStringAsFixed(0)} cm',
          'Weight': '${_wt.toStringAsFixed(1)} kg',
          'BSA (DuBois)': '${_dubois.toStringAsFixed(4)} m²',
          'BSA (Mosteller)': '${_mosteller.toStringAsFixed(4)} m²',
        }
      : {};

  @override
  void dispose() {
    _htCtrl.dispose();
    _wtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Body Surface Area',
      accentColor: c,
      toolId: 'bsa_calculator',
      categoryName: 'Health & Body',
      infoText: 'BSA is used for drug dosing & clinical formulas',
      exportData: _exportData,
      children: [
        TextField(
          controller: _htCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Height',
            suffixText: 'cm',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _wtCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Weight',
            suffixText: 'kg',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        if (_valid) ...[
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ResultRow(label: 'DuBois formula', value: '${_dubois.toStringAsFixed(4)} m²', isBold: true),
                ResultRow(label: 'Mosteller formula', value: '${_mosteller.toStringAsFixed(4)} m²'),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reference Ranges', style: TextStyle(fontWeight: FontWeight.bold, color: c)),
                  const Divider(),
                  const ResultRow(label: 'Average adult male', value: '1.7–2.0 m²'),
                  const ResultRow(label: 'Average adult female', value: '1.5–1.8 m²'),
                  const ResultRow(label: 'Newborn', value: '0.2–0.25 m²'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
