import 'package:flutter/material.dart';
import '../../core/services/live_rates_service.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/live_badge.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Independent live silver price screen with region/currency selection.
class SilverPriceScreen extends StatefulWidget {
  final Color categoryColor;
  const SilverPriceScreen({super.key, required this.categoryColor});

  @override
  State<SilverPriceScreen> createState() => _SilverPriceScreenState();
}

class _SilverPriceScreenState extends State<SilverPriceScreen> {
  bool _loading = true;
  double _silverOz = 0;
  double _silverGram = 0;
  bool _isStale = false;
  String _lastUpdated = '';

  String _currency = 'USD';
  Map<String, dynamic> _currencyRates = {};

  double _weightGrams = 100;

  // Silver purity grades
  static const _grades = {
    '999 (Fine)': 0.999,
    '925 (Sterling)': 0.925,
    '900 (Coin)': 0.900,
    '800': 0.800,
  };
  String _selectedGrade = '999 (Fine)';

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      LiveRatesService.getMetalPrices(),
      LiveRatesService.getCurrencyRates(),
    ]);
    if (!mounted) return;

    final metals = results[0];
    final currencies = results[1];

    setState(() {
      _silverOz = (metals.data['silver_oz'] as num?)?.toDouble() ?? 0;
      _silverGram = (metals.data['silver_gram'] as num?)?.toDouble() ?? 0;
      _isStale = metals.isStale;
      _lastUpdated = metals.lastUpdated ?? '';
      _currencyRates = currencies.data;
      _loading = false;
    });
  }

  double _localPrice(double usdPrice) {
    if (_currency == 'USD') return usdPrice;
    return LiveRatesService.metalPriceInCurrency(
        usdPrice, _currency, _currencyRates);
  }

  String get _sym => _currencySymbols[_currency] ?? _currency;

  double get _pricePerGram =>
      _localPrice(_silverGram) * (_grades[_selectedGrade] ?? 1.0);
  double get _totalValue => _pricePerGram * _weightGrams;

  Map<String, String> get _exportData => {
        'Metal': 'Silver',
        'Grade': _selectedGrade,
        'Currency': _currency,
        'Price/oz (USD)': '\$${_silverOz.toStringAsFixed(2)}',
        'Price/gram': '$_sym${_pricePerGram.toStringAsFixed(2)}',
        'Weight': '${_weightGrams.toStringAsFixed(1)} g',
        'Total Value': '$_sym${_totalValue.toStringAsFixed(2)}',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Silver Price',
      accentColor: c,
      toolId: 'silver_price',
      categoryName: 'Live Rates',
      exportData: _exportData,
      children: [
        _liveStatusRow(c),
        const SizedBox(height: 8),

        if (_loading)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator()))
        else ...[
          // Currency selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Text('Currency:',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: LiveRatesService.commonCurrencies.contains(_currency)
                          ? _currency
                          : 'USD',
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      items: LiveRatesService.commonCurrencies
                          .map((code) => DropdownMenuItem(
                                value: code,
                                child: Text(
                                    '$code - ${LiveRatesService.currencyNames[code] ?? code}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _currency = v);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Price card
          Card(
            color: const Color(0xFFC0C0C0).withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.circle,
                      color: Colors.grey.shade400, size: 40),
                  const SizedBox(height: 8),
                  Text('Silver (Fine)',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400)),
                  const SizedBox(height: 4),
                  Text(
                      '$_sym${_localPrice(_silverOz).toStringAsFixed(2)} / troy oz',
                      style: const TextStyle(fontSize: 16)),
                  Text(
                      '$_sym${_localPrice(_silverGram).toStringAsFixed(2)} / gram',
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Grade selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Purity Grade',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _grades.keys
                        .map((g) => ChoiceChip(
                              label: Text(g),
                              selected: _selectedGrade == g,
                              onSelected: (_) =>
                                  setState(() => _selectedGrade = g),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          SliderInput(
            label: 'Weight',
            value: _weightGrams,
            min: 1,
            max: 5000,
            suffix: '${_weightGrams.toStringAsFixed(0)} g',
            accentColor: c,
            onChanged: (v) => setState(() => _weightGrams = v),
          ),
          const SizedBox(height: 20),

          Card(
            color: c.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow(
                      label: 'Price/gram ($_selectedGrade)',
                      value: '$_sym${_pricePerGram.toStringAsFixed(2)}'),
                  const Divider(),
                  ResultRow(
                      label: 'Total (${_weightGrams.toStringAsFixed(0)}g)',
                      value: '$_sym${_totalValue.toStringAsFixed(2)}',
                      isBold: true,
                      color: c),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _liveStatusRow(Color c) {
    return Row(
      children: [
        const LiveBadge(),
        const SizedBox(width: 8),
        if (_lastUpdated.isNotEmpty)
          Text('Updated: $_lastUpdated',
              style: TextStyle(
                  fontSize: 12,
                  color: _isStale ? Colors.orange : Colors.grey)),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: _fetchAll,
        ),
      ],
    );
  }

  static const _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'INR': '₹',
    'JPY': '¥',
    'CNY': '¥',
    'AED': 'د.إ',
    'SAR': '﷼',
  };
}
