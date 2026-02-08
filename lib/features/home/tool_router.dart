import 'package:flutter/material.dart';
import '../../core/models/tool_category.dart';
import 'coming_soon_screen.dart';

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

// ── New tool screens (Math / Education) ──────────────────
import '../calculators/number_compare_screen.dart';
import '../calculators/counting_helper_screen.dart';
import '../calculators/addition_subtraction_screen.dart';
import '../calculators/fraction_decimal_screen.dart';
import '../calculators/speed_distance_time_screen.dart';
import '../calculators/gpa_cgpa_screen.dart';

// ── New tool screens (Converters / Time) ─────────────────
import '../converters/angle_converter_screen.dart';
import '../calculators/timestamp_converter_screen.dart';

// ── New tool screens (Finance / Business) ────────────────
import '../calculators/depreciation_screen.dart';
import '../calculators/salary_breakup_screen.dart';
import '../calculators/tax_estimator_screen.dart';
import '../calculators/stamp_duty_screen.dart';
import '../calculators/penalty_calculator_screen.dart';

// ── New tool screens (Real Estate & Vehicle) ─────────
import '../calculators/vehicle_cost_screen.dart';
import '../calculators/flat_buying_screen.dart';
import '../calculators/rent_calculator_screen.dart';

// ── New tool screens (Health) ────────────────────────────
import '../calculators/bsa_calculator_screen.dart';
import '../calculators/dosage_calculator_screen.dart';
import '../calculators/heart_rate_zones_screen.dart';
import '../calculators/fluid_intake_screen.dart';

// ── New tool screens (Engineering) ───────────────────────
import '../calculators/pipe_flow_screen.dart';
import '../calculators/tank_capacity_screen.dart';
import '../calculators/wood_volume_screen.dart';
import '../calculators/material_estimator_screen.dart';
import '../calculators/wastage_calculator_screen.dart';
import '../calculators/load_calculator_screen.dart';
import '../calculators/efficiency_calculator_screen.dart';
import '../calculators/ohms_law_screen.dart';
import '../calculators/wire_gauge_screen.dart';
import '../calculators/slope_calculator_screen.dart';

// ── New tool screens (Digital) ───────────────────────────
import '../calculators/color_converter_screen.dart';
import '../calculators/screen_dpi_screen.dart';
import '../calculators/file_size_estimator_screen.dart';

// ── New tool screens (v2.1) ──────────────────────────────
import '../calculators/roi_calculator_screen.dart';
import '../calculators/loan_prepayment_screen.dart';
import '../calculators/inflation_calculator_screen.dart';
import '../calculators/currency_denomination_screen.dart';
import '../converters/fuel_efficiency_screen.dart';
import '../calculators/ideal_body_weight_screen.dart';
import '../calculators/base64_encoder_screen.dart';
import '../calculators/unit_cost_area_screen.dart';
import '../calculators/loan_eligibility_screen.dart';

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
      case 'loan_compare':
        return LoanCompareScreen(categoryColor: color);
      case 'loan_prepayment':
        return LoanPrepaymentScreen(categoryColor: color);
      case 'inflation_calculator':
        return InflationCalculatorScreen(categoryColor: color);
      case 'currency_denomination':
        return CurrencyDenominationScreen(categoryColor: color);

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
      case 'roi_calculator':
        return RoiCalculatorScreen(categoryColor: color);

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

      // ── Math / Education (new) ──────────────────────────
      case 'fraction_decimal':
        return FractionDecimalScreen(categoryColor: color);
      case 'number_compare':
        return NumberCompareScreen(categoryColor: color);
      case 'addition_subtraction':
        return AdditionSubtractionScreen(categoryColor: color);
      case 'counting_helper':
        return CountingHelperScreen(categoryColor: color);
      case 'speed_distance_time':
        return SpeedDistanceTimeScreen(categoryColor: color);
      case 'gpa_cgpa':
        return GpaCgpaScreen(categoryColor: color);

      // ── Converters / Time (new) ─────────────────────────
      case 'angle_converter':
        return AngleConverterScreen(categoryColor: color);
      case 'fuel_efficiency':
        return FuelEfficiencyScreen(categoryColor: color);
      case 'timestamp_converter':
        return TimestampConverterScreen(categoryColor: color);

      // ── Finance / Business (new) ────────────────────────
      case 'depreciation':
        return DepreciationScreen(categoryColor: color);
      case 'salary_breakup':
        return SalaryBreakupScreen(categoryColor: color);
      case 'tax_estimator':
        return TaxEstimatorScreen(categoryColor: color);
      case 'stamp_duty':
        return StampDutyScreen(categoryColor: color);
      case 'penalty_calculator':
        return PenaltyCalculatorScreen(categoryColor: color);

      // ── Real Estate & Vehicle (new) ─────────────
      case 'vehicle_cost':
        return VehicleCostScreen(categoryColor: color);
      case 'flat_buying':
        return FlatBuyingScreen(categoryColor: color);
      case 'rent_calculator':
        return RentCalculatorScreen(categoryColor: color);
      case 'unit_cost_area':
        return UnitCostAreaScreen(categoryColor: color);
      case 'loan_eligibility':
        return LoanEligibilityScreen(categoryColor: color);

      // ── Health (new) ────────────────────────────────────
      case 'bsa_calculator':
        return BsaCalculatorScreen(categoryColor: color);
      case 'dosage_calculator':
        return DosageCalculatorScreen(categoryColor: color);
      case 'heart_rate_zones':
        return HeartRateZonesScreen(categoryColor: color);
      case 'fluid_intake':
        return FluidIntakeScreen(categoryColor: color);
      case 'ideal_body_weight':
        return IdealBodyWeightScreen(categoryColor: color);

      // ── Engineering (new) ───────────────────────────────
      case 'pipe_flow':
        return PipeFlowScreen(categoryColor: color);
      case 'tank_capacity':
        return TankCapacityScreen(categoryColor: color);
      case 'wood_volume':
        return WoodVolumeScreen(categoryColor: color);
      case 'material_estimator':
        return MaterialEstimatorScreen(categoryColor: color);
      case 'wastage_calculator':
        return WastageCalculatorScreen(categoryColor: color);
      case 'load_calculator':
        return LoadCalculatorScreen(categoryColor: color);
      case 'efficiency_calculator':
        return EfficiencyCalculatorScreen(categoryColor: color);
      case 'ohms_law':
        return OhmsLawScreen(categoryColor: color);
      case 'wire_gauge':
        return WireGaugeScreen(categoryColor: color);
      case 'slope_calculator':
        return SlopeCalculatorScreen(categoryColor: color);

      // ── Geometry (new) ──────────────────────────────────

      // ── Digital Tools (new) ─────────────────────────────
      case 'color_converter':
        return ColorConverterScreen(categoryColor: color);
      case 'screen_dpi':
        return ScreenDpiScreen(categoryColor: color);
      case 'file_size_estimator':
        return FileSizeEstimatorScreen(categoryColor: color);
      case 'base64_encoder':
        return Base64EncoderScreen(categoryColor: color);

      // ── Document Tools (Coming Soon) ────────────────────
      case 'pdf_merge':
      case 'pdf_split':
      case 'pdf_compress':
      case 'pdf_to_image':
      case 'image_to_pdf':
      case 'word_to_pdf':
      case 'pdf_to_word':
      case 'pdf_watermark':
        return ComingSoonScreen(
          toolName: tool.name,
          toolIcon: tool.icon,
          accentColor: color,
        );

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
