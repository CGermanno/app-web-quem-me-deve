
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/expense_repository.dart';
import '../data/expense.dart' as models;
import '../data/person.dart' as models;
import '../data/category.dart' as models;

class ExpenseController extends ChangeNotifier {
  final ExpenseRepository? repo; // ✅ agora pode ser nulo

  List<models.Category> categories = [];
  List<models.Person> people = [];
  List<models.Expense> items = [];
  DateTime currentMonth = DateTime.now();
  int monthlyLimitCents = 0; // 0 = sem limite

  int? selectedPersonId; // null = todas as pessoas

  ExpenseController(this.repo);

  // ============================================================
  // ✅ Novo: construtor auxiliar para instância temporária (sem repo)
  ExpenseController.nullRepo() : repo = null;

  // ============================================================

  Future<void> init() async {
    if (repo == null) return; // evita erro antes do repositório estar pronto
    try {
      print('Iniciando ExpenseController...');
      categories = await repo!.getCategories();
      print('Categorias carregadas: ${categories.length}');
      people = await repo!.getPeople();
      print('Pessoas carregadas: ${people.length}');
      final prefs = await SharedPreferences.getInstance();
      monthlyLimitCents = prefs.getInt('limit_cents') ?? 0;
      selectedPersonId = null;
      await loadMonth(DateTime.now());
      print('init() finalizado');
    } catch (e, st) {
      debugPrint('ERRO NO CONTROLLER INIT: $e\n$st');
      rethrow;
    }
  }

  Future<void> loadMonth(DateTime month, {int? personId}) async {
    if (repo == null) return;
    currentMonth = DateTime(month.year, month.month);
    selectedPersonId = personId;
    items = await repo!.getExpenses(
      personId: personId,
      startDate: currentMonth,
      endDate: DateTime(currentMonth.year, currentMonth.month + 1),
    );
    notifyListeners();
  }

  Future<void> loadCustomRange(DateTime startDate, DateTime endDate) async {
    if (repo == null) return;
    
    currentMonth = startDate;
    selectedPersonId = null;
    
    // Carrega despesas para o período personalizado
    items = await repo!.getExpenses(
      startDate: startDate,
      endDate: endDate,
    );
    
    notifyListeners();
  }

  Future<void> addPerson(String name) async {
    if (repo == null) return;
    
    final newPerson = models.Person(
      id: 0, // Será gerado automaticamente
      name: name,
      createdAt: DateTime.now(),
    );
    
    await repo!.insertPerson(newPerson);
    
    // Recarrega a lista de pessoas
    people = await repo!.getPeople();
    notifyListeners();
  }

  Future<void> setLimitBRL(double value) async {
    final cents = (value * 100).round();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('limit_cents', cents);
    monthlyLimitCents = cents;
    notifyListeners();
  }

  Future<void> addExpense({
    required double amount,
    required DateTime date,
    String? note,
    required int personId,
    int? categoryId,
  }) async {
    if (repo == null) return;
    final expense = models.Expense(
      amount: amount,
      date: date,
      note: note,
      personId: personId,
      categoryId: categoryId,
    );
    await repo!.insertExpense(expense);
    await loadMonth(currentMonth, personId: selectedPersonId);
  }

  Future<void> updateExpense(models.Expense expense) async {
    if (repo == null) return;
    await repo!.updateExpense(expense);
    await loadMonth(currentMonth, personId: selectedPersonId);
  }

  Future<void> deleteExpense(int expenseId) async {
    if (repo == null) return;
    await repo!.deleteExpense(expenseId);
    await loadMonth(currentMonth, personId: selectedPersonId);
  }

  double get totalMonth => items.fold(0.0, (acc, e) => acc + e.amount);

  Future<List<PersonTotal>> getTotalsByPerson({DateTime? customStart, DateTime? customEnd}) async {
    if (repo == null) return [];
    
    final start = customStart ?? currentMonth;
    final end = customEnd ?? DateTime(currentMonth.year, currentMonth.month + 1);
    
    return await repo!.getTotalsByPerson(start, end);
  }

  Future<List<CategorySubtotal>> getSubtotalsByCategory(int personId, {DateTime? customStart, DateTime? customEnd}) async {
    if (repo == null) return [];
    
    final start = customStart ?? currentMonth;
    final end = customEnd ?? DateTime(currentMonth.year, currentMonth.month + 1);
    
    return await repo!.getSubtotalsByCategory(
      personId: personId,
      start: start,
      end: end,
    );
  }
}