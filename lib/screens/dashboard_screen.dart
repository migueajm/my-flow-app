import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';
import '../utils/category_icons.dart';
import '../utils/formatters.dart';
import '../widgets/charts.dart';
import '../widgets/empty_state.dart';
import '../widgets/month_selector.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const MonthSelector(),
        const SizedBox(height: 12),
        if (provider.income == null)
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Captura tu salario mensual para activar el presupuesto 80/20.'),
            ),
          ),
        if (provider.isNearExpenseLimit)
          Card(
            color: provider.isOverExpenseLimit
                ? Theme.of(context).colorScheme.errorContainer
                : const Color(0xFFFFF3CD),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                provider.isOverExpenseLimit
                    ? 'Has excedido el presupuesto de gastos del mes.'
                    : 'Estas cerca de exceder el presupuesto de gastos.',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: MediaQuery.sizeOf(context).width > 620 ? 4 : 2,
          childAspectRatio: 1.18,
          children: [
            SummaryCard(
              title: 'Ingreso',
              amount: provider.salary,
              icon: Icons.payments,
              color: Colors.teal,
            ),
            SummaryCard(
              title: '80% gastos',
              amount: provider.expenseBudget,
              icon: Icons.account_balance_wallet,
              color: Colors.indigo,
              subtitle: 'Queda ${currencyFormat.format(provider.expenseRemaining)}',
            ),
            SummaryCard(
              title: 'Gastado',
              amount: provider.expenseTotal,
              icon: Icons.shopping_cart,
              color: Colors.deepOrange,
            ),
            SummaryCard(
              title: '20% ahorro',
              amount: provider.savingsBudget,
              icon: Icons.trending_up,
              color: Colors.green,
              subtitle: 'Disponible ${currencyFormat.format(provider.savingsRemaining)}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Uso del presupuesto', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: provider.expenseUsagePercent,
          minHeight: 12,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 20),
        Text('Distribucion de gastos', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ExpensePieChart(data: provider.categoryTotals),
        const SizedBox(height: 20),
        Text('Ultimos gastos', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (provider.expenses.isEmpty)
          const EmptyState(
            icon: Icons.receipt_long,
            title: 'Aun no hay gastos',
            message: 'Los gastos del mes apareceran aqui.',
          )
        else
          ...provider.expenses.take(5).map((expense) {
            final category = provider.categoryById(expense.categoryId);
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(category?.color ?? 0xFF6C757D).withOpacity(.15),
                child: Icon(categoryIcon(category?.icon ?? 'more')),
              ),
              title: Text(expense.description.isEmpty ? category?.name ?? 'Gasto' : expense.description),
              subtitle: Text('${category?.name ?? 'Categoria'} · ${shortDateFormat.format(expense.date)}'),
              trailing: Text(currencyFormat.format(expense.amount)),
            );
          }),
      ],
    );
  }
}
