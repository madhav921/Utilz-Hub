import 'package:flutter/material.dart';
import '../../app/theme_provider.dart';
import '../../core/models/tool_category.dart';
import '../../core/services/home_shortcut_service.dart';
import '../home/home_screen.dart';
import '../home/tool_router.dart';
import '../professions/professions_screen.dart';
import '../my_space/my_space_screen.dart';

/// Shell with a bottom navigation bar containing three tabs:
///   0 — Home (category-based tools)
///   1 — Professions (profession-based tools)
///   2 — My Space (user folders & favourites)
class AppShell extends StatefulWidget {
  final ThemeProvider themeProvider;

  const AppShell({super.key, required this.themeProvider});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(themeProvider: widget.themeProvider),
      const ProfessionsScreen(),
      const MySpaceScreen(),
    ];
    _handleShortcutLaunch();
  }

  /// If the app was opened via a pinned home-screen shortcut, navigate
  /// directly to the requested tool.
  Future<void> _handleShortcutLaunch() async {
    final toolId = await HomeShortcutService.getInitialToolId();
    if (toolId == null || !mounted) return;

    final allTools = allToolsById;
    final tool = allTools[toolId];
    if (tool == null) return;

    // Find the category colour for this tool
    final cat = defaultCategories.firstWhere(
      (c) => c.tools.any((t) => t.id == toolId),
      orElse: () => defaultCategories.first,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ToolRouter.getScreen(tool, cat.color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        animationDuration: const Duration(milliseconds: 400),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primaryContainer,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Professions',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'My Space',
          ),
        ],
      ),
    );
  }
}
