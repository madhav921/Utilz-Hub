/// Calculator models
class CalculationType {
  final String id;
  final String name;
  final String icon;
  final String description;

  const CalculationType({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

/// Available calculator types
const calculatorTypes = [
  CalculationType(
    id: 'percentage',
    name: 'Percentage',
    icon: '%',
    description: 'Calculate percentages',
  ),
  CalculationType(
    id: 'gst',
    name: 'GST',
    icon: '💰',
    description: 'GST calculator',
  ),
  CalculationType(
    id: 'emi',
    name: 'EMI',
    icon: '🏦',
    description: 'EMI calculator',
  ),
  CalculationType(
    id: 'discount',
    name: 'Discount',
    icon: '🏷️',
    description: 'Discount calculator',
  ),
  CalculationType(
    id: 'tip',
    name: 'Tip',
    icon: '🍽️',
    description: 'Tip calculator',
  ),
  CalculationType(
    id: 'date_difference',
    name: 'Date Difference',
    icon: '📅',
    description: 'Calculate date difference',
  ),
  CalculationType(
    id: 'age',
    name: 'Age',
    icon: '🎂',
    description: 'Age calculator',
  ),
  CalculationType(
    id: 'simple_interest',
    name: 'Simple Interest',
    icon: '📈',
    description: 'Simple interest calculator',
  ),
];

/// Result classes for different calculators

class PercentageResult {
  final double value;
  final String description;

  const PercentageResult({required this.value, required this.description});
}

class GSTResult {
  final double originalPrice;
  final double gstAmount;
  final double finalPrice;
  final double gstRate;

  const GSTResult({
    required this.originalPrice,
    required this.gstAmount,
    required this.finalPrice,
    required this.gstRate,
  });
}

class EMIResult {
  final double emi;
  final double totalPayment;
  final double totalInterest;
  final double principal;

  const EMIResult({
    required this.emi,
    required this.totalPayment,
    required this.totalInterest,
    required this.principal,
  });
}

class DiscountResult {
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;
  final double discountPercentage;

  const DiscountResult({
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    required this.discountPercentage,
  });
}

class TipResult {
  final double billAmount;
  final double tipAmount;
  final double totalAmount;
  final double perPerson;

  const TipResult({
    required this.billAmount,
    required this.tipAmount,
    required this.totalAmount,
    required this.perPerson,
  });
}

class DateDifferenceResult {
  final int days;
  final int years;
  final int months;
  final int remainingDays;

  const DateDifferenceResult({
    required this.days,
    required this.years,
    required this.months,
    required this.remainingDays,
  });
}

class AgeResult {
  final int years;
  final int months;
  final int days;
  final int totalDays;

  const AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
  });
}

class SimpleInterestResult {
  final double interest;
  final double totalAmount;
  final double principal;
  final double rate;
  final double time;

  const SimpleInterestResult({
    required this.interest,
    required this.totalAmount,
    required this.principal,
    required this.rate,
    required this.time,
  });
}
