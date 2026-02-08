import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_with_input.dart';

/// Loan Prepayment / Foreclosure Savings Calculator.
class LoanPrepaymentScreen extends StatefulWidget {
  final Color categoryColor;
  const LoanPrepaymentScreen({super.key, required this.categoryColor});

  @override
  State<LoanPrepaymentScreen> createState() => _LoanPrepaymentScreenState();
}

class _LoanPrepaymentScreenState extends State<LoanPrepaymentScreen> {
  double _outstanding = 1000000;
  double _rate = 9.0;
  int _remainingMonths = 120;
  double _prepayAmount = 200000;

  Map<String, double> _result = {};

  void _calculate() {
    final mr = _rate / 12 / 100;
    if (mr == 0) return;

    // EMI without prepayment
    final emi = (_outstanding * mr * math.pow(1 + mr, _remainingMonths)) /
        (math.pow(1 + mr, _remainingMonths) - 1);
    final totalWithout = emi * _remainingMonths;
    final interestWithout = totalWithout - _outstanding;

    // After prepayment
    final newPrincipal = _outstanding - _prepayAmount;
    if (newPrincipal <= 0) {
      setState(() {
        _result = {
          'emi_before': emi,
          'total_interest_before': interestWithout,
          'interest_saved': interestWithout,
          'months_saved': _remainingMonths.toDouble(),
        };
      });
      return;
    }

    // Option: keep EMI same, reduce tenure
    final newMonths =
        (math.log(emi / (emi - newPrincipal * mr)) / math.log(1 + mr));
    final totalWith = emi * newMonths;
    final interestWith = totalWith - newPrincipal;

    setState(() {
      _result = {
        'emi_before': emi,
        'total_interest_before': interestWithout,
        'total_interest_after': interestWith,
        'interest_saved': interestWithout - interestWith,
        'months_before': _remainingMonths.toDouble(),
        'months_after': newMonths.ceilToDouble(),
        'months_saved':
            (_remainingMonths - newMonths.ceil()).toDouble(),
      };
    });
  }

  Map<String, String> get _exportData {
    if (_result.isEmpty) return {};
    return _result.map((k, v) => MapEntry(
        k.replaceAll('_', ' ').toUpperCase(), v.toStringAsFixed(0)));
  }

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Loan Prepayment',
      accentColor: c,
      toolId: 'loan_prepayment',
      categoryName: 'Finance & Loans',
      infoText:
          'See how much interest you save with a lump-sum prepayment.',
      exportData: _exportData,
      children: [
        _label('Outstanding Balance', c),
        SliderWithInput(
          value: _outstanding,
          min: 10000,
          max: 10000000,
          divisions: 100,
          activeColor: c,
          onChanged: (v) => setState(() {
            _outstanding = v;
            _calculate();
          }),
        ),
        const SizedBox(height: 12),
        _label('Interest Rate (% p.a.)', c),
        SliderWithInput(
          value: _rate,
          min: 1,
          max: 25,
          divisions: 240,
          activeColor: c,
          decimalPlaces: 1,
          onChanged: (v) => setState(() {
            _rate = v;
            _calculate();
          }),
        ),
        const SizedBox(height: 12),
        _label('Remaining Tenure (months)', c),
        SliderWithInput(
          value: _remainingMonths.toDouble(),
          min: 6,
          max: 360,
          divisions: 354,
          activeColor: c,
          onChanged: (v) => setState(() {
            _remainingMonths = v.toInt();
            _calculate();
          }),
        ),
        const SizedBox(height: 12),
        _label('Prepayment Amount', c),
        SliderWithInput(
          value: _prepayAmount.clamp(0, _outstanding),
          min: 0,
          max: _outstanding,
          divisions: 100,
          activeColor: c,
          onChanged: (v) => setState(() {
            _prepayAmount = v;
            _calculate();
          }),
        ),
        if (_result.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Results',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: c)),
                  const Divider(),
                  ResultRow(
                    label: 'Monthly EMI',
                    value:
                        '₹${_result['emi_before']?.toStringAsFixed(0) ?? '-'}',
                  ),
                  if (_result.containsKey('interest_saved'))
                    ResultRow(
                      label: 'Interest Saved',
                      value:
                          '₹${_result['interest_saved']!.toStringAsFixed(0)}',
                      isBold: true,
                      color: Colors.green,
                    ),
                  if (_result.containsKey('months_saved'))
                    ResultRow(
                      label: 'Months Saved',
                      value:
                          '${_result['months_saved']!.toStringAsFixed(0)} months',
                    ),
                  if (_result.containsKey('months_after'))
                    ResultRow(
                      label: 'New Tenure',
                      value:
                          '${_result['months_after']!.toStringAsFixed(0)} months',
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _label(String text, Color c) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: c)),
      );
}
