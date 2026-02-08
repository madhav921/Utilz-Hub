import 'package:flutter/material.dart';
import '../../app/theme_provider.dart';
import '../home/home_screen.dart';
import '../professions/professions_screen.dart';

/// Shell with a bottom navigation bar containing two tabs:
///   0 — Home (category-based tools)
///   1 — Professions (profession-based tools)
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
    ];
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
        ],
      ),
    );
  }
}
