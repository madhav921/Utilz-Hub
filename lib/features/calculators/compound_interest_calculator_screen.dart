import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompoundInterestCalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const CompoundInterestCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<CompoundInterestCalculatorScreen> createState() => _CompoundInterestCalculatorScreenState();
}

class _CompoundInterestCalculatorScreenState extends State<CompoundInterestCalculatorScreen> {
  double _principal = 100000;
  double _rate = 8.0;
  double _time = 5.0;
  int _compoundFrequency = 12; // Monthly

  double get _amount => _principal * math.pow(1 + (_rate / 100) / _compoundFrequency, _compoundFrequency * _time);
  double get _interest => _amount - _principal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compound Interest'),
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
                    _buildSlider('Principal', _principal, 1000, 10000000, (v) => setState(() => _principal = v)),
                    const SizedBox(height: 20),
                    _buildSlider('Rate (%)', _rate, 1, 30, (v) => setState(() => _rate = v)),
                    const SizedBox(height: 20),
                    _buildSlider('Time (years)', _time, 1, 30, (v) => setState(() => _time = v)),
                    const SizedBox(height: 20),
                    _buildCompoundingSelector(),
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
                    const Text('Maturity Amount', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('₹', style: TextStyle(fontSize: 24)),
                        Text(_amount.toStringAsFixed(2), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: widget.categoryColor)),
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
                    _buildRow('Principal', _principal),
                    const SizedBox(height: 12),
                    _buildRow('Interest Earned', _interest, color: Colors.green),
                    const Divider(height: 24),
                    _buildRow('Total Amount', _amount, color: widget.categoryColor, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompoundingSelector() {
    final frequencies = {
      1: 'Annually',
      2: 'Half-Yearly',
      4: 'Quarterly',
      12: 'Monthly',
      365: 'Daily',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Compounding Frequency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: frequencies.entries.map((entry) {
            return ChoiceChip(
              label: Text(entry.value),
              selected: _compoundFrequency == entry.key,
              selectedColor: widget.categoryColor.withValues(alpha: 0.3),
              onSelected: (selected) {
                setState(() => _compoundFrequency = entry.key);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
            Text(value.toStringAsFixed(label.contains('Principal') ? 0 : 2), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.categoryColor)),
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
