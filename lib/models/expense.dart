class Expense {
  const Expense({
    this.id,
    required this.date,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.month,
    required this.year,
  });

  final int? id;
  final DateTime date;
  final int categoryId;
  final double amount;
  final String description;
  final int month;
  final int year;

  Map<String, Object?> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'category_id': categoryId,
        'amount': amount,
        'description': description,
        'month': month,
        'year': year,
      };

  factory Expense.fromMap(Map<String, Object?> map) => Expense(
        id: map['id'] as int?,
        date: DateTime.parse(map['date'] as String),
        categoryId: map['category_id'] as int,
        amount: (map['amount'] as num).toDouble(),
        description: map['description'] as String,
        month: map['month'] as int,
        year: map['year'] as int,
      );
}
