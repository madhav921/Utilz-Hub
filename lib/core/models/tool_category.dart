import 'package:flutter/material.dart';

/// Represents a category of tools shown on the home screen.
class ToolCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<Tool> tools;
  final int sortOrder;
  final bool showOnHome;

  const ToolCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.tools,
    required this.sortOrder,
    this.showOnHome = true,
  });

  ToolCategory copyWith({int? sortOrder, bool? showOnHome}) {
    return ToolCategory(
      id: id,
      name: name,
      icon: icon,
      color: color,
      tools: tools,
      sortOrder: sortOrder ?? this.sortOrder,
      showOnHome: showOnHome ?? this.showOnHome,
    );
  }
}

/// Represents an individual tool/calculator/converter.
class Tool {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final ToolType type;
  final bool isLive;

  const Tool({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.type,
    this.isLive = false,
  });
}

enum ToolType { calculator, converter }

// ============================================================
// CATEGORY DEFINITIONS — sorted by most used daily
// Each tool appears in EXACTLY one category. No duplicates.
// ============================================================

final List<ToolCategory> defaultCategories = [
  // ── 1. Everyday Essentials (only in My Space) ──────────────
  const ToolCategory(
    id: 'everyday',
    name: 'Everyday Essentials',
    icon: Icons.favorite_outline,
    color: Color(0xFFEC4899),
    sortOrder: 0,
    showOnHome: false,
    tools: [
      Tool(
        id: 'discount',
        name: 'Discount',
        icon: Icons.local_offer,
        description: 'Calculate sale prices & savings',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'tip',
        name: 'Tip Calculator',
        icon: Icons.restaurant,
        description: 'Calculate tips & split bills',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'bill_splitter',
        name: 'Bill Splitter',
        icon: Icons.people,
        description: 'Split bills among friends',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'fuel_cost',
        name: 'Fuel Cost',
        icon: Icons.local_gas_station,
        description: 'Calculate trip fuel expenses',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 2. Finance & Loans ────────────────────────────────────
  const ToolCategory(
    id: 'finance',
    name: 'Finance & Loans',
    icon: Icons.account_balance_wallet,
    color: Color(0xFF10B981),
    sortOrder: 1,
    tools: [
      Tool(
        id: 'emi',
        name: 'EMI Calculator',
        icon: Icons.payments,
        description: 'Monthly loan installments',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'simple_interest',
        name: 'Simple Interest',
        icon: Icons.attach_money,
        description: 'Calculate simple interest',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'compound_interest',
        name: 'Compound Interest',
        icon: Icons.account_balance,
        description: 'Calculate compound interest',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'sip',
        name: 'SIP Calculator',
        icon: Icons.trending_up,
        description: 'Systematic investment returns',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'fd_rd',
        name: 'FD/RD Calculator',
        icon: Icons.savings,
        description: 'Fixed & recurring deposit returns',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'loan_compare',
        name: 'Loan Compare',
        icon: Icons.compare_arrows,
        description: 'Compare two loan options',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'depreciation',
        name: 'Depreciation',
        icon: Icons.trending_down,
        description: 'SLM, WDV & DDB depreciation',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'loan_prepayment',
        name: 'Loan Prepayment',
        icon: Icons.price_check,
        description: 'Foreclosure savings calculator',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'inflation_calculator',
        name: 'Inflation Calculator',
        icon: Icons.show_chart,
        description: 'Inflation-adjusted value over time',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'currency_denomination',
        name: 'Cash Denomination',
        icon: Icons.payments_outlined,
        description: 'Split amount into note denominations',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 3. Business & Tax ─────────────────────────────────────
  const ToolCategory(
    id: 'business',
    name: 'Business & Tax',
    icon: Icons.business_center,
    color: Color(0xFFF59E0B),
    sortOrder: 2,
    tools: [
      Tool(
        id: 'gst',
        name: 'GST Calculator',
        icon: Icons.receipt,
        description: 'GST with CGST/SGST breakdown',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'profit_loss',
        name: 'Profit & Loss',
        icon: Icons.analytics,
        description: 'Calculate profit margins',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'markup_margin',
        name: 'Markup & Margin',
        icon: Icons.price_change,
        description: 'Markup vs margin calculator',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'break_even',
        name: 'Break-Even',
        icon: Icons.equalizer,
        description: 'Find break-even point',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'unit_price',
        name: 'Unit Price Compare',
        icon: Icons.compare,
        description: 'Compare price per unit',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'salary_breakup',
        name: 'Salary Breakup',
        icon: Icons.account_box,
        description: 'CTC → in-hand breakup',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'tax_estimator',
        name: 'Tax Estimator',
        icon: Icons.request_page,
        description: 'Basic income tax estimate',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'stamp_duty',
        name: 'Stamp Duty',
        icon: Icons.gavel,
        description: 'Stamp duty & registration',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'penalty_calculator',
        name: 'Penalty Calculator',
        icon: Icons.warning_amber,
        description: 'Penalty / fine on overdue',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'roi_calculator',
        name: 'ROI Calculator',
        icon: Icons.pie_chart_outline,
        description: 'Return on investment analysis',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 4. Math & Numbers ─────────────────────────────────────
  const ToolCategory(
    id: 'math',
    name: 'Math & Numbers',
    icon: Icons.calculate_outlined,
    color: Color(0xFF3B82F6),
    sortOrder: 3,
    tools: [
      Tool(
        id: 'percentage',
        name: 'Percentage',
        icon: Icons.percent,
        description: 'Calculate percentages easily',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'percentage_change',
        name: '% Change',
        icon: Icons.trending_up,
        description: 'Percentage increase/decrease',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'ratio',
        name: 'Ratio',
        icon: Icons.balance,
        description: 'Calculate & simplify ratios',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'number_base',
        name: 'Number Base',
        icon: Icons.tag,
        description: 'Binary, Hex, Decimal, Octal',
        type: ToolType.converter,
      ),
      Tool(
        id: 'scientific_notation',
        name: 'Scientific Notation',
        icon: Icons.functions,
        description: 'Standard ↔ scientific form',
        type: ToolType.converter,
      ),
      Tool(
        id: 'fraction_decimal',
        name: 'Fraction ↔ Decimal',
        icon: Icons.pie_chart,
        description: 'Convert fractions & decimals',
        type: ToolType.converter,
      ),
      Tool(
        id: 'speed_distance_time',
        name: 'Speed·Distance·Time',
        icon: Icons.directions_run,
        description: 'Speed = Distance ÷ Time',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'gpa_cgpa',
        name: 'GPA / CGPA',
        icon: Icons.school,
        description: 'GPA calculator & % ↔ GPA',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 5. Unit Converters ────────────────────────────────────
  const ToolCategory(
    id: 'converters',
    name: 'Unit Converters',
    icon: Icons.sync_alt,
    color: Color(0xFF6366F1),
    sortOrder: 4,
    tools: [
      Tool(
        id: 'length',
        name: 'Length',
        icon: Icons.straighten,
        description: 'Meters, feet, miles & more',
        type: ToolType.converter,
      ),
      Tool(
        id: 'weight',
        name: 'Weight',
        icon: Icons.monitor_weight,
        description: 'Kilograms, pounds, ounces',
        type: ToolType.converter,
      ),
      Tool(
        id: 'temperature',
        name: 'Temperature',
        icon: Icons.thermostat,
        description: 'Celsius, Fahrenheit, Kelvin',
        type: ToolType.converter,
      ),
      Tool(
        id: 'area',
        name: 'Area',
        icon: Icons.crop_square,
        description: 'sq.m, acres, hectares',
        type: ToolType.converter,
      ),
      Tool(
        id: 'volume',
        name: 'Volume',
        icon: Icons.water_drop,
        description: 'Liters, gallons, cups',
        type: ToolType.converter,
      ),
      Tool(
        id: 'speed',
        name: 'Speed',
        icon: Icons.speed,
        description: 'km/h, mph, knots',
        type: ToolType.converter,
      ),
      Tool(
        id: 'time_unit',
        name: 'Time',
        icon: Icons.access_time,
        description: 'Seconds to years',
        type: ToolType.converter,
      ),
      Tool(
        id: 'pressure',
        name: 'Pressure',
        icon: Icons.air,
        description: 'Pascal, bar, PSI, atm',
        type: ToolType.converter,
      ),
      Tool(
        id: 'energy',
        name: 'Energy',
        icon: Icons.bolt,
        description: 'Joules, calories, kWh',
        type: ToolType.converter,
      ),
      Tool(
        id: 'power',
        name: 'Power',
        icon: Icons.power,
        description: 'Watts, horsepower',
        type: ToolType.converter,
      ),
      Tool(
        id: 'data_storage',
        name: 'Data Storage',
        icon: Icons.storage,
        description: 'Bytes, KB, MB, GB, TB',
        type: ToolType.converter,
      ),
      Tool(
        id: 'angle_converter',
        name: 'Angle',
        icon: Icons.rotate_right,
        description: 'Degree, radian, gradian',
        type: ToolType.converter,
      ),
      Tool(
        id: 'fuel_efficiency',
        name: 'Fuel Efficiency',
        icon: Icons.local_gas_station,
        description: 'km/l ↔ mpg ↔ l/100km',
        type: ToolType.converter,
      ),
    ],
  ),

  // ── 6. Geometry ───────────────────────────────────────────
  const ToolCategory(
    id: 'geometry',
    name: 'Geometry',
    icon: Icons.square_foot,
    color: Color(0xFF14B8A6),
    sortOrder: 5,
    tools: [
      Tool(
        id: 'circle',
        name: 'Circle',
        icon: Icons.circle_outlined,
        description: 'Area & circumference',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'triangle',
        name: 'Triangle',
        icon: Icons.change_history,
        description: 'Area, perimeter, angles',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'rectangle',
        name: 'Rectangle',
        icon: Icons.crop_landscape,
        description: 'Perimeter & area',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'volume_3d',
        name: '3D Shapes',
        icon: Icons.view_in_ar,
        description: 'Sphere, cylinder, cone, cube',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'slope_calculator',
        name: 'Slope & Angle',
        icon: Icons.signal_cellular_alt,
        description: 'Rise/run, grade, degrees',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 7. Time & Date ────────────────────────────────────────
  const ToolCategory(
    id: 'time_date',
    name: 'Time & Date',
    icon: Icons.schedule,
    color: Color(0xFF8B5CF6),
    sortOrder: 6,
    tools: [
      Tool(
        id: 'date_difference',
        name: 'Date Difference',
        icon: Icons.date_range,
        description: 'Days between two dates',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'age',
        name: 'Age Calculator',
        icon: Icons.cake,
        description: 'Calculate exact age in detail',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'work_hours',
        name: 'Work Hours',
        icon: Icons.work_outline,
        description: 'Calculate work hours & pay',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'countdown',
        name: 'Countdown',
        icon: Icons.timer,
        description: 'Days until a target date',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'timestamp_converter',
        name: 'Timestamp ↔ Date',
        icon: Icons.schedule_send,
        description: 'Unix timestamp converter',
        type: ToolType.converter,
      ),
    ],
  ),

  // ── 8. Live Rates ─────────────────────────────────────────
  const ToolCategory(
    id: 'live_rates',
    name: 'Live Rates',
    icon: Icons.cell_tower,
    color: Color(0xFFEF4444),
    sortOrder: 7,
    tools: [
      Tool(
        id: 'currency',
        name: 'Currency',
        icon: Icons.currency_exchange,
        description: 'Live currency conversion',
        type: ToolType.converter,
        isLive: true,
      ),
      Tool(
        id: 'gold_price',
        name: 'Gold Price',
        icon: Icons.diamond,
        description: 'Live gold price by region & karat',
        type: ToolType.calculator,
        isLive: true,
      ),
      Tool(
        id: 'silver_price',
        name: 'Silver Price',
        icon: Icons.circle_outlined,
        description: 'Live silver price by grade',
        type: ToolType.calculator,
        isLive: true,
      ),
      Tool(
        id: 'fuel_price_live',
        name: 'Fuel Prices',
        icon: Icons.local_gas_station,
        description: 'Live fuel prices by country',
        type: ToolType.calculator,
        isLive: true,
      ),
    ],
  ),

  // ── 9. Health & Body ──────────────────────────────────────
  const ToolCategory(
    id: 'health',
    name: 'Health & Body',
    icon: Icons.health_and_safety,
    color: Color(0xFFE11D48),
    sortOrder: 8,
    tools: [
      Tool(        id: 'bmi',
        name: 'BMI & Calories',
        icon: Icons.fitness_center,
        description: 'Body mass index & daily needs',
        type: ToolType.calculator,
      ),
      Tool(        id: 'bsa_calculator',
        name: 'Body Surface Area',
        icon: Icons.accessibility_new,
        description: 'BSA for drug dosing',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'dosage_calculator',
        name: 'Dosage Calculator',
        icon: Icons.medication,
        description: 'Drug dose by body weight',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'heart_rate_zones',
        name: 'Heart Rate Zones',
        icon: Icons.monitor_heart,
        description: 'Training heart rate zones',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'fluid_intake',
        name: 'Fluid Intake',
        icon: Icons.water,
        description: 'Daily water intake guide',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'ideal_body_weight',
        name: 'Ideal Body Weight',
        icon: Icons.accessibility,
        description: 'IBW by height & frame size',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 10. Engineering (professions only) ────────────────────
  const ToolCategory(
    id: 'engineering',
    name: 'Engineering',
    icon: Icons.engineering,
    color: Color(0xFF0891B2),
    sortOrder: 9,
    showOnHome: false,
    tools: [
      Tool(
        id: 'pipe_flow',
        name: 'Pipe Flow',
        icon: Icons.plumbing,
        description: 'Pipe diameter & flow rate',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'tank_capacity',
        name: 'Tank Capacity',
        icon: Icons.propane_tank,
        description: 'Water tank volume',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'wood_volume',
        name: 'Wood Volume',
        icon: Icons.forest,
        description: 'Board feet & cubic volume',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'material_estimator',
        name: 'Material Estimator',
        icon: Icons.inventory_2,
        description: 'Bricks, cement, tiles, paint',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'wastage_calculator',
        name: 'Wastage %',
        icon: Icons.delete_sweep,
        description: 'Material wastage calculator',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'load_calculator',
        name: 'Load Calculator',
        icon: Icons.fitness_center,
        description: 'Force, stress from mass',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'efficiency_calculator',
        name: 'Efficiency',
        icon: Icons.speed,
        description: 'Input vs output efficiency',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'ohms_law',
        name: "Ohm's Law",
        icon: Icons.electrical_services,
        description: 'V = I × R calculator',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'wire_gauge',
        name: 'Wire Gauge (AWG)',
        icon: Icons.cable,
        description: 'Wire size & current reference',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 11. Digital Tools (professions only) ──────────────────
  const ToolCategory(
    id: 'digital',
    name: 'Digital Tools',
    icon: Icons.code,
    color: Color(0xFF7C3AED),
    sortOrder: 10,
    showOnHome: false,
    tools: [
      Tool(
        id: 'color_converter',
        name: 'Color Converter',
        icon: Icons.palette,
        description: 'HEX ↔ RGB ↔ HSL',
        type: ToolType.converter,
      ),
      Tool(
        id: 'screen_dpi',
        name: 'Screen DPI',
        icon: Icons.screenshot_monitor,
        description: 'PPI & resolution calculator',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'file_size_estimator',
        name: 'File Size',
        icon: Icons.insert_drive_file,
        description: 'Image/video/audio size estimate',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'base64_encoder',
        name: 'Base64 Encoder',
        icon: Icons.code,
        description: 'Encode & decode Base64 text',
        type: ToolType.converter,
      ),
    ],
  ),

  // ── 12. Real Estate & Vehicle (professions only) ──────────
  const ToolCategory(
    id: 'real_estate',
    name: 'Real Estate & Vehicle',
    icon: Icons.real_estate_agent,
    color: Color(0xFFFB923C),
    sortOrder: 11,
    showOnHome: false,
    tools: [
      Tool(
        id: 'vehicle_cost',
        name: 'Vehicle Cost',
        icon: Icons.directions_car,
        description: 'On-road price with RTO, insurance',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'flat_buying',
        name: 'Flat Buying Cost',
        icon: Icons.apartment,
        description: 'Total property buying cost',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'rent_calculator',
        name: 'Rent Calculator',
        icon: Icons.house,
        description: 'Rent affordability & costs',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'unit_cost_area',
        name: 'Cost per Area',
        icon: Icons.square_foot,
        description: 'Price per sq.ft / sq.m',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'loan_eligibility',
        name: 'Loan Eligibility',
        icon: Icons.verified,
        description: 'Check how much loan you qualify for',
        type: ToolType.calculator,
      ),
    ],
  ),

  // ── 13. Document Tools (Coming Soon) ──────────────────────
  const ToolCategory(
    id: 'document_tools',
    name: 'Document Tools',
    icon: Icons.description,
    color: Color(0xFF64748B),
    sortOrder: 12,
    tools: [
      Tool(
        id: 'pdf_merge',
        name: 'Merge PDFs',
        icon: Icons.merge_type,
        description: 'Combine multiple PDF files',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'pdf_split',
        name: 'Split PDF',
        icon: Icons.call_split,
        description: 'Extract pages from a PDF',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'pdf_compress',
        name: 'Compress PDF',
        icon: Icons.compress,
        description: 'Reduce PDF file size',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'pdf_to_image',
        name: 'PDF → Image',
        icon: Icons.image,
        description: 'Convert PDF pages to images',
        type: ToolType.converter,
      ),
      Tool(
        id: 'image_to_pdf',
        name: 'Image → PDF',
        icon: Icons.picture_as_pdf,
        description: 'Convert images to a PDF',
        type: ToolType.converter,
      ),
      Tool(
        id: 'word_to_pdf',
        name: 'Word → PDF',
        icon: Icons.picture_as_pdf,
        description: 'Convert DOCX to PDF',
        type: ToolType.converter,
      ),
      Tool(
        id: 'pdf_to_word',
        name: 'PDF → Word',
        icon: Icons.article,
        description: 'Convert PDF to editable DOCX',
        type: ToolType.converter,
      ),
      Tool(
        id: 'pdf_watermark',
        name: 'Watermark PDF',
        icon: Icons.branding_watermark,
        description: 'Add text or image watermark',
        type: ToolType.calculator,
      ),
    ],
  ),
  // ── 14. Education Basics (Pre-School only) ─────────────────
  const ToolCategory(
    id: 'education_basics',
    name: 'Education Basics',
    icon: Icons.child_care,
    color: Color(0xFFF472B6),
    sortOrder: 13,
    showOnHome: false,
    tools: [
      Tool(
        id: 'number_compare',
        name: 'Number Compare',
        icon: Icons.swap_horiz,
        description: 'Compare two numbers (>, <, =)',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'counting_helper',
        name: 'Counting Helper',
        icon: Icons.grid_view,
        description: 'Visual counting 1–100',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'addition_subtraction',
        name: 'Add & Subtract',
        icon: Icons.add_circle_outline,
        description: 'Simple addition & subtraction',
        type: ToolType.calculator,
      ),
    ],
  ),
];

// ============================================================
// HELPER — build a flat lookup of every tool by id.
// ============================================================
final Map<String, Tool> allToolsById = {
  for (final cat in defaultCategories)
    for (final tool in cat.tools) tool.id: tool,
};

/// Returns the category that owns a given tool id.
ToolCategory? categoryForTool(String toolId) {
  for (final cat in defaultCategories) {
    for (final tool in cat.tools) {
      if (tool.id == toolId) return cat;
    }
  }
  return null;
}
