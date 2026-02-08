/// Converter models
class ConversionResult {
  final double value;
  final String fromUnit;
  final String toUnit;
  final String formattedValue;

  const ConversionResult({
    required this.value,
    required this.fromUnit,
    required this.toUnit,
    required this.formattedValue,
  });
}

class ConverterType {
  final String id;
  final String name;
  final String icon;

  const ConverterType({
    required this.id,
    required this.name,
    required this.icon,
  });
}

/// Available converter types
const converterTypes = [
  ConverterType(id: 'length', name: 'Length', icon: '📏'),
  ConverterType(id: 'weight', name: 'Weight', icon: '⚖️'),
  ConverterType(id: 'temperature', name: 'Temperature', icon: '🌡️'),
  ConverterType(id: 'area', name: 'Area', icon: '📐'),
  ConverterType(id: 'volume', name: 'Volume', icon: '🧪'),
  ConverterType(id: 'speed', name: 'Speed', icon: '🚀'),
  ConverterType(id: 'time', name: 'Time', icon: '⏱️'),
  ConverterType(id: 'pressure', name: 'Pressure', icon: '💨'),
  ConverterType(id: 'energy', name: 'Energy', icon: '⚡'),
  ConverterType(id: 'power', name: 'Power', icon: '🔋'),
];
