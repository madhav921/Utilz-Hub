import 'package:flutter/material.dart';
import '../../core/services/live_rates_service.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/live_badge.dart';

/// Live currency converter using cached exchange rates.
class CurrencyConverterScreen extends StatefulWidget {
  final Color categoryColor;
  const CurrencyConverterScreen({super.key, required this.categoryColor});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final _amountCtrl = TextEditingController(text: '100');
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';

  bool _loading = true;
  Map<String, dynamic> _ratesData = {};
  bool _isStale = false;
  String _lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    setState(() => _loading = true);
    final result = await LiveRatesService.getCurrencyRates();
    if (!mounted) return;
    setState(() {
      _ratesData = result.data;
      _isStale = result.isStale;
      _lastUpdated = result.lastUpdated ?? '';
      _loading = false;
    });
  }

  double get _amount => double.tryParse(_amountCtrl.text) ?? 0;

  double get _converted {
    if (_ratesData.isEmpty) return 0;
    return LiveRatesService.convertCurrency(
      _amount,
      _fromCurrency,
      _toCurrency,
      _ratesData,
    );
  }

  double get _rate {
    if (_ratesData.isEmpty) return 0;
    return LiveRatesService.convertCurrency(1, _fromCurrency, _toCurrency, _ratesData);
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Currency Converter',
      accentColor: c,
      children: [
        // Live badge + last updated
        Row(
          children: [
            const LiveBadge(),
            const SizedBox(width: 8),
            if (_lastUpdated.isNotEmpty)
              Text(
                'Updated: $_lastUpdated',
                style: TextStyle(
                  fontSize: 12,
                  color: _isStale ? Colors.orange : Colors.grey,
                ),
              ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh rates',
              onPressed: _fetchRates,
            ),
          ],
        ),
        if (_isStale)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Using cached rates. Connect to internet for live data.',
              style: TextStyle(fontSize: 12, color: Colors.orange.shade300),
            ),
          ),
        const SizedBox(height: 8),

        if (_loading)
          const Center(child: CircularProgressIndicator())
        else ...[
          // Amount input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: _fromCurrency,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Currency selectors
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: _currencyDropdown(
                    _fromCurrency,
                    (v) => setState(() => _fromCurrency = v),
                  )),
                  IconButton(
                    icon: Icon(Icons.swap_horiz, color: c),
                    onPressed: _swapCurrencies,
                  ),
                  Expanded(
                      child: _currencyDropdown(
                    _toCurrency,
                    (v) => setState(() => _toCurrency = v),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Result
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${_amountCtrl.text} $_fromCurrency =',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_converted.toStringAsFixed(2)} $_toCurrency',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: c,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1 $_fromCurrency = ${_rate.toStringAsFixed(4)} $_toCurrency',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _currencyDropdown(String value, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: LiveRatesService.commonCurrencies
          .map((code) => DropdownMenuItem(
                value: code,
                child: Text(
                  '$code - ${LiveRatesService.currencyNames[code] ?? code}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
