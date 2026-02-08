import 'package:flutter/material.dart';
import '../../core/constants/units.dart';
import '../../core/utils/formatter.dart';
import '../../widgets/number_input.dart';
import '../../widgets/unit_dropdown.dart';
import '../../widgets/result_card.dart';
import 'converter_logic.dart';
import 'converter_models.dart';

/// Universal converter screen for all conversion types
class ConverterScreen extends StatefulWidget {
  final String categoryId;

  const ConverterScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  
  String? _fromUnit;
  String? _toUnit;
  ConversionResult? _result;
  ConversionCategory? _category;

  @override
  void initState() {
    super.initState();
    _category = ConverterLogic.getCategory(widget.categoryId);
    
    if (_category != null && _category!.units.isNotEmpty) {
      final unitKeys = _category!.units.keys.toList();
      _fromUnit = unitKeys.first;
      _toUnit = unitKeys.length > 1 ? unitKeys[1] : unitKeys.first;
    }

    _inputController.addListener(_performConversion);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _performConversion() {
    final input = NumberFormatter.parseInput(_inputController.text);
    
    if (input == null || _fromUnit == null || _toUnit == null) {
      setState(() {
        _result = null;
      });
      return;
    }

    try {
      final result = ConverterLogic.performConversion(
        value: input,
        category: widget.categoryId,
        fromUnit: _fromUnit!,
        toUnit: _toUnit!,
      );

      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = null;
      });
    }
  }

  void _swapUnits() {
    if (_fromUnit == null || _toUnit == null) return;

    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });

    _performConversion();
  }

  @override
  Widget build(BuildContext context) {
    if (_category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Converter')),
        body: const Center(child: Text('Category not found')),
      );
    }

    final units = _category!.units;
    final unitItems = units.entries.map((e) {
      return DropdownMenuItem<String>(
        value: e.key,
        child: Text('${e.value.name} (${e.value.symbol})'),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${_category!.name} Converter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field
            NumberInput(
              controller: _inputController,
              label: 'Enter value',
              hint: '0',
              onChanged: (_) => _performConversion(),
            ),
            
            const SizedBox(height: 24),

            // From unit dropdown
            UnitDropdown(
              value: _fromUnit ?? units.keys.first,
              items: unitItems,
              onChanged: (value) {
                setState(() {
                  _fromUnit = value;
                });
                _performConversion();
              },
              label: 'From',
            ),

            const SizedBox(height: 16),

            // Swap button
            Center(
              child: IconButton(
                icon: const Icon(Icons.swap_vert, size: 32),
                onPressed: _swapUnits,
              ),
            ),

            const SizedBox(height: 16),

            // To unit dropdown
            UnitDropdown(
              value: _toUnit ?? units.keys.first,
              items: unitItems,
              onChanged: (value) {
                setState(() {
                  _toUnit = value;
                });
                _performConversion();
              },
              label: 'To',
            ),

            const SizedBox(height: 24),

            // Result
            if (_result != null)
              ResultCard(
                title: 'Result',
                value: _result!.formattedValue,
              ),
          ],
        ),
      ),
    );
  }
}
