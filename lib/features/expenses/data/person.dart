class Person {
  final int id;
  final String name;
  final DateTime createdAt;

  Person({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Person.fromMap(Map<String, dynamic> map) => Person(
    id: map['id'] as int,
    name: map['name'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch((map['createdAt'] as int) * 1000),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.millisecondsSinceEpoch ~/ 1000,
  };
}
