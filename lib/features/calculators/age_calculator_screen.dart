import 'package:flutter/material.dart';

class AgeCalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const AgeCalculatorScreen({super.key, required this.categoryColor});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime _birthDate = DateTime(2000, 1, 1);
  DateTime _currentDate = DateTime.now();

  Duration get _ageDuration => _currentDate.difference(_birthDate);
  int get _years => (_ageDuration.inDays / 365).floor();
  int get _months => ((_ageDuration.inDays % 365) / 30).floor();
  int get _days => (_ageDuration.inDays % 365) % 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Calculator'),
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
                    _buildDatePicker(
                      'Date of Birth',
                      _birthDate,
                      (date) => setState(() => _birthDate = date),
                    ),
                    const SizedBox(height: 20),
                    _buildDatePicker(
                      'Current Date',
                      _currentDate,
                      (date) => setState(() => _currentDate = date),
                    ),
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
                    Text('$_years', style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                    Text('Years Old', style: TextStyle(fontSize: 24, color: widget.categoryColor.withValues(alpha: 0.7))),
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
                    Text('Detailed Age', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAgeDetail('$_years', 'Years'),
                        _buildAgeDetail('$_months', 'Months'),
                        _buildAgeDetail('$_days', 'Days'),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Total Months', '${(_ageDuration.inDays / 30).floor()}'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Total Weeks', '${(_ageDuration.inDays / 7).floor()}'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Total Days', '${_ageDuration.inDays}'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Total Hours', '${_ageDuration.inHours}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(fontSize: 18)),
                Icon(Icons.calendar_today, color: widget.categoryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeDetail(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: widget.categoryColor)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
