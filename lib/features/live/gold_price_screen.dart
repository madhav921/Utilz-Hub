import 'package:flutter/material.dart';
import '../../core/services/live_rates_service.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/live_badge.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Independent live gold price screen with region/currency selection.
class GoldPriceScreen extends StatefulWidget {
  final Color categoryColor;
  const GoldPriceScreen({super.key, required this.categoryColor});

  @override
  State<GoldPriceScreen> createState() => _GoldPriceScreenState();
}

class _GoldPriceScreenState extends State<GoldPriceScreen> {
  bool _loading = true;
  double _goldOz = 0;
  double _goldGram = 0;
  bool _isStale = false;
  String _lastUpdated = '';

  // Region / currency
  String _currency = 'USD';
  Map<String, dynamic> _currencyRates = {};

  // Weight input
  double _weightGrams = 10;

  // Karats
  static const _karats = {
    '24K': 1.0,
    '22K': 22 / 24,
    '18K': 18 / 24,
    '14K': 14 / 24,
  };
  String _selectedKarat = '24K';

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() => _loading = true);
    // Fetch metal prices and currency rates independently in parallel
    final results = await Future.wait([
      LiveRatesService.getMetalPrices(),
      LiveRatesService.getCurrencyRates(),
    ]);
    if (!mounted) return;

    final metals = results[0];
    final currencies = results[1];

    setState(() {
      _goldOz = (metals.data['gold_oz'] as num?)?.toDouble() ?? 0;
      _goldGram = (metals.data['gold_gram'] as num?)?.toDouble() ?? 0;
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
      _localPrice(_goldGram) * (_karats[_selectedKarat] ?? 1.0);
  double get _totalValue => _pricePerGram * _weightGrams;

  Map<String, String> get _exportData => {
        'Metal': 'Gold',
        'Karat': _selectedKarat,
        'Currency': _currency,
        'Price/oz (USD)': '\$${_goldOz.toStringAsFixed(2)}',
        'Price/gram': '$_sym${_pricePerGram.toStringAsFixed(2)}',
        'Weight': '${_weightGrams.toStringAsFixed(1)} g',
        'Total Value': '$_sym${_totalValue.toStringAsFixed(2)}',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Gold Price',
      accentColor: c,
      toolId: 'gold_price',
      categoryName: 'Live Rates',
      exportData: _exportData,
      children: [
        // Live status row
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
                  const Text('Region / Currency:',
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
                                child: Text('$code - ${LiveRatesService.currencyNames[code] ?? code}',
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

          // Base price card
          Card(
            color: const Color(0xFFFFD700).withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.circle, color: Color(0xFFFFD700), size: 40),
                  const SizedBox(height: 8),
                  Text('Gold (24K)',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade300)),
                  const SizedBox(height: 4),
                  Text('$_sym${_localPrice(_goldOz).toStringAsFixed(2)} / troy oz',
                      style: const TextStyle(fontSize: 16)),
                  Text('$_sym${_localPrice(_goldGram).toStringAsFixed(2)} / gram',
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Karat selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<String>(
                segments: _karats.keys
                    .map((k) => ButtonSegment(value: k, label: Text(k)))
                    .toList(),
                selected: {_selectedKarat},
                onSelectionChanged: (s) =>
                    setState(() => _selectedKarat = s.first),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Weight slider
          SliderInput(
            label: 'Weight',
            value: _weightGrams,
            min: 1,
            max: 500,
            suffix: '${_weightGrams.toStringAsFixed(1)} g',
            accentColor: c,
            onChanged: (v) => setState(() => _weightGrams = v),
          ),
          const SizedBox(height: 20),

          // Value breakdown
          Card(
            color: c.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow(
                      label: 'Price/gram ($_selectedKarat)',
                      value: '$_sym${_pricePerGram.toStringAsFixed(2)}'),
                  const Divider(),
                  ResultRow(
                      label: 'Total (${_weightGrams.toStringAsFixed(1)}g)',
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
