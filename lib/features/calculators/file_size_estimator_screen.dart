import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/result_row.dart';

/// File size estimator (images, video, audio by parameters).
class FileSizeEstimatorScreen extends StatefulWidget {
  final Color categoryColor;
  const FileSizeEstimatorScreen({super.key, required this.categoryColor});

  @override
  State<FileSizeEstimatorScreen> createState() => _FileSizeEstimatorScreenState();
}

class _FileSizeEstimatorScreenState extends State<FileSizeEstimatorScreen> {
  int _type = 0; // 0=image, 1=video, 2=audio
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  final _ctrl3 = TextEditingController();

  static const _typeLabels = ['Image', 'Video', 'Audio'];

  String _fmt(double bytes) {
    if (bytes >= 1e9) return '${(bytes / 1e9).toStringAsFixed(2)} GB';
    if (bytes >= 1e6) return '${(bytes / 1e6).toStringAsFixed(2)} MB';
    if (bytes >= 1e3) return '${(bytes / 1e3).toStringAsFixed(1)} KB';
    return '${bytes.toStringAsFixed(0)} B';
  }

  double get _sizeBytes {
    switch (_type) {
      case 0: // Image: W × H × bits_per_pixel / 8
        final w = double.tryParse(_ctrl1.text) ?? 0;
        final h = double.tryParse(_ctrl2.text) ?? 0;
        final bpp = double.tryParse(_ctrl3.text) ?? 24;
        return w * h * bpp / 8;
      case 1: // Video: bitrate(Mbps) × duration(sec) / 8
        final bitrate = double.tryParse(_ctrl1.text) ?? 0; // Mbps
        final dur = double.tryParse(_ctrl2.text) ?? 0; // seconds
        return bitrate * 1e6 * dur / 8;
      case 2: // Audio: bitrate(kbps) × duration(sec) / 8
        final bitrate = double.tryParse(_ctrl1.text) ?? 0; // kbps
        final dur = double.tryParse(_ctrl2.text) ?? 0; // seconds
        return bitrate * 1000 * dur / 8;
      default: return 0;
    }
  }

  bool get _valid => _sizeBytes > 0;

  Map<String, String> get _exportData => _valid ? {'Type': _typeLabels[_type], 'Size': _fmt(_sizeBytes)} : {};

  @override
  void dispose() { _ctrl1.dispose(); _ctrl2.dispose(); _ctrl3.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'File Size Estimator',
      accentColor: c, toolId: 'file_size_estimator', categoryName: 'Digital Tools',
      exportData: _exportData,
      children: [
        Center(child: SegmentedButton<int>(
          segments: List.generate(3, (i) => ButtonSegment(value: i, label: Text(_typeLabels[i]))),
          selected: {_type}, onSelectionChanged: (v) { _ctrl1.clear(); _ctrl2.clear(); _ctrl3.clear(); setState(() => _type = v.first); },
        )),
        const SizedBox(height: 16),
        if (_type == 0) ...[
          Row(children: [
            Expanded(child: TextField(controller: _ctrl1, keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Width', suffixText: 'px', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              onChanged: (_) => setState(() {}))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _ctrl2, keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height', suffixText: 'px', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              onChanged: (_) => setState(() {}))),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _ctrl3, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Bits per pixel (default 24)', suffixText: 'bpp', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            onChanged: (_) => setState(() {})),
        ],
        if (_type == 1) ...[
          TextField(controller: _ctrl1, keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Bitrate', suffixText: 'Mbps', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            onChanged: (_) => setState(() {})),
          const SizedBox(height: 12),
          TextField(controller: _ctrl2, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Duration', suffixText: 'seconds', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            onChanged: (_) => setState(() {})),
        ],
        if (_type == 2) ...[
          TextField(controller: _ctrl1, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Bitrate', suffixText: 'kbps', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            onChanged: (_) => setState(() {})),
          const SizedBox(height: 12),
          TextField(controller: _ctrl2, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Duration', suffixText: 'seconds', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            onChanged: (_) => setState(() {})),
        ],
        const SizedBox(height: 20),
        if (_valid)
          Card(color: c.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text(_fmt(_sizeBytes), style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: c)),
            const Text('estimated uncompressed size'),
            const Divider(),
            ResultRow(label: 'Bytes', value: _sizeBytes.toStringAsFixed(0)),
            ResultRow(label: 'JPEG (~10:1)', value: _fmt(_sizeBytes / 10)),
            ResultRow(label: 'PNG (~3:1)', value: _fmt(_sizeBytes / 3)),
          ]))),
      ],
    );
  }
}
