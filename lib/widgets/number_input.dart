import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable number input field widget
class NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool allowDecimal;
  final bool allowNegative;
  final ValueChanged<String>? onChanged;
  final String? suffixText;

  const NumberInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.allowDecimal = true,
    this.allowNegative = false,
    this.onChanged,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimal,
        signed: allowNegative,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(allowNegative 
            ? r'[0-9.-]' 
            : (allowDecimal ? r'[0-9.]' : r'[0-9]')
          ),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffixText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: const TextStyle(fontSize: 18),
      onChanged: onChanged,
    );
  }
}
