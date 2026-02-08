import '../../core/utils/math_helpers.dart';
import 'calculator_models.dart';

/// Pure calculation functions - No UI dependencies

class CalculatorLogic {
  /// Percentage calculations
  
  /// Calculate what percentage X is of Y
  static double percentageOf(double value, double total) {
    if (total == 0) return 0.0;
    return MathHelpers.safeDivide(value * 100, total);
  }

  /// Calculate X% of Y
  static double calculatePercentage(double percentage, double value) {
    return (percentage / 100) * value;
  }

  /// Increase value by percentage
  static double increaseByPercentage(double value, double percentage) {
    return value + calculatePercentage(percentage, value);
  }

  /// Decrease value by percentage
  static double decreaseByPercentage(double value, double percentage) {
    return value - calculatePercentage(percentage, value);
  }

  /// GST Calculator
  
  /// Calculate GST amount and final price (adding GST)
  static GSTResult calculateGSTAdd(double price, double gstRate) {
    assert(price >= 0, 'Price must be non-negative');
    assert(gstRate >= 0 && gstRate <= 100, 'GST rate must be between 0 and 100');
    
    final gstAmount = calculatePercentage(gstRate, price);
    final finalPrice = price + gstAmount;
    
    return GSTResult(
      originalPrice: price,
      gstAmount: gstAmount,
      finalPrice: finalPrice,
      gstRate: gstRate,
    );
  }

  /// Calculate GST from inclusive price (removing GST)
  static GSTResult calculateGSTRemove(double inclusivePrice, double gstRate) {
    assert(inclusivePrice >= 0, 'Price must be non-negative');
    assert(gstRate >= 0 && gstRate <= 100, 'GST rate must be between 0 and 100');
    
    final originalPrice = MathHelpers.safeDivide(inclusivePrice * 100, 100 + gstRate);
    final gstAmount = inclusivePrice - originalPrice;
    
    return GSTResult(
      originalPrice: originalPrice,
      gstAmount: gstAmount,
      finalPrice: inclusivePrice,
      gstRate: gstRate,
    );
  }

  /// EMI Calculator
  
  /// Calculate EMI using formula: P * r * (1+r)^n / ((1+r)^n - 1)
  static EMIResult calculateEMI(double principal, double annualRate, int months) {
    assert(principal > 0, 'Principal must be positive');
    assert(annualRate >= 0, 'Interest rate must be non-negative');
    assert(months > 0, 'Months must be positive');
    
    if (annualRate == 0) {
      // No interest
      final emi = MathHelpers.safeDivide(principal, months.toDouble());
      return EMIResult(
        emi: emi,
        totalPayment: principal,
        totalInterest: 0,
        principal: principal,
      );
    }
    
    final monthlyRate = annualRate / (12 * 100);
    final numerator = principal * monthlyRate * MathHelpers.safePower(1 + monthlyRate, months.toDouble());
    final denominator = MathHelpers.safePower(1 + monthlyRate, months.toDouble()) - 1;
    
    final emi = MathHelpers.safeDivide(numerator, denominator);
    final totalPayment = emi * months;
    final totalInterest = totalPayment - principal;
    
    return EMIResult(
      emi: emi,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
      principal: principal,
    );
  }

  /// Discount Calculator
  
  /// Calculate discount and final price
  static DiscountResult calculateDiscount(double originalPrice, double discountPercentage) {
    assert(originalPrice >= 0, 'Price must be non-negative');
    assert(discountPercentage >= 0 && discountPercentage <= 100, 'Discount must be between 0 and 100');
    
    final discountAmount = calculatePercentage(discountPercentage, originalPrice);
    final finalPrice = originalPrice - discountAmount;
    
    return DiscountResult(
      originalPrice: originalPrice,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
      discountPercentage: discountPercentage,
    );
  }

  /// Calculate discount percentage from prices
  static double calculateDiscountPercentage(double originalPrice, double finalPrice) {
    if (originalPrice == 0) return 0;
    final discount = originalPrice - finalPrice;
    return MathHelpers.safeDivide(discount * 100, originalPrice);
  }

  /// Tip Calculator
  
  /// Calculate tip and total
  static TipResult calculateTip(double billAmount, double tipPercentage, int numPeople) {
    assert(billAmount >= 0, 'Bill amount must be non-negative');
    assert(tipPercentage >= 0, 'Tip percentage must be non-negative');
    assert(numPeople > 0, 'Number of people must be positive');
    
    final tipAmount = calculatePercentage(tipPercentage, billAmount);
    final totalAmount = billAmount + tipAmount;
    final perPerson = MathHelpers.safeDivide(totalAmount, numPeople.toDouble());
    
    return TipResult(
      billAmount: billAmount,
      tipAmount: tipAmount,
      totalAmount: totalAmount,
      perPerson: perPerson,
    );
  }

  /// Date Difference Calculator
  
  /// Calculate difference between two dates
  static DateDifferenceResult calculateDateDifference(DateTime startDate, DateTime endDate) {
    // Ensure start is before end
    if (startDate.isAfter(endDate)) {
      final temp = startDate;
      startDate = endDate;
      endDate = temp;
    }
    
    final totalDays = endDate.difference(startDate).inDays;
    
    // Calculate years, months, and remaining days
    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;
    int days = endDate.day - startDate.day;
    
    if (days < 0) {
      months--;
      final previousMonth = DateTime(endDate.year, endDate.month - 1, startDate.day);
      days = endDate.difference(previousMonth).inDays;
    }
    
    if (months < 0) {
      years--;
      months += 12;
    }
    
    return DateDifferenceResult(
      days: totalDays,
      years: years,
      months: months,
      remainingDays: days,
    );
  }

  /// Age Calculator
  
  /// Calculate age from birth date
  static AgeResult calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    
    if (birthDate.isAfter(today)) {
      // Future date, return zeros
      return const AgeResult(years: 0, months: 0, days: 0, totalDays: 0);
    }
    
    final diff = calculateDateDifference(birthDate, today);
    
    return AgeResult(
      years: diff.years,
      months: diff.months,
      days: diff.remainingDays,
      totalDays: diff.days,
    );
  }

  /// Simple Interest Calculator
  
  /// Calculate simple interest: SI = (P * R * T) / 100
  static SimpleInterestResult calculateSimpleInterest(
    double principal,
    double rate,
    double time,
  ) {
    assert(principal >= 0, 'Principal must be non-negative');
    assert(rate >= 0, 'Rate must be non-negative');
    assert(time >= 0, 'Time must be non-negative');
    
    final interest = (principal * rate * time) / 100;
    final totalAmount = principal + interest;
    
    return SimpleInterestResult(
      interest: interest,
      totalAmount: totalAmount,
      principal: principal,
      rate: rate,
      time: time,
    );
  }
}
