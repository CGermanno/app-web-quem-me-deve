// import 'package:conta_facil/features/expenses/logic/expense_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'add_expense_screen.dart';
// import 'reports_screen.dart';
// import '../../../core/ads.dart';
// import 'package:collection/collection.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

// @override
// Widget build(BuildContext context) { 
//   final controller = context.watch<ExpenseController?>();
//   final f = NumberFormat.currency(
//     locale: 'pt_BR',
//     symbol: 'R\$',
//     decimalDigits: 2,
//   );

//   // ✅ VERIFICAÇÃO EXTRA: Se o controller existe mas ainda não foi inicializado
//   if (controller == null || controller.repo == null) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }


//     // ✅ CORREÇÃO: Verifica se o controller foi inicializado corretamente
//     if (controller.repo == null) {
//       return const Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Carregando dados...'),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Gastos do mês')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Total: ${f.format(controller.totalMonth)}',
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 if (controller.monthlyLimitCents > 0)
//                   Text(
//                     'Limite: ${f.format(controller.monthlyLimitCents / 100)}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: controller.items.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'Nenhum gasto registrado este mês',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: controller.items.length,
//                     itemBuilder: (_, i) {
//                       final expense = controller.items[i];
//                       // Busca categoria, pode ser null
//                       final category = expense.categoryId != null
//                           ? controller.categories.firstWhereOrNull((x) => x.id == expense.categoryId)
//                           : null;
//                       final person = controller.people.firstWhereOrNull((p) => p.id == expense.personId);

//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: category?.colorHex != null
//                               ? Color(category!.colorHex!)
//                               : Colors.grey.shade300,
//                           child: Icon(
//                             Icons.category,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         title: Text(expense.note?.isNotEmpty == true
//                             ? expense.note!
//                             : (category?.name ?? 'Sem categoria')),
//                         subtitle: Text(
//                           '${DateFormat('dd/MM/yyyy – HH:mm').format(expense.date)}'
//                           '${person != null ? ' • ${person.name}' : ''}',
//                         ),
//                         trailing: Text(
//                           f.format(expense.amount),
//                           style: TextStyle(
//                             color: expense.amount < 0 ? Colors.red : null,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//           const SizedBox(height: 8),
//           // Banner de anúncios (ver core/ads.dart)
//           const SizedBox(height: 52, child: Center(child: AdsBanner())),
//           const SizedBox(height: 8),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
//         ),
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
//           BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Gráficos'),
//         ],
//         currentIndex: 0,
//         onTap: (i) {
//           if (i == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const ReportsScreen()),
//             );
//           }
//         },
//       ),
//     );
//   }
// }



import 'package:conta_facil/features/expenses/data/category.dart';
import 'package:conta_facil/features/expenses/data/expense.dart';
import 'package:conta_facil/features/expenses/data/person.dart';
import 'package:conta_facil/features/expenses/logic/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_expense_screen.dart';
import 'rc1.dart';
import '../../../core/ads.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;
  double _adHeight = 0; // ✅ NOVA VARIÁVEL PARA ALTURA DO AD
  

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // Simula loading inicial
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshData() async {
    setState(() => _isLoading = true);
    await context.read<ExpenseController>().loadMonth(DateTime.now());
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController?>();
    final f = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    if (controller == null || controller.repo == null) {
      return _buildLoadingScreen();
    }

    if (controller.repo == null) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(controller, f),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: Column(
          children: [
            _buildHeaderSection(controller, f),
            Expanded(
              child: _isLoading 
                  ? _buildShimmerList()
                  : AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                            child: child,
                          ),
                        );
                      },
                      child: controller.items.isEmpty
                          ? _buildEmptyState()
                          : _buildExpenseList(controller, f),
                    ),
            ),
            //const SizedBox(height: 8),
            //const SizedBox(height: 52, child: Center(child: AdsBanner())),
            //const SizedBox(height: 8),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomAreaWithAd(),
    );
  }

  AppBar _buildAppBar(ExpenseController? controller, NumberFormat f) {
    return AppBar(
      title: const Text(
        'Meus Gastos',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
      actions: [
        if (controller != null && controller.monthlyLimitCents > 0)
          Tooltip(
            message: 'Limite Mensal',
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    f.format(controller.monthlyLimitCents / 100),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
          tooltip: 'Atualizar',
        ),
      ],
    );
  }

  Widget _buildHeaderSection(ExpenseController controller, NumberFormat f) {
    final progress = controller.monthlyLimitCents > 0 
        ? (controller.totalMonth * 100) / (controller.monthlyLimitCents / 100)
        : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total do Mês',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    f.format(controller.totalMonth),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          if (controller.monthlyLimitCents > 0) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Limite Mensal',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${progress.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress > 1.0 ? 1.0 : progress / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress > 80 ? Colors.red : Colors.white,
                  ),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpenseList(ExpenseController controller, NumberFormat f) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        final expense = controller.items[index];
        final category = expense.categoryId != null
            ? controller.categories.firstWhereOrNull((x) => x.id == expense.categoryId)
            : null;
        final person = controller.people.firstWhereOrNull((p) => p.id == expense.personId);

        return _ExpenseCard(
          expense: expense,
          category: category,
          person: person,
          currencyFormatter: f,
          onTap: () => _showExpenseDetails(context, expense, controller),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Nenhum gasto registrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque no botão + para adicionar\nseu primeiro gasto',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Primeiro Gasto'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (_, index) => _ShimmerExpenseCard(),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Carregando seus gastos...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildFloatingActionButton() {
  return Padding(
    padding: EdgeInsets.only(bottom: _adHeight > 0 ? _adHeight + 12 : 0),
    child: FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
      ).then((_) => _refreshData()),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    ),
  );
}

Widget _buildBottomAreaWithAd() {
  return SafeArea(
    top: false,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Banner (altura adaptativa)
        AdsBanner(
          onHeight: (h) {
            setState(() => _adHeight = h);
          },
        ),
        // Navegação
        _buildBottomNavigationBarCore(),
      ],
    ),
  );
}

Widget _buildBottomNavigationBarCore() {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Lista',
            activeIcon: Icon(Icons.list_rounded, color: Colors.blue),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Relatórios',
            activeIcon: Icon(Icons.analytics, color: Colors.blue),
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportsScreen()),
            );
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    ),
  );
}

  void _showExpenseDetails(BuildContext context, Expense expense, ExpenseController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ExpenseDetailsSheet(
        expense: expense,
        controller: controller,
        onDelete: () {
          Navigator.pop(context);
          _showDeleteConfirmation(context, expense, controller);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Expense expense, ExpenseController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Gasto'),
        content: Text('Tem certeza que deseja excluir o gasto "${expense.note ?? 'Sem descrição'}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteExpense(expense.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gasto excluído com sucesso!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Expense expense;
  final Category? category;
  final Person? person;
  final NumberFormat currencyFormatter;
  final VoidCallback onTap;

  const _ExpenseCard({
    required this.expense,
    required this.category,
    required this.person,
    required this.currencyFormatter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category?.colorHex != null
                      ? Color(category!.colorHex!).withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getCategoryIcon(category?.name),
                  color: category?.colorHex != null
                      ? Color(category!.colorHex!)
                      : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.note?.isNotEmpty == true
                          ? expense.note!
                          : (category?.name ?? 'Sem categoria'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(expense.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (person != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            person!.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormatter.format(expense.amount),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: expense.amount < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('HH:mm').format(expense.date),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'alimentação':
        return Icons.restaurant;
      case 'transporte':
        return Icons.directions_car;
      case 'moradia':
        return Icons.home;
      case 'lazer':
        return Icons.movie;
      case 'saúde':
        return Icons.local_hospital;
      case 'educação':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}

class _ShimmerExpenseCard extends StatefulWidget {
  @override
  State<_ShimmerExpenseCard> createState() => _ShimmerExpenseCardState();
}

class _ShimmerExpenseCardState extends State<_ShimmerExpenseCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _animation.value,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 60,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExpenseDetailsSheet extends StatelessWidget {
  final Expense expense;
  final ExpenseController controller;
  final VoidCallback onDelete;

  const _ExpenseDetailsSheet({
    required this.expense,
    required this.controller,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final category = expense.categoryId != null
        ? controller.categories.firstWhereOrNull((x) => x.id == expense.categoryId)
        : null;
    final person = controller.people.firstWhereOrNull((p) => p.id == expense.personId);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: category?.colorHex != null
                        ? Color(category!.colorHex!).withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: category?.colorHex != null
                        ? Color(category!.colorHex!)
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.note?.isNotEmpty == true
                            ? expense.note!
                            : 'Sem descrição',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category?.name ?? 'Sem categoria',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  f.format(expense.amount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow(
              icon: Icons.calendar_today,
              title: 'Data',
              value: DateFormat('dd/MM/yyyy').format(expense.date),
            ),
            _DetailRow(
              icon: Icons.access_time,
              title: 'Hora',
              value: DateFormat('HH:mm').format(expense.date),
            ),
            if (person != null)
              _DetailRow(
                icon: Icons.person,
                title: 'Pessoa',
                value: person.name,
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Excluir',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Fechar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}