import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Enhanced EMI Calculator
class EMICalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const EMICalculatorScreen({super.key, required this.categoryColor});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _tenureController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double _principal = 1000000;
  double _interestRate = 8.5;
  int _tenure = 12; // in months
  TenureMode _tenureMode = TenureMode.years;

  EMIResult? _result;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final principal = double.parse(_principalController.text.isEmpty
        ? _principal.toString()
        : _principalController.text);
    final annualRate = double.parse(_rateController.text.isEmpty
        ? _interestRate.toString()
        : _rateController.text);
    final months = _tenureMode == TenureMode.years
        ? int.parse(_tenureController.text.isEmpty
                ? (_tenure / 12).toString()
                : _tenureController.text) *
            12
        : int.parse(_tenureController.text.isEmpty
            ? _tenure.toString()
            : _tenureController.text);

    final monthlyRate = annualRate / 12 / 100;
    final emi = (principal *
            monthlyRate *
            math.pow(1 + monthlyRate, months)) /
        (math.pow(1 + monthlyRate, months) - 1);

    final totalPayment = emi * months;
    final totalInterest = totalPayment - principal;

    setState(() {
      _result = EMIResult(
        emi: emi,
        totalPayment: totalPayment,
        totalInterest: totalInterest,
        principal: principal,
        months: months,
        interestRate: annualRate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI Calculator'),
        backgroundColor: widget.categoryColor.withValues(alpha: 0.1),
        foregroundColor: widget.categoryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 20),
              _buildPrincipalSlider(),
              const SizedBox(height: 20),
              _buildInterestSlider(),
              const SizedBox(height: 20),
              _buildTenureSelector(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.categoryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Calculate EMI',
                    style: TextStyle(fontSize: 18)),
              ),
              if (_result != null) ...[
                const SizedBox(height: 24),
                _buildResultCard(),
                const SizedBox(height: 16),
                _buildBreakdownCard(),
                const SizedBox(height: 16),
                _buildPieChart(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: widget.categoryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: widget.categoryColor),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Calculate your Equated Monthly Installment (EMI) for loans',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipalSlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loan Amount',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.categoryColor)),
                Text('₹${_principal.toStringAsFixed(0)}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.categoryColor)),
              ],
            ),
            Slider(
              value: _principal,
              min: 10000,
              max: 10000000,
              divisions: 100,
              activeColor: widget.categoryColor,
              onChanged: (value) {
                setState(() {
                  _principal = value;
                  _result = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestSlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Interest Rate (p.a.)',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.categoryColor)),
                Text('${_interestRate.toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.categoryColor)),
              ],
            ),
            Slider(
              value: _interestRate,
              min: 1,
              max: 30,
              divisions: 290,
              activeColor: widget.categoryColor,
              onChanged: (value) {
                setState(() {
                  _interestRate = value;
                  _result = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenureSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loan Tenure',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.categoryColor)),
                SegmentedButton<TenureMode>(
                  segments: const [
                    ButtonSegment(
                        value: TenureMode.years, label: Text('Years')),
                    ButtonSegment(
                        value: TenureMode.months, label: Text('Months')),
                  ],
                  selected: {_tenureMode},
                  onSelectionChanged: (Set<TenureMode> newSelection) {
                    setState(() {
                      _tenureMode = newSelection.first;
                      _result = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _tenureMode == TenureMode.years
                      ? '${(_tenure / 12).toStringAsFixed(0)} Years'
                      : '$_tenure Months',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.categoryColor),
                ),
              ],
            ),
            Slider(
              value: _tenure.toDouble(),
              min: _tenureMode == TenureMode.years ? 12 : 6,
              max: _tenureMode == TenureMode.years ? 360 : 360,
              divisions: _tenureMode == TenureMode.years ? 29 : 354,
              activeColor: widget.categoryColor,
              onChanged: (value) {
                setState(() {
                  _tenure = value.toInt();
                  _result = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      color: widget.categoryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Monthly EMI', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('₹', style: TextStyle(fontSize: 24)),
                Text(
                  _result!.emi.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: widget.categoryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Breakdown',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.categoryColor)),
            const Divider(height: 24),
            _buildRow('Principal Amount', _result!.principal),
            const SizedBox(height: 12),
            _buildRow('Total Interest', _result!.totalInterest,
                color: Colors.orange),
            const SizedBox(height: 12),
            _buildRow('Total Payment', _result!.totalPayment,
                color: widget.categoryColor, isBold: true),
            const Divider(height: 24),
            _buildRow('Loan Tenure', null,
                value: '${_result!.months} months'),
            const SizedBox(height: 8),
            _buildRow('Interest Rate', null,
                value: '${_result!.interestRate.toStringAsFixed(2)}% p.a.'),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, double? amount,
      {Color? color, bool isBold = false, String? value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(
          value ?? '₹${amount!.toStringAsFixed(0)}',
          style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    final principalPercent =
        (_result!.principal / _result!.totalPayment) * 100;
    final interestPercent =
        (_result!.totalInterest / _result!.totalPayment) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Payment Distribution',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.categoryColor)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                    'Principal', principalPercent, widget.categoryColor),
                _buildLegendItem('Interest', interestPercent, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, double percent, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(
              '${percent.toStringAsFixed(1)}%',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

enum TenureMode { years, months }

class EMIResult {
  final double emi;
  final double totalPayment;
  final double totalInterest;
  final double principal;
  final int months;
  final double interestRate;

  EMIResult({
    required this.emi,
    required this.totalPayment,
    required this.totalInterest,
    required this.principal,
    required this.months,
    required this.interestRate,
  });
}
