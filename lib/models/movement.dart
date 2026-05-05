enum MovementType {
  deposito,
  retiro,
  rendimiento;

  String get label {
    switch (this) {
      case MovementType.deposito:
        return 'Deposito';
      case MovementType.retiro:
        return 'Retiro';
      case MovementType.rendimiento:
        return 'Rendimiento';
    }
  }
}

class Movement {
  const Movement({
    this.id,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.month,
    required this.year,
  });

  final int? id;
  final int accountId;
  final MovementType type;
  final double amount;
  final DateTime date;
  final String description;
  final int month;
  final int year;

  double get signedAmount {
    if (type == MovementType.retiro) return -amount;
    return amount;
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'account_id': accountId,
        'type': type.name,
        'amount': amount,
        'date': date.toIso8601String(),
        'description': description,
        'month': month,
        'year': year,
      };

  factory Movement.fromMap(Map<String, Object?> map) => Movement(
        id: map['id'] as int?,
        accountId: map['account_id'] as int,
        type: MovementType.values.byName(map['type'] as String),
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
        description: map['description'] as String,
        month: map['month'] as int,
        year: map['year'] as int,
      );
}
