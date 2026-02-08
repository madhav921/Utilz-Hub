import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/calculator_scaffold.dart';

/// Base64 Encoder / Decoder.
class Base64EncoderScreen extends StatefulWidget {
  final Color categoryColor;
  const Base64EncoderScreen({super.key, required this.categoryColor});

  @override
  State<Base64EncoderScreen> createState() => _Base64EncoderScreenState();
}

class _Base64EncoderScreenState extends State<Base64EncoderScreen> {
  final _inputCtrl = TextEditingController();
  final _outputCtrl = TextEditingController();
  bool _isEncoding = true; // true = encode, false = decode
  String? _error;

  void _process() {
    setState(() {
      _error = null;
      try {
        if (_isEncoding) {
          _outputCtrl.text =
              base64Encode(utf8.encode(_inputCtrl.text));
        } else {
          _outputCtrl.text =
              utf8.decode(base64Decode(_inputCtrl.text));
        }
      } catch (e) {
        _error = _isEncoding
            ? 'Could not encode text'
            : 'Invalid Base64 string';
        _outputCtrl.clear();
      }
    });
  }

  void _swap() {
    setState(() {
      _isEncoding = !_isEncoding;
      final tmp = _inputCtrl.text;
      _inputCtrl.text = _outputCtrl.text;
      _outputCtrl.text = tmp;
    });
  }

  Map<String, String> get _exportData =>
      _outputCtrl.text.isEmpty
          ? {}
          : {
              _isEncoding ? 'Plain Text' : 'Base64':
                  _inputCtrl.text,
              _isEncoding ? 'Base64' : 'Decoded Text':
                  _outputCtrl.text,
            };

  @override
  void dispose() {
    _inputCtrl.dispose();
    _outputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Base64 Encoder',
      accentColor: c,
      toolId: 'base64_encoder',
      categoryName: 'Digital Tools',
      infoText:
          'Encode plain text to Base64 or decode Base64 back to text.',
      exportData: _exportData,
      children: [
        Row(
          children: [
            Expanded(
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Encode')),
                  ButtonSegment(value: false, label: Text('Decode')),
                ],
                selected: {_isEncoding},
                onSelectionChanged: (v) {
                  _isEncoding = v.first;
                  _process();
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.swap_vert),
              tooltip: 'Swap',
              onPressed: _swap,
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _inputCtrl,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: _isEncoding ? 'Plain Text' : 'Base64 String',
            alignLabelWithHint: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => _process(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_isEncoding ? 'Base64 Output' : 'Decoded Text',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: c)),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      tooltip: 'Copy',
                      onPressed: _outputCtrl.text.isEmpty
                          ? null
                          : () {
                              Clipboard.setData(
                                  ClipboardData(text: _outputCtrl.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Copied to clipboard')),
                              );
                            },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SelectableText(
                  _outputCtrl.text.isEmpty
                      ? 'Output will appear here…'
                      : _outputCtrl.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                    color: _outputCtrl.text.isEmpty
                        ? Colors.grey
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
