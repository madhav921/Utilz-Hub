import 'package:flutter/material.dart';

/// Enhanced GST Calculator with comprehensive features
class GSTCalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const GSTCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<GSTCalculatorScreen> createState() => _GSTCalculatorScreenState();
}

class _GSTCalculatorScreenState extends State<GSTCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  GSTMode _mode = GSTMode.exclusive; // Add GST or Remove GST
  double _gstRate = 18.0;
  GSTResult? _result;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    late GSTResult result;

    if (_mode == GSTMode.exclusive) {
      // Add GST to amount
      final gstAmount = amount * (_gstRate / 100);
      final totalAmount = amount + gstAmount;
      result = GSTResult(
        originalAmount: amount,
        gstAmount: gstAmount,
        finalAmount: totalAmount,
        gstRate: _gstRate,
        cgst: gstAmount / 2,
        sgst: gstAmount / 2,
        mode: _mode,
      );
    } else {
      // Remove GST from amount (amount includes GST)
      final baseAmount = amount / (1 + (_gstRate / 100));
      final gstAmount = amount - baseAmount;
      result = GSTResult(
        originalAmount: baseAmount,
        gstAmount: gstAmount,
        finalAmount: amount,
        gstRate: _gstRate,
        cgst: gstAmount / 2,
        sgst: gstAmount / 2,
        mode: _mode,
      );
    }

    setState(() {
      _result = result;
    });

    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GST Calculator'),
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
              _buildModeSelector(),
              const SizedBox(height: 20),
              _buildAmountInput(),
              const SizedBox(height: 20),
              _buildGSTRateSelector(),
              const SizedBox(height: 24),
              _buildCalculateButton(),
              if (_result != null) ...[
                const SizedBox(height: 24),
                _buildResultCard(),
                const SizedBox(height: 16),
                _buildDetailedBreakdown(),
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
            Icon(Icons.info_outline, color: widget.categoryColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Calculate GST (Goods and Services Tax) with detailed breakdown including CGST and SGST',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GST Mode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.categoryColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildModeOption(
                    GSTMode.exclusive,
                    'Add GST',
                    'Calculate amount with GST',
                    Icons.add_circle_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModeOption(
                    GSTMode.inclusive,
                    'Remove GST',
                    'Extract GST from total',
                    Icons.remove_circle_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
      GSTMode mode, String title, String subtitle, IconData icon) {
    final isSelected = _mode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _mode = mode;
          _result = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.categoryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? widget.categoryColor
                : Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? widget.categoryColor : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? widget.categoryColor : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _mode == GSTMode.exclusive ? 'Base Amount' : 'Total Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.categoryColor,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter amount',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(value) <= 0) {
                  return 'Amount must be greater than 0';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGSTRateSelector() {
    final commonRates = [0.25, 3.0, 5.0, 12.0, 18.0, 28.0];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GST Rate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.categoryColor,
                  ),
                ),
                Text(
                  '${_gstRate.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.categoryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              value: _gstRate,
              min: 0,
              max: 30,
              divisions: 60,
              label: '${_gstRate.toStringAsFixed(1)}%',
              activeColor: widget.categoryColor,
              onChanged: (value) {
                setState(() {
                  _gstRate = value;
                  _result = null;
                });
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: commonRates.map((rate) {
                return ChoiceChip(
                  label: Text('$rate%'),
                  selected: _gstRate == rate,
                  selectedColor: widget.categoryColor.withValues(alpha: 0.3),
                  onSelected: (selected) {
                    setState(() {
                      _gstRate = rate;
                      _result = null;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return ElevatedButton(
      onPressed: _calculate,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.categoryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calculate),
          SizedBox(width: 8),
          Text(
            'Calculate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        color: widget.categoryColor.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: widget.categoryColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                _mode == GSTMode.exclusive
                    ? 'Amount with GST'
                    : 'Base Amount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '₹',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _mode == GSTMode.exclusive
                        ? _result!.finalAmount.toStringAsFixed(2)
                        : _result!.originalAmount.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: widget.categoryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedBreakdown() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detailed Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.categoryColor,
                ),
              ),
              const Divider(height: 24),
              _buildBreakdownRow(
                'Base Amount',
                _result!.originalAmount,
                Icons.money,
              ),
              const SizedBox(height: 12),
              _buildBreakdownRow(
                'GST Amount ($_gstRate%)',
                _result!.gstAmount,
                Icons.receipt,
                color: widget.categoryColor,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  children: [
                    _buildBreakdownRow(
                      'CGST (${(_gstRate / 2).toStringAsFixed(2)}%)',
                      _result!.cgst,
                      Icons.arrow_right,
                      isSubItem: true,
                    ),
                    const SizedBox(height: 8),
                    _buildBreakdownRow(
                      'SGST (${(_gstRate / 2).toStringAsFixed(2)}%)',
                      _result!.sgst,
                      Icons.arrow_right,
                      isSubItem: true,
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              _buildBreakdownRow(
                'Total Amount',
                _result!.finalAmount,
                Icons.account_balance_wallet,
                color: widget.categoryColor,
                isBold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    double amount,
    IconData icon, {
    Color? color,
    bool isBold = false,
    bool isSubItem = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isSubItem ? 16 : 20,
          color: color ?? Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSubItem ? 13 : 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isSubItem ? 13 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

enum GSTMode {
  exclusive, // Add GST
  inclusive, // Remove GST
}

class GSTResult {
  final double originalAmount;
  final double gstAmount;
  final double finalAmount;
  final double gstRate;
  final double cgst;
  final double sgst;
  final GSTMode mode;

  GSTResult({
    required this.originalAmount,
    required this.gstAmount,
    required this.finalAmount,
    required this.gstRate,
    required this.cgst,
    required this.sgst,
    required this.mode,
  });
}

