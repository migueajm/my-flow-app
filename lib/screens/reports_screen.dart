import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/finance_provider.dart';
import '../utils/formatters.dart';
import '../widgets/charts.dart';
import '../widgets/month_selector.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final l10n = AppLocalizations.of(context);
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
                Text(
                  l10n.t('monthlyReport'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.t('incomeLabel')}: ${currencyFormat.format(provider.salary)}',
                ),
                Text(
                  '${l10n.t('expenses')}: ${currencyFormat.format(provider.expenseTotal)}',
                ),
                Text(
                  '${l10n.t('savingsInvestments')}: ${currencyFormat.format(provider.savingsTotal)}',
                ),
                Text(
                  '${l10n.t('expenseAvailable')}: ${currencyFormat.format(provider.expenseRemaining)}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.t('categoryExpenses'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ExpensePieChart(data: provider.categoryTotals),
        const SizedBox(height: 20),
        Text(
          l10n.t('dailyReport'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        PeriodBarChart(data: provider.dailyTotals),
        const SizedBox(height: 20),
        Text(
          l10n.t('weeklyReport'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        PeriodBarChart(data: provider.weeklyTotals),
        const SizedBox(height: 20),
        Text(
          l10n.t('monthlyComparison'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.show_chart, color: Colors.red, size: 16),
            const SizedBox(width: 4),
            Text(l10n.t('expenses')),
            const SizedBox(width: 16),
            const Icon(Icons.show_chart, color: Colors.teal, size: 16),
            const SizedBox(width: 4),
            Text(l10n.t('savings')),
          ],
        ),
        const SizedBox(height: 8),
        MonthlyLineChart(data: provider.monthlyComparison),
      ],
    );
  }
}
