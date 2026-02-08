import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cache_service.dart';

/// Service for fetching live exchange rates and metal prices.
///
/// Caching strategy (per user spec):
/// - Currency: every 6–12 hours
/// - Gold/Silver: every 2–4 hours
///
/// If API fails → returns cached data with [isStale] = true.
/// NEVER blocks the user.
class LiveRatesService {
  // ── Cache keys ──────────────────────────────────────────
  static const _currencyKey = 'currency_rates';
  static const _metalsKey = 'metal_prices';

  // ── Cache durations (hours) ─────────────────────────────
  static const _currencyMaxAge = 8; // 6–12 hrs
  static const _metalsMaxAge = 3; // 2–4 hrs

  // ── Currency Rates ──────────────────────────────────────

  /// Fetch currency rates (base: USD).
  /// Uses free exchangerate.host or fallback data.
  static Future<LiveRateResult> getCurrencyRates({
    String base = 'USD',
  }) async {
    // Check cache first
    final cached = await CacheService.load(_currencyKey);
    final stale = await CacheService.isStale(
      _currencyKey,
      maxAgeHours: _currencyMaxAge,
    );

    if (!stale && cached != null) {
      return LiveRateResult(
        data: cached,
        isStale: false,
        lastUpdated: await CacheService.lastUpdated(_currencyKey),
      );
    }

    // Try fetching fresh data
    try {
      final url = Uri.parse(
        'https://open.er-api.com/v6/latest/$base',
      );
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final rates = (json['rates'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
            {};

        final data = {
          'base': base,
          'rates': rates,
        };

        await CacheService.save(_currencyKey, data);

        return LiveRateResult(
          data: data,
          isStale: false,
          lastUpdated: 'Just now',
        );
      }
    } catch (_) {
      // API failed — fall through to cached/fallback
    }

    // Return cached data or fallback
    if (cached != null) {
      return LiveRateResult(
        data: cached,
        isStale: true,
        lastUpdated: await CacheService.lastUpdated(_currencyKey),
      );
    }

    // No cache, no API — return fallback rates
    return LiveRateResult(
      data: _fallbackCurrencyRates,
      isStale: true,
      lastUpdated: 'Fallback data',
    );
  }

  /// Convert an amount between currencies.
  static double convertCurrency(
    double amount,
    String from,
    String to,
    Map<String, dynamic> ratesData,
  ) {
    final rates = ratesData['rates'] as Map<String, dynamic>? ?? {};
    final fromRate = (rates[from] as num?)?.toDouble() ?? 1.0;
    final toRate = (rates[to] as num?)?.toDouble() ?? 1.0;
    return amount * (toRate / fromRate);
  }

  // ── Metal Prices ────────────────────────────────────────

  /// Fetch gold and silver prices in USD per ounce.
  static Future<LiveRateResult> getMetalPrices() async {
    final cached = await CacheService.load(_metalsKey);
    final stale = await CacheService.isStale(
      _metalsKey,
      maxAgeHours: _metalsMaxAge,
    );

    if (!stale && cached != null) {
      return LiveRateResult(
        data: cached,
        isStale: false,
        lastUpdated: await CacheService.lastUpdated(_metalsKey),
      );
    }

    // Try fetching from metals API
    try {
      // Using a free metals price API
      final url = Uri.parse(
        'https://api.metalpriceapi.com/v1/latest?api_key=demo&base=USD&currencies=XAU,XAG',
      );
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final rates = json['rates'] as Map<String, dynamic>? ?? {};

        // API returns USD per troy ounce as 1/rate
        final goldOz = rates['USDXAU'] != null
            ? 1.0 / (rates['USDXAU'] as num).toDouble()
            : _fallbackMetalPrices['gold_oz']!;
        final silverOz = rates['USDXAG'] != null
            ? 1.0 / (rates['USDXAG'] as num).toDouble()
            : _fallbackMetalPrices['silver_oz']!;

        final data = {
          'gold_oz': goldOz,
          'silver_oz': silverOz,
          'gold_gram': goldOz / 31.1035,
          'silver_gram': silverOz / 31.1035,
        };

        await CacheService.save(_metalsKey, data);

        return LiveRateResult(
          data: data,
          isStale: false,
          lastUpdated: 'Just now',
        );
      }
    } catch (_) {
      // Fall through
    }

    if (cached != null) {
      return LiveRateResult(
        data: cached,
        isStale: true,
        lastUpdated: await CacheService.lastUpdated(_metalsKey),
      );
    }

    return LiveRateResult(
      data: _fallbackMetalPrices,
      isStale: true,
      lastUpdated: 'Fallback data',
    );
  }

  // ── Fallback Data ───────────────────────────────────────

  static final Map<String, dynamic> _fallbackCurrencyRates = {
    'base': 'USD',
    'rates': {
      'USD': 1.0,
      'EUR': 0.92,
      'GBP': 0.79,
      'INR': 83.50,
      'JPY': 154.50,
      'AUD': 1.54,
      'CAD': 1.37,
      'CHF': 0.88,
      'CNY': 7.24,
      'SGD': 1.34,
      'AED': 3.67,
      'SAR': 3.75,
      'BRL': 4.97,
      'ZAR': 18.50,
      'MXN': 17.15,
      'KRW': 1330.0,
      'THB': 35.5,
      'MYR': 4.72,
      'IDR': 15600.0,
      'PHP': 56.0,
      'VND': 24500.0,
      'BDT': 110.0,
      'PKR': 278.0,
      'LKR': 325.0,
      'NPR': 133.0,
      'NZD': 1.68,
      'SEK': 10.5,
      'NOK': 10.8,
      'DKK': 6.85,
      'HKD': 7.82,
      'TWD': 32.0,
      'RUB': 92.0,
      'TRY': 30.0,
      'EGP': 30.9,
      'NGN': 780.0,
      'KES': 153.0,
    },
  };

  static final Map<String, dynamic> _fallbackMetalPrices = {
    'gold_oz': 2350.0,
    'silver_oz': 28.50,
    'gold_gram': 2350.0 / 31.1035,
    'silver_gram': 28.50 / 31.1035,
  };

  /// Common currencies for the picker.
  static const List<String> commonCurrencies = [
    'USD', 'EUR', 'GBP', 'INR', 'JPY', 'AUD', 'CAD', 'CHF',
    'CNY', 'SGD', 'AED', 'SAR', 'BRL', 'ZAR', 'MXN', 'KRW',
    'THB', 'MYR', 'IDR', 'PHP', 'VND', 'BDT', 'PKR', 'LKR',
    'NPR', 'NZD', 'SEK', 'NOK', 'DKK', 'HKD', 'TWD', 'RUB',
    'TRY', 'EGP', 'NGN', 'KES',
  ];

  /// Currency names for display.
  static const Map<String, String> currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'INR': 'Indian Rupee',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'SGD': 'Singapore Dollar',
    'AED': 'UAE Dirham',
    'SAR': 'Saudi Riyal',
    'BRL': 'Brazilian Real',
    'ZAR': 'South African Rand',
    'MXN': 'Mexican Peso',
    'KRW': 'South Korean Won',
    'THB': 'Thai Baht',
    'MYR': 'Malaysian Ringgit',
    'IDR': 'Indonesian Rupiah',
    'PHP': 'Philippine Peso',
    'VND': 'Vietnamese Dong',
    'BDT': 'Bangladeshi Taka',
    'PKR': 'Pakistani Rupee',
    'LKR': 'Sri Lankan Rupee',
    'NPR': 'Nepalese Rupee',
    'NZD': 'New Zealand Dollar',
    'SEK': 'Swedish Krona',
    'NOK': 'Norwegian Krone',
    'DKK': 'Danish Krone',
    'HKD': 'Hong Kong Dollar',
    'TWD': 'Taiwan Dollar',
    'RUB': 'Russian Ruble',
    'TRY': 'Turkish Lira',
    'EGP': 'Egyptian Pound',
    'NGN': 'Nigerian Naira',
    'KES': 'Kenyan Shilling',
  };
}

/// Result wrapper for live rate API calls.
class LiveRateResult {
  final Map<String, dynamic> data;
  final bool isStale;
  final String? lastUpdated;

  const LiveRateResult({
    required this.data,
    required this.isStale,
    this.lastUpdated,
  });
}
