import '../../core/constants/units.dart';
import '../../core/utils/formatter.dart';
import 'converter_models.dart';

/// Core conversion logic
class ConverterLogic {
  /// Generic conversion using base unit method
  static double convert(double value, double fromFactor, double toFactor) {
    assert(!value.isNaN && !value.isInfinite, 'Invalid input value');
    assert(fromFactor > 0 && toFactor > 0, 'Factors must be positive');
    
    return value * fromFactor / toFactor;
  }

  /// Temperature conversion (special case)
  static double convertTemperature(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;

    // Convert to Celsius first
    double celsius;
    switch (fromUnit) {
      case 'celsius':
        celsius = value;
        break;
      case 'fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Convert from Celsius to target unit
    switch (toUnit) {
      case 'celsius':
        return celsius;
      case 'fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  /// Main conversion method
  static ConversionResult performConversion({
    required double value,
    required String category,
    required String fromUnit,
    required String toUnit,
  }) {
    double result;

    // Special handling for temperature
    if (category == 'temperature') {
      result = convertTemperature(value, fromUnit, toUnit);
    } else {
      // Get the conversion category
      final conversionCategory = allConversionCategories[category];
      if (conversionCategory == null) {
        throw ArgumentError('Unknown category: $category');
      }

      final fromUnitDef = conversionCategory.units[fromUnit];
      final toUnitDef = conversionCategory.units[toUnit];

      if (fromUnitDef == null || toUnitDef == null) {
        throw ArgumentError('Unknown units');
      }

      result = convert(value, fromUnitDef.factor, toUnitDef.factor);
    }

    return ConversionResult(
      value: result,
      fromUnit: fromUnit,
      toUnit: toUnit,
      formattedValue: NumberFormatter.format(result),
    );
  }

  /// Get units for a category
  static Map<String, UnitDefinition> getUnitsForCategory(String category) {
    final conversionCategory = allConversionCategories[category];
    return conversionCategory?.units ?? {};
  }

  /// Get category details
  static ConversionCategory? getCategory(String categoryId) {
    return allConversionCategories[categoryId];
  }
}
