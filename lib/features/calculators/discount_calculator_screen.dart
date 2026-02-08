import 'package:flutter/material.dart';

class DiscountCalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const DiscountCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<DiscountCalculatorScreen> createState() =>
      _DiscountCalculatorScreenState();
}

class _DiscountCalculatorScreenState extends State<DiscountCalculatorScreen> {
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double _discountPercent = 10.0;
  DiscountResult? _result;

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final originalPrice = double.parse(_priceController.text);
    final discountAmount = originalPrice * (_discountPercent / 100);
    final finalPrice = originalPrice - discountAmount;
    final savings = discountAmount;

    setState(() {
      _result = DiscountResult(
        originalPrice: originalPrice,
        discountPercent: _discountPercent,
        discountAmount: discountAmount,
        finalPrice: finalPrice,
        savings: savings,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount Calculator'),
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
                      Icon(Icons.local_offer, color: widget.categoryColor),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Calculate sale prices and savings',
                          style: TextStyle(fontSize: 13),
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
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Original Price',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.categoryColor)),
                          Text('${_discountPercent.toStringAsFixed(0)}%',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: widget.categoryColor)),
                        ],
                      ),
                      Slider(
                        value: _discountPercent,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        activeColor: widget.categoryColor,
                        onChanged: (value) {
                          setState(() {
                            _discountPercent = value;
                            _result = null;
                          });
                        },
                      ),
                      Wrap(
                        spacing: 8,
                        children: [10.0, 20.0, 30.0, 50.0, 70.0].map((percent) {
                          return ChoiceChip(
                            label: Text('${percent.toInt()}%'),
                            selected: _discountPercent == percent,
                            onSelected: (selected) {
                              setState(() {
                                _discountPercent = percent;
                                _result = null;
                              });
                            },
                          );
                        }).toList(),
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
                child: const Text('Calculate', style: TextStyle(fontSize: 18)),
              ),
              if (_result != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: widget.categoryColor.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text('Final Price',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('₹', style: TextStyle(fontSize: 24)),
                            Text(
                              _result!.finalPrice.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: widget.categoryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.savings,
                                  color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'You save ₹${_result!.savings.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
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
                        _buildRow('Original Price',
                            _result!.originalPrice),
                        const Divider(height: 24),
                        _buildRow(
                          'Discount (${_result!.discountPercent}%)',
                          _result!.discountAmount,
                          color: Colors.red,
                        ),
                        const Divider(height: 24),
                        _buildRow(
                          'Final Price',
                          _result!.finalPrice,
                          color: widget.categoryColor,
                          isBold: true,
                        ),
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

  Widget _buildRow(String label, double amount,
      {Color? color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class DiscountResult {
  final double originalPrice;
  final double discountPercent;
  final double discountAmount;
  final double finalPrice;
  final double savings;

  DiscountResult({
    required this.originalPrice,
    required this.discountPercent,
    required this.discountAmount,
    required this.finalPrice,
    required this.savings,
  });
}
