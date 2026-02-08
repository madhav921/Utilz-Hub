# All-in-One Converter & Calculator

A lightweight, offline-first Android app for daily-use conversions and calculators.

## Features

### Converters
- Length (meters, kilometers, miles, feet, inches, etc.)
- Weight (kilograms, grams, pounds, ounces, etc.)
- Temperature (Celsius, Fahrenheit, Kelvin)
- Area (square meters, acres, hectares, etc.)
- Volume (liters, gallons, milliliters, etc.)
- Speed (km/h, mph, m/s, knots, etc.)
- Time (seconds, minutes, hours, days, etc.)
- Pressure (Pascal, bar, PSI, atmosphere, etc.)
- Energy (Joules, calories, kWh, etc.)
- Power (Watts, kilowatts, horsepower, etc.)

### Calculators
- Percentage Calculator
- GST Calculator (Add/Remove GST)
- EMI Calculator
- Discount Calculator
- Tip Calculator
- Date Difference Calculator
- Age Calculator
- Simple Interest Calculator

## Technology Stack

- **Framework**: Flutter (Dart)
- **Platform**: Android
- **UI**: Material Design 3
- **Dependencies**: flutter, intl, collection (minimal)
- **Architecture**: Clean separation of UI and logic

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Build Release APK/AAB

```bash
flutter build appbundle --release
```

The output AAB will be in `build/app/outputs/bundle/release/`

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app/
│   ├── app.dart                 # Main app widget & home screen
│   └── theme.dart               # Theme configuration
├── core/
│   ├── constants/
│   │   └── units.dart           # Unit definitions
│   └── utils/
│       ├── formatter.dart       # Number formatting
│       └── math_helpers.dart    # Math utilities
├── features/
│   ├── converters/
│   │   ├── converter_screen.dart
│   │   ├── converter_logic.dart
│   │   └── converter_models.dart
│   └── calculators/
│       ├── calculator_screen.dart
│       ├── calculator_logic.dart
│       └── calculator_models.dart
└── widgets/
    ├── unit_dropdown.dart
    ├── number_input.dart
    └── result_card.dart
```

## Features

- ✅ Offline-first (no internet required)
- ✅ Clean Material 3 design
- ✅ Light & Dark mode support
- ✅ Fast and lightweight
- ✅ No ads (prepared for future integration)
- ✅ No user accounts required
- ✅ Privacy-friendly (no data collection)

## Architecture

The app follows a strict separation of concerns:
- **UI Layer**: Flutter widgets (in screens and widgets folders)
- **Logic Layer**: Pure Dart functions (in logic files)
- **Models**: Data classes (in model files)
- **Constants**: Unit definitions and configurations

All mathematical calculations are in pure Dart functions with no UI dependencies, making the code testable and maintainable.

## License

This project is for educational/utility purposes.
