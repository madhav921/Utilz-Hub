import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// Document page count & size helper.
class DocSizeHelperScreen extends StatefulWidget {
  final Color categoryColor;
  const DocSizeHelperScreen({super.key, required this.categoryColor});

  @override
  State<DocSizeHelperScreen> createState() => _DocSizeHelperScreenState();
}

class _DocSizeHelperScreenState extends State<DocSizeHelperScreen> {
  final _pagesCtrl = TextEditingController();
  final _fileSizeCtrl = TextEditingController();
  String _pageSize = 'A4';
  bool _doubleSided = false;

  static const _pageDims = {
    'A4': '210 × 297 mm',
    'A3': '297 × 420 mm',
    'Letter': '216 × 279 mm',
    'Legal': '216 × 356 mm',
    'A5': '148 × 210 mm',
  };

  static const _weightPerSheet = {
    'A4': 5.0,   // grams (80 gsm)
    'A3': 10.0,
    'Letter': 4.5,
    'Legal': 5.5,
    'A5': 2.5,
  };

  int get _pages => int.tryParse(_pagesCtrl.text) ?? 0;
  double get _fileSizeMB => double.tryParse(_fileSizeCtrl.text) ?? 0;
  int get _sheets => _doubleSided ? (_pages / 2).ceil() : _pages;
  double get _weightG => _sheets * (_weightPerSheet[_pageSize] ?? 5);
  double get _perPageKB => _pages > 0 && _fileSizeMB > 0 ? (_fileSizeMB * 1024) / _pages : 0;
  bool get _valid => _pages > 0;

  Map<String, String> get _exportData => _valid
      ? {
          'Pages': '$_pages',
          'Page Size': '$_pageSize (${_pageDims[_pageSize]})',
          'Sheets': '$_sheets${_doubleSided ? ' (double-sided)' : ''}',
          'Paper Weight': '${_weightG.toStringAsFixed(0)} g (${(_weightG / 1000).toStringAsFixed(2)} kg)',
          if (_fileSizeMB > 0) 'File Size': '${_fileSizeMB.toStringAsFixed(1)} MB',
          if (_perPageKB > 0) 'Per Page': '${_perPageKB.toStringAsFixed(0)} KB',
        }
      : {};

  @override
  void dispose() {
    _pagesCtrl.dispose();
    _fileSizeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Document Helper',
      accentColor: c,
      toolId: 'doc_size_helper',
      categoryName: 'Business & Tax',
      infoText: 'Estimate paper weight & file size per page',
      exportData: _exportData,
      children: [
        TextField(
          controller: _pagesCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of Pages',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _pageSize,
          decoration: InputDecoration(
            labelText: 'Page Size',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: _pageDims.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text('${e.key} (${e.value})')))
              .toList(),
          onChanged: (v) => setState(() => _pageSize = v!),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('Double-sided printing'),
          value: _doubleSided,
          activeTrackColor: c.withAlpha(100),
          onChanged: (v) => setState(() => _doubleSided = v),
        ),
        TextField(
          controller: _fileSizeCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'File Size (optional)',
            suffixText: 'MB',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),
        if (_valid)
          Card(
            color: c.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ResultRow(label: 'Sheets needed', value: '$_sheets'),
                ResultRow(label: 'Paper weight (80 gsm)', value: '${_weightG.toStringAsFixed(0)} g'),
                ResultRow(label: 'Weight in kg', value: '${(_weightG / 1000).toStringAsFixed(2)} kg'),
                if (_perPageKB > 0) ResultRow(label: 'Size per page', value: '${_perPageKB.toStringAsFixed(0)} KB'),
              ]),
            ),
          ),
      ],
    );
  }
}
