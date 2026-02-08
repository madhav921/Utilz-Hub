import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// Work hours calculator — daily/weekly hours and pay.
class WorkHoursScreen extends StatefulWidget {
  final Color categoryColor;
  const WorkHoursScreen({super.key, required this.categoryColor});

  @override
  State<WorkHoursScreen> createState() => _WorkHoursScreenState();
}

class _WorkHoursScreenState extends State<WorkHoursScreen> {
  double _startHour = 9;
  double _endHour = 17;
  double _breakMins = 30;
  double _daysPerWeek = 5;
  double _hourlyRate = 25;

  double get _dailyHours =>
      (_endHour - _startHour) - (_breakMins / 60);
  double get _weeklyHours => _dailyHours * _daysPerWeek;
  double get _monthlyHours => _weeklyHours * 4.33; // avg weeks/month
  double get _dailyPay => _dailyHours * _hourlyRate;
  double get _weeklyPay => _weeklyHours * _hourlyRate;
  double get _monthlyPay => _monthlyHours * _hourlyRate;

  String _formatTime(double hour) {
    final h = hour.floor();
    final m = ((hour - h) * 60).round();
    final amPm = h >= 12 ? 'PM' : 'AM';
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$h12:${m.toString().padLeft(2, '0')} $amPm';
  }

  Map<String, String> get _exportData => {
        'Start': _formatTime(_startHour),
        'End': _formatTime(_endHour),
        'Break': '${_breakMins.round()} min',
        'Daily Hours': _dailyHours.toStringAsFixed(1),
        'Weekly Hours': _weeklyHours.toStringAsFixed(1),
        'Monthly Hours': _monthlyHours.toStringAsFixed(1),
        'Hourly Rate': '\$${_hourlyRate.toStringAsFixed(2)}',
        'Daily Pay': '\$${_dailyPay.toStringAsFixed(2)}',
        'Weekly Pay': '\$${_weeklyPay.toStringAsFixed(2)}',
        'Monthly Pay': '\$${_monthlyPay.toStringAsFixed(2)}',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Work Hours',
      accentColor: c,
      infoText: 'Set your schedule to calculate hours and pay.',
      exportData: _exportData,
      children: [
        SliderInput(
          label: 'Start Time',
          value: _startHour,
          min: 0,
          max: 23,
          suffix: _formatTime(_startHour),
          accentColor: c,
          onChanged: (v) => setState(() => _startHour = v),
        ),
        const SizedBox(height: 4),
        SliderInput(
          label: 'End Time',
          value: _endHour,
          min: 1,
          max: 24,
          suffix: _formatTime(_endHour),
          accentColor: c,
          onChanged: (v) => setState(() => _endHour = v),
        ),
        const SizedBox(height: 4),
        SliderInput(
          label: 'Break',
          value: _breakMins,
          min: 0,
          max: 120,
          suffix: '${_breakMins.round()} min',
          accentColor: c,
          onChanged: (v) => setState(() => _breakMins = v),
        ),
        const SizedBox(height: 4),
        SliderInput(
          label: 'Days / Week',
          value: _daysPerWeek,
          min: 1,
          max: 7,
          suffix: '${_daysPerWeek.round()} days',
          accentColor: c,
          onChanged: (v) => setState(() => _daysPerWeek = v),
        ),
        const SizedBox(height: 4),
        SliderInput(
          label: 'Hourly Rate',
          value: _hourlyRate,
          min: 0,
          max: 500,
          suffix: '\$${_hourlyRate.toStringAsFixed(0)}',
          accentColor: c,
          onChanged: (v) => setState(() => _hourlyRate = v),
        ),
        const SizedBox(height: 24),

        // Hours breakdown
        Card(
          color: c.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hours', style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: c)),
                const SizedBox(height: 8),
                ResultRow(
                    label: 'Daily',
                    value: '${_dailyHours.toStringAsFixed(1)} hrs'),
                const Divider(),
                ResultRow(
                    label: 'Weekly',
                    value: '${_weeklyHours.toStringAsFixed(1)} hrs'),
                const Divider(),
                ResultRow(
                    label: 'Monthly (avg)',
                    value: '${_monthlyHours.toStringAsFixed(1)} hrs'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Pay breakdown
        if (_hourlyRate > 0)
          Card(
            color: c.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pay Estimate', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: c)),
                  const SizedBox(height: 8),
                  ResultRow.currency('Daily', _dailyPay),
                  const Divider(),
                  ResultRow.currency('Weekly', _weeklyPay),
                  const Divider(),
                  ResultRow.currency('Monthly', _monthlyPay),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
