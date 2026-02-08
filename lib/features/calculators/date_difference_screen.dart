import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Calculate the difference between two dates in days, weeks, months, years.
class DateDifferenceScreen extends StatefulWidget {
  final Color categoryColor;
  const DateDifferenceScreen({super.key, required this.categoryColor});

  @override
  State<DateDifferenceScreen> createState() => _DateDifferenceScreenState();
}

class _DateDifferenceScreenState extends State<DateDifferenceScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  int get _totalDays => _endDate.difference(_startDate).inDays.abs();
  int get _totalWeeks => _totalDays ~/ 7;
  int get _remainingDays => _totalDays % 7;
  int get _totalHours => _endDate.difference(_startDate).inHours.abs();

  /// Human-readable years, months, days breakdown.
  String get _breakdown {
    DateTime earlier = _startDate.isBefore(_endDate) ? _startDate : _endDate;
    DateTime later = _startDate.isBefore(_endDate) ? _endDate : _startDate;

    int years = later.year - earlier.year;
    int months = later.month - earlier.month;
    int days = later.day - earlier.day;

    if (days < 0) {
      months -= 1;
      // Days in previous month
      final prevMonth = DateTime(later.year, later.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    final parts = <String>[];
    if (years > 0) parts.add('$years year${years > 1 ? 's' : ''}');
    if (months > 0) parts.add('$months month${months > 1 ? 's' : ''}');
    if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');
    return parts.isEmpty ? '0 days' : parts.join(', ');
  }

  Map<String, String> get _exportData => {
        'Start Date': _formatDate(_startDate),
        'End Date': _formatDate(_endDate),
        'Breakdown': _breakdown,
        'Total Days': _totalDays.toString(),
        'Total Hours': _totalHours.toString(),
      };

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Date Difference',
      accentColor: c,
      infoText: 'Select two dates to find the difference.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _dateRow('Start Date', _startDate, () => _pickDate(true), c),
                const SizedBox(height: 16),
                _dateRow('End Date', _endDate, () => _pickDate(false), c),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Big result
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '$_totalDays',
                  style: TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold, color: c),
                ),
                const Text('total days', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: c.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ResultRow(label: 'Breakdown', value: _breakdown),
                const Divider(),
                ResultRow(
                    label: 'Weeks + Days',
                    value: '$_totalWeeks wk $_remainingDays d'),
                const Divider(),
                ResultRow(label: 'Total Hours', value: _totalHours.toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateRow(
      String label, DateTime date, VoidCallback onTap, Color c) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.calendar_today, color: c),
        ),
        child: Text(
          _formatDate(date),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
