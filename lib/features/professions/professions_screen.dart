import 'package:flutter/material.dart';
import '../../core/models/profession_category.dart';
import 'profession_tools_screen.dart';

/// Grid of 11 profession categories.
class ProfessionsScreen extends StatelessWidget {
  const ProfessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tools by Profession'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: professionCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (ctx, i) {
            final prof = professionCategories[i];
            return _ProfessionCard(profession: prof, theme: theme);
          },
        ),
      ),
    );
  }
}

class _ProfessionCard extends StatelessWidget {
  final ProfessionCategory profession;
  final ThemeData theme;

  const _ProfessionCard({required this.profession, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: isDark
          ? profession.color.withAlpha(40)
          : profession.color.withAlpha(25),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfessionToolsScreen(profession: profession),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(profession.icon, size: 36, color: profession.color),
              const SizedBox(height: 8),
              Text(
                profession.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${profession.allToolIds.length} tools',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
