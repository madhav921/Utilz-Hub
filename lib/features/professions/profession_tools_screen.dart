import 'package:flutter/material.dart';
import '../../core/models/profession_category.dart';
import '../../core/models/tool_category.dart';
import '../../core/services/cache_service.dart';
import '../../core/widgets/live_badge.dart';
import '../home/tool_router.dart';

/// Shows the list of tools for a single profession.
/// Supports sub-categories (e.g. High-School grouped by subject).
class ProfessionToolsScreen extends StatefulWidget {
  final ProfessionCategory profession;

  const ProfessionToolsScreen({super.key, required this.profession});

  @override
  State<ProfessionToolsScreen> createState() => _ProfessionToolsScreenState();
}

class _ProfessionToolsScreenState extends State<ProfessionToolsScreen> {
  Set<String> _favouriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favs = await CacheService.loadFavourites() ?? [];
    if (mounted) setState(() => _favouriteIds = favs.toSet());
  }

  Future<void> _toggleFavourite(Tool tool) async {
    if (_favouriteIds.contains(tool.id)) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Remove Favourite?'),
          content:
              Text('Remove "${tool.name}" from Everyday Essentials?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Remove')),
          ],
        ),
      );
      if (ok != true) return;
    } else if (_favouriteIds.length >= CacheService.maxFavourites) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 10 favourites reached')),
      );
      return;
    }
    await CacheService.toggleFavourite(tool.id);
    await _loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profession.name),
        centerTitle: true,
      ),
      body: widget.profession.hasSubCategories
          ? _buildSubCategoryView(theme)
          : _buildFlatList(theme, widget.profession.tools),
    );
  }

  Widget _buildSubCategoryView(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemCount: widget.profession.subCategories!.length,
      itemBuilder: (ctx, i) {
        final sub = widget.profession.subCategories![i];
        return _SubCategorySection(
          sub: sub,
          color: widget.profession.color,
          theme: theme,
          favouriteIds: _favouriteIds,
          onToggleFavourite: _toggleFavourite,
        );
      },
    );
  }

  Widget _buildFlatList(ThemeData theme, List<Tool> tools) {
    if (tools.isEmpty) {
      return const Center(child: Text('No tools available yet.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemCount: tools.length,
      itemBuilder: (ctx, i) => _ToolTile(
        tool: tools[i],
        color: widget.profession.color,
        theme: theme,
        isFavourite: _favouriteIds.contains(tools[i].id),
        onToggleFavourite: () => _toggleFavourite(tools[i]),
      ),
    );
  }
}

/// Collapsible section for a sub-category.
class _SubCategorySection extends StatelessWidget {
  final ProfessionSubCategory sub;
  final Color color;
  final ThemeData theme;
  final Set<String> favouriteIds;
  final Future<void> Function(Tool) onToggleFavourite;

  const _SubCategorySection({
    required this.sub,
    required this.color,
    required this.theme,
    required this.favouriteIds,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(sub.icon, color: color, size: 20),
        ),
        title: Text(
          sub.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('${sub.tools.length} tools',
            style: theme.textTheme.bodySmall),
        children: sub.tools
            .map((tool) => _ToolTile(
                  tool: tool,
                  color: color,
                  theme: theme,
                  isFavourite: favouriteIds.contains(tool.id),
                  onToggleFavourite: () => onToggleFavourite(tool),
                ))
            .toList(),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  final Tool tool;
  final Color color;
  final ThemeData theme;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const _ToolTile({
    required this.tool,
    required this.color,
    required this.theme,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isDark ? color.withAlpha(30) : color.withAlpha(18),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ToolRouter.getScreen(tool, color),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(tool.icon, color: color, size: 26),
                const SizedBox(width: 12),
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
                          color:
                              theme.colorScheme.onSurface.withAlpha(160),
                        ),
                      ),
                    ],
                  ),
                ),
                // Heart icon
                GestureDetector(
                  onTap: onToggleFavourite,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 20,
                      color: isFavourite
                          ? Colors.redAccent
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
