import 'package:flutter/material.dart';
import '../../core/utils/formatter.dart';
import '../../widgets/number_input.dart';
import '../../widgets/result_card.dart';
import 'calculator_logic.dart';
import 'calculator_models.dart';

/// Main calculator screen that routes to specific calculators
class CalculatorScreen extends StatelessWidget {
  final String calculatorId;

  const CalculatorScreen({
    super.key,
    required this.calculatorId,
  });

  @override
  Widget build(BuildContext context) {
    switch (calculatorId) {
      case 'percentage':
        return const PercentageCalculatorScreen();
      case 'gst':
        return const GSTCalculatorScreen();
      case 'emi':
        return const EMICalculatorScreen();
      case 'discount':
        return const DiscountCalculatorScreen();
      case 'tip':
        return const TipCalculatorScreen();
      case 'date_difference':
        return const DateDifferenceCalculatorScreen();
      case 'age':
        return const AgeCalculatorScreen();
      case 'simple_interest':
        return const SimpleInterestCalculatorScreen();
      default:
        return Scaffold(
          appBar: AppBar(title: const Text('Calculator')),
          body: const Center(child: Text('Calculator not found')),
        );
    }
  }
}

/// Percentage Calculator
class PercentageCalculatorScreen extends StatefulWidget {
  const PercentageCalculatorScreen({super.key});

  @override
  State<PercentageCalculatorScreen> createState() => _PercentageCalculatorScreenState();
}

class _PercentageCalculatorScreenState extends State<PercentageCalculatorScreen> {
  final _percentageController = TextEditingController();
  final _valueController = TextEditingController();
  double? _result;

  void _calculate() {
    final percentage = NumberFormatter.parseInput(_percentageController.text);
    final value = NumberFormatter.parseInput(_valueController.text);

    if (percentage == null || value == null) {
      setState(() => _result = null);
      return;
    }

    setState(() {
      _result = CalculatorLogic.calculatePercentage(percentage, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Percentage Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NumberInput(
              controller: _percentageController,
              label: 'Percentage (%)',
              hint: 'e.g., 15',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _valueController,
              label: 'Of Value',
              hint: 'e.g., 1000',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Result',
                value: NumberFormatter.format(_result!),
              ),
          ],
        ),
      ),
    );
  }
}

/// GST Calculator
class GSTCalculatorScreen extends StatefulWidget {
  const GSTCalculatorScreen({super.key});

  @override
  State<GSTCalculatorScreen> createState() => _GSTCalculatorScreenState();
}

class _GSTCalculatorScreenState extends State<GSTCalculatorScreen> {
  final _priceController = TextEditingController();
  final _gstRateController = TextEditingController(text: '18');
  bool _addGST = true;
  GSTResult? _result;

  void _calculate() {
    final price = NumberFormatter.parseInput(_priceController.text);
    final gstRate = NumberFormatter.parseInput(_gstRateController.text);

    if (price == null || gstRate == null) {
      setState(() => _result = null);
      return;
    }

    setState(() {
      _result = _addGST
          ? CalculatorLogic.calculateGSTAdd(price, gstRate)
          : CalculatorLogic.calculateGSTRemove(price, gstRate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GST Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Add GST')),
                ButtonSegment(value: false, label: Text('Remove GST')),
              ],
              selected: {_addGST},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _addGST = newSelection.first;
                });
                _calculate();
              },
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _priceController,
              label: _addGST ? 'Base Price' : 'Price (GST Inclusive)',
              hint: 'e.g., 1000',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _gstRateController,
              label: 'GST Rate (%)',
              hint: 'e.g., 18',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Result',
                value: NumberFormatter.formatCurrency(_result!.finalPrice),
                details: [
                  ResultItem(
                    label: 'Base Price',
                    value: NumberFormatter.formatCurrency(_result!.originalPrice),
                  ),
                  ResultItem(
                    label: 'GST Amount',
                    value: NumberFormatter.formatCurrency(_result!.gstAmount),
                  ),
                  ResultItem(
                    label: 'GST Rate',
                    value: '${_result!.gstRate}%',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// EMI Calculator
class EMICalculatorScreen extends StatefulWidget {
  const EMICalculatorScreen({super.key});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _monthsController = TextEditingController();
  EMIResult? _result;

  void _calculate() {
    final principal = NumberFormatter.parseInput(_principalController.text);
    final rate = NumberFormatter.parseInput(_rateController.text);
    final months = NumberFormatter.parseInput(_monthsController.text)?.toInt();

    if (principal == null || rate == null || months == null || months <= 0) {
      setState(() => _result = null);
      return;
    }

    setState(() {
      _result = CalculatorLogic.calculateEMI(principal, rate, months);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NumberInput(
              controller: _principalController,
              label: 'Loan Amount',
              hint: 'e.g., 500000',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _rateController,
              label: 'Annual Interest Rate (%)',
              hint: 'e.g., 10.5',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _monthsController,
              label: 'Loan Tenure (Months)',
              hint: 'e.g., 60',
              allowDecimal: false,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Monthly EMI',
                value: NumberFormatter.formatCurrency(_result!.emi),
                details: [
                  ResultItem(
                    label: 'Principal Amount',
                    value: NumberFormatter.formatCurrency(_result!.principal),
                  ),
                  ResultItem(
                    label: 'Total Interest',
                    value: NumberFormatter.formatCurrency(_result!.totalInterest),
                  ),
                  ResultItem(
                    label: 'Total Payment',
                    value: NumberFormatter.formatCurrency(_result!.totalPayment),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Discount Calculator
class DiscountCalculatorScreen extends StatefulWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  State<DiscountCalculatorScreen> createState() => _DiscountCalculatorScreenState();
}

class _DiscountCalculatorScreenState extends State<DiscountCalculatorScreen> {
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  DiscountResult? _result;

  void _calculate() {
    final price = NumberFormatter.parseInput(_priceController.text);
    final discount = NumberFormatter.parseInput(_discountController.text);

    if (price == null || discount == null) {
      setState(() => _result = null);
      return;
    }

    setState(() {
      _result = CalculatorLogic.calculateDiscount(price, discount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discount Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NumberInput(
              controller: _priceController,
              label: 'Original Price',
              hint: 'e.g., 2000',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _discountController,
              label: 'Discount (%)',
              hint: 'e.g., 20',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Final Price',
                value: NumberFormatter.formatCurrency(_result!.finalPrice),
                details: [
                  ResultItem(
                    label: 'Original Price',
                    value: NumberFormatter.formatCurrency(_result!.originalPrice),
                  ),
                  ResultItem(
                    label: 'Discount',
                    value: NumberFormatter.formatCurrency(_result!.discountAmount),
                  ),
                  ResultItem(
                    label: 'You Save',
                    value: '${_result!.discountPercentage}%',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Tip Calculator
class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final _billController = TextEditingController();
  final _tipController = TextEditingController(text: '10');
  final _peopleController = TextEditingController(text: '1');
  TipResult? _result;

  void _calculate() {
    final bill = NumberFormatter.parseInput(_billController.text);
    final tip = NumberFormatter.parseInput(_tipController.text);
    final people = NumberFormatter.parseInput(_peopleController.text)?.toInt();

    if (bill == null || tip == null || people == null || people <= 0) {
      setState(() => _result = null);
      return;
    }

    setState(() {
      _result = CalculatorLogic.calculateTip(bill, tip, people);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tip Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NumberInput(
              controller: _billController,
              label: 'Bill Amount',
              hint: 'e.g., 500',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _tipController,
              label: 'Tip (%)',
              hint: 'e.g., 10',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _peopleController,
              label: 'Number of People',
              hint: 'e.g., 2',
              allowDecimal: false,
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Total Amount',
                value: NumberFormatter.formatCurrency(_result!.totalAmount),
                details: [
                  ResultItem(
                    label: 'Bill Amount',
                    value: NumberFormatter.formatCurrency(_result!.billAmount),
                  ),
                  ResultItem(
                    label: 'Tip Amount',
                    value: NumberFormatter.formatCurrency(_result!.tipAmount),
                  ),
                  ResultItem(
                    label: 'Per Person',
                    value: NumberFormatter.formatCurrency(_result!.perPerson),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Date Difference Calculator
class DateDifferenceCalculatorScreen extends StatefulWidget {
  const DateDifferenceCalculatorScreen({super.key});

  @override
  State<DateDifferenceCalculatorScreen> createState() => _DateDifferenceCalculatorScreenState();
}

class _DateDifferenceCalculatorScreenState extends State<DateDifferenceCalculatorScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  DateDifferenceResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    setState(() {
      _result = CalculatorLogic.calculateDateDifference(_startDate, _endDate);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _calculate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date Difference')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text('${_startDate.day}/${_startDate.month}/${_startDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('End Date'),
              subtitle: Text('${_endDate.day}/${_endDate.month}/${_endDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Difference',
                value: '${_result!.days} days',
                details: [
                  ResultItem(label: 'Years', value: '${_result!.years}'),
                  ResultItem(label: 'Months', value: '${_result!.months}'),
                  ResultItem(label: 'Days', value: '${_result!.remainingDays}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Age Calculator
class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365 * 25));
  AgeResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    setState(() {
      _result = CalculatorLogic.calculateAge(_birthDate);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
      _calculate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Date of Birth'),
              subtitle: Text('${_birthDate.day}/${_birthDate.month}/${_birthDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Your Age',
                value: '${_result!.years} years',
                details: [
                  ResultItem(label: 'Years', value: '${_result!.years}'),
                  ResultItem(label: 'Months', value: '${_result!.months}'),
                  ResultItem(label: 'Days', value: '${_result!.days}'),
                  ResultItem(label: 'Total Days', value: '${_result!.totalDays}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Simple Interest Calculator
class SimpleInterestCalculatorScreen extends StatefulWidget {
  const SimpleInterestCalculatorScreen({super.key});

  @override
  State<SimpleInterestCalculatorScreen> createState() => _SimpleInterestCalculatorScreenState();
}

class _SimpleInterestCalculatorScreenState extends State<SimpleInterestCalculatorScreen> {
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();
  SimpleInterestResult? _result;

  void _calculate() {
    final principal = NumberFormatter.parseInput(_principalController.text);
    final rate = NumberFormatter.parseInput(_rateController.text);
    final time = NumberFormatter.parseInput(_timeController.text);

    if (principal == null || rate == null || time == null) {
      setState(() => _result = null);
      return;
    }

    setState(() {
      _result = CalculatorLogic.calculateSimpleInterest(principal, rate, time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Interest')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NumberInput(
              controller: _principalController,
              label: 'Principal Amount',
              hint: 'e.g., 10000',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _rateController,
              label: 'Rate of Interest (% per year)',
              hint: 'e.g., 5',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            NumberInput(
              controller: _timeController,
              label: 'Time Period (years)',
              hint: 'e.g., 2',
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_result != null)
              ResultCard(
                title: 'Total Amount',
                value: NumberFormatter.formatCurrency(_result!.totalAmount),
                details: [
                  ResultItem(
                    label: 'Principal',
                    value: NumberFormatter.formatCurrency(_result!.principal),
                  ),
                  ResultItem(
                    label: 'Interest',
                    value: NumberFormatter.formatCurrency(_result!.interest),
                  ),
                  ResultItem(
                    label: 'Rate',
                    value: '${_result!.rate}%',
                  ),
                  ResultItem(
                    label: 'Time',
                    value: '${_result!.time} years',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
