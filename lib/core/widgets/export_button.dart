import 'package:flutter/material.dart';
import '../services/export_service.dart';

/// AppBar action button that triggers export (text or image).
///
/// Shows a popup menu with export format options.
class ExportButton extends StatelessWidget {
  final String title;
  final Map<String, String> data;
  final Color accentColor;

  const ExportButton({
    super.key,
    required this.title,
    required this.data,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExportFormat>(
      icon: Icon(Icons.ios_share, color: accentColor),
      tooltip: 'Export',
      onSelected: (format) => _export(context, format),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: ExportFormat.text,
          child: Row(
            children: [
              Icon(Icons.text_snippet_outlined),
              SizedBox(width: 8),
              Text('Export as Text'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ExportFormat.share,
          child: Row(
            children: [
              Icon(Icons.share_outlined),
              SizedBox(width: 8),
              Text('Share Result'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, ExportFormat format) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ExportService.export(
        title: title,
        data: data,
        format: format,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            format == ExportFormat.text
                ? 'Exported as text file'
                : 'Shared successfully',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
