import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Triangle calculator — area, perimeter & angles.
///
/// Supports two modes:
/// - **Sides**: Enter 3 sides (uses Heron's formula)
/// - **Base & Height**: Direct area calculation
class TriangleScreen extends StatefulWidget {
  final Color categoryColor;
  const TriangleScreen({super.key, required this.categoryColor});

  @override
  State<TriangleScreen> createState() => _TriangleScreenState();
}

class _TriangleScreenState extends State<TriangleScreen> {
  bool _useThreeSides = true;
  final _aCtrl = TextEditingController(text: '3');
  final _bCtrl = TextEditingController(text: '4');
  final _cCtrl = TextEditingController(text: '5');
  final _baseCtrl = TextEditingController(text: '6');
  final _heightCtrl = TextEditingController(text: '4');

  // ── Three-sides calculations (Heron's formula) ──────────

  double _parseCtrl(TextEditingController c) =>
      double.tryParse(c.text) ?? 0;

  void _calculate() => setState(() {});

  Map<String, String> get _exportData {
    if (_useThreeSides) {
      final a = _parseCtrl(_aCtrl);
      final b = _parseCtrl(_bCtrl);
      final c = _parseCtrl(_cCtrl);
      if (!_isValidTriangle(a, b, c)) return {'Error': 'Invalid triangle'};
      final s = (a + b + c) / 2;
      final area = math.sqrt(s * (s - a) * (s - b) * (s - c));
      return {
        'Side A': a.toString(),
        'Side B': b.toString(),
        'Side C': c.toString(),
        'Perimeter': (a + b + c).toStringAsFixed(4),
        'Area': area.toStringAsFixed(4),
      };
    }
    final base = _parseCtrl(_baseCtrl);
    final height = _parseCtrl(_heightCtrl);
    return {
      'Base': base.toString(),
      'Height': height.toString(),
      'Area': (0.5 * base * height).toStringAsFixed(4),
    };
  }

  bool _isValidTriangle(double a, double b, double c) {
    return a > 0 && b > 0 && c > 0 && a + b > c && a + c > b && b + c > a;
  }

  double _angleDeg(double opposite, double adj1, double adj2) {
    // Law of cosines: cosA = (b² + c² - a²) / 2bc
    final cosA = (adj1 * adj1 + adj2 * adj2 - opposite * opposite) /
        (2 * adj1 * adj2);
    return math.acos(cosA.clamp(-1.0, 1.0)) * 180 / math.pi;
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    _cCtrl.dispose();
    _baseCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final col = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Triangle Calculator',
      accentColor: col,
      infoText: _useThreeSides
          ? 'Enter 3 side lengths (Heron\'s formula).'
          : 'Enter base & height for area.',
      exportData: _exportData,
      children: [
        // Mode toggle
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('3 Sides')),
                ButtonSegment(value: false, label: Text('Base & Height')),
              ],
              selected: {_useThreeSides},
              onSelectionChanged: (s) =>
                  setState(() => _useThreeSides = s.first),
            ),
          ),
        ),
        const SizedBox(height: 12),

        if (_useThreeSides) _buildThreeSidesInput(col) else _buildBaseHeight(col),
      ],
    );
  }

  Widget _buildThreeSidesInput(Color c) {
    final a = _parseCtrl(_aCtrl);
    final b = _parseCtrl(_bCtrl);
    final cc = _parseCtrl(_cCtrl);
    final valid = _isValidTriangle(a, b, cc);

    double perimeter = 0, area = 0;
    double angleA = 0, angleB = 0, angleC = 0;
    if (valid) {
      perimeter = a + b + cc;
      final s = perimeter / 2;
      area = math.sqrt(s * (s - a) * (s - b) * (s - cc));
      angleA = _angleDeg(a, b, cc);
      angleB = _angleDeg(b, a, cc);
      angleC = _angleDeg(cc, a, b);
    }

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field(_aCtrl, 'Side A'),
                const SizedBox(height: 12),
                _field(_bCtrl, 'Side B'),
                const SizedBox(height: 12),
                _field(_cCtrl, 'Side C'),
              ],
            ),
          ),
        ),
        if (!valid && (a > 0 || b > 0 || cc > 0)) ...[
          const SizedBox(height: 8),
          Text('Not a valid triangle',
              style: TextStyle(color: Colors.red.shade300)),
        ],
        if (valid) ...[
          const SizedBox(height: 16),
          Card(
            color: c.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow(
                      label: 'Perimeter',
                      value: perimeter.toStringAsFixed(4)),
                  const Divider(),
                  ResultRow(
                      label: 'Area (Heron\'s)',
                      value: area.toStringAsFixed(4)),
                  const Divider(),
                  ResultRow(
                      label: 'Angle A',
                      value: '${angleA.toStringAsFixed(2)}°'),
                  const Divider(),
                  ResultRow(
                      label: 'Angle B',
                      value: '${angleB.toStringAsFixed(2)}°'),
                  const Divider(),
                  ResultRow(
                      label: 'Angle C',
                      value: '${angleC.toStringAsFixed(2)}°'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBaseHeight(Color c) {
    final base = _parseCtrl(_baseCtrl);
    final height = _parseCtrl(_heightCtrl);
    final area = 0.5 * base * height;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field(_baseCtrl, 'Base'),
                const SizedBox(height: 12),
                _field(_heightCtrl, 'Height'),
              ],
            ),
          ),
        ),
        if (base > 0 && height > 0) ...[
          const SizedBox(height: 16),
          Card(
            color: c.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ResultRow(
                  label: 'Area (½ × b × h)', value: area.toStringAsFixed(4)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _field(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (_) => _calculate(),
    );
  }
}
