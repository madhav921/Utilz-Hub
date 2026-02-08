import 'package:flutter/material.dart';
import '../../core/widgets/calculator_scaffold.dart';
import '../../core/widgets/slider_input.dart';
import '../../core/widgets/result_row.dart';

/// Calculate fuel cost for a trip.
class FuelCostScreen extends StatefulWidget {
  final Color categoryColor;
  const FuelCostScreen({super.key, required this.categoryColor});

  @override
  State<FuelCostScreen> createState() => _FuelCostScreenState();
}

class _FuelCostScreenState extends State<FuelCostScreen> {
  double _distance = 100; // km
  double _mileage = 15; // km/l
  double _fuelPrice = 100; // per liter

  double get _fuelNeeded => _mileage > 0 ? _distance / _mileage : 0;
  double get _totalCost => _fuelNeeded * _fuelPrice;
  double get _costPerKm => _distance > 0 ? _totalCost / _distance : 0;

  Map<String, String> get _exportData => {
        'Distance': '${_distance.toStringAsFixed(0)} km',
        'Mileage': '${_mileage.toStringAsFixed(1)} km/l',
        'Fuel Price': '₹${_fuelPrice.toStringAsFixed(2)}/L',
        'Fuel Needed': '${_fuelNeeded.toStringAsFixed(2)} L',
        'Total Cost': '₹${_totalCost.toStringAsFixed(2)}',
        'Cost per km': '₹${_costPerKm.toStringAsFixed(2)}',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.categoryColor;
    return CalculatorScaffold(
      title: 'Fuel Cost',
      accentColor: c,
      infoText: 'Estimate fuel expenses for your trip.',
      exportData: _exportData,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SliderInput(
                  label: 'Distance',
                  value: _distance,
                  min: 1,
                  max: 2000,
                  divisions: 200,
                  suffix: 'km',
                  accentColor: c,
                  onChanged: (v) => setState(() => _distance = v),
                ),
                const SizedBox(height: 16),
                SliderInput(
                  label: 'Mileage',
                  value: _mileage,
                  min: 3,
                  max: 50,
                  divisions: 94,
                  suffix: 'km/l',
                  decimals: 1,
                  accentColor: c,
                  onChanged: (v) => setState(() => _mileage = v),
                ),
                const SizedBox(height: 16),
                SliderInput(
                  label: 'Fuel Price',
                  value: _fuelPrice,
                  min: 50,
                  max: 250,
                  divisions: 200,
                  suffix: '₹/L',
                  decimals: 2,
                  accentColor: c,
                  onChanged: (v) => setState(() => _fuelPrice = v),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          color: c.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Total Fuel Cost', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 6),
                Text(
                  '₹${_totalCost.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 42, fontWeight: FontWeight.bold, color: c),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ResultRow(
                    label: 'Fuel Needed',
                    value: '${_fuelNeeded.toStringAsFixed(2)} L'),
                ResultRow.currency('Cost per km', _costPerKm, color: c),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
