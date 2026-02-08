import 'package:flutter/material.dart';

/// A placeholder screen for tools that are coming soon (e.g. Document Tools).
class ComingSoonScreen extends StatelessWidget {
  final String toolName;
  final IconData toolIcon;
  final Color accentColor;

  const ComingSoonScreen({
    super.key,
    required this.toolName,
    required this.toolIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toolName),
        backgroundColor: accentColor.withValues(alpha: 0.1),
        foregroundColor: accentColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.1),
                ),
                child: Icon(toolIcon, size: 56, color: accentColor),
              ),
              const SizedBox(height: 24),
              Text(
                'Coming Soon',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$toolName is currently under development and will be '
                'available in an upcoming update.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: accentColor.withValues(alpha: 0.08),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_active_outlined,
                        size: 18, color: accentColor),
                    const SizedBox(width: 8),
                    Text(
                      'Stay tuned!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: accentColor,
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
