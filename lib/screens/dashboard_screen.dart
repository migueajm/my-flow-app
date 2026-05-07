import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const MonthSelector(),
        const SizedBox(height: 12),
        if (provider.income == null)
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.t('salaryPrompt')),
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
                    ? l10n.t('overLimit')
                    : l10n.t('nearLimit'),
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
              title: l10n.t('incomeLabel'),
              amount: provider.salary,
              icon: Icons.payments,
              color: Colors.teal,
            ),
            SummaryCard(
              title: l10n.t('expenseBudget'),
              amount: provider.expenseBudget,
              icon: Icons.account_balance_wallet,
              color: Colors.indigo,
              subtitle:
                  '${l10n.t('remaining')} ${currencyFormat.format(provider.expenseRemaining)}',
            ),
            SummaryCard(
              title: l10n.t('spent'),
              amount: provider.expenseTotal,
              icon: Icons.shopping_cart,
              color: Colors.deepOrange,
            ),
            SummaryCard(
              title: l10n.t('savingsBudget'),
              amount: provider.savingsBudget,
              icon: Icons.trending_up,
              color: Colors.green,
              subtitle:
                  '${l10n.t('available')} ${currencyFormat.format(provider.savingsRemaining)}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l10n.t('budgetUsage'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: provider.expenseUsagePercent,
          minHeight: 12,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.t('expenseDistribution'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ExpensePieChart(data: provider.categoryTotals),
        const SizedBox(height: 20),
        Text(
          l10n.t('latestExpenses'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (provider.expenses.isEmpty)
          EmptyState(
            icon: Icons.receipt_long,
            title: l10n.t('noExpensesTitle'),
            message: l10n.t('noExpensesMessage'),
          )
        else
          ...provider.expenses.take(5).map((expense) {
            final category = provider.categoryById(expense.categoryId);
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(
                  category?.color ?? 0xFF6C757D,
                ).withValues(alpha: .15),
                child: Icon(categoryIcon(category?.icon ?? 'more')),
              ),
              title: Text(
                expense.description.isEmpty
                    ? category?.name ?? l10n.t('expenses')
                    : expense.description,
              ),
              subtitle: Text(
                '${category?.name ?? l10n.t('category')} · ${shortDateFormat.format(expense.date)}',
              ),
              trailing: Text(currencyFormat.format(expense.amount)),
            );
          }),
      ],
    );
  }
}
