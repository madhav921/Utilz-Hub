import 'package:flutter/material.dart';
import 'export_button.dart';
import 'save_button.dart';

/// Reusable scaffold for all calculator/converter screens.
///
/// Provides a consistent layout with:
/// - Themed AppBar with category color
/// - Info card at the top
/// - ScrollView body
/// - Optional export button in AppBar
/// - Optional save button in AppBar (bookmark icon)
class CalculatorScaffold extends StatelessWidget {
  final String title;
  final Color accentColor;
  final String? infoText;
  final IconData? infoIcon;
  final List<Widget> children;
  final Map<String, String>? exportData;

  /// Required for save functionality — identifies the tool.
  final String? toolId;
  final String? categoryName;

  const CalculatorScaffold({
    super.key,
    required this.title,
    required this.accentColor,
    this.infoText,
    this.infoIcon,
    required this.children,
    this.exportData,
    this.toolId,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = exportData != null && exportData!.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: accentColor.withValues(alpha: 0.1),
        foregroundColor: accentColor,
        actions: [
          if (hasData) ...[
            SaveButton(
              toolId: toolId ?? title.toLowerCase().replaceAll(' ', '_'),
              toolName: title,
              categoryName: categoryName ?? '',
              data: exportData!,
              accentColor: accentColor,
            ),
            ExportButton(
              title: title,
              data: exportData!,
              accentColor: accentColor,
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (infoText != null) ...[
              _InfoCard(
                text: infoText!,
                icon: infoIcon ?? Icons.info_outline,
                color: accentColor,
              ),
              const SizedBox(height: 16),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
