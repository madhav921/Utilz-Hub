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

  // ── Favourites ──────────────────────────────────────────

  static const _favKey = 'favourite_tool_ids';
  static const int maxFavourites = 10;

  /// Save favourite tool IDs.
  static Future<void> saveFavourites(List<String> toolIds) async {
    await init();
    _prefs!.setStringList(_favKey, toolIds);
  }

  /// Load favourite tool IDs. Returns null if never set (use defaults).
  static Future<List<String>?> loadFavourites() async {
    await init();
    return _prefs!.getStringList(_favKey);
  }

  /// Toggle a tool as favourite. Returns the updated list.
  static Future<List<String>> toggleFavourite(String toolId) async {
    final current = await loadFavourites() ?? [];
    if (current.contains(toolId)) {
      current.remove(toolId);
    } else if (current.length < maxFavourites) {
      current.add(toolId);
    }
    await saveFavourites(current);
    return current;
  }

  /// Check if a tool is favourited.
  static Future<bool> isFavourite(String toolId) async {
    final favs = await loadFavourites();
    return favs?.contains(toolId) ?? false;
  }

  // ── Tool Order (per-category) ────────────────────────────

  /// Save custom tool order for a category.
  static Future<void> saveToolOrder(
      String categoryId, List<String> toolIds) async {
    await init();
    _prefs!.setStringList('tool_order_$categoryId', toolIds);
  }

  /// Load custom tool order for a category. Returns null if never set.
  static Future<List<String>?> loadToolOrder(String categoryId) async {
    await init();
    return _prefs!.getStringList('tool_order_$categoryId');
  }

  // ── Custom Folders (My Space) ───────────────────────────

  static const _foldersKey = 'custom_folders';

  /// Save the list of custom folders as JSON.
  static Future<void> saveCustomFolders(
      List<Map<String, dynamic>> folders) async {
    await init();
    _prefs!.setString(_foldersKey, jsonEncode(folders));
  }

  /// Load the list of custom folders.
  static Future<List<Map<String, dynamic>>> loadCustomFolders() async {
    await init();
    final raw = _prefs!.getString(_foldersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }
}
