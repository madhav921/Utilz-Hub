import 'package:flutter/material.dart';

enum PercentageMode {
  basic,
  change,
}

class PercentageCalculatorScreen extends StatefulWidget {
  final Color categoryColor;
  final PercentageMode mode;

  const PercentageCalculatorScreen({
    super.key,
    required this.categoryColor,
    this.mode = PercentageMode.basic,
  });

  @override
  State<PercentageCalculatorScreen> createState() =>
      _PercentageCalculatorScreenState();
}

class _PercentageCalculatorScreenState
    extends State<PercentageCalculatorScreen> {
  final _value1Controller = TextEditingController();
  final _value2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PercentageMode _mode = PercentageMode.basic;
  double? _result;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  void dispose() {
    _value1Controller.dispose();
    _value2Controller.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final value1 = double.parse(_value1Controller.text);
    final value2 = double.parse(_value2Controller.text);

    setState(() {
      if (_mode == PercentageMode.basic) {
        // Calculate: What is X% of Y?
        _result = (value1 / 100) * value2;
      } else {
        // Calculate percentage change
        _result = ((value2 - value1) / value1) * 100;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == PercentageMode.basic
            ? 'Percentage Calculator'
            : 'Percentage Change'),
        backgroundColor: widget.categoryColor.withValues(alpha: 0.1),
        foregroundColor: widget.categoryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                color: widget.categoryColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: widget.categoryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _mode == PercentageMode.basic
                              ? 'Calculate: What is X% of Y?'
                              : 'Calculate % increase or decrease',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
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
                      TextFormField(
                        controller: _value1Controller,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: _mode == PercentageMode.basic
                              ? 'Percentage (%)'
                              : 'Original Value',
                          prefixIcon: Icon(Icons.calculate,
                              color: widget.categoryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _value2Controller,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: _mode == PercentageMode.basic
                              ? 'Total Value'
                              : 'New Value',
                          prefixIcon: Icon(Icons.numbers,
                              color: widget.categoryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.categoryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('Calculate',
                    style: TextStyle(fontSize: 18)),
              ),
              if (_result != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: widget.categoryColor.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle,
                            color: widget.categoryColor, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _mode == PercentageMode.basic
                              ? 'Result'
                              : 'Percentage Change',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _mode == PercentageMode.basic
                              ? _result!.toStringAsFixed(2)
                              : '${_result!.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: widget.categoryColor,
                          ),
                        ),
                        if (_mode == PercentageMode.change) ...[
                          const SizedBox(height: 8),
                          Text(
                            _result! >= 0 ? 'Increase' : 'Decrease',
                            style: TextStyle(
                              fontSize: 16,
                              color: _result! >= 0
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
