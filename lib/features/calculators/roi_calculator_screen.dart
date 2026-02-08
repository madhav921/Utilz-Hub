import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// ROI (Return on Investment) Calculator.
class RoiCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  const RoiCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<RoiCalculatorScreen> createState() => _RoiCalculatorScreenState();
}

class _RoiCalculatorScreenState extends State<RoiCalculatorScreen> {
  final _investedCtrl = TextEditingController();
  final _returnedCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController(text: '1');

  double? _roi;
  double? _annualizedRoi;
  double? _netProfit;

  void _calculate() {
    final invested = double.tryParse(_investedCtrl.text);
    final returned = double.tryParse(_returnedCtrl.text);
    final years = double.tryParse(_yearsCtrl.text);
    if (invested == null || invested == 0 || returned == null || years == null || years == 0) {
      return;
    }
    setState(() {
      _netProfit = returned - invested;
      _roi = (_netProfit! / invested) * 100;
      _annualizedRoi = _roi! / years;
    });
  }

  Map<String, String> get _exportData => _roi == null
      ? {}
      : {
          'Invested': '₹${_investedCtrl.text}',
          'Returned': '₹${_returnedCtrl.text}',
          'Net Profit': '₹${_netProfit!.toStringAsFixed(2)}',
          'ROI': '${_roi!.toStringAsFixed(2)}%',
          'Annualized ROI': '${_annualizedRoi!.toStringAsFixed(2)}% / yr',
        };

  @override
  void dispose() {
    _investedCtrl.dispose();
    _returnedCtrl.dispose();
    _yearsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'ROI Calculator',
      accentColor: c,
      toolId: 'roi_calculator',
      categoryName: 'Business & Tax',
      infoText: 'ROI = (Gain − Cost) / Cost × 100',
      exportData: _exportData,
      children: [
        TextField(
          controller: _investedCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount Invested',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => _calculate(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _returnedCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount Returned',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => _calculate(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _yearsCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Duration (years)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => _calculate(),
        ),
        if (_roi != null) ...[
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow(
                    label: 'Net Profit',
                    value: '₹${_netProfit!.toStringAsFixed(2)}',
                    color: _netProfit! >= 0 ? Colors.green : Colors.red,
                  ),
                  ResultRow(
                    label: 'Total ROI',
                    value: '${_roi!.toStringAsFixed(2)}%',
                    isBold: true,
                  ),
                  ResultRow(
                    label: 'Annualized ROI',
                    value: '${_annualizedRoi!.toStringAsFixed(2)}% / yr',
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
