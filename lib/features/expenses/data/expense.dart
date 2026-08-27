class Expense {
  final int? id;             // ID do gasto (autoincrement)
  final double amount;       // Valor
  final DateTime date;       // Data (use timestamp em segundos)
  final String? note;        // Observação/opcional
  final int personId;        // Pessoa (sempre obrigatório)
  final int? categoryId;     // Categoria (opcional)

  Expense({
    this.id,
    required this.amount,
    required this.date,
    this.note,
    required this.personId,
    this.categoryId,
  });

  /// Converte um registro do banco em um objeto Expense
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(
        (map['date'] as int) * 1000,
      ),
      note: map['note'] as String?,
      personId: map['personId'] as int? ?? 1,         // fallback para "EU"
      categoryId: map['categoryId'] as int?,
    );
  }

  /// Converte o objeto Expense para um Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'date': date.millisecondsSinceEpoch ~/ 1000,
      'note': note,
      'personId': personId,
      'categoryId': categoryId,
    };
  }

  Expense copyWith({
    int? id,
    double? amount,
    DateTime? date,
    String? note,
    int? personId,
    int? categoryId,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      personId: personId ?? this.personId,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
