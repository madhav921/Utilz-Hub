import 'package:flutter/material.dart';
import 'package:all_in_one_converter/core/models/tool_models.dart';
import 'package:all_in_one_converter/features/tool_detail/tool_detail_screen.dart';
import 'package:all_in_one_converter/app/theme_provider.dart';

/// Enhanced home screen with categorized toolbox view
class EnhancedHomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const EnhancedHomeScreen({super.key, required this.themeProvider});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<ToolCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return allCategories;

    return allCategories
        .map((category) {
          final filteredTools = category.tools.where((tool) {
            return tool.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                tool.description.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredTools.isEmpty) return null;

          return ToolCategory(
            id: category.id,
            name: category.name,
            icon: category.icon,
            color: category.color,
            tools: filteredTools,
          );
        })
        .whereType<ToolCategory>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All-in-One Toolbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ToolSearchDelegate(),
              );
            },
          ),
          PopupMenuButton<AppThemeMode>(
            icon: const Icon(Icons.palette),
            tooltip: 'Change Theme',
            onSelected: (mode) {
              widget.themeProvider.setTheme(mode);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppThemeMode.dark,
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Dark Theme'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AppThemeMode.light,
                child: Row(
                  children: [
                    Icon(Icons.light_mode),
                    SizedBox(width: 8),
                    Text('Light Theme'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AppThemeMode.ocean,
                child: Row(
                  children: [
                    Icon(Icons.water),
                    SizedBox(width: 8),
                    Text('Ocean Theme'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredCategories.length,
        itemBuilder: (context, index) {
          return _buildCategorySection(_filteredCategories[index], index);
        },
      ),
    );
  }

  Widget _buildCategorySection(ToolCategory category, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.05,
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.05,
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryHeader(category),
              const SizedBox(height: 12),
              _buildToolGrid(category),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(ToolCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: category.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            category.icon,
            color: category.color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: category.color,
              ),
            ),
          ),
          Text(
            '${category.tools.length} tools',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolGrid(ToolCategory category) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: category.tools.length,
      itemBuilder: (context, index) {
        return _buildToolCard(category.tools[index], category.color);
      },
    );
  }

  Widget _buildToolCard(Tool tool, Color categoryColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToolDetailScreen(
              tool: tool,
              categoryColor: categoryColor,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  categoryColor.withValues(alpha: 0.1),
                  categoryColor.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tool.icon,
                  size: 40,
                  color: categoryColor,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
        ),
      ),
    );
  }
}

/// Search delegate for tools
class ToolSearchDelegate extends SearchDelegate<Tool?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = <Tool>[];
    final categoryMap = <Tool, ToolCategory>{};

    for (final category in allCategories) {
      for (final tool in category.tools) {
        if (tool.name.toLowerCase().contains(query.toLowerCase()) ||
            tool.description.toLowerCase().contains(query.toLowerCase())) {
          results.add(tool);
          categoryMap[tool] = category;
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
            Text(
              'No tools found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final tool = results[index];
        final category = categoryMap[tool]!;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: category.color.withValues(alpha: 0.2),
            child: Icon(tool.icon, color: category.color),
          ),
          title: Text(tool.name),
          subtitle: Text(tool.description),
          trailing: Chip(
            label: Text(
              category.name,
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: category.color.withValues(alpha: 0.2),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ToolDetailScreen(
                  tool: tool,
                  categoryColor: category.color,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
