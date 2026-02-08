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

  const ProfessionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.toolIds,
  });

  /// Resolve ids to [Tool] objects via the master registry.
  List<Tool> get tools =>
      toolIds.where((id) => allToolsById.containsKey(id)).map((id) => allToolsById[id]!).toList();
}

// ============================================================
//  11 PROFESSION CATEGORIES
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

  // 2 ─ High-School Students
  ProfessionCategory(
    id: 'high_school',
    name: 'High-School',
    icon: Icons.menu_book,
    color: Color(0xFF60A5FA),
    toolIds: [
      'percentage',
      'percentage_change',
      'ratio',
      'fraction_decimal',
      'number_base',
      'scientific_notation',
      'speed_distance_time',
      'circle',
      'triangle',
      'rectangle',
      'volume_3d',
      'length',
      'weight',
      'temperature',
      'area',
      'volume',
      'speed',
      'energy',
      'power',
      'pressure',
      'angle_converter',
      'slope_calculator',
    ],
  ),

  // 3 ─ Graduation / College
  ProfessionCategory(
    id: 'graduation',
    name: 'Graduation / College',
    icon: Icons.school,
    color: Color(0xFF34D399),
    toolIds: [
      'gpa_cgpa',
      'percentage',
      'percentage_change',
      'scientific_notation',
      'number_base',
      'simple_interest',
      'compound_interest',
      'emi',
      'date_difference',
      'work_hours',
      'countdown',
      'bmi',
      'age',
      'discount',
      'tip',
      'bill_splitter',
      'fuel_cost',
      'unit_price',
    ],
  ),

  // 4 ─ Lawyers
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
      'doc_size_helper',
      'simple_interest',
      'compound_interest',
      'percentage',
      'percentage_change',
      'age',
    ],
  ),

  // 5 ─ Doctors / Medical
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
      'weight',
      'temperature',
      'unit_price',
      'percentage',
    ],
  ),

  // 6 ─ Plumbers
  ProfessionCategory(
    id: 'plumbers',
    name: 'Plumbers',
    icon: Icons.plumbing,
    color: Color(0xFF38BDF8),
    toolIds: [
      'pipe_flow',
      'thread_reference',
      'tank_capacity',
      'length',
      'volume',
      'pressure',
      'material_estimator',
      'wastage_calculator',
      'unit_price',
      'gst',
      'profit_loss',
    ],
  ),

  // 7 ─ Carpenters
  ProfessionCategory(
    id: 'carpenters',
    name: 'Carpenters',
    icon: Icons.carpenter,
    color: Color(0xFFFBBF24),
    toolIds: [
      'wood_volume',
      'material_estimator',
      'wastage_calculator',
      'area',
      'volume',
      'length',
      'rectangle',
      'triangle',
      'circle',
      'volume_3d',
      'angle_converter',
      'slope_calculator',
      'unit_price',
      'gst',
      'profit_loss',
    ],
  ),

  // 8 ─ Engineers (Civil / Mechanical / Electrical)
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
      'wastage_calculator',
      'slope_calculator',
      'area',
      'volume',
      'length',
      'weight',
      'pressure',
      'energy',
      'power',
      'speed',
      'temperature',
      'volume_3d',
      'number_base',
      'scientific_notation',
      'unit_price',
      'data_storage',
    ],
  ),

  // 9 ─ Chartered Accountants
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
      'mortgage',
      'loan_compare',
      'salary_breakup',
      'stamp_duty',
      'penalty_calculator',
      'percentage',
      'percentage_change',
    ],
  ),

  // 10 ─ Business Owners
  ProfessionCategory(
    id: 'business_owners',
    name: 'Business Owners',
    icon: Icons.storefront,
    color: Color(0xFFFB923C),
    toolIds: [
      'gst',
      'profit_loss',
      'markup_margin',
      'break_even',
      'unit_price',
      'discount',
      'salary_breakup',
      'tax_estimator',
      'emi',
      'loan_compare',
      'depreciation',
      'stamp_duty',
      'penalty_calculator',
      'doc_size_helper',
      'work_hours',
      'date_difference',
      'percentage',
      'percentage_change',
      'currency',
      'fuel_cost',
    ],
  ),

  // 11 ─ IT / Software Professionals
  ProfessionCategory(
    id: 'it_software',
    name: 'IT / Software',
    icon: Icons.computer,
    color: Color(0xFF818CF8),
    toolIds: [
      'color_converter',
      'screen_dpi',
      'file_size_estimator',
      'time_complexity',
      'number_base',
      'data_storage',
      'scientific_notation',
      'percentage',
      'percentage_change',
      'salary_breakup',
      'tax_estimator',
      'gst',
      'work_hours',
      'date_difference',
      'countdown',
      'timestamp_converter',
      'time_period',
    ],
  ),
];
