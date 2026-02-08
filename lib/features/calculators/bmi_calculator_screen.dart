import 'package:flutter/material.dart';

class BMICalculatorScreen extends StatefulWidget {
  final Color categoryColor;

  const BMICalculatorScreen({super.key, required this.categoryColor});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  double _weight = 70.0;
  double _height = 170.0;
  int _age = 25;
  String _gender = 'Male';
  String _activityLevel = 'Moderate';

  double get _bmi => _weight / ((_height / 100) * (_height / 100));
  
  String get _bmiCategory {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Normal';
    if (_bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    if (_bmi < 18.5) return Colors.blue;
    if (_bmi < 25) return Colors.green;
    if (_bmi < 30) return Colors.orange;
    return Colors.red;
  }

  double get _bmr {
    if (_gender == 'Male') {
      return 88.362 + (13.397 * _weight) + (4.799 * _height) - (5.677 * _age);
    } else {
      return 447.593 + (9.247 * _weight) + (3.098 * _height) - (4.330 * _age);
    }
  }

  double get _calories {
    final multipliers = {
      'Sedentary': 1.2,
      'Light': 1.375,
      'Moderate': 1.55,
      'Active': 1.725,
      'Very Active': 1.9,
    };
    return _bmr * (multipliers[_activityLevel] ?? 1.55);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI & Calorie Calculator'),
        backgroundColor: widget.categoryColor.withValues(alpha: 0.1),
        foregroundColor: widget.categoryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderButton('Male', Icons.male),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderButton('Female', Icons.female),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSlider('Weight', _weight, 30, 200, (v) => setState(() => _weight = v), 'kg'),
                    const SizedBox(height: 20),
                    _buildSlider('Height', _height, 100, 250, (v) => setState(() => _height = v), 'cm'),
                    const SizedBox(height: 20),
                    _buildSlider('Age', _age.toDouble(), 10, 100, (v) => setState(() => _age = v.toInt()), 'years'),
                    const SizedBox(height: 20),
                    _buildActivitySelector(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: _bmiColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Your BMI', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(_bmi.toStringAsFixed(1), style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: _bmiColor)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _bmiColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(_bmiCategory, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Calorie Needs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.categoryColor)),
                    const Divider(height: 24),
                    _buildRow('BMR (Base Metabolic Rate)', _bmr),
                    const SizedBox(height: 12),
                    _buildRow('Daily Calories', _calories, color: widget.categoryColor, isBold: true),
                    const Divider(height: 24),
                    _buildRow('To lose weight', _calories - 500, color: Colors.red),
                    const SizedBox(height: 8),
                    _buildRow('To gain weight', _calories + 500, color: Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _gender == gender;
    return GestureDetector(
      onTap: () => setState(() => _gender = gender),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? widget.categoryColor.withValues(alpha: 0.2) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? widget.categoryColor : Colors.grey, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: isSelected ? widget.categoryColor : Colors.grey),
            const SizedBox(height: 8),
            Text(gender, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? widget.categoryColor : null)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Activity Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active'].map((level) {
            return ChoiceChip(
              label: Text(level),
              selected: _activityLevel == level,
              selectedColor: widget.categoryColor.withValues(alpha: 0.3),
              onSelected: (selected) => setState(() => _activityLevel = level),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.categoryColor)),
            Text('${value.toStringAsFixed(0)} $suffix', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.categoryColor)),
          ],
        ),
        Slider(value: value, min: min, max: max, divisions: (max - min).toInt(), activeColor: widget.categoryColor, onChanged: onChanged),
      ],
    );
  }

  Widget _buildRow(String label, double amount, {Color? color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text('${amount.toStringAsFixed(0)} kcal', style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color)),
      ],
    );
  }
}
