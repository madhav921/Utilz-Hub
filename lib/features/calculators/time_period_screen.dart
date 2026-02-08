import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Convert between days, weeks, months, years.
/// Always shows output section (with 0s when no input).
class TimePeriodScreen extends StatefulWidget {
  final Color categoryColor;
  const TimePeriodScreen({super.key, required this.categoryColor});

  @override
  State<TimePeriodScreen> createState() => _TimePeriodScreenState();
}

class _TimePeriodScreenState extends State<TimePeriodScreen> {
  final _ctrl = TextEditingController();
  String _from = 'Days';
  static const _units = ['Days', 'Weeks', 'Months', 'Years'];

  double _toDays(double v) {
    switch (_from) {
      case 'Weeks': return v * 7;
      case 'Months': return v * 30.4375;
      case 'Years': return v * 365.25;
      default: return v;
    }
  }

  Map<String, String> _convert() {
    final v = double.tryParse(_ctrl.text) ?? 0;
    final days = _toDays(v);
    return {
      'Days': days.toStringAsFixed(1),
      'Weeks': (days / 7).toStringAsFixed(2),
      'Months': (days / 30.4375).toStringAsFixed(2),
      'Years': (days / 365.25).toStringAsFixed(4),
      'Hours': (days * 24).toStringAsFixed(0),
      'Minutes': (days * 1440).toStringAsFixed(0),
    };
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    final r = _convert();
    return CalculatorScaffold(
      title: 'Time Period',
      accentColor: c,
      toolId: 'time_period',
      categoryName: 'Time & Date',
      exportData: r,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _from,
          decoration: InputDecoration(
            labelText: 'Convert from',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
          onChanged: (v) => setState(() => _from = v!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Value',
            suffixText: _from.toLowerCase(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: r.entries.map((e) =>
                ResultRow(label: e.key, value: e.value),
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
