import 'package:flutter/material.dart';
import '../../core/models/profession_category.dart';
import '../../core/models/tool_category.dart';
import '../../core/widgets/live_badge.dart';
import '../home/tool_router.dart';

/// Shows the list of tools for a single profession.
class ProfessionToolsScreen extends StatelessWidget {
  final ProfessionCategory profession;

  const ProfessionToolsScreen({super.key, required this.profession});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tools = profession.tools;

    return Scaffold(
      appBar: AppBar(
        title: Text(profession.name),
        centerTitle: true,
      ),
      body: tools.isEmpty
          ? const Center(child: Text('No tools available yet.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: tools.length,
              itemBuilder: (ctx, i) {
                final tool = tools[i];
                return _ToolTile(
                  tool: tool,
                  color: profession.color,
                  theme: theme,
                );
              },
            ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  final Tool tool;
  final Color color;
  final ThemeData theme;

  const _ToolTile({
    required this.tool,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isDark ? color.withAlpha(30) : color.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ToolRouter.getScreen(tool, color),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(tool.icon, color: color, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              tool.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (tool.isLive) ...[
                            const SizedBox(width: 6),
                            const LiveBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tool.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(160),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
