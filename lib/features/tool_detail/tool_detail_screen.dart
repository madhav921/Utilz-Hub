import 'package:flutter/material.dart';
import 'package:all_in_one_converter/core/models/tool_models.dart';
import 'package:all_in_one_converter/features/calculators/gst_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/emi_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/percentage_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/discount_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/tip_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/simple_interest_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/compound_interest_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/sip_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/bmi_calculator_screen.dart';
import 'package:all_in_one_converter/features/calculators/age_calculator_screen.dart';
import 'package:all_in_one_converter/features/converters/converter_screen.dart';

/// Tool detail screen - routes to specific calculator/converter
class ToolDetailScreen extends StatelessWidget {
  final Tool tool;
  final Color categoryColor;

  const ToolDetailScreen({
    super.key,
    required this.tool,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return _getToolScreen();
  }

  Widget _getToolScreen() {
    switch (tool.id) {
      // General Math
      case 'percentage':
        return PercentageCalculatorScreen(categoryColor: categoryColor);
      case 'percentage_change':
        return PercentageCalculatorScreen(categoryColor: categoryColor, mode: PercentageMode.change);
      case 'simple_interest':
        return SimpleInterestCalculatorScreen(categoryColor: categoryColor);
      case 'compound_interest':
        return CompoundInterestCalculatorScreen(categoryColor: categoryColor);

      // Finance & Budgeting
      case 'emi':
        return EMICalculatorScreen(categoryColor: categoryColor);
      case 'sip_calculator':
        return SIPCalculatorScreen(categoryColor: categoryColor);

      // Business Tools
      case 'gst':
        return GSTCalculatorScreen(categoryColor: categoryColor);

      // Everyday Life
      case 'discount':
        return DiscountCalculatorScreen(categoryColor: categoryColor);
      case 'tip':
        return TipCalculatorScreen(categoryColor: categoryColor);
      case 'bmi':
        return BMICalculatorScreen(categoryColor: categoryColor);

      // Time & Planning
      case 'age':
        return AgeCalculatorScreen(categoryColor: categoryColor);

      // Unit Converters
      case 'length':
      case 'weight':
      case 'temperature':
      case 'area':
      case 'volume':
      case 'speed':
      case 'time':
      case 'pressure':
      case 'energy':
      case 'power':
        return ConverterScreen(categoryId: tool.id);

      // Default placeholder for not-yet-implemented tools
      default:
        return _ComingSoonScreen(tool: tool, categoryColor: categoryColor);
    }
  }
}

/// Coming soon screen for tools under development
class _ComingSoonScreen extends StatelessWidget {
  final Tool tool;
  final Color categoryColor;

  const _ComingSoonScreen({
    required this.tool,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tool.name),
        backgroundColor: categoryColor.withValues(alpha: 0.1),
        foregroundColor: categoryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tool.icon,
              size: 100,
              color: categoryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              tool.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                tool.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '🚧 Coming Soon 🚧',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'This calculator is under development and will be available in the next update.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
