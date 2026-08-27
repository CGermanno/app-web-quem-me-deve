// import 'package:conta_facil/features/expenses/logic/expense_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class AddExpenseScreen extends StatefulWidget {
//   const AddExpenseScreen({Key? key}) : super(key: key);

//   @override
//   State<AddExpenseScreen> createState() => _AddExpenseScreenState();
// }

// class _AddExpenseScreenState extends State<AddExpenseScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _amountController = TextEditingController();
//   final _noteController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   int? _selectedPersonId;
//   int? _selectedCategoryId;

//   @override
//   void initState() {
//     super.initState();
//     // Definir defaults quando controller estiver pronto
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final controller = context.read<ExpenseController>();
//       setState(() {
//         _selectedPersonId = controller.people.isNotEmpty ? controller.people.first.id : 1; // "EU" como padrão
//         _selectedCategoryId = controller.categories.isNotEmpty ? controller.categories.first.id : null;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _noteController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveExpense() async {
//     if (!_formKey.currentState!.validate()) return;
//     final controller = context.read<ExpenseController>();

//     final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
//     if (amount == null || amount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Informe um valor válido!')),
//       );
//       return;
//     }
//     if (_selectedPersonId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Selecione uma pessoa!')),
//       );
//       return;
//     }

//     await controller.addExpense(
//       amount: amount,
//       date: _selectedDate,
//       note: _noteController.text,
//       personId: _selectedPersonId!,
//       categoryId: _selectedCategoryId,
//     );
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<ExpenseController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Adicionar Despesa'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Valor
//               TextFormField(
//                 controller: _amountController,
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 decoration: const InputDecoration(
//                   labelText: 'Valor (R\$)',
//                   prefixIcon: Icon(Icons.attach_money),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return 'Digite o valor';
//                   final v = double.tryParse(value.replaceAll(',', '.'));
//                   if (v == null || v <= 0) return 'Valor inválido';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Data
//               Row(
//                 children: [
//                   const Text('Data:'),
//                   const SizedBox(width: 12),
//                   TextButton.icon(
//                     icon: const Icon(Icons.calendar_today),
//                     label: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
//                     onPressed: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: _selectedDate,
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime.now().add(const Duration(days: 365)),
//                       );
//                       if (picked != null) {
//                         setState(() => _selectedDate = picked);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Pessoa
//               DropdownButtonFormField<int>(
//                 value: _selectedPersonId,
//                 items: controller.people
//                     .map((p) => DropdownMenuItem(
//                           value: p.id,
//                           child: Text(p.name),
//                         ))
//                     .toList(),
//                 decoration: const InputDecoration(
//                   labelText: 'Pessoa',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedPersonId = value;
//                   });
//                 },
//                 validator: (value) =>
//                     value == null ? 'Selecione uma pessoa' : null,
//               ),
//               const SizedBox(height: 16),

//               // Categoria
//               DropdownButtonFormField<int>(
//                 value: _selectedCategoryId,
//                 items: [
//                   const DropdownMenuItem<int>(
//                     value: null,
//                     child: Text('Sem categoria'),
//                   ),
//                   ...controller.categories.map(
//                     (c) => DropdownMenuItem(
//                       value: c.id,
//                       child: Text(c.name),
//                     ),
//                   ),
//                 ],
//                 decoration: const InputDecoration(
//                   labelText: 'Categoria',
//                   prefixIcon: Icon(Icons.category),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCategoryId = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Observação
//               TextFormField(
//                 controller: _noteController,
//                 decoration: const InputDecoration(
//                   labelText: 'Observação',
//                   prefixIcon: Icon(Icons.notes),
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 24),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   icon: const Icon(Icons.save),
//                   label: const Text('Salvar'),
//                   onPressed: _saveExpense,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:conta_facil/features/expenses/logic/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int? _selectedPersonId;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ExpenseController>();
      setState(() {
        _selectedPersonId = controller.people.isNotEmpty ? controller.people.first.id : 1;
        _selectedCategoryId = controller.categories.isNotEmpty ? controller.categories.first.id : null;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _showAddPersonDialog() async {
    final TextEditingController nameController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Pessoa'),
        content: TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            hintText: 'Ex: Silvana, Meu Filho, etc.',
          ),
          autofocus: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Digite um nome';
            if (value.length < 2) return 'Nome muito curto';
            return null;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                final controller = context.read<ExpenseController>();
                await controller.addPerson(nameController.text.trim());
                Navigator.of(context).pop();
                
                // Seleciona a nova pessoa automaticamente
                setState(() {
                  _selectedPersonId = controller.people.last.id;
                });
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = context.read<ExpenseController>();

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor válido!')),
      );
      return;
    }
    if (_selectedPersonId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma pessoa!')),
      );
      return;
    }

    await controller.addExpense(
      amount: amount,
      date: _selectedDate,
      note: _noteController.text,
      personId: _selectedPersonId!,
      categoryId: _selectedCategoryId,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ExpenseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Despesa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Valor
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite o valor';
                  final v = double.tryParse(value.replaceAll(',', '.'));
                  if (v == null || v <= 0) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Data
              Row(
                children: [
                  const Text('Data:'),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pessoa com botão para adicionar nova
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedPersonId,
                      items: [
                        ...controller.people.map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(p.name),
                          ),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Pessoa',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedPersonId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione uma pessoa' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.person_add, color: Colors.blue),
                    onPressed: _showAddPersonDialog,
                    tooltip: 'Adicionar nova pessoa',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('Sem categoria'),
                  ),
                  ...controller.categories.map(
                    (c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    ),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(Icons.category),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Observação
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Observação',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                  onPressed: _saveExpense,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}