# Utilz Hub — All-in-One Converter & Calculator

A feature-rich, offline-first Flutter app with **77+ tools** spanning calculators, unit converters, live rates, and reference charts — organised by **11 tool categories** and **11 profession-based groupings**.

---

## ✨ Highlights

| Feature | Details |
|---|---|
| **77+ Tools** | Calculators, converters, live data, reference charts |
| **11 Categories** | Everyday, Finance, Business, Math, Converters, Geometry, Time, Live Rates, Health, Engineering, Digital |
| **11 Professions** | Pre-School, High-School, College, Lawyers, Doctors, Plumbers, Carpenters, Engineers, CAs, Business Owners, IT/Software |
| **3 Themes** | Light, Dark, AMOLED Black |
| **Bottom Nav** | Home (category grid) + Professions tab |
| **Live Data** | Currency, Gold, Silver, Fuel — cached & batched |
| **Save & Export** | Bookmark results, share as text |
| **Offline-first** | Works without internet (except live rates) |
| **Reorderable** | Drag-to-reorder category grid |

---

## 🗂️ Tool Categories

### 1. Everyday Essentials
Discount · Tip · Bill Splitter · Fuel Cost · Age · BMI & Calories

### 2. Finance & Loans
EMI · Simple Interest · Compound Interest · SIP · FD/RD · Mortgage · Loan Compare · Depreciation

### 3. Business & Tax
GST · Profit & Loss · Markup & Margin · Break-Even · Unit Price · Salary Breakup · Tax Estimator · Stamp Duty · Penalty Calculator · Document Helper

### 4. Math & Numbers
Percentage · % Change · Ratio · Number Base · Scientific Notation · Fraction ↔ Decimal · Number Compare · Add & Subtract · Counting Helper · Speed·Distance·Time · GPA / CGPA

### 5. Unit Converters
Length · Weight · Temperature · Area · Volume · Speed · Time · Pressure · Energy · Power · Data Storage · Angle

### 6. Geometry
Circle · Triangle · Rectangle · 3D Shapes · Slope & Angle

### 7. Time & Date
Date Difference · Work Hours · Countdown · Time Period · Timestamp ↔ Date

### 8. Live Rates 🔴
Currency · Gold Price · Silver Price · Fuel Prices

### 9. Health & Body
Body Surface Area · Dosage Calculator · Heart Rate Zones · Fluid Intake

### 10. Engineering
Pipe Flow · Thread Sizes · Tank Capacity · Wood Volume · Material Estimator · Wastage % · Load Calculator · Efficiency · Ohm's Law · Wire Gauge (AWG)

### 11. Digital Tools
Color Converter · Screen DPI · File Size Estimator · Time Complexity

---

## 👷 Profession-Based Groupings

Each profession page shows a curated set of tools (no duplicates within a page):

| Profession | # Tools | Key Tools |
|---|---|---|
| Pre-School Kids | 3 | Number Compare, Counting Helper, Add & Subtract |
| High-School | 22 | Percentage, Geometry, Unit Converters, Slope |
| Graduation / College | 18 | GPA/CGPA, Interest, EMI, BMI, Discount |
| Lawyers | 12 | Stamp Duty, Penalty, GST, Date Diff, Tax |
| Doctors / Medical | 10 | BMI, BSA, Dosage, Heart Rate, Fluid Intake |
| Plumbers | 11 | Pipe Flow, Thread Sizes, Tank, Pressure |
| Carpenters | 15 | Wood Volume, Material, Area, Slope, Angle |
| Engineers | 23 | Ohm's Law, Load, Efficiency, Wire Gauge, All units |
| Chartered Accountants | 18 | GST, Tax, Depreciation, All finance tools |
| Business Owners | 20 | P&L, Markup, Break-Even, Salary, Stamp Duty |
| IT / Software | 17 | Color Converter, DPI, File Size, Big-O, Number Base |

---

## 🛠️ Tech Stack

- **Framework**: Flutter (Dart SDK ≥ 3.0.0)
- **UI**: Material Design 3
- **State**: `StatefulWidget` + `ChangeNotifier` (ThemeProvider)
- **Storage**: `SharedPreferences` (gzip + Base64 compressed)
- **HTTP**: `http` package for live rates
- **Sharing**: `share_plus` & `path_provider`
- **Architecture**: Feature-first folder structure

---

## 📁 Project Structure

```
lib/
├── main.dart                         # Entry point
├── app/
│   ├── app.dart                      # MaterialApp → AppShell
│   ├── theme.dart                    # M3 theme builder
│   └── theme_provider.dart           # Light / Dark / AMOLED
├── core/
│   ├── constants/units.dart          # Unit definitions
│   ├── models/
│   │   ├── tool_category.dart        # 11 categories, 77+ Tool objects
│   │   └── profession_category.dart  # 11 professions (reference by ID)
│   ├── services/
│   │   ├── cache_service.dart        # Category order persistence
│   │   ├── live_rates_service.dart   # Currency, metals, fuel APIs
│   │   └── saved_results_service.dart# Compressed bookmark storage
│   ├── utils/
│   │   ├── formatter.dart
│   │   └── math_helpers.dart
│   └── widgets/
│       ├── calculator_scaffold.dart  # Shared scaffold + save/export
│       ├── live_badge.dart           # "LIVE" chip
│       ├── result_row.dart
│       ├── save_button.dart
│       ├── export_button.dart
│       └── slider_input.dart
├── features/
│   ├── home/
│   │   ├── app_shell.dart            # BottomNavigationBar (2 tabs)
│   │   ├── home_screen.dart          # Category grid + search + reorder
│   │   ├── category_screen.dart      # Tool list for a category
│   │   └── tool_router.dart          # Central switch router
│   ├── professions/
│   │   ├── professions_screen.dart   # Grid of 11 professions
│   │   └── profession_tools_screen.dart # Tools list for a profession
│   ├── calculators/                  # 50+ calculator screens
│   ├── converters/                   # Unit converter engine
│   ├── live/                         # Live rate screens
│   └── saved/                        # Saved results viewer
└── widgets/
    ├── number_input.dart
    ├── result_card.dart
    └── unit_dropdown.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable channel, ≥ 3.0.0)
- Android Studio / VS Code
- Android device or emulator

### Run

```bash
git clone https://github.com/madhav921/Utilz-Hub.git
cd Utilz-Hub/flutter_application
flutter pub get
flutter run
```

### Build Release

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `intl` | Number & date formatting |
| `collection` | List utilities |
| `http` | Live rate API calls |
| `shared_preferences` | Local storage |
| `share_plus` | Share/export results |
| `path_provider` | File system paths |

---

## 🎨 Themes

| Mode | Description |
|---|---|
| **Light** | Clean white/grey palette |
| **Dark** | Material You dark surface |
| **AMOLED** | Pure black for OLED screens |

Toggle from the palette icon in the top-right of the home screen.

---

## 📄 License

This project is for educational and utility purposes.
