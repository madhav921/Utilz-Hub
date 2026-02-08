import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Countdown — days remaining until a target date.
class CountdownScreen extends StatefulWidget {
  final Color categoryColor;
  const CountdownScreen({super.key, required this.categoryColor});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  DateTime _targetDate = DateTime.now().add(const Duration(days: 90));
  String _eventName = '';

  int get _daysLeft {
    final now = DateTime.now();
    return _targetDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  int get _weeksLeft => _daysLeft ~/ 7;
  int get _hoursLeft =>
      _targetDate.difference(DateTime.now()).inHours.clamp(0, 999999);

  bool get _isPast => _daysLeft < 0;

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Map<String, String> get _exportData => {
        if (_eventName.isNotEmpty) 'Event': _eventName,
        'Target Date': _formatDate(_targetDate),
        'Days Left': _daysLeft.toString(),
        'Weeks Left': _weeksLeft.toString(),
        'Hours Left': _hoursLeft.toString(),
      };

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Countdown Timer',
      accentColor: c,
      infoText: 'Pick a target date to see the countdown.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Event Name (optional)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) => setState(() => _eventName = v),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Target Date',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: Icon(Icons.calendar_today, color: c),
                    ),
                    child: Text(
                      _formatDate(_targetDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Big countdown display
        Card(
          color: _isPast
              ? Colors.red.withValues(alpha: 0.1)
              : c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                if (_eventName.isNotEmpty) ...[
                  Text(
                    _eventName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  _isPast ? 'Past!' : '${_daysLeft.abs()}',
                  style: TextStyle(
                    fontSize: _isPast ? 36 : 64,
                    fontWeight: FontWeight.bold,
                    color: _isPast ? Colors.red : c,
                  ),
                ),
                Text(
                  _isPast
                      ? '${_daysLeft.abs()} days ago'
                      : _daysLeft == 1
                          ? 'day left'
                          : 'days left',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (!_isPast)
          Card(
            color: c.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow(
                      label: 'Weeks',
                      value: '$_weeksLeft wk ${_daysLeft % 7} d'),
                  const Divider(),
                  ResultRow(
                      label: 'Hours', value: _hoursLeft.toString()),
                  const Divider(),
                  ResultRow(
                      label: 'Minutes',
                      value: (_hoursLeft * 60).toString()),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
