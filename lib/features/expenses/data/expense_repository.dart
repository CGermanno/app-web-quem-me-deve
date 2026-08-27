import 'package:conta_facil/features/expenses/data/db.dart';
import 'package:sqflite/sqflite.dart';
import 'expense.dart';
import 'category.dart';
import 'person.dart';

class ExpenseRepository {
  final Database db;

  ExpenseRepository._(this.db);

  static Future<ExpenseRepository> create() async {
    await AppDatabase.instance.init();
    return ExpenseRepository._(AppDatabase.instance.db);
  }

  // Cria um novo gasto
  Future<int> insertExpense(Expense expense) async {
    return await db.insert('transactions', expense.toMap());
  }

  // Atualiza gasto
  Future<int> updateExpense(Expense expense) async {
    return await db.update(
      'transactions',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
// Método para inserir nova pessoa

Future<int> insertPerson(Person person) async {
  final map = person.toMap();
  map.remove('id'); // Remove o ID problemático
  
  return await db.insert('person', map);
}
  // Deleta gasto
  Future<int> deleteExpense(int id) async {
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Retorna lista de gastos (filtra por pessoa/categoria/período)
  Future<List<Expense>> getExpenses({
    int? personId,
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final where = <String>[];
    final args = <dynamic>[];

    if (personId != null) {
      where.add('personId = ?');
      args.add(personId);
    }
    if (categoryId != null) {
      where.add('categoryId = ?');
      args.add(categoryId);
    }
    if (startDate != null) {
      where.add('date >= ?');
      args.add(startDate.millisecondsSinceEpoch ~/ 1000);
    }
    if (endDate != null) {
      where.add('date < ?');
      args.add(endDate.millisecondsSinceEpoch ~/ 1000);
    }

    final res = await db.query(
      'transactions',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: args,
      orderBy: 'date DESC',
    );
    return res.map((row) => Expense.fromMap(row)).toList();
  }

  // Lista todas as categorias cadastradas
  Future<List<Category>> getCategories() async {
    final res = await db.query('category', orderBy: 'name');
    return res.map((row) => Category.fromMap(row)).toList();
  }

  // Lista todas as pessoas cadastradas
  Future<List<Person>> getPeople() async {
    final res = await db.query('person', orderBy: 'name');
    return res.map((row) => Person.fromMap(row)).toList();
  }

  // Retorna TOTAL por pessoa (para pilhas da tela de comparação)
  Future<List<PersonTotal>> getTotalsByPerson(DateTime start, DateTime end) async {
    final res = await db.rawQuery('''
      SELECT t.personId, p.name as personName, SUM(t.amount) as total
      FROM transactions t
      JOIN person p ON p.id = t.personId
      WHERE t.date >= ? AND t.date < ?
      GROUP BY t.personId
      ORDER BY total DESC
    ''', [
      start.millisecondsSinceEpoch ~/ 1000,
      end.millisecondsSinceEpoch ~/ 1000,
    ]);
    return res.map((row) => PersonTotal(
      personId: row['personId'] as int,
      personName: row['personName'] as String,
      total: (row['total'] as num?)?.toDouble() ?? 0,
    )).toList();
  }

  // Retorna SUBTOTAIS por categoria de uma pessoa (para pilha detalhada)
  Future<List<CategorySubtotal>> getSubtotalsByCategory({
    required int personId,
    required DateTime start,
    required DateTime end,
  }) async {
    final res = await db.rawQuery('''
      SELECT t.categoryId, c.name as categoryName, SUM(t.amount) as subtotal
      FROM transactions t
      LEFT JOIN category c ON c.id = t.categoryId
      WHERE t.personId = ? AND t.date >= ? AND t.date < ?
      GROUP BY t.categoryId
      ORDER BY subtotal DESC
    ''', [
      personId,
      start.millisecondsSinceEpoch ~/ 1000,
      end.millisecondsSinceEpoch ~/ 1000,
    ]);
    return res.map((row) => CategorySubtotal(
      categoryId: row['categoryId'] as int?,
      categoryName: row['categoryName'] as String? ?? 'Sem categoria',
      subtotal: (row['subtotal'] as num?)?.toDouble() ?? 0,
    )).toList();
  }

  // Retorna lista de gastos de uma pessoa num período (detalhe da pilha)
  Future<List<Expense>> getExpensesByPerson({
    required int personId,
    required DateTime start,
    required DateTime end,
  }) async {
    final res = await db.query(
      'transactions',
      where: 'personId = ? AND date >= ? AND date < ?',
      whereArgs: [
        personId,
        start.millisecondsSinceEpoch ~/ 1000,
        end.millisecondsSinceEpoch ~/ 1000,
      ],
      orderBy: 'date DESC',
    );
    return res.map((row) => Expense.fromMap(row)).toList();
  }
}

// ==================== MODELOS DE SUPORTE ====================
class PersonTotal {
  final int personId;
  final String personName;
  final double total;
  PersonTotal({
    required this.personId,
    required this.personName,
    required this.total,
  });
}

class CategorySubtotal {
  final int? categoryId;
  final String categoryName;
  final double subtotal;
  CategorySubtotal({
    required this.categoryId,
    required this.categoryName,
    required this.subtotal,
  });
}
