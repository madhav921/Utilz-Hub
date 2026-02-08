import 'package:flutter/material.dart';

/// Tool categories with their tools
class ToolCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<Tool> tools;

  const ToolCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.tools,
  });
}

/// Individual tool/calculator/converter
class Tool {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final ToolType type;

  const Tool({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.type,
  });
}

enum ToolType {
  calculator,
  converter,
}

/// All tool categories
final List<ToolCategory> allCategories = [
  // General Math
  ToolCategory(
    id: 'general_math',
    name: 'General Math',
    icon: Icons.calculate_outlined,
    color: const Color(0xFF3B82F6),
    tools: const [
      Tool(
        id: 'percentage',
        name: 'Percentage',
        icon: Icons.percent,
        description: 'Calculate percentages easily',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'percentage_change',
        name: 'Percentage Change',
        icon: Icons.trending_up,
        description: 'Calculate % increase/decrease',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'ratio',
        name: 'Ratio Calculator',
        icon: Icons.compare_arrows,
        description: 'Calculate and simplify ratios',
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
    ],
  ),

  // Finance & Budgeting
  ToolCategory(
    id: 'finance_budgeting',
    name: 'Finance & Budgeting',
    icon: Icons.account_balance_wallet,
    color: const Color(0xFF10B981),
    tools: const [
      Tool(
        id: 'emi',
        name: 'EMI Calculator',
        icon: Icons.payments,
        description: 'Calculate monthly EMI payments',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'loan_interest',
        name: 'Loan Interest',
        icon: Icons.local_atm,
        description: 'Calculate loan interest',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'sip_calculator',
        name: 'SIP/MF Returns',
        icon: Icons.trending_up,
        description: 'Calculate SIP returns',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'fd_rd',
        name: 'FD/RD Interest',
        icon: Icons.savings,
        description: 'Fixed & recurring deposits',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'tax_savings',
        name: 'Tax Savings',
        icon: Icons.receipt_long,
        description: 'Estimate tax savings',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'mortgage',
        name: 'Mortgage Calculator',
        icon: Icons.home,
        description: 'Calculate mortgage payments',
        type: ToolType.calculator,
      ),
    ],
  ),

  // Business Tools
  ToolCategory(
    id: 'business_tools',
    name: 'Business Tools',
    icon: Icons.business_center,
    color: const Color(0xFFF59E0B),
    tools: const [
      Tool(
        id: 'gst',
        name: 'GST Calculator',
        icon: Icons.receipt,
        description: 'Calculate GST with detailed breakdown',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'profit_loss',
        name: 'Profit & Loss',
        icon: Icons.analytics,
        description: 'Calculate profit and loss',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'markup_margin',
        name: 'Markup & Margin',
        icon: Icons.price_change,
        description: 'Calculate markup and margin',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'break_even',
        name: 'Break-Even Analysis',
        icon: Icons.equalizer,
        description: 'Find break-even point',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'unit_cost',
        name: 'Unit Cost',
        icon: Icons.shopping_cart,
        description: 'Calculate cost per unit',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'unit_price',
        name: 'Unit Price Compare',
        icon: Icons.compare,
        description: 'Compare unit prices',
        type: ToolType.calculator,
      ),
    ],
  ),

  // Everyday Life
  ToolCategory(
    id: 'everyday_life',
    name: 'Everyday Life',
    icon: Icons.home_outlined,
    color: const Color(0xFFEC4899),
    tools: const [
      Tool(
        id: 'discount',
        name: 'Discount Calculator',
        icon: Icons.local_offer,
        description: 'Calculate sale prices',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'tip',
        name: 'Tip Calculator',
        icon: Icons.restaurant,
        description: 'Calculate tips easily',
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
        id: 'currency',
        name: 'Currency Converter',
        icon: Icons.currency_exchange,
        description: 'Convert between currencies',
        type: ToolType.converter,
      ),
      Tool(
        id: 'fuel_cost',
        name: 'Fuel Cost',
        icon: Icons.local_gas_station,
        description: 'Calculate fuel expenses',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'bmi',
        name: 'BMI & Calories',
        icon: Icons.fitness_center,
        description: 'BMI and calorie needs',
        type: ToolType.calculator,
      ),
    ],
  ),

  // Time & Planning
  ToolCategory(
    id: 'time_planning',
    name: 'Time & Planning',
    icon: Icons.schedule,
    color: const Color(0xFF8B5CF6),
    tools: const [
      Tool(
        id: 'age',
        name: 'Age Calculator',
        icon: Icons.cake,
        description: 'Calculate exact age',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'date_difference',
        name: 'Date Difference',
        icon: Icons.date_range,
        description: 'Days between dates',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'work_hours',
        name: 'Work Hours',
        icon: Icons.work_outline,
        description: 'Calculate work hours',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'countdown',
        name: 'Countdown Timer',
        icon: Icons.timer,
        description: 'Count down to a date',
        type: ToolType.calculator,
      ),
    ],
  ),

  // Engineering & Scientific
  ToolCategory(
    id: 'engineering_scientific',
    name: 'Engineering & Scientific',
    icon: Icons.science_outlined,
    color: const Color(0xFF06B6D4),
    tools: const [
      Tool(
        id: 'number_base',
        name: 'Number Base',
        icon: Icons.tag,
        description: 'Hex/Binary/Decimal/Octal',
        type: ToolType.converter,
      ),
      Tool(
        id: 'scientific_notation',
        name: 'Scientific Notation',
        icon: Icons.functions,
        description: 'Scientific notation converter',
        type: ToolType.converter,
      ),
      Tool(
        id: 'log_exponential',
        name: 'Log & Exponential',
        icon: Icons.calculate,
        description: 'Log and exp calculator',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'vector_magnitude',
        name: 'Vector Magnitude',
        icon: Icons.arrow_forward,
        description: 'Calculate vector magnitude',
        type: ToolType.calculator,
      ),
    ],
  ),

  // Finance Advanced
  ToolCategory(
    id: 'finance_advanced',
    name: 'Finance Advanced',
    icon: Icons.trending_up,
    color: const Color(0xFFEF4444),
    tools: const [
      Tool(
        id: 'loan_amortization',
        name: 'Loan Amortization',
        icon: Icons.table_chart,
        description: 'Detailed payment schedule',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'sip_lumpsum',
        name: 'SIP vs Lumpsum',
        icon: Icons.compare_arrows,
        description: 'Compare investment strategies',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'inflation_adjusted',
        name: 'Inflation Adjusted',
        icon: Icons.show_chart,
        description: 'Inflation adjusted returns',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'investment_return',
        name: 'Investment Simulator',
        icon: Icons.insights,
        description: 'Simulate investment returns',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'retirement_needs',
        name: 'Retirement Needs',
        icon: Icons.elderly,
        description: 'Plan retirement corpus',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'crypto_profit',
        name: 'Crypto P&L',
        icon: Icons.currency_bitcoin,
        description: 'Crypto profit/loss',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'emi_prepayment',
        name: 'EMI Prepayment',
        icon: Icons.fast_forward,
        description: 'Early repayment benefits',
        type: ToolType.calculator,
      ),
    ],
  ),

  // Geometry Tools
  ToolCategory(
    id: 'geometry_tools',
    name: 'Geometry',
    icon: Icons.square_foot,
    color: const Color(0xFF14B8A6),
    tools: const [
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
        description: 'Area by sides',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'rectangle',
        name: 'Rectangle/Square',
        icon: Icons.crop_square,
        description: 'Perimeter & area',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'volume',
        name: '3D Volumes',
        icon: Icons.view_in_ar,
        description: 'Sphere/Cylinder/Cube',
        type: ToolType.calculator,
      ),
    ],
  ),

  // Unit Converters
  ToolCategory(
    id: 'unit_converters',
    name: 'Unit Converters',
    icon: Icons.sync_alt,
    color: const Color(0xFF6366F1),
    tools: const [
      Tool(
        id: 'length',
        name: 'Length',
        icon: Icons.straighten,
        description: 'Convert length units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'weight',
        name: 'Weight',
        icon: Icons.monitor_weight,
        description: 'Convert weight units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'temperature',
        name: 'Temperature',
        icon: Icons.thermostat,
        description: 'Convert temperature',
        type: ToolType.converter,
      ),
      Tool(
        id: 'area',
        name: 'Area',
        icon: Icons.crop_square,
        description: 'Convert area units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'volume',
        name: 'Volume',
        icon: Icons.water_drop,
        description: 'Convert volume units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'speed',
        name: 'Speed',
        icon: Icons.speed,
        description: 'Convert speed units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'time',
        name: 'Time',
        icon: Icons.access_time,
        description: 'Convert time units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'pressure',
        name: 'Pressure',
        icon: Icons.air,
        description: 'Convert pressure units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'energy',
        name: 'Energy',
        icon: Icons.bolt,
        description: 'Convert energy units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'power',
        name: 'Power',
        icon: Icons.power,
        description: 'Convert power units',
        type: ToolType.converter,
      ),
      Tool(
        id: 'data_storage',
        name: 'Data Storage',
        icon: Icons.storage,
        description: 'Bits/Bytes/KB/MB/GB',
        type: ToolType.converter,
      ),
      Tool(
        id: 'angle',
        name: 'Angle',
        icon: Icons.rotate_right,
        description: 'Degrees ↔ Radians',
        type: ToolType.converter,
      ),
    ],
  ),

  // Conversion Assistants
  ToolCategory(
    id: 'conversion_assistants',
    name: 'Specialized Converters',
    icon: Icons.swap_horiz,
    color: const Color(0xFFF97316),
    tools: const [
      Tool(
        id: 'fuel_consumption',
        name: 'Fuel Consumption',
        icon: Icons.local_gas_station,
        description: 'km/l ↔ mpg',
        type: ToolType.converter,
      ),
      Tool(
        id: 'shoe_size',
        name: 'Shoe Size',
        icon: Icons.directions_run,
        description: 'US ↔ UK ↔ EU',
        type: ToolType.converter,
      ),
      Tool(
        id: 'clothing_size',
        name: 'Clothing Size',
        icon: Icons.checkroom,
        description: 'S/M/L → International',
        type: ToolType.converter,
      ),
      Tool(
        id: 'color_code',
        name: 'Color Code',
        icon: Icons.palette,
        description: 'RGB ↔ HEX ↔ HSL',
        type: ToolType.converter,
      ),
      Tool(
        id: 'screen_size',
        name: 'Screen Size',
        icon: Icons.screenshot,
        description: 'Diagonal converter',
        type: ToolType.converter,
      ),
      Tool(
        id: 'file_size',
        name: 'File Size',
        icon: Icons.insert_drive_file,
        description: 'File size converter',
        type: ToolType.converter,
      ),
    ],
  ),

  // Investment & Planning
  ToolCategory(
    id: 'investment_planning',
    name: 'Investment & Planning',
    icon: Icons.account_balance,
    color: const Color(0xFF84CC16),
    tools: const [
      Tool(
        id: 'loan_vs_lease',
        name: 'Loan vs Lease',
        icon: Icons.compare,
        description: 'Compare loan and lease',
        type: ToolType.calculator,
      ),
      Tool(
        id: 'compound_growth',
        name: 'Compound Growth',
        icon: Icons.show_chart,
        description: 'Project compound growth',
        type: ToolType.calculator,
      ),
    ],
  ),
];
