import 'package:flutter/material.dart';
import 'theme_provider.dart';
import '../features/home/enhanced_home_screen.dart';

/// Main app widget with theme management
class ConverterApp extends StatefulWidget {
  const ConverterApp({super.key});

  @override
  State<ConverterApp> createState() => _ConverterAppState();
}

class _ConverterAppState extends State<ConverterApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'All-in-One Toolbox',
          theme: _themeProvider.getThemeData(),
          home: EnhancedHomeScreen(themeProvider: _themeProvider),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

