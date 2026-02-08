import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Kid-friendly counting helper with visual dots.
class CountingHelperScreen extends StatefulWidget {
  final Color categoryColor;
  const CountingHelperScreen({super.key, required this.categoryColor});

  @override
  State<CountingHelperScreen> createState() => _CountingHelperScreenState();
}

class _CountingHelperScreenState extends State<CountingHelperScreen> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Counting Helper',
      accentColor: c,
      toolId: 'counting_helper',
      categoryName: 'Math & Numbers',
      infoText: 'Tap + or − to count. See the dots!',
      exportData: {'Count': '$_count'},
      children: [
        // Big number display
        Center(
          child: Text(
            '$_count',
            style: TextStyle(fontSize: 96, fontWeight: FontWeight.w900, color: c),
          ),
        ),
        // Visual dots grid
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(
                _count,
                (i) => Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.primaries[i % Colors.primaries.length],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${i + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bigBtn(Icons.remove, () {
              if (_count > 1) setState(() => _count--);
            }, Colors.red),
            const SizedBox(width: 24),
            _bigBtn(Icons.refresh, () => setState(() => _count = 1), Colors.grey),
            const SizedBox(width: 24),
            _bigBtn(Icons.add, () {
              if (_count < 100) setState(() => _count++);
            }, Colors.green),
          ],
        ),
        const SizedBox(height: 16),
        // Slider for quick jump
        Slider(
          value: _count.toDouble(),
          min: 1,
          max: 100,
          divisions: 99,
          activeColor: c,
          label: '$_count',
          onChanged: (v) => setState(() => _count = v.round()),
        ),
        Center(
          child: Text('Slide to pick a number (1–100)',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _bigBtn(IconData icon, VoidCallback onTap, Color color) {
    return Material(
      color: color.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Icon(icon, size: 36, color: color),
        ),
      ),
    );
  }
}
