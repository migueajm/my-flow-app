import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../providers/finance_provider.dart';
import '../utils/category_icons.dart';
import '../utils/formatters.dart';
import '../widgets/month_selector.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  Category? _category;
  Expense? _editingExpense;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final l10n = AppLocalizations.of(context);
    _category ??=
        provider.categories.isNotEmpty ? provider.categories.first : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const MonthSelector(),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editingExpense == null
                        ? l10n.t('registerExpense')
                        : l10n.t('updateExpense'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.t('amount'),
                      prefixText: r'$ ',
                    ),
                    validator: (value) {
                      final amount = double.tryParse(
                        value?.replaceAll(',', '') ?? '',
                      );
                      if (amount == null || amount <= 0) {
                        return l10n.t('validAmount');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Category>(
                    initialValue: _category,
                    items: provider.categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Icon(categoryIcon(category.icon), size: 18),
                                const SizedBox(width: 8),
                                Text(l10n.t(category.name)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _category = value),
                    decoration: InputDecoration(labelText: l10n.t('category')),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.t('description'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        initialDate: _date,
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text(shortDateFormat.format(_date)),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate() ||
                          _category?.id == null) {
                        return;
                      }
                      final amount = double.parse(
                        _amountController.text.replaceAll(',', ''),
                      );
                      final finance = context.read<FinanceProvider>();
                      final wasEditing = _editingExpense != null;
                      if (_editingExpense == null) {
                        await finance.addExpense(
                          date: _date,
                          categoryId: _category!.id!,
                          amount: amount,
                          description: _descriptionController.text.trim(),
                        );
                      } else {
                        await finance.updateExpense(
                          id: _editingExpense!.id!,
                          date: _date,
                          categoryId: _category!.id!,
                          amount: amount,
                          description: _descriptionController.text.trim(),
                        );
                      }
                      _resetForm();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              wasEditing
                                  ? l10n.t('expenseUpdated')
                                  : l10n.t('expenseSaved'),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      _editingExpense == null ? Icons.add : Icons.save,
                    ),
                    label: Text(
                      _editingExpense == null
                          ? l10n.t('addExpense')
                          : l10n.t('updateExpense'),
                    ),
                  ),
                  if (_editingExpense != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.close),
                      label: Text(l10n.t('cancel')),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${l10n.t('available')}: ${currencyFormat.format(provider.expenseRemaining)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...provider.expenses.map((expense) {
          final category = provider.categoryById(expense.categoryId);
          return Dismissible(
            key: ValueKey('expense-${expense.id}'),
            background: _dismissBackground(
              context,
              l10n.t('edit'),
              Icons.edit,
              Alignment.centerLeft,
            ),
            secondaryBackground: _dismissBackground(
              context,
              l10n.t('delete'),
              Icons.delete,
              Alignment.centerRight,
              isDelete: true,
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                _startEditing(expense);
                return false;
              }
              return _confirmDelete(context, expense);
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
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
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _dismissBackground(
    BuildContext context,
    String label,
    IconData icon,
    Alignment alignment, {
    bool isDelete = false,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: isDelete
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: alignment == Alignment.centerLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _startEditing(Expense expense) {
    final provider = context.read<FinanceProvider>();
    setState(() {
      _editingExpense = expense;
      _date = expense.date;
      _category = provider.categoryById(expense.categoryId);
      _amountController.text = expense.amount.toString();
      _descriptionController.text = expense.description;
    });
  }

  void _resetForm() {
    setState(() {
      _editingExpense = null;
      _date = DateTime.now();
      _amountController.clear();
      _descriptionController.clear();
    });
  }

  Future<bool> _confirmDelete(BuildContext context, Expense expense) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t('deleteExpense')),
        content: Text(l10n.t('deleteExpenseMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.t('delete')),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<FinanceProvider>().deleteExpense(expense.id!);
    }
    return false;
  }
}
