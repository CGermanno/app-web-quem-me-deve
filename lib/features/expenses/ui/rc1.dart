
// // import 'package:conta_facil/features/expenses/logic/expense_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';

// // class ReportsScreen extends StatefulWidget {
// //   const ReportsScreen({Key? key}) : super(key: key);

// //   @override
// //   State<ReportsScreen> createState() => _ReportsScreenState();
// // }

// // class _ReportsScreenState extends State<ReportsScreen> {
// //   DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<ExpenseController>().loadMonth(_selectedMonth);
// //     });
// //   }

// //   void _changeMonth(DateTime newMonth) {
// //     setState(() {
// //       _selectedMonth = newMonth;
// //     });
// //     context.read<ExpenseController>().loadMonth(newMonth);
// //   }

// //   void _showCustomRangeDialog(BuildContext context) {
// //     DateTime? startDate;
// //     DateTime? endDate;

// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Período Personalizado'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             ListTile(
// //               leading: const Icon(Icons.calendar_today),
// //               title: const Text('Data inicial'),
// //               subtitle: Text(startDate != null 
// //                 ? DateFormat('dd/MM/yyyy').format(startDate!)
// //                 : 'Selecionar data'),
// //               onTap: () async {
// //                 final picked = await showDatePicker(
// //                   context: context,
// //                   initialDate: startDate ?? DateTime.now(),
// //                   firstDate: DateTime(2020),
// //                   lastDate: DateTime.now().add(const Duration(days: 365)),
// //                   locale: const Locale('pt', 'BR'),
// //                 );
// //                 if (picked != null) {
// //                   startDate = picked;
// //                   Navigator.of(context).pop();
// //                   _showCustomRangeDialog(context);
// //                 }
// //               },
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.calendar_today),
// //               title: const Text('Data final'),
// //               subtitle: Text(endDate != null 
// //                 ? DateFormat('dd/MM/yyyy').format(endDate!)
// //                 : 'Selecionar data'),
// //               onTap: () async {
// //                 final picked = await showDatePicker(
// //                   context: context,
// //                   initialDate: endDate ?? DateTime.now(),
// //                   firstDate: startDate ?? DateTime(2020),
// //                   lastDate: DateTime.now().add(const Duration(days: 365)),
// //                   locale: const Locale('pt', 'BR'),
// //                 );
// //                 if (picked != null) {
// //                   endDate = picked;
// //                   Navigator.of(context).pop();
// //                   _showCustomRangeDialog(context);
// //                 }
// //               },
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(),
// //             child: const Text('Cancelar'),
// //           ),
// //           ElevatedButton(
// //             onPressed: (startDate != null && endDate != null)
// //                 ? () {
// //                     // Aqui você implementaria a lógica para período customizado
// //                     Navigator.of(context).pop();
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                         content: Text('Período personalizado selecionado!'),
// //                       ),
// //                     );
// //                   }
// //                 : null,
// //             child: const Text('Aplicar'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = context.watch<ExpenseController>();
// //     final f = NumberFormat.simpleCurrency(locale: 'pt_BR');

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Comparativo ${DateFormat('MM/yyyy').format(_selectedMonth)}'),
// //         actions: [
// //           PopupMenuButton<String>(
// //             icon: const Icon(Icons.date_range),
// //             onSelected: (value) {
// //               switch (value) {
// //                 case 'current_month':
// //                   _changeMonth(DateTime.now());
// //                   break;
// //                 case 'previous_month':
// //                   final now = DateTime.now();
// //                   _changeMonth(DateTime(now.year, now.month - 1));
// //                   break;
// //                 case 'three_months_ago':
// //                   final now = DateTime.now();
// //                   _changeMonth(DateTime(now.year, now.month - 3));
// //                   break;
// //                 case 'custom':
// //                   _showCustomRangeDialog(context);
// //                   break;
// //               }
// //             },
// //             itemBuilder: (context) => [
// //               const PopupMenuItem(
// //                 value: 'current_month',
// //                 child: ListTile(
// //                   leading: Icon(Icons.today),
// //                   title: Text('Este mês'),
// //                 ),
// //               ),
// //               const PopupMenuItem(
// //                 value: 'previous_month',
// //                 child: ListTile(
// //                   leading: Icon(Icons.arrow_back),
// //                   title: Text('Mês anterior'),
// //                 ),
// //               ),
// //               const PopupMenuItem(
// //                 value: 'three_months_ago',
// //                 child: ListTile(
// //                   leading: Icon(Icons.history),
// //                   title: Text('Há 3 meses'),
// //                 ),
// //               ),
// //               const PopupMenuItem(
// //                 value: 'custom',
// //                 child: ListTile(
// //                   leading: Icon(Icons.date_range),
// //                   title: Text('Personalizado...'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //       body: FutureBuilder(
// //         future: controller.getTotalsByPerson(),
// //         builder: (context, AsyncSnapshot<List> snap) {
// //           if (!snap.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           final peopleTotals = snap.data!;
// //           if (peopleTotals.isEmpty) {
// //             return const Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.people_outline, size: 64, color: Colors.grey),
// //                   SizedBox(height: 16),
// //                   Text(
// //                     'Sem gastos neste período',
// //                     style: TextStyle(fontSize: 16, color: Colors.grey),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }
// //           return ListView(
// //             scrollDirection: Axis.horizontal,
// //             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
// //             children: peopleTotals.map((personTotal) {
// //               return _PersonSummaryCard(
// //                 personName: personTotal.personName,
// //                 total: personTotal.total,
// //                 getBreakdown: () => controller.getSubtotalsByCategory(personTotal.personId),
// //                 currencyFormatter: f,
// //                 onShowDetails: () => Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (_) => PersonExpensesScreen(
// //                       personId: personTotal.personId,
// //                       personName: personTotal.personName,
// //                       month: _selectedMonth,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             }).toList(),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // class _PersonSummaryCard extends StatelessWidget {
// //   final String personName;
// //   final double total;
// //   final Future<List> Function() getBreakdown;
// //   final NumberFormat currencyFormatter;
// //   final VoidCallback onShowDetails;

// //   const _PersonSummaryCard({
// //     required this.personName,
// //     required this.total,
// //     required this.getBreakdown,
// //     required this.currencyFormatter,
// //     required this.onShowDetails,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       margin: const EdgeInsets.symmetric(horizontal: 8),
// //       elevation: 4,
// //       child: Container(
// //         width: 240,
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.start,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               personName, 
// //               style: Theme.of(context).textTheme.titleLarge,
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               currencyFormatter.format(total),
// //               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.indigo,
// //                   ),
// //             ),
// //             const SizedBox(height: 12),
// //             FutureBuilder(
// //               future: getBreakdown(),
// //               builder: (context, AsyncSnapshot<List> snap) {
// //                 if (!snap.hasData) {
// //                   return const LinearProgressIndicator();
// //                 }
// //                 final breakdown = snap.data!;
                
// //                 if (breakdown.isEmpty) {
// //                   return const Padding(
// //                     padding: EdgeInsets.symmetric(vertical: 8),
// //                     child: Text(
// //                       'Sem gastos por categoria',
// //                       style: TextStyle(color: Colors.grey, fontSize: 12),
// //                     ),
// //                   );
// //                 }
                
// //                 return Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: breakdown.take(5).map<Widget>((cat) {
// //                     return Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 2),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Flexible(
// //                             child: Text(
// //                               cat.categoryName, 
// //                               overflow: TextOverflow.ellipsis,
// //                               style: const TextStyle(fontSize: 12),
// //                             ),
// //                           ),
// //                           Text(
// //                             currencyFormatter.format(cat.subtotal),
// //                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   }).toList(),
// //                 );
// //               },
// //             ),
// //             const Spacer(),
// //             SizedBox(
// //               width: double.infinity,
// //               child: OutlinedButton.icon(
// //                 icon: const Icon(Icons.list, size: 16),
// //                 label: const Text('Ver lançamentos'),
// //                 onPressed: onShowDetails,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Tela de detalhes dos lançamentos de uma pessoa no mês selecionado
// // class PersonExpensesScreen extends StatelessWidget {
// //   final int personId;
// //   final String personName;
// //   final DateTime month;

// //   const PersonExpensesScreen({
// //     Key? key,
// //     required this.personId,
// //     required this.personName,
// //     required this.month,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = context.read<ExpenseController>();
// //     final start = DateTime(month.year, month.month);
// //     final end = DateTime(month.year, month.month + 1);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Gastos de $personName - ${DateFormat('MM/yyyy').format(month)}'),
// //       ),
// //       body: FutureBuilder(
// //         future: (controller.repo == null)
// //             ? Future.value([])
// //             : controller.repo!.getExpensesByPerson(
// //                 personId: personId,
// //                 start: start,
// //                 end: end,
// //               ),
// //         builder: (context, AsyncSnapshot<List> snap) {
// //           if (!snap.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           final items = snap.data!;
// //           if (items.isEmpty) {
// //             return const Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.receipt_long, size: 64, color: Colors.grey),
// //                   SizedBox(height: 16),
// //                   Text(
// //                     'Sem lançamentos neste período',
// //                     style: TextStyle(fontSize: 16, color: Colors.grey),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }
          
// //           final total = items.fold(0.0, (sum, item) => sum + item.amount);
// //           final f = NumberFormat.simpleCurrency(locale: 'pt_BR');
          
// //           return Column(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(16),
// //                 color: Colors.grey[50],
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text(
// //                       'Total do período:',
// //                       style: TextStyle(fontWeight: FontWeight.bold),
// //                     ),
// //                     Text(
// //                       f.format(total),
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 16,
// //                         color: Colors.indigo,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: items.length,
// //                   itemBuilder: (_, i) {
// //                     final e = items[i];
// //                     return ListTile(
// //                       leading: const Icon(Icons.label),
// //                       title: Text(e.note?.isNotEmpty == true ? e.note! : 'Sem descrição'),
// //                       subtitle: Text(DateFormat('dd/MM/yyyy – HH:mm').format(e.date)),
// //                       trailing: Text(
// //                         f.format(e.amount),
// //                         style: const TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }



// import 'package:conta_facil/features/expenses/data/expense.dart';
// import 'package:conta_facil/features/expenses/data/expense_repository.dart';
// import 'package:conta_facil/features/expenses/logic/expense_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({Key? key}) : super(key: key);

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
//   DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
//   late TabController _tabController;
//   int _currentChartIndex = 0;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _refreshData();
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _refreshData() async {
//     setState(() => _isLoading = true);
//     await context.read<ExpenseController>().loadMonth(_selectedMonth);
//     setState(() => _isLoading = false);
//   }

//   void _changeMonth(DateTime newMonth) {
//     setState(() {
//       _selectedMonth = newMonth;
//     });
//     _refreshData();
//   }

//   void _showCustomRangeDialog(BuildContext context) {
//     DateTime? startDate = _selectedMonth;
//     DateTime? endDate = DateTime(_selectedMonth.year, _selectedMonth.month + 1);

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           title: const Text('Período Personalizado'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _DatePickerCard(
//                 title: 'Data inicial',
//                 date: startDate,
//                 onDateSelected: (date) {
//                   setDialogState(() => startDate = date);
//                 },
//               ),
//               const SizedBox(height: 16),
//               _DatePickerCard(
//                 title: 'Data final',
//                 date: endDate,
//                 onDateSelected: (date) {
//                   setDialogState(() => endDate = date);
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancelar'),
//             ),
//             ElevatedButton(
//               onPressed: (startDate != null && endDate != null)
//                   ? () {
//                       Navigator.of(context).pop();
//                       // Implementar lógica de período customizado
//                     }
//                   : null,
//               child: const Text('Aplicar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMonthSelector() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surfaceVariant,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.chevron_left),
//             onPressed: () {
//               final previousMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
//               _changeMonth(previousMonth);
//             },
//           ),
//           Expanded(
//             child: Text(
//               DateFormat('MMMM yyyy', 'pt_BR').format(_selectedMonth),
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.chevron_right),
//             onPressed: () {
//               final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
//               if (nextMonth.isBefore(DateTime.now().add(const Duration(days: 365)))) {
//                 _changeMonth(nextMonth);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<ExpenseController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Relatórios',
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _isLoading ? null : _refreshData,
//             tooltip: 'Atualizar',
//           ),
//           _PeriodMenu(
//             onMonthSelected: _changeMonth,
//             onCustomRangeSelected: () => _showCustomRangeDialog(context),
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(icon: Icon(Icons.bar_chart), text: 'Visão Geral'),
//             Tab(icon: Icon(Icons.pie_chart), text: 'Categorias'),
//             Tab(icon: Icon(Icons.people), text: 'Pessoas'),
//           ],
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: Column(
//           children: [
//             _buildMonthSelector(),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _OverviewTab(selectedMonth: _selectedMonth, isLoading: _isLoading),
//                   _CategoriesTab(selectedMonth: _selectedMonth, isLoading: _isLoading),
//                   _PeopleTab(selectedMonth: _selectedMonth, isLoading: _isLoading),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PeriodMenu extends StatelessWidget {
//   final Function(DateTime) onMonthSelected;
//   final VoidCallback onCustomRangeSelected;

//   const _PeriodMenu({
//     required this.onMonthSelected,
//     required this.onCustomRangeSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String>(
//       icon: const Icon(Icons.date_range),
//       onSelected: (value) {
//         final now = DateTime.now();
//         switch (value) {
//           case 'current_month':
//             onMonthSelected(DateTime(now.year, now.month));
//             break;
//           case 'previous_month':
//             onMonthSelected(DateTime(now.year, now.month - 1));
//             break;
//           case 'three_months_ago':
//             onMonthSelected(DateTime(now.year, now.month - 3));
//             break;
//           case 'custom':
//             onCustomRangeSelected();
//             break;
//         }
//       },
//       itemBuilder: (context) => [
//         const PopupMenuItem(
//           value: 'current_month',
//           child: ListTile(
//             leading: Icon(Icons.today, color: Colors.blue),
//             title: Text('Este mês'),
//           ),
//         ),
//         const PopupMenuItem(
//           value: 'previous_month',
//           child: ListTile(
//             leading: Icon(Icons.arrow_back, color: Colors.orange),
//             title: Text('Mês anterior'),
//           ),
//         ),
//         const PopupMenuItem(
//           value: 'three_months_ago',
//           child: ListTile(
//             leading: Icon(Icons.history, color: Colors.purple),
//             title: Text('Há 3 meses'),
//           ),
//         ),
//         const PopupMenuItem(
//           value: 'custom',
//           child: ListTile(
//             leading: Icon(Icons.date_range, color: Colors.green),
//             title: Text('Personalizado...'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _DatePickerCard extends StatelessWidget {
//   final String title;
//   final DateTime? date;
//   final Function(DateTime) onDateSelected;

//   const _DatePickerCard({
//     required this.title,
//     required this.date,
//     required this.onDateSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: ListTile(
//         leading: const Icon(Icons.calendar_today),
//         title: Text(title),
//         subtitle: Text(
//           date != null ? DateFormat('dd/MM/yyyy').format(date!) : 'Selecionar data',
//         ),
//         trailing: const Icon(Icons.arrow_drop_down),
//         onTap: () async {
//           final picked = await showDatePicker(
//             context: context,
//             initialDate: date ?? DateTime.now(),
//             firstDate: DateTime(2020),
//             lastDate: DateTime.now().add(const Duration(days: 365)),
//             locale: const Locale('pt', 'BR'),
//           );
//           if (picked != null) {
//             onDateSelected(picked);
//           }
//         },
//       ),
//     );
//   }
// }

// class _OverviewTab extends StatelessWidget {
//   final DateTime selectedMonth;
//   final bool isLoading;

//   const _OverviewTab({
//     required this.selectedMonth,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<ExpenseController>();
//     final f = NumberFormat.simpleCurrency(locale: 'pt_BR');

//     return FutureBuilder<List<PersonTotal>>(
//       future: controller.getTotalsByPerson(),
//       builder: (context, AsyncSnapshot<List<PersonTotal>> snap) {
//         if (isLoading || !snap.hasData) {
//           return _ShimmerOverview();
//         }

//         final peopleTotals = snap.data!;
//         if (peopleTotals.isEmpty) {
//           return _EmptyState(
//             icon: Icons.analytics_outlined,
//             message: 'Sem dados para exibir\nneste período',
//           );
//         }

//         final total = peopleTotals.fold<double>(0.0, (sum, item) => sum + item.total);

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _TotalSummaryCard(total: total, currencyFormatter: f),
//               const SizedBox(height: 20),
//               _ExpenseChart(peopleTotals: peopleTotals),
//               const SizedBox(height: 20),
//               _QuickStatsGrid(peopleTotals: peopleTotals, currencyFormatter: f),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _CategoriesTab extends StatelessWidget {
//   final DateTime selectedMonth;
//   final bool isLoading;

//   const _CategoriesTab({
//     required this.selectedMonth,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<ExpenseController>();

//     return FutureBuilder<List<PersonTotal>>(
//       future: controller.getTotalsByPerson(),
//       builder: (context, AsyncSnapshot<List<PersonTotal>> snap) {
//         if (isLoading || !snap.hasData) {
//           return _ShimmerCategories();
//         }

//         final peopleTotals = snap.data!;
//         if (peopleTotals.isEmpty) {
//           return _EmptyState(
//             icon: Icons.category_outlined,
//             message: 'Sem categorias para exibir',
//           );
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: peopleTotals.length,
//           itemBuilder: (context, index) {
//             final person = peopleTotals[index];
//             return _PersonCategoryCard(
//               personId: person.personId,
//               personName: person.personName,
//               total: person.total,
//               selectedMonth: selectedMonth,
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class _PeopleTab extends StatelessWidget {
//   final DateTime selectedMonth;
//   final bool isLoading;

//   const _PeopleTab({
//     required this.selectedMonth,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<ExpenseController>();
//     final f = NumberFormat.simpleCurrency(locale: 'pt_BR');

//     return FutureBuilder<List<PersonTotal>>(
//       future: controller.getTotalsByPerson(),
//       builder: (context, AsyncSnapshot<List<PersonTotal>> snap) {
//         if (isLoading || !snap.hasData) {
//           return _ShimmerPeople();
//         }

//         final peopleTotals = snap.data!;
//         if (peopleTotals.isEmpty) {
//           return _EmptyState(
//             icon: Icons.people_outline,
//             message: 'Sem gastos por pessoa\nneste período',
//           );
//         }

//         final total = peopleTotals.fold<double>(0.0, (sum, item) => sum + item.total);

//         return CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: _TotalSummaryCard(total: total, currencyFormatter: f),
//               ),
//             ),
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   final person = peopleTotals[index];
//                   final percentage = (person.total / total * 100);
                  
//                   return _PersonSummaryCard(
//                     personName: person.personName,
//                     total: person.total,
//                     percentage: percentage,
//                     currencyFormatter: f,
//                     getBreakdown: () => controller.getSubtotalsByCategory(person.personId),
//                     onShowDetails: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => PersonExpensesScreen(
//                           personId: person.personId,
//                           personName: person.personName,
//                           month: selectedMonth,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 childCount: peopleTotals.length,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _TotalSummaryCard extends StatelessWidget {
//   final double total;
//   final NumberFormat currencyFormatter;

//   const _TotalSummaryCard({
//     required this.total,
//     required this.currencyFormatter,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Theme.of(context).colorScheme.primary,
//               Theme.of(context).colorScheme.primaryContainer,
//             ],
//           ),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           children: [
//             Text(
//               'Total do Período',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: Theme.of(context).colorScheme.onPrimary,
//                   ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               currencyFormatter.format(total),
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     color: Theme.of(context).colorScheme.onPrimary,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ExpenseChart extends StatelessWidget {
//   final List<PersonTotal> peopleTotals;

//   const _ExpenseChart({required this.peopleTotals});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Distribuição por Pessoa',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sections: _buildChartSections(peopleTotals, context),
//                   centerSpaceRadius: 40,
//                   sectionsSpace: 4,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<PieChartSectionData> _buildChartSections(List<PersonTotal> peopleTotals, BuildContext context) {
//     final total = peopleTotals.fold<double>(0.0, (sum, item) => sum + item.total);
//     final colors = [
//       Colors.blue,
//       Colors.green,
//       Colors.orange,
//       Colors.purple,
//       Colors.red,
//       Colors.teal,
//     ];

//     return peopleTotals.asMap().entries.map((entry) {
//       final index = entry.key;
//       final person = entry.value;
//       final percentage = (person.total / total * 100);

//       return PieChartSectionData(
//         color: colors[index % colors.length],
//         value: person.total,
//         title: '${percentage.toStringAsFixed(1)}%',
//         radius: 24,
//         titleStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       );
//     }).toList();
//   }
// }

// class _QuickStatsGrid extends StatelessWidget {
//   final List<PersonTotal> peopleTotals;
//   final NumberFormat currencyFormatter;

//   const _QuickStatsGrid({
//     required this.peopleTotals,
//     required this.currencyFormatter,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (peopleTotals.isEmpty) return const SizedBox();

//     // CORREÇÃO: 
//     // inicio techo corrigido
// final sorted = List<PersonTotal>.from(peopleTotals)
//   ..sort((a, b) => b.total.compareTo(a.total));

// final highestSpender = sorted.first;
// final lowestSpender = sorted.last;

// //fim  techo corrigido

//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       crossAxisSpacing: 12,
//       mainAxisSpacing: 12,
//       children: [
//         _StatCard(
//           title: 'Maior Gastador',
//           value: highestSpender.personName,
//           subtitle: currencyFormatter.format(highestSpender.total),
//           icon: Icons.arrow_upward,
//           color: Colors.red,
//         ),
//         _StatCard(
//           title: 'Menor Gastador',
//           value: lowestSpender.personName,
//           subtitle: currencyFormatter.format(lowestSpender.total),
//           icon: Icons.arrow_downward,
//           color: Colors.green,
//         ),
//         _StatCard(
//           title: 'Total de Pessoas',
//           value: peopleTotals.length.toString(),
//           subtitle: 'envolvidas',
//           icon: Icons.people,
//           color: Colors.blue,
//         ),
//         _StatCard(
//           title: 'Média por Pessoa',
//           value: currencyFormatter.format(
//             peopleTotals.fold(0.0, (double sum, PersonTotal item) => sum + item.total) / peopleTotals.length,
//           ),
//           subtitle: 'valor médio',
//           icon: Icons.equalizer,
//           color: Colors.orange,
//         ),
//       ],
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final String subtitle;
//   final IconData icon;
//   final Color color;

//   const _StatCard({
//     required this.title,
//     required this.value,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               subtitle,
//               style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                     color: Colors.grey[600],
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PersonCategoryCard extends StatelessWidget {
//   final int personId;
//   final String personName;
//   final double total;
//   final DateTime selectedMonth;

//   const _PersonCategoryCard({
//     required this.personId,
//     required this.personName,
//     required this.total,
//     required this.selectedMonth,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<ExpenseController>();
//     final f = NumberFormat.simpleCurrency(locale: 'pt_BR');

//     return FutureBuilder<List<CategorySubtotal>>(
//       future: controller.getSubtotalsByCategory(personId),
//       builder: (context, AsyncSnapshot<List<CategorySubtotal>> snap) {
//         if (!snap.hasData) {
//           return _ShimmerCategoryItem();
//         }

//         final categories = snap.data!;
//         if (categories.isEmpty) {
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey[200],
//                 child: const Icon(Icons.person, color: Colors.grey),
//               ),
//               title: Text(personName),
//               subtitle: const Text('Sem gastos por categoria'),
//               trailing: Text(
//                 f.format(total),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           );
//         }

//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           child: ExpansionTile(
//             leading: CircleAvatar(
//               backgroundColor: Theme.of(context).colorScheme.primary,
//               child: Text(
//                 personName.substring(0, 1).toUpperCase(),
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             title: Text(
//               personName,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//             subtitle: Text('${categories.length} categorias'),
//             trailing: Text(
//               f.format(total),
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             children: categories.map((category) => ListTile(
//               leading: Container(
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               title: Text(category.categoryName),
//               trailing: Text(f.format(category.subtotal)),
//             )).toList(),
//           ),
//         );
//       },
//     );
//   }
// }

// class _PersonSummaryCard extends StatelessWidget {
//   final String personName;
//   final double total;
//   final double percentage;
//   final Future<List<CategorySubtotal>> Function() getBreakdown;
//   final NumberFormat currencyFormatter;
//   final VoidCallback onShowDetails;

//   const _PersonSummaryCard({
//     required this.personName,
//     required this.total,
//     required this.percentage,
//     required this.getBreakdown,
//     required this.currencyFormatter,
//     required this.onShowDetails,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   child: Text(
//                     personName.substring(0, 1).toUpperCase(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         personName,
//                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                       ),
//                       Text(
//                         '${percentage.toStringAsFixed(1)}% do total',
//                         style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                               color: Colors.grey[600],
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   currencyFormatter.format(total),
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             FutureBuilder<List<CategorySubtotal>>(
//               future: getBreakdown(),
//               builder: (context, AsyncSnapshot<List<CategorySubtotal>> snap) {
//                 if (!snap.hasData) {
//                   return const LinearProgressIndicator();
//                 }
//                 final breakdown = snap.data!;
                
//                 if (breakdown.isEmpty) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 8),
//                     child: Text(
//                       'Sem gastos por categoria',
//                       style: TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//                   );
//                 }
                
//                 return Column(
//                   children: breakdown.take(3).map((cat) => Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             cat.categoryName,
//                             style: const TextStyle(fontSize: 12),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Text(
//                           currencyFormatter.format(cat.subtotal),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )).toList(),
//                 );
//               },
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 icon: const Icon(Icons.list, size: 16),
//                 label: const Text('Ver Detalhes'),
//                 onPressed: onShowDetails,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Custom Shimmer Loading Widgets
// class _ShimmerOverview extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _ShimmerCard(height: 120, borderRadius: 16),
//           const SizedBox(height: 20),
//           _ShimmerCard(height: 200, borderRadius: 12),
//           const SizedBox(height: 20),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             children: List.generate(4, (index) => 
//               _ShimmerCard(height: 80, borderRadius: 12)
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ShimmerCategories extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: 5,
//       itemBuilder: (context, index) => 
//         _ShimmerCard(height: 80, borderRadius: 12, margin: const EdgeInsets.symmetric(vertical: 4)),
//     );
//   }
// }

// class _ShimmerPeople extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: 5,
//       itemBuilder: (context, index) => 
//         _ShimmerCard(height: 120, borderRadius: 12, margin: const EdgeInsets.symmetric(vertical: 4)),
//     );
//   }
// }

// class _ShimmerCategoryItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return _ShimmerCard(height: 80, borderRadius: 12, margin: const EdgeInsets.symmetric(vertical: 4));
//   }
// }

// class _ShimmerCard extends StatefulWidget {
//   final double height;
//   final double borderRadius;
//   final EdgeInsets? margin;

//   const _ShimmerCard({
//     required this.height,
//     required this.borderRadius,
//     this.margin,
//   });

//   @override
//   State<_ShimmerCard> createState() => _ShimmerCardState();
// }

// class _ShimmerCardState extends State<_ShimmerCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Color?> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat(reverse: true);
    
//     _animation = ColorTween(
//       begin: Colors.grey[300],
//       end: Colors.grey[100],
//     ).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Container(
//           height: widget.height,
//           margin: widget.margin,
//           decoration: BoxDecoration(
//             color: _animation.value,
//             borderRadius: BorderRadius.circular(widget.borderRadius),
//           ),
//         );
//       },
//     );
//   }
// }

// class _EmptyState extends StatelessWidget {
//   final IconData icon;
//   final String message;

//   const _EmptyState({
//     required this.icon,
//     required this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 80, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Tela de detalhes dos lançamentos (mantida com melhorias)
// class PersonExpensesScreen extends StatelessWidget {
//   final int personId;
//   final String personName;
//   final DateTime month;

//   const PersonExpensesScreen({
//     Key? key,
//     required this.personId,
//     required this.personName,
//     required this.month,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.read<ExpenseController>();
//     final start = DateTime(month.year, month.month);
//     final end = DateTime(month.year, month.month + 1);

//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(personName),
//             Text(
//               DateFormat('MMMM yyyy', 'pt_BR').format(month),
//               style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//                   ),
//             ),
//           ],
//         ),
//       ),
//       body: FutureBuilder<List<Expense>>(
//         future: (controller.repo == null)
//             ? Future.value([])
//             : controller.repo!.getExpensesByPerson(
//                 personId: personId,
//                 start: start,
//                 end: end,
//               ),
//         builder: (context, AsyncSnapshot<List<Expense>> snap) {
//           if (!snap.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final items = snap.data!;
//           if (items.isEmpty) {
//             return _EmptyState(
//               icon: Icons.receipt_long,
//               message: 'Sem lançamentos\nneste período',
//             );
//           }
          
//           final total = items.fold(0.0, (sum, item) => sum + item.amount);
//           final f = NumberFormat.simpleCurrency(locale: 'pt_BR');
          
//           return Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 margin: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Theme.of(context).colorScheme.primary,
//                       Theme.of(context).colorScheme.primaryContainer,
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total',
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                         ),
//                         Text(
//                           '${items.length} lançamentos',
//                           style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                                 color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
//                               ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       f.format(total),
//                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                             color: Theme.of(context).colorScheme.onPrimary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (_, i) {
//                     final e = items[i];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                       child: ListTile(
//                         leading: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.money_off,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                         ),
//                         title: Text(
//                           e.note?.isNotEmpty == true ? e.note! : 'Sem descrição',
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                         subtitle: Text(
//                           DateFormat('dd/MM/yyyy – HH:mm').format(e.date),
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               f.format(e.amount),
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               DateFormat('dd MMM', 'pt_BR').format(e.date),
//                               style: TextStyle(
//                                 color: Colors.grey[500],
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:conta_facil/features/expenses/data/expense.dart';
import 'package:conta_facil/features/expenses/data/expense_repository.dart';
import 'package:conta_facil/features/expenses/logic/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  bool _isCustomRange = false;
  late TabController _tabController;
  int _currentChartIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    if (_isCustomRange && _customStartDate != null && _customEndDate != null) {
      await context.read<ExpenseController>().loadCustomRange(_customStartDate!, _customEndDate!);
    } else {
      await context.read<ExpenseController>().loadMonth(_selectedMonth);
    }
    setState(() => _isLoading = false);
  }

  void _changeMonth(DateTime newMonth) {
    setState(() {
      _selectedMonth = newMonth;
      _isCustomRange = false;
      _customStartDate = null;
      _customEndDate = null;
    });
    _refreshData();
  }

  void _showCustomRangeDialog(BuildContext context) {
    DateTime? startDate = _customStartDate ?? _selectedMonth;
    DateTime? endDate = _customEndDate ?? DateTime(_selectedMonth.year, _selectedMonth.month + 1);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.date_range, color: Colors.blue),
              SizedBox(width: 8),
              Text('Período Personalizado'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DatePickerCard(
                title: 'Data inicial',
                date: startDate,
                onDateSelected: (date) {
                  setDialogState(() => startDate = date);
                },
              ),
              const SizedBox(height: 16),
              _DatePickerCard(
                title: 'Data final',
                date: endDate,
                onDateSelected: (date) {
                  setDialogState(() => endDate = date);
                },
              ),
              if (startDate != null && endDate != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Período: ${DateFormat('dd/MM/yy').format(startDate!)} - ${DateFormat('dd/MM/yy').format(endDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: (startDate != null && endDate != null && endDate!.isAfter(startDate!))
                  ? () {
                      _applyCustomRange(startDate!, endDate!);
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aplicar Período'),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCustomRange(DateTime startDate, DateTime endDate) {
    setState(() {
      _customStartDate = startDate;
      _customEndDate = endDate;
      _isCustomRange = true;
    });
    _refreshData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Período personalizado aplicado: ${DateFormat('dd/MM/yy').format(startDate)} - ${DateFormat('dd/MM/yy').format(endDate)}',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _clearCustomRange() {
    setState(() {
      _isCustomRange = false;
      _customStartDate = null;
      _customEndDate = null;
      _selectedMonth = DateTime.now();
    });
    _refreshData();
  }

  Widget _buildMonthSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final previousMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
              _changeMonth(previousMonth);
            },
          ),
          Expanded(
            child: _isCustomRange && _customStartDate != null && _customEndDate != null
                ? Text(
                    '${DateFormat('dd/MM/yy').format(_customStartDate!)} - ${DateFormat('dd/MM/yy').format(_customEndDate!)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  )
                : Text(
                    DateFormat('MMMM yyyy', 'pt_BR').format(_selectedMonth),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              if (_isCustomRange) {
                _clearCustomRange();
              } else {
                final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                if (nextMonth.isBefore(DateTime.now().add(const Duration(days: 365)))) {
                  _changeMonth(nextMonth);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relatórios',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          if (_isCustomRange)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearCustomRange,
              tooltip: 'Voltar ao mês atual',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshData,
            tooltip: 'Atualizar',
          ),
          _PeriodMenu(
            onMonthSelected: _changeMonth,
            onCustomRangeSelected: () => _showCustomRangeDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.bar_chart), text: 'Visão Geral'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Categorias'),
            Tab(icon: Icon(Icons.people), text: 'Pessoas'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            _buildMonthSelector(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(
                    selectedMonth: _selectedMonth,
                    isLoading: _isLoading,
                    customStartDate: _customStartDate,
                    customEndDate: _customEndDate,
                    isCustomRange: _isCustomRange,
                  ),
                  _CategoriesTab(
                    selectedMonth: _selectedMonth,
                    isLoading: _isLoading,
                    customStartDate: _customStartDate,
                    customEndDate: _customEndDate,
                    isCustomRange: _isCustomRange,
                  ),
                  _PeopleTab(
                    selectedMonth: _selectedMonth,
                    isLoading: _isLoading,
                    customStartDate: _customStartDate,
                    customEndDate: _customEndDate,
                    isCustomRange: _isCustomRange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodMenu extends StatelessWidget {
  final Function(DateTime) onMonthSelected;
  final VoidCallback onCustomRangeSelected;

  const _PeriodMenu({
    required this.onMonthSelected,
    required this.onCustomRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.date_range),
      onSelected: (value) {
        final now = DateTime.now();
        switch (value) {
          case 'current_month':
            onMonthSelected(DateTime(now.year, now.month));
            break;
          case 'previous_month':
            onMonthSelected(DateTime(now.year, now.month - 1));
            break;
          case 'three_months_ago':
            onMonthSelected(DateTime(now.year, now.month - 3));
            break;
          case 'custom':
            onCustomRangeSelected();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'current_month',
          child: ListTile(
            leading: Icon(Icons.today, color: Colors.blue),
            title: Text('Este mês'),
          ),
        ),
        const PopupMenuItem(
          value: 'previous_month',
          child: ListTile(
            leading: Icon(Icons.arrow_back, color: Colors.orange),
            title: Text('Mês anterior'),
          ),
        ),
        const PopupMenuItem(
          value: 'three_months_ago',
          child: ListTile(
            leading: Icon(Icons.history, color: Colors.purple),
            title: Text('Há 3 meses'),
          ),
        ),
        const PopupMenuItem(
          value: 'custom',
          child: ListTile(
            leading: Icon(Icons.date_range, color: Colors.green),
            title: Text('Personalizado...'),
          ),
        ),
      ],
    );
  }
}

class _DatePickerCard extends StatelessWidget {
  final String title;
  final DateTime? date;
  final Function(DateTime) onDateSelected;

  const _DatePickerCard({
    required this.title,
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(title),
        subtitle: Text(
          date != null ? DateFormat('dd/MM/yyyy').format(date!) : 'Selecionar data',
        ),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            locale: const Locale('pt', 'BR'),
          );
          if (picked != null) {
            onDateSelected(picked);
          }
        },
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final DateTime selectedMonth;
  final bool isLoading;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final bool isCustomRange;

  const _OverviewTab({
    required this.selectedMonth,
    required this.isLoading,
    required this.customStartDate,
    required this.customEndDate,
    required this.isCustomRange,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();
    final f = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return FutureBuilder<List<PersonTotal>>(
      future: isCustomRange && customStartDate != null && customEndDate != null
          ? controller.getTotalsByPerson(customStart: customStartDate, customEnd: customEndDate)
          : controller.getTotalsByPerson(),
      builder: (context, AsyncSnapshot<List<PersonTotal>> snap) {
        if (isLoading || !snap.hasData) {
          return _ShimmerOverview();
        }

        final peopleTotals = snap.data!;
        if (peopleTotals.isEmpty) {
          return _EmptyState(
            icon: Icons.analytics_outlined,
            message: 'Sem dados para exibir\nneste período',
          );
        }

        final total = peopleTotals.fold<double>(0.0, (sum, item) => sum + item.total);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _TotalSummaryCard(total: total, currencyFormatter: f),
              const SizedBox(height: 20),
              _ExpenseChart(peopleTotals: peopleTotals),
              const SizedBox(height: 20),
              _QuickStatsGrid(peopleTotals: peopleTotals, currencyFormatter: f),
            ],
          ),
        );
      },
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  final DateTime selectedMonth;
  final bool isLoading;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final bool isCustomRange;

  const _CategoriesTab({
    required this.selectedMonth,
    required this.isLoading,
    required this.customStartDate,
    required this.customEndDate,
    required this.isCustomRange,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    return FutureBuilder<List<PersonTotal>>(
      future: isCustomRange && customStartDate != null && customEndDate != null
          ? controller.getTotalsByPerson(customStart: customStartDate, customEnd: customEndDate)
          : controller.getTotalsByPerson(),
      builder: (context, AsyncSnapshot<List<PersonTotal>> snap) {
        if (isLoading || !snap.hasData) {
          return _ShimmerCategories();
        }

        final peopleTotals = snap.data!;
        if (peopleTotals.isEmpty) {
          return _EmptyState(
            icon: Icons.category_outlined,
            message: 'Sem categorias para exibir',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: peopleTotals.length,
          itemBuilder: (context, index) {
            final person = peopleTotals[index];
            return _PersonCategoryCard(
              personId: person.personId,
              personName: person.personName,
              total: person.total,
              selectedMonth: selectedMonth,
              customStartDate: customStartDate,
              customEndDate: customEndDate,
              isCustomRange: isCustomRange,
            );
          },
        );
      },
    );
  }
}

class _PeopleTab extends StatelessWidget {
  final DateTime selectedMonth;
  final bool isLoading;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final bool isCustomRange;

  const _PeopleTab({
    required this.selectedMonth,
    required this.isLoading,
    required this.customStartDate,
    required this.customEndDate,
    required this.isCustomRange,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();
    final f = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return FutureBuilder<List<PersonTotal>>(
      future: isCustomRange && customStartDate != null && customEndDate != null
          ? controller.getTotalsByPerson(customStart: customStartDate, customEnd: customEndDate)
          : controller.getTotalsByPerson(),
      builder: (context, AsyncSnapshot<List<PersonTotal>> snap) {
        if (isLoading || !snap.hasData) {
          return _ShimmerPeople();
        }

        final peopleTotals = snap.data!;
        if (peopleTotals.isEmpty) {
          return _EmptyState(
            icon: Icons.people_outline,
            message: 'Sem gastos por pessoa\nneste período',
          );
        }

        final total = peopleTotals.fold<double>(0.0, (sum, item) => sum + item.total);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _TotalSummaryCard(total: total, currencyFormatter: f),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final person = peopleTotals[index];
                  final percentage = (person.total / total * 100);
                  
                  return _PersonSummaryCard(
                    personName: person.personName,
                    total: person.total,
                    percentage: percentage,
                    currencyFormatter: f,
                    getBreakdown: () => controller.getSubtotalsByCategory(
                      person.personId,
                      customStart: customStartDate,
                      customEnd: customEndDate,
                    ),
                    onShowDetails: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonExpensesScreen(
                          personId: person.personId,
                          personName: person.personName,
                          month: selectedMonth,
                          customStartDate: customStartDate,
                          customEndDate: customEndDate,
                          isCustomRange: isCustomRange,
                        ),
                      ),
                    ),
                  );
                },
                childCount: peopleTotals.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TotalSummaryCard extends StatelessWidget {
  final double total;
  final NumberFormat currencyFormatter;

  const _TotalSummaryCard({
    required this.total,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              'Total do Período',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormatter.format(total),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseChart extends StatelessWidget {
  final List<PersonTotal> peopleTotals;

  const _ExpenseChart({required this.peopleTotals});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição por Pessoa',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildChartSections(peopleTotals, context),
                  centerSpaceRadius: 40,
                  sectionsSpace: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(List<PersonTotal> peopleTotals, BuildContext context) {
    final total = peopleTotals.fold<double>(0.0, (sum, item) => sum + item.total);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    return peopleTotals.asMap().entries.map((entry) {
      final index = entry.key;
      final person = entry.value;
      final percentage = (person.total / total * 100);

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: person.total,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 24,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

class _QuickStatsGrid extends StatelessWidget {
  final List<PersonTotal> peopleTotals;
  final NumberFormat currencyFormatter;

  const _QuickStatsGrid({
    required this.peopleTotals,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    if (peopleTotals.isEmpty) return const SizedBox();

    final sorted = List<PersonTotal>.from(peopleTotals)
      ..sort((a, b) => b.total.compareTo(a.total));

    final highestSpender = sorted.first;
    final lowestSpender = sorted.last;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatCard(
          title: 'Maior Gastador',
          value: highestSpender.personName,
          subtitle: currencyFormatter.format(highestSpender.total),
          icon: Icons.arrow_upward,
          color: Colors.red,
        ),
        _StatCard(
          title: 'Menor Gastador',
          value: lowestSpender.personName,
          subtitle: currencyFormatter.format(lowestSpender.total),
          icon: Icons.arrow_downward,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Total de Pessoas',
          value: peopleTotals.length.toString(),
          subtitle: 'envolvidas',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Média por Pessoa',
          value: currencyFormatter.format(
            peopleTotals.fold(0.0, (double sum, PersonTotal item) => sum + item.total) / peopleTotals.length,
          ),
          subtitle: 'valor médio',
          icon: Icons.equalizer,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonCategoryCard extends StatelessWidget {
  final int personId;
  final String personName;
  final double total;
  final DateTime selectedMonth;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final bool isCustomRange;

  const _PersonCategoryCard({
    required this.personId,
    required this.personName,
    required this.total,
    required this.selectedMonth,
    required this.customStartDate,
    required this.customEndDate,
    required this.isCustomRange,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();
    final f = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return FutureBuilder<List<CategorySubtotal>>(
      future: controller.getSubtotalsByCategory(
        personId,
        customStart: customStartDate,
        customEnd: customEndDate,
      ),
      builder: (context, AsyncSnapshot<List<CategorySubtotal>> snap) {
        if (!snap.hasData) {
          return _ShimmerCategoryItem();
        }

        final categories = snap.data!;
        if (categories.isEmpty) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              title: Text(personName),
              subtitle: const Text('Sem gastos por categoria'),
              trailing: Text(
                f.format(total),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                personName.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              personName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${categories.length} categorias'),
            trailing: Text(
              f.format(total),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            children: categories.map((category) => ListTile(
              leading: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(category.categoryName),
              trailing: Text(f.format(category.subtotal)),
            )).toList(),
          ),
        );
      },
    );
  }
}

class _PersonSummaryCard extends StatelessWidget {
  final String personName;
  final double total;
  final double percentage;
  final Future<List<CategorySubtotal>> Function() getBreakdown;
  final NumberFormat currencyFormatter;
  final VoidCallback onShowDetails;

  const _PersonSummaryCard({
    required this.personName,
    required this.total,
    required this.percentage,
    required this.getBreakdown,
    required this.currencyFormatter,
    required this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    personName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        personName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}% do total',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  currencyFormatter.format(total),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<CategorySubtotal>>(
              future: getBreakdown(),
              builder: (context, AsyncSnapshot<List<CategorySubtotal>> snap) {
                if (!snap.hasData) {
                  return const LinearProgressIndicator();
                }
                final breakdown = snap.data!;
                
                if (breakdown.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Sem gastos por categoria',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                }
                
                return Column(
                  children: breakdown.take(3).map((cat) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            cat.categoryName,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(cat.subtotal),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.list, size: 16),
                label: const Text('Ver Detalhes'),
                onPressed: onShowDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Shimmer Loading Widgets
class _ShimmerOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ShimmerCard(height: 120, borderRadius: 16),
          const SizedBox(height: 20),
          _ShimmerCard(height: 200, borderRadius: 12),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: List.generate(4, (index) => 
              _ShimmerCard(height: 80, borderRadius: 12)
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => 
        _ShimmerCard(height: 80, borderRadius: 12, margin: const EdgeInsets.symmetric(vertical: 4)),
    );
  }
}

class _ShimmerPeople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => 
        _ShimmerCard(height: 120, borderRadius: 12, margin: const EdgeInsets.symmetric(vertical: 4)),
    );
  }
}

class _ShimmerCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ShimmerCard(height: 80, borderRadius: 12, margin: const EdgeInsets.symmetric(vertical: 4));
  }
}

class _ShimmerCard extends StatefulWidget {
  final double height;
  final double borderRadius;
  final EdgeInsets? margin;

  const _ShimmerCard({
    required this.height,
    required this.borderRadius,
    this.margin,
  });

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard> with SingleTickerProviderStateMixin {
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
        return Container(
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: _animation.value,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Tela de detalhes dos lançamentos (mantida com melhorias)
class PersonExpensesScreen extends StatelessWidget {
  final int personId;
  final String personName;
  final DateTime month;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final bool isCustomRange;

  const PersonExpensesScreen({
    Key? key,
    required this.personId,
    required this.personName,
    required this.month,
    required this.customStartDate,
    required this.customEndDate,
    required this.isCustomRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ExpenseController>();
    final start = isCustomRange && customStartDate != null ? customStartDate! : DateTime(month.year, month.month);
    final end = isCustomRange && customEndDate != null ? customEndDate! : DateTime(month.year, month.month + 1);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(personName),
            Text(
              isCustomRange && customStartDate != null && customEndDate != null
                  ? '${DateFormat('dd/MM/yy').format(customStartDate!)} - ${DateFormat('dd/MM/yy').format(customEndDate!)}'
                  : DateFormat('MMMM yyyy', 'pt_BR').format(month),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Expense>>(
        future: (controller.repo == null)
            ? Future.value([])
            : controller.repo!.getExpensesByPerson(
                personId: personId,
                start: start,
                end: end,
              ),
        builder: (context, AsyncSnapshot<List<Expense>> snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return _EmptyState(
              icon: Icons.receipt_long,
              message: 'Sem lançamentos\nneste período',
            );
          }
          
          final total = items.fold(0.0, (sum, item) => sum + item.amount);
          final f = NumberFormat.simpleCurrency(locale: 'pt_BR');
          
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        Text(
                          '${items.length} lançamentos',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                              ),
                        ),
                      ],
                    ),
                    Text(
                      f.format(total),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final e = items[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.money_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          e.note?.isNotEmpty == true ? e.note! : 'Sem descrição',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy – HH:mm').format(e.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              f.format(e.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM', 'pt_BR').format(e.date),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}