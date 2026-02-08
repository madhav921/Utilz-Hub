import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Salary breakup calculator (CTC → in-hand) with **editable** percentages
/// and the ability to add custom earning / deduction fields.
class SalaryBreakupScreen extends StatefulWidget {
  final Color categoryColor;
  const SalaryBreakupScreen({super.key, required this.categoryColor});

  @override
  State<SalaryBreakupScreen> createState() => _SalaryBreakupScreenState();
}

class _SalaryBreakupScreenState extends State<SalaryBreakupScreen> {
  final _ctcCtrl = TextEditingController();

  // ── Editable percentage controllers ────────────────────
  final _basicPctCtrl = TextEditingController(text: '40');
  final _hraPctCtrl = TextEditingController(text: '50'); // of basic
  final _daPctCtrl = TextEditingController(text: '10'); // of basic
  final _pfPctCtrl = TextEditingController(text: '12'); // of basic
  final _insuranceCtrl = TextEditingController(text: '1800');
  final _profTaxCtrl = TextEditingController(text: '2400');

  // ── Custom fields ──────────────────────────────────────
  final List<_CustomField> _customEarnings = [];
  final List<_CustomField> _customDeductions = [];

  double get _ctc => double.tryParse(_ctcCtrl.text) ?? 0;
  double get _basicPct => double.tryParse(_basicPctCtrl.text) ?? 40;
  double get _hraPct => double.tryParse(_hraPctCtrl.text) ?? 50;
  double get _daPct => double.tryParse(_daPctCtrl.text) ?? 10;
  double get _pfPct => double.tryParse(_pfPctCtrl.text) ?? 12;
  double get _insurance => double.tryParse(_insuranceCtrl.text) ?? 1800;
  double get _profTax => double.tryParse(_profTaxCtrl.text) ?? 2400;

  double get _basic => _ctc * _basicPct / 100;
  double get _hra => _basic * _hraPct / 100;
  double get _da => _basic * _daPct / 100;
  double get _pf => _basic * _pfPct / 100;

  double get _customEarningsTotal =>
      _customEarnings.fold(0.0, (s, f) => s + f.amount);
  double get _customDeductionsTotal =>
      _customDeductions.fold(0.0, (s, f) => s + f.amount);

  double get _special =>
      _ctc - _basic - _hra - _da - _pf - _insurance - _customEarningsTotal;
  double get _totalDeductions =>
      _pf + _insurance + _profTax + _customDeductionsTotal;
  double get _annual => _ctc - _totalDeductions;
  double get _monthly => _annual / 12;

  String _fmt(double v) => '₹${v.toStringAsFixed(0)}';

  Map<String, String> get _exportData => {
        'CTC': _fmt(_ctc),
        'Basic ($_basicPct%)': _fmt(_basic),
        'HRA ($_hraPct% of Basic)': _fmt(_hra),
        'DA ($_daPct% of Basic)': _fmt(_da),
        'Special Allowance': _fmt(_special),
        for (final f in _customEarnings) f.name: _fmt(f.amount),
        'PF ($_pfPct% of Basic)': _fmt(_pf),
        'Medical Insurance': _fmt(_insurance),
        'Professional Tax': _fmt(_profTax),
        for (final f in _customDeductions) f.name: _fmt(f.amount),
        'Total Deductions': _fmt(_totalDeductions),
        'In-Hand (Annual)': _fmt(_annual),
        'In-Hand (Monthly)': _fmt(_monthly),
      };

  @override
  void dispose() {
    _ctcCtrl.dispose();
    _basicPctCtrl.dispose();
    _hraPctCtrl.dispose();
    _daPctCtrl.dispose();
    _pfPctCtrl.dispose();
    _insuranceCtrl.dispose();
    _profTaxCtrl.dispose();
    for (final f in _customEarnings) {
      f.dispose();
    }
    for (final f in _customDeductions) {
      f.dispose();
    }
    super.dispose();
  }

  void _addCustomField(bool isEarning) {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add ${isEarning ? "Earning" : "Deduction"}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amtCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Annual Amount', prefixText: '₹ '),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final amt = double.tryParse(amtCtrl.text) ?? 0;
                if (name.isNotEmpty) {
                  setState(() {
                    final field = _CustomField(name: name, amount: amt);
                    if (isEarning) {
                      _customEarnings.add(field);
                    } else {
                      _customDeductions.add(field);
                    }
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Salary Breakup',
      accentColor: c,
      toolId: 'salary_breakup',
      categoryName: 'Business & Tax',
      infoText: 'Enter annual CTC. Tap % fields to customise breakup.',
      exportData: _exportData,
      children: [
        TextField(
          controller: _ctcCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Annual CTC',
            prefixText: '₹ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        // ── Editable Percentages ──────────────────────────
        _EditablePercentagesCard(
          accentColor: c,
          children: [
            _pctRow('Basic %', _basicPctCtrl),
            _pctRow('HRA (% of Basic)', _hraPctCtrl),
            _pctRow('DA (% of Basic)', _daPctCtrl),
            _pctRow('PF (% of Basic)', _pfPctCtrl),
            _amtRow('Insurance (₹/yr)', _insuranceCtrl),
            _amtRow('Prof. Tax (₹/yr)', _profTaxCtrl),
          ],
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: 20),
        // ── Earnings ──────────────────────────────────────
        _section('Earnings', [
          ResultRow(label: 'Basic ($_basicPct%)', value: _fmt(_basic)),
          ResultRow(label: 'HRA ($_hraPct% of Basic)', value: _fmt(_hra)),
          ResultRow(label: 'DA ($_daPct% of Basic)', value: _fmt(_da)),
          ResultRow(label: 'Special Allowance', value: _fmt(_special)),
          for (final f in _customEarnings)
            Row(
              children: [
                Expanded(
                    child: ResultRow(label: f.name, value: _fmt(f.amount))),
                IconButton(
                  icon: Icon(Icons.close, size: 16, color: Colors.red.shade300),
                  onPressed: () =>
                      setState(() => _customEarnings.remove(f)),
                ),
              ],
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addCustomField(true),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Earning'),
            ),
          ),
        ], c),
        const SizedBox(height: 12),
        // ── Deductions ────────────────────────────────────
        _section('Deductions', [
          ResultRow(label: 'PF ($_pfPct% of Basic)', value: _fmt(_pf)),
          ResultRow(label: 'Medical Insurance', value: _fmt(_insurance)),
          ResultRow(label: 'Professional Tax', value: _fmt(_profTax)),
          for (final f in _customDeductions)
            Row(
              children: [
                Expanded(
                    child: ResultRow(label: f.name, value: _fmt(f.amount))),
                IconButton(
                  icon: Icon(Icons.close, size: 16, color: Colors.red.shade300),
                  onPressed: () =>
                      setState(() => _customDeductions.remove(f)),
                ),
              ],
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addCustomField(false),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Deduction'),
            ),
          ),
          const Divider(),
          ResultRow(
              label: 'Total Deductions',
              value: _fmt(_totalDeductions),
              isBold: true),
        ], Colors.red),
        const SizedBox(height: 12),
        // ── Summary ───────────────────────────────────────
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ResultRow(
                    label: 'In-Hand (Annual)',
                    value: _fmt(_annual),
                    isBold: true),
                const Divider(),
                ResultRow(
                    label: 'In-Hand (Monthly)',
                    value: _fmt(_monthly),
                    isBold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _section(String title, List<Widget> rows, Color accent) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: accent)),
            const Divider(),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _pctRow(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label)),
          Expanded(
            flex: 2,
            child: TextField(
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                suffixText: '%',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amtRow(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label)),
          Expanded(
            flex: 2,
            child: TextField(
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '₹',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}

/// Expandable card showing editable percentage fields.
class _EditablePercentagesCard extends StatelessWidget {
  final Color accentColor;
  final List<Widget> children;
  final VoidCallback onChanged;

  const _EditablePercentagesCard({
    required this.accentColor,
    required this.children,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(Icons.tune, color: accentColor),
        title: const Text('Customise Breakup',
            style: TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

/// Helper model for custom earning/deduction fields.
class _CustomField {
  final String name;
  final double amount;
  final TextEditingController _nameCtrl;
  final TextEditingController _amtCtrl;

  _CustomField({required this.name, required this.amount})
      : _nameCtrl = TextEditingController(text: name),
        _amtCtrl = TextEditingController(text: amount.toStringAsFixed(0));

  void dispose() {
    _nameCtrl.dispose();
    _amtCtrl.dispose();
  }
}
