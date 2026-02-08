import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Flat / commercial space buying cost calculator.
class FlatBuyingScreen extends StatefulWidget {
  final Color categoryColor;
  const FlatBuyingScreen({super.key, required this.categoryColor});

  @override
  State<FlatBuyingScreen> createState() => _FlatBuyingScreenState();
}

class _FlatBuyingScreenState extends State<FlatBuyingScreen> {
  final _baseCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  // Editable percentages
  double _stampPercent = 0.06;
  double _regPercent = 0.01;
  double _gstPercent = 0.05;
  double _brokeragePercent = 0.01;
  final double _maintenanceMonths = 12;
  final double _maintenancePerSqft = 4;

  double get _basePricePerSqft => double.tryParse(_baseCtrl.text) ?? 0;
  double get _areaSqft => double.tryParse(_areaCtrl.text) ?? 0;
  bool get _valid => _basePricePerSqft > 0 && _areaSqft > 0;

  double get _baseTotal => _basePricePerSqft * _areaSqft;
  double get _stamp => _baseTotal * _stampPercent;
  double get _reg => _baseTotal * _regPercent;
  double get _gst => _baseTotal * _gstPercent;
  double get _brokerage => _baseTotal * _brokeragePercent;
  double get _maintenance => _areaSqft * _maintenancePerSqft * _maintenanceMonths;
  double get _totalCost => _baseTotal + _stamp + _reg + _gst + _brokerage + _maintenance;

  Map<String, String> get _exportData => _valid
      ? {
          'Base Price': '₹${_basePricePerSqft.toStringAsFixed(0)}/sqft',
          'Area': '${_areaSqft.toStringAsFixed(0)} sqft',
          'Agreement Value': '₹${_baseTotal.toStringAsFixed(0)}',
          'Stamp Duty (${(_stampPercent * 100).toStringAsFixed(1)}%)': '₹${_stamp.toStringAsFixed(0)}',
          'Registration (${(_regPercent * 100).toStringAsFixed(1)}%)': '₹${_reg.toStringAsFixed(0)}',
          'GST (${(_gstPercent * 100).toStringAsFixed(0)}%)': '₹${_gst.toStringAsFixed(0)}',
          'Brokerage': '₹${_brokerage.toStringAsFixed(0)}',
          'Maintenance Fund': '₹${_maintenance.toStringAsFixed(0)}',
          'Total Cost': '₹${_totalCost.toStringAsFixed(0)}',
        }
      : {};

  @override
  void dispose() {
    _baseCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Flat / Property Buying',
      accentColor: c,
      toolId: 'flat_buying',
      categoryName: 'Real Estate & Vehicle',
      infoText: 'Estimate total cost of buying a flat or commercial space',
      exportData: _exportData,
      children: [
        TextField(
          controller: _baseCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Base Price per sqft',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _areaCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Carpet / Built-up Area',
            suffixText: 'sqft',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 14),
        const Text('Adjust Percentages', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        _pctField('Stamp Duty %', _stampPercent, (v) => _stampPercent = v),
        const SizedBox(height: 8),
        _pctField('Registration %', _regPercent, (v) => _regPercent = v),
        const SizedBox(height: 8),
        _pctField('GST %', _gstPercent, (v) => _gstPercent = v),
        const SizedBox(height: 8),
        _pctField('Brokerage %', _brokeragePercent, (v) => _brokeragePercent = v),
        const SizedBox(height: 20),
        // Always show output
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              ResultRow(label: 'Agreement Value', value: '₹${_baseTotal.toStringAsFixed(0)}'),
              ResultRow(label: 'Stamp Duty', value: '₹${_stamp.toStringAsFixed(0)}'),
              ResultRow(label: 'Registration', value: '₹${_reg.toStringAsFixed(0)}'),
              ResultRow(label: 'GST', value: '₹${_gst.toStringAsFixed(0)}'),
              ResultRow(label: 'Brokerage', value: '₹${_brokerage.toStringAsFixed(0)}'),
              ResultRow(label: 'Maintenance Fund', value: '₹${_maintenance.toStringAsFixed(0)}'),
              const Divider(),
              ResultRow(label: 'Total Cost', value: '₹${_totalCost.toStringAsFixed(0)}', isBold: true),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _pctField(String label, double value, ValueChanged<double> onChanged) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: '%',
        hintText: (value * 100).toStringAsFixed(1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (t) {
        final v = double.tryParse(t);
        if (v != null) setState(() => onChanged(v / 100));
      },
    );
  }
}
