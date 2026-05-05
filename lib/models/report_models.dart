class CategoryTotal {
  const CategoryTotal({
    required this.categoryId,
    required this.categoryName,
    required this.color,
    required this.total,
  });

  final int categoryId;
  final String categoryName;
  final int color;
  final double total;
}

class PeriodTotal {
  const PeriodTotal({
    required this.label,
    required this.total,
  });

  final String label;
  final double total;
}

class MonthlyComparison {
  const MonthlyComparison({
    required this.label,
    required this.income,
    required this.expenses,
    required this.savings,
  });

  final String label;
  final double income;
  final double expenses;
  final double savings;
}
