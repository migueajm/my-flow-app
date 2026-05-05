class Category {
  const Category({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  final int? id;
  final String name;
  final int color;
  final String icon;

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'color': color,
        'icon': icon,
      };

  factory Category.fromMap(Map<String, Object?> map) => Category(
        id: map['id'] as int?,
        name: map['name'] as String,
        color: map['color'] as int,
        icon: map['icon'] as String,
      );
}
