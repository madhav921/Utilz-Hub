import 'package:flutter/material.dart';
import '../../core/services/live_rates_service.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/live_badge.dart';
import '../../core/widgets/result_row.dart';
import '../../core/widgets/slider_input.dart';

/// Live gold & silver price viewer with weight converter.
class GoldSilverScreen extends StatefulWidget {
  final Color categoryColor;
  const GoldSilverScreen({super.key, required this.categoryColor});

  @override
  State<GoldSilverScreen> createState() => _GoldSilverScreenState();
}

class _GoldSilverScreenState extends State<GoldSilverScreen> {
  bool _loading = true;
  double _goldOz = 0;
  double _silverOz = 0;
  double _goldGram = 0;
  double _silverGram = 0;
  bool _isStale = false;
  String _lastUpdated = '';

  double _weightGrams = 10;

  @override
  void initState() {
    super.initState();
    _fetchPrices();
  }

  Future<void> _fetchPrices() async {
    setState(() => _loading = true);
    final result = await LiveRatesService.getMetalPrices();
    if (!mounted) return;
    setState(() {
      _goldOz = (result.data['gold_oz'] as num?)?.toDouble() ?? 0;
      _silverOz = (result.data['silver_oz'] as num?)?.toDouble() ?? 0;
      _goldGram = (result.data['gold_gram'] as num?)?.toDouble() ?? 0;
      _silverGram = (result.data['silver_gram'] as num?)?.toDouble() ?? 0;
      _isStale = result.isStale;
      _lastUpdated = result.lastUpdated ?? '';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Gold & Silver Prices',
      accentColor: c,
      children: [
        // Live status
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
              tooltip: 'Refresh prices',
              onPressed: _fetchPrices,
            ),
          ],
        ),
        if (_isStale)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Using cached/fallback prices. Connect for live data.',
              style: TextStyle(fontSize: 12, color: Colors.orange.shade300),
            ),
          ),
        const SizedBox(height: 8),

        if (_loading)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ))
        else ...[
          // Gold card
          _metalCard(
            icon: Icons.circle,
            label: 'Gold',
            color: const Color(0xFFFFD700),
            priceOz: _goldOz,
            priceGram: _goldGram,
          ),
          const SizedBox(height: 12),

          // Silver card
          _metalCard(
            icon: Icons.circle,
            label: 'Silver',
            color: const Color(0xFFC0C0C0),
            priceOz: _silverOz,
            priceGram: _silverGram,
          ),
          const SizedBox(height: 24),

          // Weight converter
          Text('Quick Weight Calculator',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: c)),
          const SizedBox(height: 8),
          SliderInput(
            label: 'Weight',
            value: _weightGrams,
            min: 1,
            max: 1000,
            suffix: '${_weightGrams.round()} grams',
            accentColor: c,
            onChanged: (v) => setState(() => _weightGrams = v),
          ),
          const SizedBox(height: 12),
          Card(
            color: c.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ResultRow.currency(
                    'Gold (${_weightGrams.round()}g)',
                    _goldGram * _weightGrams,
                  ),
                  const Divider(),
                  ResultRow.currency(
                    'Silver (${_weightGrams.round()}g)',
                    _silverGram * _weightGrams,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _metalCard({
    required IconData icon,
    required String label,
    required Color color,
    required double priceOz,
    required double priceGram,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    '\$${priceOz.toStringAsFixed(2)} / troy oz',
                    style: TextStyle(fontSize: 14, color: color),
                  ),
                  Text(
                    '\$${priceGram.toStringAsFixed(2)} / gram',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
