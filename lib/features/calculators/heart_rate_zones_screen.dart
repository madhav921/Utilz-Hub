import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Heart rate zone calculator based on max HR.
class HeartRateZonesScreen extends StatefulWidget {
  final Color categoryColor;
  const HeartRateZonesScreen({super.key, required this.categoryColor});

  @override
  State<HeartRateZonesScreen> createState() => _HeartRateZonesScreenState();
}

class _HeartRateZonesScreenState extends State<HeartRateZonesScreen> {
  double _age = 30;
  double _restHR = 60;

  double get _maxHR => 220 - _age;

  // Karvonen formula zones
  List<_Zone> get _zones => [
    _Zone('Zone 1 – Recovery', 0.50, 0.60, Colors.blue),
    _Zone('Zone 2 – Fat Burn', 0.60, 0.70, Colors.green),
    _Zone('Zone 3 – Aerobic', 0.70, 0.80, Colors.yellow.shade700),
    _Zone('Zone 4 – Anaerobic', 0.80, 0.90, Colors.orange),
    _Zone('Zone 5 – Max Effort', 0.90, 1.00, Colors.red),
  ];

  double _hr(double pct) => ((_maxHR - _restHR) * pct + _restHR);

  Map<String, String> get _exportData => {
    'Age': '${_age.round()}',
    'Resting HR': '${_restHR.round()} bpm',
    'Max HR': '${_maxHR.round()} bpm',
    for (final z in _zones)
      z.name: '${_hr(z.low).round()}–${_hr(z.high).round()} bpm',
  };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Heart Rate Zones',
      accentColor: c,
      toolId: 'heart_rate_zones',
      categoryName: 'Health & Body',
      infoText: 'Based on Karvonen formula (220 − age)',
      exportData: _exportData,
      children: [
        SliderInput(label: 'Age', value: _age, min: 10, max: 90, divisions: 80, suffix: 'yrs', accentColor: c, decimals: 0, onChanged: (v) => setState(() => _age = v)),
        SliderInput(label: 'Resting Heart Rate', value: _restHR, min: 40, max: 100, divisions: 60, suffix: 'bpm', accentColor: c, decimals: 0, onChanged: (v) => setState(() => _restHR = v)),
        const SizedBox(height: 8),
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ResultRow(label: 'Max Heart Rate', value: '${_maxHR.round()} bpm', isBold: true),
          ),
        ),
        const SizedBox(height: 12),
        ...(_zones.map((z) => Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: z.color, radius: 8),
            title: Text(z.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            subtitle: Text('${(z.low * 100).round()}–${(z.high * 100).round()}% HRR'),
            trailing: Text('${_hr(z.low).round()}–${_hr(z.high).round()}',
                style: TextStyle(fontWeight: FontWeight.bold, color: z.color, fontSize: 16)),
          ),
        ))),
      ],
    );
  }
}

class _Zone {
  final String name;
  final double low, high;
  final Color color;
  const _Zone(this.name, this.low, this.high, this.color);
}
