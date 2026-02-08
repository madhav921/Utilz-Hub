import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Convert Unix timestamps ↔ human-readable dates.
class TimestampConverterScreen extends StatefulWidget {
  final Color categoryColor;
  const TimestampConverterScreen({super.key, required this.categoryColor});

  @override
  State<TimestampConverterScreen> createState() => _TimestampConverterScreenState();
}

class _TimestampConverterScreenState extends State<TimestampConverterScreen> {
  final _tsCtrl = TextEditingController();
  bool _isSeconds = true;
  DateTime? _pickedDate;
  final _fmt = DateFormat('yyyy-MM-dd HH:mm:ss');

  DateTime? get _fromTimestamp {
    final v = int.tryParse(_tsCtrl.text);
    if (v == null) return null;
    return _isSeconds
        ? DateTime.fromMillisecondsSinceEpoch(v * 1000)
        : DateTime.fromMillisecondsSinceEpoch(v);
  }

  Map<String, String> get _exportData {
    final m = <String, String>{};
    final ts = _fromTimestamp;
    if (ts != null) {
      m['Timestamp'] = _tsCtrl.text;
      m['Date/Time (local)'] = _fmt.format(ts);
      m['Date/Time (UTC)'] = _fmt.format(ts.toUtc());
    }
    if (_pickedDate != null) {
      m['Selected Date'] = _fmt.format(_pickedDate!);
      m['Unix (seconds)'] = '${_pickedDate!.millisecondsSinceEpoch ~/ 1000}';
      m['Unix (milliseconds)'] = '${_pickedDate!.millisecondsSinceEpoch}';
    }
    return m;
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    if (!mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _pickedDate = DateTime(d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0);
    });
  }

  @override
  void dispose() {
    _tsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Timestamp ↔ Date',
      accentColor: c,
      toolId: 'timestamp_converter',
      categoryName: 'Time & Date',
      exportData: _exportData,
      children: [
        // Current timestamp
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.access_time, color: c),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Unix Timestamp'),
                      Text('${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Timestamp → Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tsCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Unix Timestamp',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('sec')),
                ButtonSegment(value: false, label: Text('ms')),
              ],
              selected: {_isSeconds},
              onSelectionChanged: (v) => setState(() => _isSeconds = v.first),
            ),
          ],
        ),
        if (_fromTimestamp != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                ResultRow(label: 'Local', value: _fmt.format(_fromTimestamp!)),
                ResultRow(label: 'UTC', value: _fmt.format(_fromTimestamp!.toUtc())),
                ResultRow(label: 'Day', value: DateFormat('EEEE').format(_fromTimestamp!)),
              ]),
            ),
          ),
        ],
        const SizedBox(height: 24),
        const Text('Date → Timestamp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.calendar_today),
          label: Text(_pickedDate == null ? 'Pick a Date & Time' : _fmt.format(_pickedDate!)),
          style: FilledButton.styleFrom(backgroundColor: c),
        ),
        if (_pickedDate != null) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                ResultRow(label: 'Unix (sec)', value: '${_pickedDate!.millisecondsSinceEpoch ~/ 1000}'),
                ResultRow(label: 'Unix (ms)', value: '${_pickedDate!.millisecondsSinceEpoch}'),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}
