import 'package:flutter/material.dart';
import '../../core/services/live_rates_service.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/live_badge.dart';
import '../../core/widgets/result_row.dart';

/// Independent live fuel price screen with country/region selector.
///
/// Fetches fuel prices independently, shows petrol/diesel/CNG/LPG
/// based on the selected country.
class FuelPriceScreen extends StatefulWidget {
  final Color categoryColor;
  const FuelPriceScreen({super.key, required this.categoryColor});

  @override
  State<FuelPriceScreen> createState() => _FuelPriceScreenState();
}

class _FuelPriceScreenState extends State<FuelPriceScreen> {
  bool _loading = true;
  String _country = 'IN';
  Map<String, dynamic> _fuelData = {};
  bool _isStale = false;
  String _lastUpdated = '';

  // Quick trip calculator
  double _distance = 100;
  double _mileage = 15;
  String _selectedFuelType = 'petrol';

  @override
  void initState() {
    super.initState();
    _fetchPrices();
  }

  Future<void> _fetchPrices() async {
    setState(() => _loading = true);
    final result =
        await LiveRatesService.getFuelPrices(countryCode: _country);
    if (!mounted) return;
    setState(() {
      _fuelData = result.data;
      _isStale = result.isStale;
      _lastUpdated = result.lastUpdated ?? '';
      _loading = false;
      // Default to first available fuel type
      final prices = _fuelData['prices'] as Map<String, dynamic>? ?? {};
      if (prices.isNotEmpty && !prices.containsKey(_selectedFuelType)) {
        _selectedFuelType = prices.keys.first;
      }
    });
  }

  String get _currencyCode =>
      (_fuelData['currency'] as String?) ?? 'INR';
  String get _unit => (_fuelData['unit'] as String?) ?? 'litre';

  Map<String, dynamic> get _prices =>
      (_fuelData['prices'] as Map<String, dynamic>?) ?? {};

  double get _selectedPrice =>
      (_prices[_selectedFuelType] as num?)?.toDouble() ?? 0;

  double get _fuelNeeded => _mileage > 0 ? _distance / _mileage : 0;
  double get _tripCost => _fuelNeeded * _selectedPrice;

  Map<String, String> get _exportData {
    final data = <String, String>{
      'Country': LiveRatesService.fuelCountries[_country] ?? _country,
      'Currency': _currencyCode,
    };
    for (final entry in _prices.entries) {
      final name =
          LiveRatesService.fuelTypeNames[entry.key] ?? entry.key;
      data[name] =
          '$_currencyCode ${(entry.value as num).toStringAsFixed(2)} / $_unit';
    }
    if (_tripCost > 0) {
      data['Trip Distance'] = '${_distance.toStringAsFixed(0)} km';
      data['Trip Cost'] =
          '$_currencyCode ${_tripCost.toStringAsFixed(2)}';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Fuel Prices',
      accentColor: c,
      toolId: 'fuel_price_live',
      categoryName: 'Live Rates',
      exportData: _exportData,
      children: [
        // Live status
        _liveStatusRow(c),
        const SizedBox(height: 8),

        // Country selector
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.public, size: 20),
                const SizedBox(width: 8),
                const Text('Country:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _country,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: LiveRatesService.fuelCountries.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text('${e.value} (${e.key})',
                                  style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        _country = v;
                        _fetchPrices();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        if (_loading)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator()))
        else ...[
          if (_isStale)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Using cached/fallback prices. Connect for live data.',
                style: TextStyle(fontSize: 12, color: Colors.orange.shade300),
              ),
            ),

          // Fuel price cards
          ..._prices.entries.map((e) {
            final name =
                LiveRatesService.fuelTypeNames[e.key] ?? e.key;
            final price = (e.value as num).toDouble();
            final isSelected = e.key == _selectedFuelType;
            return GestureDetector(
              onTap: () =>
                  setState(() => _selectedFuelType = e.key),
              child: Card(
                color: isSelected
                    ? c.withValues(alpha: 0.12)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSelected
                      ? BorderSide(color: c, width: 2)
                      : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        e.key == 'diesel'
                            ? Icons.local_gas_station
                            : e.key == 'cng'
                                ? Icons.propane_tank
                                : Icons.local_gas_station_outlined,
                        color: c,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                      ),
                      Text(
                        '$_currencyCode ${price.toStringAsFixed(2)} / $_unit',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: c),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),

          // Quick trip cost calculator
          Text('Quick Trip Calculator',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: c)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text('Distance:')),
                      Expanded(
                        child: TextFormField(
                          initialValue: _distance.toStringAsFixed(0),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixText: 'km',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onChanged: (v) => setState(() {
                            _distance = double.tryParse(v) ?? 0;
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 80, child: Text('Mileage:')),
                      Expanded(
                        child: TextFormField(
                          initialValue: _mileage.toStringAsFixed(0),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixText: 'km/$_unit',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          onChanged: (v) => setState(() {
                            _mileage = double.tryParse(v) ?? 0;
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_tripCost > 0) ...[
            const SizedBox(height: 12),
            Card(
              color: c.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ResultRow(
                        label: 'Fuel Type',
                        value: LiveRatesService.fuelTypeNames[_selectedFuelType] ??
                            _selectedFuelType),
                    const Divider(),
                    ResultRow(
                        label: 'Fuel Needed',
                        value: '${_fuelNeeded.toStringAsFixed(2)} $_unit'),
                    const Divider(),
                    ResultRow(
                        label: 'Trip Cost',
                        value:
                            '$_currencyCode ${_tripCost.toStringAsFixed(2)}',
                        isBold: true,
                        color: c),
                  ],
                ),
              ),
            ),
          ],
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
          onPressed: _fetchPrices,
        ),
      ],
    );
  }
}
