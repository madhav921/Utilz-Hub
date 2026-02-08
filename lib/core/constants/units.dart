/// Unit conversion factors relative to base units
/// All conversions follow: value * fromFactor / toFactor
library;

class UnitDefinition {
  final String name;
  final String symbol;
  final double factor; // Factor relative to base unit

  const UnitDefinition({
    required this.name,
    required this.symbol,
    required this.factor,
  });
}

class ConversionCategory {
  final String name;
  final String icon;
  final Map<String, UnitDefinition> units;

  const ConversionCategory({
    required this.name,
    required this.icon,
    required this.units,
  });
}

/// LENGTH - Base unit: Meter
const lengthUnits = {
  'meter': UnitDefinition(name: 'Meter', symbol: 'm', factor: 1.0),
  'kilometer': UnitDefinition(name: 'Kilometer', symbol: 'km', factor: 1000.0),
  'centimeter': UnitDefinition(name: 'Centimeter', symbol: 'cm', factor: 0.01),
  'millimeter': UnitDefinition(name: 'Millimeter', symbol: 'mm', factor: 0.001),
  'mile': UnitDefinition(name: 'Mile', symbol: 'mi', factor: 1609.344),
  'yard': UnitDefinition(name: 'Yard', symbol: 'yd', factor: 0.9144),
  'foot': UnitDefinition(name: 'Foot', symbol: 'ft', factor: 0.3048),
  'inch': UnitDefinition(name: 'Inch', symbol: 'in', factor: 0.0254),
};

/// WEIGHT - Base unit: Kilogram
const weightUnits = {
  'kilogram': UnitDefinition(name: 'Kilogram', symbol: 'kg', factor: 1.0),
  'gram': UnitDefinition(name: 'Gram', symbol: 'g', factor: 0.001),
  'milligram': UnitDefinition(name: 'Milligram', symbol: 'mg', factor: 0.000001),
  'ton': UnitDefinition(name: 'Metric Ton', symbol: 't', factor: 1000.0),
  'pound': UnitDefinition(name: 'Pound', symbol: 'lb', factor: 0.453592),
  'ounce': UnitDefinition(name: 'Ounce', symbol: 'oz', factor: 0.0283495),
};

/// TEMPERATURE - Base unit: Celsius (special conversion)
const temperatureUnits = {
  'celsius': UnitDefinition(name: 'Celsius', symbol: '°C', factor: 1.0),
  'fahrenheit': UnitDefinition(name: 'Fahrenheit', symbol: '°F', factor: 1.0),
  'kelvin': UnitDefinition(name: 'Kelvin', symbol: 'K', factor: 1.0),
};

/// AREA - Base unit: Square Meter
const areaUnits = {
  'square_meter': UnitDefinition(name: 'Square Meter', symbol: 'm²', factor: 1.0),
  'square_kilometer': UnitDefinition(name: 'Square Kilometer', symbol: 'km²', factor: 1000000.0),
  'square_centimeter': UnitDefinition(name: 'Square Centimeter', symbol: 'cm²', factor: 0.0001),
  'hectare': UnitDefinition(name: 'Hectare', symbol: 'ha', factor: 10000.0),
  'acre': UnitDefinition(name: 'Acre', symbol: 'ac', factor: 4046.86),
  'square_mile': UnitDefinition(name: 'Square Mile', symbol: 'mi²', factor: 2589988.11),
  'square_yard': UnitDefinition(name: 'Square Yard', symbol: 'yd²', factor: 0.836127),
  'square_foot': UnitDefinition(name: 'Square Foot', symbol: 'ft²', factor: 0.092903),
};

/// VOLUME - Base unit: Liter
const volumeUnits = {
  'liter': UnitDefinition(name: 'Liter', symbol: 'L', factor: 1.0),
  'milliliter': UnitDefinition(name: 'Milliliter', symbol: 'mL', factor: 0.001),
  'cubic_meter': UnitDefinition(name: 'Cubic Meter', symbol: 'm³', factor: 1000.0),
  'cubic_centimeter': UnitDefinition(name: 'Cubic Centimeter', symbol: 'cm³', factor: 0.001),
  'gallon': UnitDefinition(name: 'Gallon (US)', symbol: 'gal', factor: 3.78541),
  'quart': UnitDefinition(name: 'Quart (US)', symbol: 'qt', factor: 0.946353),
  'pint': UnitDefinition(name: 'Pint (US)', symbol: 'pt', factor: 0.473176),
  'cup': UnitDefinition(name: 'Cup (US)', symbol: 'cup', factor: 0.236588),
};

/// SPEED - Base unit: Meter per Second
const speedUnits = {
  'meter_per_second': UnitDefinition(name: 'Meter/Second', symbol: 'm/s', factor: 1.0),
  'kilometer_per_hour': UnitDefinition(name: 'Kilometer/Hour', symbol: 'km/h', factor: 0.277778),
  'mile_per_hour': UnitDefinition(name: 'Mile/Hour', symbol: 'mph', factor: 0.44704),
  'knot': UnitDefinition(name: 'Knot', symbol: 'kn', factor: 0.514444),
  'foot_per_second': UnitDefinition(name: 'Foot/Second', symbol: 'ft/s', factor: 0.3048),
};

/// TIME - Base unit: Second
const timeUnits = {
  'second': UnitDefinition(name: 'Second', symbol: 's', factor: 1.0),
  'minute': UnitDefinition(name: 'Minute', symbol: 'min', factor: 60.0),
  'hour': UnitDefinition(name: 'Hour', symbol: 'h', factor: 3600.0),
  'day': UnitDefinition(name: 'Day', symbol: 'd', factor: 86400.0),
  'week': UnitDefinition(name: 'Week', symbol: 'wk', factor: 604800.0),
  'month': UnitDefinition(name: 'Month (30 days)', symbol: 'mo', factor: 2592000.0),
  'year': UnitDefinition(name: 'Year (365 days)', symbol: 'yr', factor: 31536000.0),
};

/// PRESSURE - Base unit: Pascal
const pressureUnits = {
  'pascal': UnitDefinition(name: 'Pascal', symbol: 'Pa', factor: 1.0),
  'kilopascal': UnitDefinition(name: 'Kilopascal', symbol: 'kPa', factor: 1000.0),
  'bar': UnitDefinition(name: 'Bar', symbol: 'bar', factor: 100000.0),
  'psi': UnitDefinition(name: 'PSI', symbol: 'psi', factor: 6894.76),
  'atmosphere': UnitDefinition(name: 'Atmosphere', symbol: 'atm', factor: 101325.0),
  'torr': UnitDefinition(name: 'Torr', symbol: 'Torr', factor: 133.322),
};

/// ENERGY - Base unit: Joule
const energyUnits = {
  'joule': UnitDefinition(name: 'Joule', symbol: 'J', factor: 1.0),
  'kilojoule': UnitDefinition(name: 'Kilojoule', symbol: 'kJ', factor: 1000.0),
  'calorie': UnitDefinition(name: 'Calorie', symbol: 'cal', factor: 4.184),
  'kilocalorie': UnitDefinition(name: 'Kilocalorie', symbol: 'kcal', factor: 4184.0),
  'watt_hour': UnitDefinition(name: 'Watt Hour', symbol: 'Wh', factor: 3600.0),
  'kilowatt_hour': UnitDefinition(name: 'Kilowatt Hour', symbol: 'kWh', factor: 3600000.0),
  'electronvolt': UnitDefinition(name: 'Electronvolt', symbol: 'eV', factor: 1.60218e-19),
};

/// POWER - Base unit: Watt
const powerUnits = {
  'watt': UnitDefinition(name: 'Watt', symbol: 'W', factor: 1.0),
  'kilowatt': UnitDefinition(name: 'Kilowatt', symbol: 'kW', factor: 1000.0),
  'megawatt': UnitDefinition(name: 'Megawatt', symbol: 'MW', factor: 1000000.0),
  'horsepower': UnitDefinition(name: 'Horsepower', symbol: 'hp', factor: 745.7),
  'btu_per_hour': UnitDefinition(name: 'BTU/Hour', symbol: 'BTU/h', factor: 0.293071),
};

/// DATA STORAGE - Base unit: Byte
const dataStorageUnits = {
  'byte': UnitDefinition(name: 'Byte', symbol: 'B', factor: 1.0),
  'kilobyte': UnitDefinition(name: 'Kilobyte', symbol: 'KB', factor: 1024.0),
  'megabyte': UnitDefinition(name: 'Megabyte', symbol: 'MB', factor: 1048576.0),
  'gigabyte': UnitDefinition(name: 'Gigabyte', symbol: 'GB', factor: 1073741824.0),
  'terabyte': UnitDefinition(name: 'Terabyte', symbol: 'TB', factor: 1099511627776.0),
  'petabyte': UnitDefinition(name: 'Petabyte', symbol: 'PB', factor: 1125899906842624.0),
  'bit': UnitDefinition(name: 'Bit', symbol: 'bit', factor: 0.125),
  'kilobit': UnitDefinition(name: 'Kilobit', symbol: 'Kb', factor: 128.0),
  'megabit': UnitDefinition(name: 'Megabit', symbol: 'Mb', factor: 131072.0),
  'gigabit': UnitDefinition(name: 'Gigabit', symbol: 'Gb', factor: 134217728.0),
};

/// All conversion categories
const allConversionCategories = {
  'length': ConversionCategory(name: 'Length', icon: '📏', units: lengthUnits),
  'weight': ConversionCategory(name: 'Weight', icon: '⚖️', units: weightUnits),
  'temperature': ConversionCategory(name: 'Temperature', icon: '🌡️', units: temperatureUnits),
  'area': ConversionCategory(name: 'Area', icon: '📐', units: areaUnits),
  'volume': ConversionCategory(name: 'Volume', icon: '🧪', units: volumeUnits),
  'speed': ConversionCategory(name: 'Speed', icon: '🚀', units: speedUnits),
  'time': ConversionCategory(name: 'Time', icon: '⏱️', units: timeUnits),
  'pressure': ConversionCategory(name: 'Pressure', icon: '💨', units: pressureUnits),
  'energy': ConversionCategory(name: 'Energy', icon: '⚡', units: energyUnits),
  'power': ConversionCategory(name: 'Power', icon: '🔋', units: powerUnits),
  'data_storage': ConversionCategory(name: 'Data Storage', icon: '💾', units: dataStorageUnits),
};
