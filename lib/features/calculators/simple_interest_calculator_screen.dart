import 'package:flutter/material.dart';

class SimpleInterestCalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const SimpleInterestCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<SimpleInterestCalculatorScreen> createState() => _SimpleInterestCalculatorScreenState();
}

class _SimpleInterestCalculatorScreenState extends State<SimpleInterestCalculatorScreen> {
  double _principal = 100000;
  double _rate = 8.0;
  double _time = 5.0;
  
  double get _interest => (_principal * _rate * _time) / 100;
  double get _totalAmount => _principal + _interest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Interest'),
        backgroundColor: widget.categoryColor.withValues(alpha: 0.1),
        foregroundColor: widget.categoryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSlider('Principal Amount', _principal, 1000, 10000000, (v) => setState(() => _principal = v), '₹'),
                    const SizedBox(height: 20),
                    _buildSlider('Interest Rate (p.a.)', _rate, 1, 30, (v) => setState(() => _rate = v), '%'),
                    const SizedBox(height: 20),
                    _buildSlider('Time Period', _time, 1, 30, (v) => setState(() => _time = v), 'years'),
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
                    const Text('Total Amount', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('₹', style: TextStyle(fontSize: 24)),
                        Text(_totalAmount.toStringAsFixed(2), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: widget.categoryColor)),
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
                    Text('Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                    const Divider(height: 24),
                    _buildRow('Principal', _principal),
                    const SizedBox(height: 12),
                    _buildRow('Interest Earned', _interest, color: Colors.green),
                    const Divider(height: 24),
                    _buildRow('Total Amount', _totalAmount, color: widget.categoryColor, isBold: true),
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
        Text('₹${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color)),
      ],
    );
  }
}
