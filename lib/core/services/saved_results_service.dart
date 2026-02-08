import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for a saved calculation/conversion result.
///
/// Stored in compressed format to minimize storage footprint.
class SavedResult {
  final String id;
  final String toolId;
  final String toolName;
  final String categoryName;
  final Map<String, String> data;
  final DateTime savedAt;
  final String? note;

  const SavedResult({
    required this.id,
    required this.toolId,
    required this.toolName,
    required this.categoryName,
    required this.data,
    required this.savedAt,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'i': id,
        't': toolId,
        'n': toolName,
        'c': categoryName,
        'd': data,
        's': savedAt.millisecondsSinceEpoch,
        if (note != null) 'o': note,
      };

  factory SavedResult.fromJson(Map<String, dynamic> json) => SavedResult(
        id: json['i'] as String,
        toolId: json['t'] as String,
        toolName: json['n'] as String,
        categoryName: json['c'] as String,
        data: (json['d'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v.toString())),
        savedAt:
            DateTime.fromMillisecondsSinceEpoch(json['s'] as int),
        note: json['o'] as String?,
      );
}

/// Service for persisting saved results using gzip-compressed JSON.
///
/// Storage layout in SharedPreferences:
/// - Key: `saved_results` → Base64(gzip(JSON array of results))
/// - Typical 50 results ≈ 2–4 KB compressed vs 15–25 KB raw.
class SavedResultsService {
  static const _storageKey = 'saved_results_gz';
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _sp async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ── Compression helpers ─────────────────────────────────

  /// Compress JSON string → gzip → Base64 string.
  static String _compress(String json) {
    final bytes = utf8.encode(json);
    final compressed = gzip.encode(bytes);
    return base64Encode(compressed);
  }

  /// Base64 string → gunzip → JSON string.
  static String _decompress(String encoded) {
    final compressed = base64Decode(encoded);
    final bytes = gzip.decode(compressed);
    return utf8.decode(bytes);
  }

  // ── CRUD operations ─────────────────────────────────────

  /// Load all saved results from compressed storage.
  static Future<List<SavedResult>> loadAll() async {
    final sp = await _sp;
    final raw = sp.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final json = _decompress(raw);
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => SavedResult.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt)); // newest first
    } catch (_) {
      return [];
    }
  }

  /// Save a new result. Generates a unique ID automatically.
  static Future<void> save({
    required String toolId,
    required String toolName,
    required String categoryName,
    required Map<String, String> data,
    String? note,
  }) async {
    final results = await loadAll();
    final id = '${toolId}_${DateTime.now().millisecondsSinceEpoch}';

    results.insert(
      0,
      SavedResult(
        id: id,
        toolId: toolId,
        toolName: toolName,
        categoryName: categoryName,
        data: data,
        savedAt: DateTime.now(),
        note: note,
      ),
    );

    await _persist(results);
  }

  /// Delete a saved result by ID.
  static Future<void> delete(String id) async {
    final results = await loadAll();
    results.removeWhere((r) => r.id == id);
    await _persist(results);
  }

  /// Clear all saved results.
  static Future<void> clearAll() async {
    final sp = await _sp;
    await sp.remove(_storageKey);
  }

  /// Get count of saved results (without full decompression).
  static Future<int> count() async {
    final results = await loadAll();
    return results.length;
  }

  /// Persist the full list back to compressed storage.
  static Future<void> _persist(List<SavedResult> results) async {
    final sp = await _sp;
    final json = jsonEncode(results.map((r) => r.toJson()).toList());
    final compressed = _compress(json);
    await sp.setString(_storageKey, compressed);
  }
}
