import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/models/tool_category.dart';
import '../../core/services/cache_service.dart';
import '../../core/widgets/live_badge.dart';
import '../../app/theme_provider.dart';
import '../saved/saved_results_screen.dart';
import 'category_screen.dart';

/// Home screen showing tool categories in a reorderable grid.
///
/// Categories can be long-pressed to enter jiggle-reorder mode.
/// Hidden categories (Engineering, Digital) are only accessible
/// through the Professions tab.
class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _jiggle;
  late List<ToolCategory> _categories;
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _categories = defaultCategories.where((c) => c.showOnHome).toList();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _jiggle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadCategoryOrder();
  }

  @override
  void dispose() {
    _animController.dispose();
    _jiggle.dispose();
    super.dispose();
  }

  Future<void> _loadCategoryOrder() async {
    final order = await CacheService.loadCategoryOrder();
    if (order != null && order.isNotEmpty) {
      final visible = defaultCategories.where((c) => c.showOnHome).toList();
      final map = {for (final c in visible) c.id: c};
      final reordered = <ToolCategory>[];
      for (final id in order) {
        if (map.containsKey(id)) reordered.add(map.remove(id)!);
      }
      reordered.addAll(map.values); // add any new categories at the end
      if (mounted) setState(() => _categories = reordered);
    }
  }

  Future<void> _saveCategoryOrder() async {
    await CacheService.saveCategoryOrder(
      _categories.map((c) => c.id).toList(),
    );
  }

  // ── Search ──────────────────────────────────────────────
  void _openSearch() {
    showSearch(context: context, delegate: _ToolSearchDelegate());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All-in-One Toolbox'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Saved results',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedResultsScreen()),
            ),
          ),
          if (_editMode)
            TextButton(
              onPressed: _exitEditMode,
              child: const Text('Done',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search tools',
            onPressed: _openSearch,
          ),
          PopupMenuButton<AppThemeMode>(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Theme',
            onSelected: (m) => widget.themeProvider.setTheme(m),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: AppThemeMode.dark,
                child: Row(children: [
                  Icon(Icons.dark_mode),
                  SizedBox(width: 8),
                  Text('Dark'),
                ]),
              ),
              PopupMenuItem(
                value: AppThemeMode.light,
                child: Row(children: [
                  Icon(Icons.light_mode),
                  SizedBox(width: 8),
                  Text('Light'),
                ]),
              ),
              PopupMenuItem(
                value: AppThemeMode.ocean,
                child: Row(children: [
                  Icon(Icons.water),
                  SizedBox(width: 8),
                  Text('Ocean'),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: _buildGrid(theme),
    );
  }

  // ── Jiggle mode helpers ──────────────────────────────────
  void _enterEditMode() {
    setState(() => _editMode = true);
    _jiggle.repeat(reverse: true);
  }

  void _exitEditMode() {
    _jiggle.stop();
    _jiggle.value = 0;
    setState(() => _editMode = false);
    _saveCategoryOrder();
  }

  // ── Category grid ───────────────────────────────────────
  Widget _buildGrid(ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.45,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final delay = index * 0.08;

        Widget card = _CategoryCard(
          category: cat,
          onTap: () => _openCategory(cat),
          onLongPress: _enterEditMode,
        );

        // ── Jiggle mode: animate + draggable ──
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
                  final item = _categories.removeAt(old);
                  _categories.insert(index, item);
                });
              },
              builder: (ctx, cand, rej) {
                return LongPressDraggable<int>(
                  data: index,
                  feedback: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      height: 110,
                      child: _CategoryCard(
                        category: cat,
                        onTap: () {},
                        onLongPress: () {},
                      ),
                    ),
                  ),
                  childWhenDragging: Opacity(opacity: 0.3, child: card),
                  child: card,
                );
              },
            ),
          );
          return card;
        }

        // ── Normal mode: fade / slide entry ──
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _animController,
              curve: Interval(delay.clamp(0.0, 0.8), 1.0,
                  curve: Curves.easeOut),
            ),
          ),
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                    .animate(
              CurvedAnimation(
                parent: _animController,
                curve: Interval(delay.clamp(0.0, 0.8), 1.0,
                    curve: Curves.easeOut),
              ),
            ),
            child: _CategoryCard(
              category: cat,
              onTap: () => _openCategory(cat),
              onLongPress: _enterEditMode,
            ),
          ),
        );
      },
    );
  }

  void _openCategory(ToolCategory cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(category: cat),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Category card widget
// ═══════════════════════════════════════════════════════════

class _CategoryCard extends StatelessWidget {
  final ToolCategory category;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CategoryCard({
    required this.category,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final hasLive = category.tools.any((t) => t.isLive);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withValues(alpha: 0.15),
                category.color.withValues(alpha: 0.05),
              ],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(category.icon, color: category.color, size: 28),
                  const Spacer(),
                  if (hasLive) const LiveBadge(),
                ],
              ),
              const Spacer(),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: category.color,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '${category.tools.length} tools',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Global tool search delegate
// ═══════════════════════════════════════════════════════════

class _ToolSearchDelegate extends SearchDelegate<Tool?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final q = query.toLowerCase();
    final results = <({Tool tool, ToolCategory category})>[];

    for (final cat in defaultCategories) {
      for (final tool in cat.tools) {
        if (tool.name.toLowerCase().contains(q) ||
            tool.description.toLowerCase().contains(q)) {
          results.add((tool: tool, category: cat));
        }
      }
    }

    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No tools found',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final r = results[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: r.category.color.withValues(alpha: 0.2),
            child: Icon(r.tool.icon, color: r.category.color),
          ),
          title: Text(r.tool.name),
          subtitle: Text(r.tool.description),
          trailing: r.tool.isLive ? const LiveBadge() : null,
          onTap: () {
            close(context, r.tool);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryScreen.openTool(
                  category: r.category,
                  toolId: r.tool.id,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
