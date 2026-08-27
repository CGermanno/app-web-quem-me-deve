import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/expenses/logic/expense_controller.dart';
import 'features/expenses/data/expense_repository.dart';
import 'features/expenses/ui/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<ExpenseRepository?>(
          create: (_) async => await ExpenseRepository.create(),
          initialData: null,
        ),

        ChangeNotifierProxyProvider<ExpenseRepository?, ExpenseController>(
          create: (_) => ExpenseController.nullRepo(),
          update: (_, repo, controller) {
            if (repo == null) return controller!;
            
            // ✅ CORREÇÃO: Cria o controller e inicia a inicialização
            final newController = ExpenseController(repo);
            
            // Inicia o init() mas não espera - ele vai completar em background
            newController.init().catchError((error) {
              debugPrint('Erro na inicialização do controller: $error');
            });
            return newController;
          },
        ),
      ],
child: MaterialApp(
  title: 'Controle Simples de Gastos',
  theme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.green,
  ),

  // 👇 Adicione estas linhas:
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ],

  home: const HomeScreen(),
),

    );
  }
}