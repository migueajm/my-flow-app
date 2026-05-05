import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';
import 'dashboard_screen.dart';
import 'expenses_screen.dart';
import 'income_screen.dart';
import 'reports_screen.dart';
import 'savings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    ExpensesScreen(),
    IncomeScreen(),
    SavingsScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<FinanceProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos personales'),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(child: _screens[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Gastos'),
          NavigationDestination(icon: Icon(Icons.payments_outlined), label: 'Ingresos'),
          NavigationDestination(icon: Icon(Icons.savings_outlined), label: 'Ahorros'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), label: 'Reportes'),
        ],
      ),
    );
  }
}
