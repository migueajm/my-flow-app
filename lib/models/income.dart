class Income {
  const Income({
    this.id,
    required this.amount,
    required this.expenseBudget,
    required this.savingsBudget,
    required this.month,
    required this.year,
    required this.createdAt,
  });

  final int? id;
  final double amount;
  final double expenseBudget;
  final double savingsBudget;
  final int month;
  final int year;
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
        'id': id,
        'amount': amount,
        'expense_budget': expenseBudget,
        'savings_budget': savingsBudget,
        'month': month,
        'year': year,
        'created_at': createdAt.toIso8601String(),
      };

  factory Income.fromMap(Map<String, Object?> map) => Income(
        id: map['id'] as int?,
        amount: (map['amount'] as num).toDouble(),
        expenseBudget: (map['expense_budget'] as num).toDouble(),
        savingsBudget: (map['savings_budget'] as num).toDouble(),
        month: map['month'] as int,
        year: map['year'] as int,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
