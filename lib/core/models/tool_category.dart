import 'package:flutter/material.dart';

/// Represents a category of tools shown on the home screen.
class ToolCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<Tool> tools;
  final int sortOrder;

  const ToolCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.tools,
    required this.sortOrder,
  });

  ToolCategory copyWith({int? sortOrder}) {
    return ToolCategory(
      id: id,
      name: name,
      icon: icon,
      color: color,
      tools: tools,
      sortOrder: sortOrder ?? this.sortOrder,
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
  // ── 1. Everyday Essentials ────────────────────────────────
  const ToolCategory(
    id: 'everyday',
    name: 'Everyday Essentials',
    icon: Icons.favorite_outline,
    color: Color(0xFFEC4899),
    sortOrder: 0,
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
      Tool(
        id: 'age',
        name: 'Age Calculator',
        icon: Icons.cake,
        description: 'Calculate exact age in detail',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'bmi',
        name: 'BMI & Calories',
        icon: Icons.fitness_center,
        description: 'Body mass index & daily needs',
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
        id: 'mortgage',
        name: 'Mortgage',
        icon: Icons.home,
        description: 'Home loan EMI & amortization',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'loan_compare',
        name: 'Loan Compare',
        icon: Icons.compare_arrows,
        description: 'Compare two loan options',
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
        id: 'gold_silver',
        name: 'Gold & Silver',
        icon: Icons.diamond,
        description: 'Live precious metal prices',
        type: ToolType.calculator,
        isLive: true,
      ),
    ],
  ),
];
