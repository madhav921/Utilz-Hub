import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Formats for export.
enum ExportFormat { text, share }

/// Service for exporting calculation results.
///
/// Generates a professional, well-formatted output that can be:
/// - Saved as a text file
/// - Shared via the system share sheet
class ExportService {
  /// Export data in the requested format.
  static Future<void> export({
    required String title,
    required Map<String, String> data,
    required ExportFormat format,
  }) async {
    final content = _buildExportContent(title, data);

    switch (format) {
      case ExportFormat.text:
        await _saveToFile(title, content);
        break;
      case ExportFormat.share:
        await _shareText(title, content);
        break;
    }
  }

  /// Build a professional formatted text export.
  static String _buildExportContent(
    String title,
    Map<String, String> data,
  ) {
    final buf = StringBuffer();
    final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final separator = '═' * 44;
    final thinLine = '─' * 44;

    buf.writeln(separator);
    buf.writeln('  📊 ALL-IN-ONE TOOLBOX');
    buf.writeln('  $title');
    buf.writeln(separator);
    buf.writeln();

    // Find max label length for alignment
    int maxLabel = 0;
    for (final key in data.keys) {
      if (key.length > maxLabel) maxLabel = key.length;
    }

    for (final entry in data.entries) {
      final label = entry.key.padRight(maxLabel + 2);
      buf.writeln('  $label ${entry.value}');
    }

    buf.writeln();
    buf.writeln(thinLine);
    buf.writeln('  Generated: $now');
    buf.writeln('  App: All-in-One Toolbox v2.0');
    buf.writeln(separator);

    return buf.toString();
  }

  /// Save content to a text file in the documents directory.
  static Future<void> _saveToFile(String title, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final sanitized = title.replaceAll(RegExp(r'[^\w\s]'), '').trim();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${dir.path}/${sanitized}_$timestamp.txt');
    await file.writeAsString(content);
  }

  /// Share content via the system share sheet.
  static Future<void> _shareText(String title, String content) async {
    await Share.share(content, subject: 'All-in-One Toolbox — $title');
  }
}
