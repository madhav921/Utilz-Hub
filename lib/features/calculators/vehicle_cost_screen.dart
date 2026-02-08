import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Vehicle purchase cost calculator (car / bike / EV).
class VehicleCostScreen extends StatefulWidget {
  final Color categoryColor;
  const VehicleCostScreen({super.key, required this.categoryColor});

  @override
  State<VehicleCostScreen> createState() => _VehicleCostScreenState();
}

class _VehicleCostScreenState extends State<VehicleCostScreen> {
  final _exShowroomCtrl = TextEditingController();
  int _type = 0; // 0=Car, 1=Bike, 2=EV
  static const _types = ['Car', 'Bike', 'Electric Vehicle'];
  static const _defaultRTO = [0.08, 0.06, 0.04]; // approx % of ex-showroom
  static const _defaultInsurance = [0.04, 0.03, 0.035];

  // Editable percentages
  late double _rtoPercent = _defaultRTO[0];
  late double _insurancePercent = _defaultInsurance[0];
  double _accessoriesAmt = 0;
  double _extendedWarrantyAmt = 0;

  double get _exShowroom => double.tryParse(_exShowroomCtrl.text) ?? 0;
  bool get _valid => _exShowroom > 0;

  double get _rto => _exShowroom * _rtoPercent;
  double get _insurance => _exShowroom * _insurancePercent;
  double get _tcs => _exShowroom > 1000000 ? _exShowroom * 0.01 : 0;
  double get _onRoad => _exShowroom + _rto + _insurance + _tcs + _accessoriesAmt + _extendedWarrantyAmt;

  Map<String, String> get _exportData => _valid
      ? {
          'Vehicle Type': _types[_type],
          'Ex-Showroom': '₹${_exShowroom.toStringAsFixed(0)}',
          'RTO (${(_rtoPercent * 100).toStringAsFixed(1)}%)': '₹${_rto.toStringAsFixed(0)}',
          'Insurance': '₹${_insurance.toStringAsFixed(0)}',
          if (_tcs > 0) 'TCS (1%)': '₹${_tcs.toStringAsFixed(0)}',
          if (_accessoriesAmt > 0) 'Accessories': '₹${_accessoriesAmt.toStringAsFixed(0)}',
          if (_extendedWarrantyAmt > 0) 'Ext. Warranty': '₹${_extendedWarrantyAmt.toStringAsFixed(0)}',
          'On-Road Price': '₹${_onRoad.toStringAsFixed(0)}',
        }
      : {};

  @override
  void dispose() {
    _exShowroomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Vehicle Cost',
      accentColor: c,
      toolId: 'vehicle_cost',
      categoryName: 'Real Estate & Vehicle',
      infoText: 'Estimate on-road price for car, bike or EV',
      exportData: _exportData,
      children: [
        SegmentedButton<int>(
          segments: List.generate(3, (i) => ButtonSegment(value: i, label: Text(_types[i]))),
          selected: {_type},
          onSelectionChanged: (v) => setState(() {
            _type = v.first;
            _rtoPercent = _defaultRTO[_type];
            _insurancePercent = _defaultInsurance[_type];
          }),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _exShowroomCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Ex-Showroom Price',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _percentField('RTO / Road Tax', _rtoPercent, (v) => _rtoPercent = v),
        const SizedBox(height: 10),
        _percentField('Insurance', _insurancePercent, (v) => _insurancePercent = v),
        const SizedBox(height: 10),
        _amountField('Accessories (optional)', _accessoriesAmt, (v) => _accessoriesAmt = v),
        const SizedBox(height: 10),
        _amountField('Ext. Warranty (optional)', _extendedWarrantyAmt, (v) => _extendedWarrantyAmt = v),
        const SizedBox(height: 20),
        // Always show output
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              ResultRow(label: 'Ex-Showroom', value: '₹${_exShowroom.toStringAsFixed(0)}'),
              ResultRow(label: 'RTO (${(_rtoPercent * 100).toStringAsFixed(1)}%)', value: '₹${_rto.toStringAsFixed(0)}'),
              ResultRow(label: 'Insurance (${(_insurancePercent * 100).toStringAsFixed(1)}%)', value: '₹${_insurance.toStringAsFixed(0)}'),
              if (_tcs > 0) ResultRow(label: 'TCS (1%)', value: '₹${_tcs.toStringAsFixed(0)}'),
              if (_accessoriesAmt > 0) ResultRow(label: 'Accessories', value: '₹${_accessoriesAmt.toStringAsFixed(0)}'),
              if (_extendedWarrantyAmt > 0) ResultRow(label: 'Ext. Warranty', value: '₹${_extendedWarrantyAmt.toStringAsFixed(0)}'),
              const Divider(),
              ResultRow(label: 'On-Road Price', value: '₹${_onRoad.toStringAsFixed(0)}', isBold: true),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _percentField(String label, double value, ValueChanged<double> onChanged) {
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

  Widget _amountField(String label, double value, ValueChanged<double> onChanged) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: '₹ ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (t) {
        final v = double.tryParse(t);
        setState(() => onChanged(v ?? 0));
      },
    );
  }
}
