import 'package:flutter/material.dart';
import 'dart:math' as math;

class SIPCalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const SIPCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<SIPCalculatorScreen> createState() => _SIPCalculatorScreenState();
}

class _SIPCalculatorScreenState extends State<SIPCalculatorScreen> {
  double _monthlyInvestment = 5000;
  double _expectedReturn = 12.0;
  double _timePeriod = 10.0;

  double get _totalInvestment => _monthlyInvestment * _timePeriod * 12;
  double get _futureValue {
    final r = _expectedReturn / 100 / 12;
    final n = _timePeriod * 12;
    return _monthlyInvestment * ((math.pow(1 + r, n) - 1) / r) * (1 + r);
  }
  double get _estimatedReturns => _futureValue - _totalInvestment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIP Calculator'),
        backgroundColor: widget.categoryColor.withValues(alpha: 0.1),
        foregroundColor: widget.categoryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: widget.categoryColor.withValues(alpha: 0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 28),
                    SizedBox(width: 12),
                    Expanded(child: Text('Calculate your Systematic Investment Plan (SIP) returns', style: TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSlider('Monthly Investment', _monthlyInvestment, 500, 100000, (v) => setState(() => _monthlyInvestment = v), '₹'),
                    const SizedBox(height: 20),
                    _buildSlider('Expected Return (p.a.)', _expectedReturn, 1, 30, (v) => setState(() => _expectedReturn = v), '%'),
                    const SizedBox(height: 20),
                    _buildSlider('Time Period', _timePeriod, 1, 40, (v) => setState(() => _timePeriod = v), 'years'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: widget.categoryColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Estimated Returns', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('₹', style: TextStyle(fontSize: 24)),
                        Text(_futureValue.toStringAsFixed(0), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow('Total Investment', _totalInvestment),
                    const SizedBox(height: 12),
                    _buildRow('Estimated Gains', _estimatedReturns, color: Colors.green),
                    const Divider(height: 24),
                    _buildRow('Future Value', _futureValue, color: widget.categoryColor, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
            Text('${value.toStringAsFixed(suffix == '₹' ? 0 : (suffix == 'years' ? 0 : 2))} $suffix', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.categoryColor)),
          ],
        ),
        Slider(value: value, min: min, max: max, divisions: 100, activeColor: widget.categoryColor, onChanged: onChanged),
      ],
    );
  }

  Widget _buildRow(String label, double amount, {Color? color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text('₹${amount.toStringAsFixed(0)}', style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color)),
      ],
    );
  }
}
