import 'package:flutter/material.dart';

/// A polished "Coming Soon" screen for the Custom Tool Builder feature.
///
/// Showcases what users will be able to do once the feature ships and
/// builds anticipation with a professional, informative layout.
class CustomToolBuilderScreen extends StatelessWidget {
  const CustomToolBuilderScreen({super.key});

  static const _accentColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Tool Builder'),
        backgroundColor: _accentColor.withValues(alpha: 0.1),
        foregroundColor: _accentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // ── Hero illustration ─────────────────────────
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _accentColor.withValues(alpha: 0.2),
                    _accentColor.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: const Icon(Icons.build_circle_outlined,
                  size: 64, color: _accentColor),
            ),
            const SizedBox(height: 24),

            // ── Headline ──────────────────────────────────
            const Text(
              'Build Your Own Tools',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _accentColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create personalised calculators and converters tailored '
              'to your exact needs — no coding required.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),

            // ── Feature preview cards ─────────────────────
            _FeaturePreviewCard(
              icon: Icons.functions,
              title: 'Custom Formulas',
              description:
                  'Define your own formulas with variables, '
                  'operators, and functions like sqrt, pow, round.',
              isDark: isDark,
            ),
            _FeaturePreviewCard(
              icon: Icons.tune,
              title: 'Input Controls',
              description:
                  'Add sliders, text fields, dropdowns and toggles — '
                  'configure labels, units, min/max values.',
              isDark: isDark,
            ),
            _FeaturePreviewCard(
              icon: Icons.dashboard_customize,
              title: 'Visual Results',
              description:
                  'Display output as numbers, breakdowns, pie charts '
                  'or comparison tables — all customisable.',
              isDark: isDark,
            ),
            _FeaturePreviewCard(
              icon: Icons.folder_copy,
              title: 'Save & Organise',
              description:
                  'Save your custom tools to My Space folders, share '
                  'them with friends or export as templates.',
              isDark: isDark,
            ),
            _FeaturePreviewCard(
              icon: Icons.palette,
              title: 'Personalise',
              description:
                  'Choose icons, accent colours and category labels — '
                  'make every tool feel truly yours.',
              isDark: isDark,
            ),
            const SizedBox(height: 24),

            // ── Example preview mockup ────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _accentColor.withValues(alpha: 0.06),
                border: Border.all(
                  color: _accentColor.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.preview, size: 20, color: _accentColor),
                      const SizedBox(width: 8),
                      Text(
                        'Example: Paint Coverage Calculator',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MockInput(label: 'Wall Area', hint: 'sq.ft', isDark: isDark),
                  const SizedBox(height: 8),
                  _MockInput(label: 'Coats', hint: '2', isDark: isDark),
                  const SizedBox(height: 8),
                  _MockInput(
                      label: 'Coverage per Litre',
                      hint: '120 sq.ft',
                      isDark: isDark),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _accentColor.withValues(alpha: 0.12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paint Needed',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.black87)),
                        Text('8.3 litres',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _accentColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Coming Soon badge ─────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    _accentColor.withValues(alpha: 0.15),
                    _accentColor.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_outlined,
                      size: 20, color: _accentColor),
                  const SizedBox(width: 10),
                  const Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _accentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We\'re working hard to bring this feature to life.\n'
              'Stay tuned for updates!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Private helper widgets
// ═══════════════════════════════════════════════════════════

class _FeaturePreviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;

  const _FeaturePreviewCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomToolBuilderScreen._accentColor
                  .withValues(alpha: 0.1),
            ),
            child: Icon(icon, size: 22,
                color: CustomToolBuilderScreen._accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockInput extends StatelessWidget {
  final String label;
  final String hint;
  final bool isDark;

  const _MockInput({
    required this.label,
    required this.hint,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700)),
        ),
        Expanded(
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.grey.shade100,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.shade300,
              ),
            ),
            alignment: Alignment.centerRight,
            child: Text(hint,
                style: TextStyle(
                    fontSize: 13,
                    color:
                        isDark ? Colors.grey.shade600 : Colors.grey.shade400)),
          ),
        ),
      ],
    );
  }
}
