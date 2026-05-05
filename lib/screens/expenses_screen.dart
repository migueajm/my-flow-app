import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
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

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    _category ??= provider.categories.isNotEmpty ? provider.categories.first : null;

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
                  Text('Registrar gasto', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Monto', prefixText: r'$ '),
                    validator: (value) {
                      final amount = double.tryParse(value?.replaceAll(',', '') ?? '');
                      if (amount == null || amount <= 0) return 'Ingresa un monto valido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Category>(
                    value: _category,
                    items: provider.categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Icon(categoryIcon(category.icon), size: 18),
                                const SizedBox(width: 8),
                                Text(category.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _category = value),
                    decoration: const InputDecoration(labelText: 'Categoria'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripcion'),
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
                      if (!_formKey.currentState!.validate() || _category?.id == null) return;
                      await context.read<FinanceProvider>().addExpense(
                            date: _date,
                            categoryId: _category!.id!,
                            amount: double.parse(_amountController.text.replaceAll(',', '')),
                            description: _descriptionController.text.trim(),
                          );
                      _amountController.clear();
                      _descriptionController.clear();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gasto registrado')),
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar gasto'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Disponible del 80%: ${currencyFormat.format(provider.expenseRemaining)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...provider.expenses.map((expense) {
          final category = provider.categoryById(expense.categoryId);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(categoryIcon(category?.icon ?? 'more')),
              ),
              title: Text(expense.description.isEmpty ? category?.name ?? 'Gasto' : expense.description),
              subtitle: Text('${category?.name ?? ''} · ${shortDateFormat.format(expense.date)}'),
              trailing: Text(currencyFormat.format(expense.amount)),
            ),
          );
        }),
      ],
    );
  }
}
