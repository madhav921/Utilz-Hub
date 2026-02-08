import 'package:flutter/material.dart';

class TipCalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const TipCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final _billController = TextEditingController();
  double _tipPercent = 15.0;
  int _splitCount = 1;
  TipResult? _result;

  void _calculate() {
    if (_billController.text.isEmpty) return;
    
    final billAmount = double.parse(_billController.text);
    final tipAmount = billAmount * (_tipPercent / 100);
    final totalAmount = billAmount + tipAmount;
    final perPerson = totalAmount / _splitCount;

    setState(() {
      _result = TipResult(
        billAmount: billAmount,
        tipPercent: _tipPercent,
        tipAmount: tipAmount,
        totalAmount: totalAmount,
        splitCount: _splitCount,
        perPerson: perPerson,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Calculator'),
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
                child: TextFormField(
                  controller: _billController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Bill Amount',
                    prefixIcon: const Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tip Percentage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                        Text('${_tipPercent.toStringAsFixed(0)}%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                      ],
                    ),
                    Slider(
                      value: _tipPercent,
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: widget.categoryColor,
                      onChanged: (value) {
                        setState(() {
                          _tipPercent = value;
                          _calculate();
                        });
                      },
                    ),
                    Wrap(
                      spacing: 8,
                      children: [10.0, 15.0, 18.0, 20.0, 25.0].map((percent) {
                        return ChoiceChip(
                          label: Text('${percent.toInt()}%'),
                          selected: _tipPercent == percent,
                          onSelected: (selected) {
                            setState(() {
                              _tipPercent = percent;
                              _calculate();
                            });
                          },
                        );
                      }).toList(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Split Bill', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                        Text('$_splitCount ${_splitCount == 1 ? 'person' : 'people'}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: _splitCount > 1 ? () {
                            setState(() {
                              _splitCount--;
                              _calculate();
                            });
                          } : null,
                        ),
                        ...List.generate(
                          _splitCount > 5 ? 1 : _splitCount,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.person, color: widget.categoryColor),
                          ),
                        ),
                        if (_splitCount > 5)
                          Text(' × $_splitCount', style: TextStyle(color: widget.categoryColor, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _splitCount < 20 ? () {
                            setState(() {
                              _splitCount++;
                              _calculate();
                            });
                          } : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: widget.categoryColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('Amount Per Person', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('₹', style: TextStyle(fontSize: 24)),
                          Text(_result!.perPerson.toStringAsFixed(2), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: widget.categoryColor)),
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
                      _buildRow('Bill Amount', _result!.billAmount),
                      const Divider(height: 24),
                      _buildRow('Tip (${_result!.tipPercent}%)', _result!.tipAmount, color: Colors.green),
                      const Divider(height: 24),
                      _buildRow('Total Amount', _result!.totalAmount, color: widget.categoryColor, isBold: true),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
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

class TipResult {
  final double billAmount;
  final double tipPercent;
  final double tipAmount;
  final double totalAmount;
  final int splitCount;
  final double perPerson;

  TipResult({required this.billAmount, required this.tipPercent, required this.tipAmount, required this.totalAmount, required this.splitCount, required this.perPerson});
}
