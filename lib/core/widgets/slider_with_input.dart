import 'package:flutter/material.dart';

/// A [Slider] with a companion text‑input field below it so the user can
/// either drag **or** type an exact value.
class SliderWithInput extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final Color activeColor;
  final ValueChanged<double> onChanged;
  final int decimalPlaces;

  const SliderWithInput({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.activeColor,
    required this.onChanged,
    this.decimalPlaces = 0,
  });

  @override
  State<SliderWithInput> createState() => _SliderWithInputState();
}

class _SliderWithInputState extends State<SliderWithInput> {
  late TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _fmt(widget.value));
  }

  @override
  void didUpdateWidget(SliderWithInput old) {
    super.didUpdateWidget(old);
    if (!_editing && old.value != widget.value) {
      _ctrl.text = _fmt(widget.value);
    }
  }

  String _fmt(double v) => widget.decimalPlaces == 0
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(widget.decimalPlaces);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit(String text) {
    _editing = false;
    final v = double.tryParse(text);
    if (v != null) {
      widget.onChanged(v.clamp(widget.min, widget.max));
    } else {
      _ctrl.text = _fmt(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
          value: widget.value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          activeColor: widget.activeColor,
          onChanged: widget.onChanged,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 110,
            height: 34,
            child: TextField(
              controller: _ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                hintText: 'Enter',
              ),
              onTap: () => _editing = true,
              onSubmitted: _submit,
            ),
          ),
        ),
      ],
    );
  }
}
