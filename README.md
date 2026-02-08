# Utilz Hub — All-in-One Toolbox App

A comprehensive, offline-first **Flutter** utility app packed with **86+ tools** across **14 categories**, **12 profession-based groupings**, a personalizable **My Space** workspace, home-screen shortcuts, and real-time live-rate converters — all in a single, beautifully themed application.

---

## Highlights

| Feature | Description |
|---------|-------------|
| Home | Reorderable category grid with iOS-style jiggle mode |
| Professions | 12 curated tool sets for different career roles |
| My Space | Personal workspace — create custom folders and favourites |
| 3 Themes | Dark, Light and Ocean — switch instantly |
| Favourites | Heart-tap any tool to add it to Everyday Essentials |
| Home Screen Shortcuts | Pin any tool to your phone's home screen for one-tap access |
| Save and Share | Bookmark results, copy to clipboard, share via apps |
| Live Rates | Real-time currency, gold, silver and fuel prices |
| Custom Tool Builder | Build your own calculators — coming soon |
| Coming Soon | Document Tools (PDF/Word) actively in development |

---

## Getting Started

### Prerequisites

- **Flutter SDK** >= 3.0.0 (< 4.0.0)
- **Dart SDK** (bundled with Flutter)
- Android Studio / Xcode (for mobile) or Chrome (for web)

### Installation

```
# Clone the repository
git clone https://github.com/madhav921/Utilz-Hub.git
cd Utilz-Hub/flutter_application

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build for Release

```
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.x (Material Design 3) |
| **Language** | Dart + Kotlin (Android shortcuts) |
| **State Management** | ChangeNotifier + setState |
| **Persistence** | shared_preferences — favourites, folder data, category order, saved results |
| **Networking** | http — live currency, gold, silver and fuel rate APIs |
| **Sharing** | share_plus — share calculation results |
| **File Storage** | path_provider — local file paths |
| **Formatting** | intl — number and date formatting |
| **Collections** | collection — list utilities |
| **Platform Channels** | MethodChannel — Android pinned shortcuts |

---

## Project Structure

```
lib/
  main.dart                        # Entry point
  app/
    app.dart                       # MaterialApp setup
    theme_provider.dart            # Dark / Light / Ocean theme switcher
  core/
    constants/                     # Unit conversion data and lookup tables
    models/
      tool_category.dart           # 14 tool categories and 86+ Tool definitions
      profession_category.dart     # 12 profession groupings
    services/
      cache_service.dart           # SharedPreferences persistence layer
      home_shortcut_service.dart   # Android home-screen shortcut service
    utils/                         # Shared helpers (formatters, validators)
    widgets/                       # Reusable widgets (LiveBadge, SliderWithInput, etc.)
  features/
    home/
      home_screen.dart             # Category grid with jiggle reorder
      app_shell.dart               # 3-tab bottom navigation shell
      category_screen.dart         # Tool grid within a category (3-dot menu, heart icon)
      tool_router.dart             # Central router to all tool screens
      coming_soon_screen.dart      # Placeholder for upcoming tools
    professions/
      professions_screen.dart      # Profession grid
      profession_tools_screen.dart
    my_space/
      my_space_screen.dart         # Custom folders and favourites workspace
    calculators/                   # Individual calculator screens
    converters/                    # Individual converter screens
    live/                          # Live rate screens (currency, gold, silver, fuel)
    saved/
      saved_results_screen.dart
  widgets/
    number_input.dart              # Styled numeric text field
    result_card.dart               # Calculation result display card
    unit_dropdown.dart             # Unit picker dropdown

android/
  app/src/main/kotlin/.../
    MainActivity.kt                # MethodChannel handler for pinned shortcuts
```

---

## All 86+ Tools by Category

### 1. Finance and Loans (10 tools)
| Tool | Description |
|------|-------------|
| EMI Calculator | Monthly loan installments with amortization |
| Simple Interest | Calculate simple interest |
| Compound Interest | Calculate compound interest |
| SIP Calculator | Systematic investment returns |
| FD/RD Calculator | Fixed and recurring deposit returns |
| Loan Compare | Compare two loan options |
| Depreciation | SLM, WDV and DDB depreciation |
| Loan Prepayment | Foreclosure savings calculator |
| Inflation Calculator | Inflation-adjusted future/present value |
| Cash Denomination | Split amount into fewest notes and coins |

### 2. Business and Tax (10 tools)
| Tool | Description |
|------|-------------|
| GST Calculator | GST with CGST/SGST breakdown |
| Profit and Loss | Calculate profit margins |
| Markup and Margin | Markup vs margin calculator |
| Break-Even | Find break-even point |
| Unit Price Compare | Compare price per unit |
| Salary Breakup | CTC to in-hand breakup (editable components) |
| Tax Estimator | Basic income tax estimate |
| Stamp Duty | Stamp duty and registration costs |
| Penalty Calculator | Penalty / fine on overdue amounts |
| ROI Calculator | Return on investment percentage |

### 3. Math and Numbers (8 tools)
| Tool | Description |
|------|-------------|
| Percentage | Calculate percentages easily |
| % Change | Percentage increase / decrease |
| Ratio | Calculate and simplify ratios |
| Number Base | Binary, Hex, Decimal, Octal converter |
| Scientific Notation | Standard to scientific form |
| Fraction to Decimal | Convert fractions and decimals |
| Speed Distance Time | Speed = Distance / Time |
| GPA / CGPA | GPA calculator and % to GPA |

### 4. Unit Converters (13 tools)
| Tool | Description |
|------|-------------|
| Length | Meters, feet, miles and more |
| Weight | Kilograms, pounds, ounces |
| Temperature | Celsius, Fahrenheit, Kelvin |
| Area | sq.m, acres, hectares |
| Volume | Liters, gallons, cups |
| Speed | km/h, mph, knots |
| Time | Seconds to years |
| Pressure | Pascal, bar, PSI, atm |
| Energy | Joules, calories, kWh |
| Power | Watts, horsepower |
| Data Storage | Bytes, KB, MB, GB, TB |
| Angle | Degree, radian, gradian |
| Fuel Efficiency | km/l, l/100km, mpg (US/UK) |

### 5. Geometry (5 tools)
| Tool | Description |
|------|-------------|
| Circle | Area and circumference |
| Triangle | Area, perimeter, angles |
| Rectangle | Perimeter and area |
| 3D Shapes | Sphere, cylinder, cone, cube |
| Slope and Angle | Rise/run, grade, degrees |

### 6. Time and Date (5 tools)
| Tool | Description |
|------|-------------|
| Date Difference | Days between two dates |
| Age Calculator | Calculate exact age in detail |
| Work Hours | Calculate work hours and pay |
| Countdown | Days until a target date |
| Timestamp to Date | Unix timestamp converter |

### 7. Live Rates (4 tools)
| Tool | Description |
|------|-------------|
| Currency | Live currency conversion |
| Gold Price | Live gold price by region and karat |
| Silver Price | Live silver price by grade |
| Fuel Prices | Live fuel prices by country |

### 8. Health and Body (6 tools)
| Tool | Description |
|------|-------------|
| BMI and Calories | Body mass index and daily calorie needs |
| Body Surface Area | BSA for drug dosing |
| Dosage Calculator | Drug dose by body weight |
| Heart Rate Zones | Training heart rate zones |
| Fluid Intake | Daily water intake guide |
| Ideal Body Weight | IBW using Devine, Robinson, Miller, Hamwi formulas |

### 9. Engineering (9 tools)
| Tool | Description |
|------|-------------|
| Pipe Flow | Pipe diameter and flow rate |
| Tank Capacity | Water tank volume |
| Wood Volume | Board feet and cubic volume |
| Material Estimator | Bricks, cement, tiles, paint |
| Wastage % | Material wastage calculator |
| Load Calculator | Force, stress from mass |
| Efficiency | Input vs output efficiency |
| Ohms Law | V = I × R calculator |
| Wire Gauge (AWG) | Wire size and current reference |

### 10. Digital Tools (4 tools)
| Tool | Description |
|------|-------------|
| Color Converter | HEX to RGB to HSL |
| Screen DPI | PPI and resolution calculator |
| File Size | Image/video/audio size estimate |
| Base64 Encoder | Encode and decode Base64 text |

### 11. Real Estate and Vehicle (5 tools)
| Tool | Description |
|------|-------------|
| Vehicle Cost | On-road price with RTO, insurance |
| Flat Buying Cost | Total property buying cost |
| Rent Calculator | Rent affordability and costs |
| Cost per Area | Price per sq.ft, sq.m, sq.yd, acre |
| Loan Eligibility | Max loan based on income and expenses |

### 12. Everyday Essentials (4 tools — in My Space)
| Tool | Description |
|------|-------------|
| Discount | Calculate sale prices and savings |
| Tip Calculator | Calculate tips and split bills |
| Bill Splitter | Split bills among friends |
| Fuel Cost | Calculate trip fuel expenses |

### 13. Education Basics (3 tools — Pre-School professions only)
| Tool | Description |
|------|-------------|
| Number Compare | Compare two numbers visually |
| Counting Helper | Visual counting 1 to 100 |
| Add and Subtract | Simple addition and subtraction |

### 14. Document Tools — Coming Soon (8 tools)

> These tools are actively being developed and will be available in a future update.

| Tool | Description |
|------|-------------|
| Merge PDFs | Combine multiple PDF files |
| Split PDF | Extract pages from a PDF |
| Compress PDF | Reduce PDF file size |
| PDF to Image | Convert PDF pages to images |
| Image to PDF | Convert images to a PDF |
| Word to PDF | Convert DOCX to PDF |
| PDF to Word | Convert PDF to editable DOCX |
| Watermark PDF | Add text or image watermark |

---

## Professions Tab — 12 Career Groupings

Each profession surfaces a curated subset of tools most relevant to that role. High-School includes sub-categories (Mathematics, Geometry, Physics, General).

| Profession | Example Tools |
|------------|---------------|
| Pre-School Kids | Counting Helper, Add and Subtract, Number Compare |
| High-School | Percentage, Ratio, Circle, Triangle, Speed Distance Time, GPA |
| Lawyers | Stamp Duty, Penalty Calculator, Tax Estimator |
| Doctors / Medical | BSA, Dosage Calculator, Heart Rate Zones, Fluid Intake, BMI |
| Plumbers | Pipe Flow, Tank Capacity, Material Estimator |
| Carpenters | Wood Volume, Material Estimator, Area, Length |
| Engineers | Ohms Law, Wire Gauge, Load Calculator, Efficiency, Pipe Flow |
| Chartered Accountants | GST, Profit and Loss, Tax Estimator, Depreciation, Break-Even |
| Real Estate | Vehicle Cost, Flat Buying, Rent Calculator, Stamp Duty, Loan Prepayment |
| IT / Software | Color Converter, Screen DPI, File Size, Base64 Encoder, Number Base |

---

## Home Screen Shortcuts

Pin any tool directly to your phone's home screen for **one-tap access**.

### How it works
1. Open any category and find the tool you want
2. Tap the **⋮** (3-dot menu) on the tool card
3. Select **Add to Home Screen**
4. Confirm in the dialog
5. The shortcut appears on your home screen — tap it to jump straight to the tool

> **Supported on:** Android 8.0+ (API 26+). Uses `ShortcutManagerCompat.requestPinShortcut` via a Kotlin MethodChannel.

---

## My Space

A personal workspace where users can:

- **Everyday Essentials** — Quick-access favourite tools (heart any tool to add it)
- **Custom Tool Builder** *(Coming Soon)* — Build your own calculators with custom formulas, inputs, and visual results
- **Create custom folders** — Choose name, icon (16 options) and color (10 options)
- **Add any tool** to any folder via a searchable tool picker
- **Edit / delete** folders and remove individual tools
- All data persists locally via SharedPreferences

### Custom Tool Builder — Coming Soon

A visual, no-code builder to create personalised calculators and converters:

| Capability | Description |
|------------|-------------|
| Custom Formulas | Define formulas with variables, operators, and functions |
| Input Controls | Add sliders, text fields, dropdowns and toggles |
| Visual Results | Display output as numbers, breakdowns, charts or tables |
| Save and Organise | Save custom tools to My Space, share or export as templates |
| Personalise | Choose icons, accent colours and category labels |

---

## Key Features

- **Offline-first** — All calculators and converters work without internet
- **Live rate APIs** — Currency, gold, silver and fuel prices fetched in real-time
- **Home screen shortcuts** — Pin tools to your phone's home screen (Android)
- **iOS-style jiggle reorder** — Long-press the home grid to rearrange categories
- **Heart-based favouriting** — Tap the heart on any tool card to favourite it
- **3-dot tool menu** — Quick actions including "Add to Home Screen"
- **Slider + text input** — Every slider has a synced editable text field
- **Save and bookmark** — Save calculation results locally for later reference
- **Copy and share** — Copy results to clipboard or share via any app
- **3 theme modes** — Dark, Light and Ocean toggled from the palette icon
- **Responsive layout** — Adapts to phones, tablets and web
- **Zero-config persistence** — Category order, favourites, folders and saved results all persist across sessions

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| intl | ^0.20.2 | Number and date formatting |
| collection | ^1.17.0 | List utilities |
| http | ^1.2.0 | REST API calls for live rates |
| shared_preferences | ^2.3.0 | Local key-value persistence |
| share_plus | ^10.1.4 | Native share sheet integration |
| path_provider | ^2.1.0 | Platform file paths |

---

## Roadmap

- [x] 86+ calculators and converters
- [x] 3-tab navigation (Home, Professions, My Space)
- [x] Custom folder creation in My Space
- [x] iOS-style jiggle reorder on home grid
- [x] Heart-based favouriting system
- [x] Home screen shortcuts (Android pinned shortcuts)
- [x] Dark, Light and Ocean themes
- [x] Live currency, gold, silver and fuel rates
- [x] Save, copy and share results
- [x] ROI, Loan Prepayment, Inflation, Fuel Efficiency, IBW, Base64, Cost per Area, Loan Eligibility
- [ ] Custom Tool Builder — visual no-code calculator/converter builder
- [ ] Document Tools — PDF merge/split/compress, Image to PDF, Word to PDF, watermarking
- [ ] iOS shortcut support
- [ ] Push notifications for rate alerts
- [ ] History and analytics dashboard
- [ ] Multi-language support

---

## License

This project is for personal/educational use.

---

> Built with Flutter
