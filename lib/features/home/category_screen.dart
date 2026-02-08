import 'package:flutter/material.dart';
import '../../core/models/tool_category.dart';
import '../../core/widgets/live_badge.dart';
import 'tool_router.dart';

/// Screen showing all tools within a single category.
///
/// Tools are displayed in a responsive grid. Tapping a tool opens
/// the corresponding calculator/converter screen via [ToolRouter].
class CategoryScreen extends StatelessWidget {
  final ToolCategory category;
  final String? initialToolId;

  const CategoryScreen({super.key, required this.category, this.initialToolId});

  /// Open the category screen and immediately navigate to a specific tool.
  factory CategoryScreen.openTool({
    required ToolCategory category,
    required String toolId,
  }) {
    return CategoryScreen(category: category, initialToolId: toolId);
  }

  @override
  Widget build(BuildContext context) {
    // If a specific tool was requested, navigate immediately
    if (initialToolId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tool = category.tools.firstWhere(
          (t) => t.id == initialToolId,
          orElse: () => category.tools.first,
        );
        _openTool(context, tool);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color.withValues(alpha: 0.1),
        foregroundColor: category.color,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: category.tools.length,
        itemBuilder: (context, index) {
          final tool = category.tools[index];
          return _ToolCard(
            tool: tool,
            color: category.color,
            onTap: () => _openTool(context, tool),
          );
        },
      ),
    );
  }

  void _openTool(BuildContext context, Tool tool) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ToolRouter.getScreen(tool, category.color),
      ),
    );
  }
}

/// Individual tool card within a category.
class _ToolCard extends StatelessWidget {
  final Tool tool;
  final Color color;
  final VoidCallback onTap;

  const _ToolCard({
    required this.tool,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.12),
                color.withValues(alpha: 0.04),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Live badge
              if (tool.isLive)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: LiveBadge(size: 8),
                ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tool.icon, size: 36, color: color),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        tool.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
