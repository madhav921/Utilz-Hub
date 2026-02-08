import 'package:flutter/material.dart';
import 'tool_category.dart';

/// A profession-based grouping that references tools by their id.
/// The actual [Tool] objects come from [defaultCategories] — no duplication.
class ProfessionCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  /// Tool ids that belong to this profession (looked up at runtime).
  final List<String> toolIds;

  /// Optional sub-categories for grouping tools within a profession.
  final List<ProfessionSubCategory>? subCategories;

  const ProfessionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.toolIds = const [],
    this.subCategories,
  });

  /// Whether this profession uses sub-category grouping.
  bool get hasSubCategories =>
      subCategories != null && subCategories!.isNotEmpty;

  /// All tool ids (flat list — from subCategories or direct toolIds).
  List<String> get allToolIds {
    if (hasSubCategories) {
      return subCategories!.expand((s) => s.toolIds).toList();
    }
    return toolIds;
  }

  /// Resolve ids to [Tool] objects via the master registry.
  List<Tool> get tools => allToolIds
      .where((id) => allToolsById.containsKey(id))
      .map((id) => allToolsById[id]!)
      .toList();
}

/// A sub-grouping within a profession (e.g. subject-wise for High School).
class ProfessionSubCategory {
  final String name;
  final IconData icon;
  final List<String> toolIds;

  const ProfessionSubCategory({
    required this.name,
    required this.icon,
    required this.toolIds,
  });

  List<Tool> get tools => toolIds
      .where((id) => allToolsById.containsKey(id))
      .map((id) => allToolsById[id]!)
      .toList();
}

// ============================================================
//  PROFESSION CATEGORIES
// ============================================================

const List<ProfessionCategory> professionCategories = [
  // 1 ─ Pre-School Kids
  ProfessionCategory(
    id: 'pre_school',
    name: 'Pre-School Kids',
    icon: Icons.child_care,
    color: Color(0xFFF472B6),
    toolIds: [
      'number_compare',
      'counting_helper',
      'addition_subtraction',
    ],
  ),

  // 2 ─ High-School Students (sub-categories by subject)
  ProfessionCategory(
    id: 'high_school',
    name: 'High-School',
    icon: Icons.menu_book,
    color: Color(0xFF60A5FA),
    subCategories: [
      ProfessionSubCategory(
        name: 'Mathematics',
        icon: Icons.calculate,
        toolIds: [
          'percentage',
          'percentage_change',
          'ratio',
          'fraction_decimal',
          'number_base',
          'scientific_notation',
          'speed_distance_time',
          'gpa_cgpa',
          'simple_interest',
          'compound_interest',
        ],
      ),
      ProfessionSubCategory(
        name: 'Geometry',
        icon: Icons.square_foot,
        toolIds: [
          'circle',
          'triangle',
          'rectangle',
          'volume_3d',
          'slope_calculator',
          'angle_converter',
        ],
      ),
      ProfessionSubCategory(
        name: 'Physics',
        icon: Icons.science,
        toolIds: [
          'speed',
          'energy',
          'power',
          'pressure',
          'temperature',
          'length',
          'weight',
          'ohms_law',
          'efficiency_calculator',
          'load_calculator',
        ],
      ),
      ProfessionSubCategory(
        name: 'General',
        icon: Icons.auto_stories,
        toolIds: [
          'area',
          'volume',
          'data_storage',
          'time_unit',
          'date_difference',
          'countdown',
          'bmi',
          'age',
        ],
      ),
    ],
  ),

  // 3 ─ Lawyers
  ProfessionCategory(
    id: 'lawyers',
    name: 'Lawyers',
    icon: Icons.gavel,
    color: Color(0xFFA78BFA),
    toolIds: [
      'stamp_duty',
      'penalty_calculator',
      'date_difference',
      'work_hours',
      'gst',
      'tax_estimator',
      'simple_interest',
      'compound_interest',
      'flat_buying',
      'rent_calculator',
    ],
  ),

  // 4 ─ Doctors / Medical
  ProfessionCategory(
    id: 'doctors',
    name: 'Doctors / Medical',
    icon: Icons.local_hospital,
    color: Color(0xFFF87171),
    toolIds: [
      'bmi',
      'bsa_calculator',
      'dosage_calculator',
      'heart_rate_zones',
      'fluid_intake',
      'age',
    ],
  ),

  // 5 ─ Plumbers
  ProfessionCategory(
    id: 'plumbers',
    name: 'Plumbers',
    icon: Icons.plumbing,
    color: Color(0xFF38BDF8),
    toolIds: [
      'pipe_flow',
      'tank_capacity',
      'material_estimator',
      'gst',
      'profit_loss',
    ],
  ),

  // 6 ─ Carpenters
  ProfessionCategory(
    id: 'carpenters',
    name: 'Carpenters',
    icon: Icons.carpenter,
    color: Color(0xFFFBBF24),
    toolIds: [
      'wood_volume',
      'material_estimator',
      'rectangle',
      'triangle',
      'circle',
      'volume_3d',
      'slope_calculator',
      'gst',
      'profit_loss',
    ],
  ),

  // 7 ─ Engineers (Civil / Mechanical / Electrical)
  ProfessionCategory(
    id: 'engineers',
    name: 'Engineers',
    icon: Icons.engineering,
    color: Color(0xFF0EA5E9),
    toolIds: [
      'load_calculator',
      'efficiency_calculator',
      'ohms_law',
      'wire_gauge',
      'pipe_flow',
      'tank_capacity',
      'material_estimator',
      'slope_calculator',
      'volume_3d',
      'number_base',
      'scientific_notation',
    ],
  ),

  // 8 ─ Chartered Accountants
  ProfessionCategory(
    id: 'cas',
    name: 'Chartered Accountants',
    icon: Icons.account_balance,
    color: Color(0xFF22D3EE),
    toolIds: [
      'gst',
      'tax_estimator',
      'depreciation',
      'profit_loss',
      'markup_margin',
      'break_even',
      'simple_interest',
      'compound_interest',
      'emi',
      'sip',
      'fd_rd',
      'loan_compare',
      'salary_breakup',
      'stamp_duty',
      'penalty_calculator',
      'flat_buying',
      'rent_calculator',
    ],
  ),

  // 9 ─ Real Estate & Vehicle
  ProfessionCategory(
    id: 'real_estate',
    name: 'Real Estate & Vehicle',
    icon: Icons.real_estate_agent,
    color: Color(0xFFFB923C),
    toolIds: [
      'vehicle_cost',
      'flat_buying',
      'rent_calculator',
      'emi',
      'loan_prepayment',
      'stamp_duty',
      'loan_compare',
      'gst',
    ],
  ),

  // 10 ─ IT / Software Professionals
  ProfessionCategory(
    id: 'it_software',
    name: 'IT / Software',
    icon: Icons.computer,
    color: Color(0xFF818CF8),
    toolIds: [
      'color_converter',
      'screen_dpi',
      'file_size_estimator',
      'base64_encoder',
      'number_base',
      'data_storage',
      'scientific_notation',
      'salary_breakup',
      'tax_estimator',
      'gst',
      'work_hours',
      'date_difference',
      'countdown',
      'timestamp_converter',
    ],
  ),
];
