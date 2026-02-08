import 'package:flutter/material.dart';
import '../../core/models/tool_category.dart';
import '../../core/services/cache_service.dart';
import '../../core/widgets/live_badge.dart';
import '../../app/theme_provider.dart';
import 'category_screen.dart';

/// Home screen showing tool categories in a reorderable grid.
///
/// Navigation: Home (categories) → Category (tools) → Tool screen.
/// Categories are sorted by daily use and can be reordered by the user.
class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late List<ToolCategory> _categories;
  bool _isReordering = false;

  @override
  void initState() {
    super.initState();
    _categories = List.from(defaultCategories);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _loadCategoryOrder();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadCategoryOrder() async {
    final order = await CacheService.loadCategoryOrder();
    if (order != null && order.isNotEmpty) {
      final map = {for (final c in defaultCategories) c.id: c};
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
            icon: const Icon(Icons.search),
            tooltip: 'Search tools',
            onPressed: _openSearch,
          ),
          IconButton(
            icon: Icon(_isReordering ? Icons.check : Icons.swap_vert),
            tooltip: _isReordering ? 'Done' : 'Reorder categories',
            onPressed: () {
              setState(() => _isReordering = !_isReordering);
              if (!_isReordering) _saveCategoryOrder();
            },
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
      body: _isReordering ? _buildReorderableList(theme) : _buildGrid(theme),
    );
  }

  // ── Reorderable list mode ───────────────────────────────
  Widget _buildReorderableList(ThemeData theme) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _categories.length,
      onReorder: (oldIdx, newIdx) {
        setState(() {
          if (newIdx > oldIdx) newIdx--;
          final item = _categories.removeAt(oldIdx);
          _categories.insert(newIdx, item);
        });
      },
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return Card(
          key: ValueKey(cat.id),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: cat.color.withValues(alpha: 0.2),
              child: Icon(cat.icon, color: cat.color),
            ),
            title: Text(cat.name),
            subtitle: Text('${cat.tools.length} tools'),
            trailing: const Icon(Icons.drag_handle),
          ),
        );
      },
    );
  }

  // ── Category grid mode ──────────────────────────────────
  Widget _buildGrid(ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.all(14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.35,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final delay = index * 0.08;
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

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasLive = category.tools.any((t) => t.isLive);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withValues(alpha: 0.15),
                category.color.withValues(alpha: 0.05),
              ],
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(category.icon, color: category.color, size: 32),
                  const Spacer(),
                  if (hasLive) const LiveBadge(),
                ],
              ),
              const Spacer(),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: category.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${category.tools.length} tools',
                style: TextStyle(
                  fontSize: 12,
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
