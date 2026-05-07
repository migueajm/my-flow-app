enum AccountType {
  ahorro,
  inversion;

  String get label => this == AccountType.ahorro ? 'savings' : 'investments';
}

class SavingsAccount {
  const SavingsAccount({
    this.id,
    required this.name,
    required this.type,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final AccountType type;
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'type': type.name,
        'created_at': createdAt.toIso8601String(),
      };

  factory SavingsAccount.fromMap(Map<String, Object?> map) => SavingsAccount(
        id: map['id'] as int?,
        name: map['name'] as String,
        type: AccountType.values.byName(map['type'] as String),
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
