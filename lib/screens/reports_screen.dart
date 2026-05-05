import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';
import '../utils/formatters.dart';
import '../widgets/charts.dart';
import '../widgets/month_selector.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const MonthSelector(),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reporte mensual', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Ingreso: ${currencyFormat.format(provider.salary)}'),
                Text('Gastos: ${currencyFormat.format(provider.expenseTotal)}'),
                Text('Ahorros/Inversiones: ${currencyFormat.format(provider.savingsTotal)}'),
                Text('Disponible gastos: ${currencyFormat.format(provider.expenseRemaining)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Gastos por categoria', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ExpensePieChart(data: provider.categoryTotals),
        const SizedBox(height: 20),
        Text('Reporte diario', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        PeriodBarChart(data: provider.dailyTotals),
        const SizedBox(height: 20),
        Text('Reporte semanal', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        PeriodBarChart(data: provider.weeklyTotals),
        const SizedBox(height: 20),
        Text('Comparacion entre meses', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Row(
          children: [
            Icon(Icons.show_chart, color: Colors.red, size: 16),
            SizedBox(width: 4),
            Text('Gastos'),
            SizedBox(width: 16),
            Icon(Icons.show_chart, color: Colors.teal, size: 16),
            SizedBox(width: 4),
            Text('Ahorros'),
          ],
        ),
        const SizedBox(height: 8),
        MonthlyLineChart(data: provider.monthlyComparison),
      ],
    );
  }
}
