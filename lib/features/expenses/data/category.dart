class Category {
  final int id;
  final String name;
  final int? colorHex;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    this.colorHex,
    this.icon,
  });

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int,
    name: map['name'] as String,
    colorHex: map['colorHex'] as int?,
    icon: map['icon'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'colorHex': colorHex,
    'icon': icon,
  };
}
