import 'package:flutter/material.dart';
import '../../core/models/tool_category.dart';

// ── Existing calculator screens ──────────────────────────
import '../calculators/gst_calculator_screen.dart';
import '../calculators/emi_calculator_screen.dart';
import '../calculators/percentage_calculator_screen.dart';
import '../calculators/discount_calculator_screen.dart';
import '../calculators/tip_calculator_screen.dart';
import '../calculators/simple_interest_calculator_screen.dart';
import '../calculators/compound_interest_calculator_screen.dart';
import '../calculators/sip_calculator_screen.dart';
import '../calculators/bmi_calculator_screen.dart';
import '../calculators/age_calculator_screen.dart';

// ── New calculator screens ───────────────────────────────
import '../calculators/bill_splitter_screen.dart';
import '../calculators/fuel_cost_screen.dart';
import '../calculators/fd_rd_screen.dart';
import '../calculators/mortgage_screen.dart';
import '../calculators/loan_compare_screen.dart';
import '../calculators/profit_loss_screen.dart';
import '../calculators/markup_margin_screen.dart';
import '../calculators/break_even_screen.dart';
import '../calculators/unit_price_screen.dart';
import '../calculators/ratio_screen.dart';
import '../calculators/number_base_screen.dart';
import '../calculators/scientific_notation_screen.dart';
import '../calculators/circle_screen.dart';
import '../calculators/triangle_screen.dart';
import '../calculators/rectangle_screen.dart';
import '../calculators/volume_3d_screen.dart';
import '../calculators/date_difference_screen.dart';
import '../calculators/work_hours_screen.dart';
import '../calculators/countdown_screen.dart';

// ── Live rate screens ────────────────────────────────────
import '../live/currency_converter_screen.dart';
import '../live/gold_price_screen.dart';
import '../live/silver_price_screen.dart';
import '../live/fuel_price_screen.dart';

// ── Unit converter ───────────────────────────────────────
import '../converters/converter_screen.dart';

/// Central router that maps [Tool.id] to its screen widget.
///
/// Keeps all navigation in one place for easy debugging.
class ToolRouter {
  static Widget getScreen(Tool tool, Color color) {
    switch (tool.id) {
      // ── Everyday Essentials ─────────────────────────────
      case 'discount':
        return DiscountCalculatorScreen(categoryColor: color);
      case 'tip':
        return TipCalculatorScreen(categoryColor: color);
      case 'bill_splitter':
        return BillSplitterScreen(categoryColor: color);
      case 'fuel_cost':
        return FuelCostScreen(categoryColor: color);
      case 'age':
        return AgeCalculatorScreen(categoryColor: color);
      case 'bmi':
        return BMICalculatorScreen(categoryColor: color);

      // ── Finance & Loans ─────────────────────────────────
      case 'emi':
        return EMICalculatorScreen(categoryColor: color);
      case 'simple_interest':
        return SimpleInterestCalculatorScreen(categoryColor: color);
      case 'compound_interest':
        return CompoundInterestCalculatorScreen(categoryColor: color);
      case 'sip':
        return SIPCalculatorScreen(categoryColor: color);
      case 'fd_rd':
        return FdRdScreen(categoryColor: color);
      case 'mortgage':
        return MortgageScreen(categoryColor: color);
      case 'loan_compare':
        return LoanCompareScreen(categoryColor: color);

      // ── Business & Tax ──────────────────────────────────
      case 'gst':
        return GSTCalculatorScreen(categoryColor: color);
      case 'profit_loss':
        return ProfitLossScreen(categoryColor: color);
      case 'markup_margin':
        return MarkupMarginScreen(categoryColor: color);
      case 'break_even':
        return BreakEvenScreen(categoryColor: color);
      case 'unit_price':
        return UnitPriceScreen(categoryColor: color);

      // ── Math & Numbers ──────────────────────────────────
      case 'percentage':
        return PercentageCalculatorScreen(
          categoryColor: color,
          mode: PercentageMode.basic,
        );
      case 'percentage_change':
        return PercentageCalculatorScreen(
          categoryColor: color,
          mode: PercentageMode.change,
        );
      case 'ratio':
        return RatioScreen(categoryColor: color);
      case 'number_base':
        return NumberBaseScreen(categoryColor: color);
      case 'scientific_notation':
        return ScientificNotationScreen(categoryColor: color);

      // ── Unit Converters ─────────────────────────────────
      case 'length':
      case 'weight':
      case 'temperature':
      case 'area':
      case 'volume':
      case 'speed':
      case 'pressure':
      case 'energy':
      case 'power':
      case 'data_storage':
        return ConverterScreen(categoryId: tool.id);
      case 'time_unit':
        return ConverterScreen(categoryId: 'time');

      // ── Geometry ────────────────────────────────────────
      case 'circle':
        return CircleScreen(categoryColor: color);
      case 'triangle':
        return TriangleScreen(categoryColor: color);
      case 'rectangle':
        return RectangleScreen(categoryColor: color);
      case 'volume_3d':
        return Volume3DScreen(categoryColor: color);

      // ── Time & Date ─────────────────────────────────────
      case 'date_difference':
        return DateDifferenceScreen(categoryColor: color);
      case 'work_hours':
        return WorkHoursScreen(categoryColor: color);
      case 'countdown':
        return CountdownScreen(categoryColor: color);

      // ── Live Rates ──────────────────────────────────────
      case 'currency':
        return CurrencyConverterScreen(categoryColor: color);
      case 'gold_price':
        return GoldPriceScreen(categoryColor: color);
      case 'silver_price':
        return SilverPriceScreen(categoryColor: color);
      case 'fuel_price_live':
        return FuelPriceScreen(categoryColor: color);

      default:
        return _UnknownToolScreen(tool: tool, color: color);
    }
  }
}

class _UnknownToolScreen extends StatelessWidget {
  final Tool tool;
  final Color color;

  const _UnknownToolScreen({required this.tool, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tool.name)),
      body: Center(
        child: Text('Tool "${tool.id}" not found.',
            style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
