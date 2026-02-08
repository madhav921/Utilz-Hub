import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for caching live rate data locally.
///
/// Strategy:
/// - Currency rates: cached 6–12 hours
/// - Gold/Silver prices: cached 2–4 hours
/// - On app open → check cache timestamp → fetch if stale
/// - If API fails → return cached data + staleness flag
class CacheService {
  static const _prefix = 'cache_';
  static const _tsPrefix = 'cache_ts_';

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save data to cache with current timestamp.
  static Future<void> save(String key, Map<String, dynamic> data) async {
    await init();
    _prefs!.setString('$_prefix$key', jsonEncode(data));
    _prefs!.setInt('$_tsPrefix$key', DateTime.now().millisecondsSinceEpoch);
  }

  /// Load cached data. Returns null if no cache exists.
  static Future<Map<String, dynamic>?> load(String key) async {
    await init();
    final raw = _prefs!.getString('$_prefix$key');
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Check if cache is stale beyond [maxAgeHours].
  static Future<bool> isStale(String key, {required int maxAgeHours}) async {
    await init();
    final ts = _prefs!.getInt('$_tsPrefix$key');
    if (ts == null) return true;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age > maxAgeHours * 3600 * 1000;
  }

  /// Get the last-updated timestamp as a human-readable string.
  static Future<String?> lastUpdated(String key) async {
    await init();
    final ts = _prefs!.getInt('$_tsPrefix$key');
    if (ts == null) return null;
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// Save user category order preference.
  static Future<void> saveCategoryOrder(List<String> categoryIds) async {
    await init();
    _prefs!.setStringList('category_order', categoryIds);
  }

  /// Load user category order preference.
  static Future<List<String>?> loadCategoryOrder() async {
    await init();
    return _prefs!.getStringList('category_order');
  }
}
