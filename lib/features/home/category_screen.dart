import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/models/tool_category.dart';
import '../../core/services/cache_service.dart';
import '../../core/widgets/live_badge.dart';
import 'tool_router.dart';

/// Screen showing all tools within a single category.
///
/// Supports heart-button favouriting, iOS-style long-press jiggle
/// reorder, and optimised compact layout.
class CategoryScreen extends StatefulWidget {
  final ToolCategory category;
  final String? initialToolId;

  const CategoryScreen({super.key, required this.category, this.initialToolId});

  factory CategoryScreen.openTool({
    required ToolCategory category,
    required String toolId,
  }) {
    return CategoryScreen(category: category, initialToolId: toolId);
  }

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late List<Tool> _tools;
  Set<String> _favouriteIds = {};
  bool _editMode = false;
  late AnimationController _jiggle;

  @override
  void initState() {
    super.initState();
    _tools = List.from(widget.category.tools);
    _jiggle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadToolOrder();
    _loadFavourites();

    if (widget.initialToolId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tool = _tools.firstWhere(
          (t) => t.id == widget.initialToolId,
          orElse: () => _tools.first,
        );
        _openTool(tool);
      });
    }
  }

  @override
  void dispose() {
    _jiggle.dispose();
    super.dispose();
  }

  Future<void> _loadFavourites() async {
    final favs = await CacheService.loadFavourites() ?? [];
    if (mounted) setState(() => _favouriteIds = favs.toSet());
  }

  Future<void> _loadToolOrder() async {
    final order = await CacheService.loadToolOrder(widget.category.id);
    if (order != null && order.isNotEmpty) {
      final map = {for (final t in widget.category.tools) t.id: t};
      final reordered = <Tool>[];
      for (final id in order) {
        if (map.containsKey(id)) reordered.add(map.remove(id)!);
      }
      reordered.addAll(map.values);
      if (mounted) setState(() => _tools = reordered);
    }
  }

  Future<void> _saveToolOrder() async {
    await CacheService.saveToolOrder(
      widget.category.id,
      _tools.map((t) => t.id).toList(),
    );
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

  void _enterEditMode() {
    setState(() => _editMode = true);
    _jiggle.repeat(reverse: true);
  }

  void _exitEditMode() {
    _jiggle.stop();
    _jiggle.value = 0;
    setState(() => _editMode = false);
    _saveToolOrder();
  }

  void _openTool(Tool tool) {
    if (_editMode) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ToolRouter.getScreen(tool, widget.category.color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.category.color;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: c.withValues(alpha: 0.1),
        foregroundColor: c,
        actions: [
          if (_editMode)
            TextButton(
              onPressed: _exitEditMode,
              child: Text('Done',
                  style: TextStyle(
                      color: c, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.82,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _tools.length,
        itemBuilder: (context, index) {
          final tool = _tools[index];
          Widget card = _ToolCard(
            tool: tool,
            color: c,
            isFavourite: _favouriteIds.contains(tool.id),
            onTap: () => _openTool(tool),
            onFavouriteTap: () => _toggleFavourite(tool),
            onLongPress: _enterEditMode,
          );

          if (_editMode) {
            card = AnimatedBuilder(
              animation: _jiggle,
              builder: (_, child) {
                final angle =
                    sin((_jiggle.value * 2 - 1) * pi) * 0.025 *
                    (index.isEven ? 1 : -1);
                return Transform.rotate(angle: angle, child: child);
              },
              child: DragTarget<int>(
                onAcceptWithDetails: (details) {
                  setState(() {
                    final old = details.data;
                    final item = _tools.removeAt(old);
                    _tools.insert(index, item);
                  });
                },
                builder: (ctx, cand, rej) {
                  return LongPressDraggable<int>(
                    data: index,
                    feedback: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 110,
                        height: 130,
                        child: _ToolCard(
                          tool: tool,
                          color: c,
                          isFavourite: _favouriteIds.contains(tool.id),
                          onTap: () {},
                          onFavouriteTap: () {},
                          onLongPress: () {},
                        ),
                      ),
                    ),
                    childWhenDragging:
                        Opacity(opacity: 0.3, child: card),
                    child: card,
                  );
                },
              ),
            );
          }
          return card;
        },
      ),
    );
  }
}

/// Individual tool card with heart icon for favouriting.
class _ToolCard extends StatelessWidget {
  final Tool tool;
  final Color color;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback onFavouriteTap;
  final VoidCallback onLongPress;

  const _ToolCard({
    required this.tool,
    required this.color,
    required this.isFavourite,
    required this.onTap,
    required this.onFavouriteTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
              // Heart / favourite button
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onFavouriteTap,
                  child: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFavourite
                        ? Colors.redAccent
                        : Colors.grey.shade400,
                  ),
                ),
              ),
              // Live badge
              if (tool.isLive)
                const Positioned(
                  top: 4,
                  left: 4,
                  child: LiveBadge(size: 7),
                ),
              // Content
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(tool.icon, size: 32, color: color),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          tool.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
