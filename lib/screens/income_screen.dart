import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';
import '../utils/formatters.dart';
import '../widgets/month_selector.dart';
import '../widgets/summary_card.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const MonthSelector(),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Salario mensual', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _salaryController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Monto',
                      prefixText: r'$ ',
                      helperText: provider.income == null
                          ? 'Se guardara para ${provider.selectedMonth.label}.'
                          : 'Actual: ${currencyFormat.format(provider.salary)}',
                    ),
                    validator: (value) {
                      final amount = double.tryParse(value?.replaceAll(',', '') ?? '');
                      if (amount == null || amount <= 0) return 'Ingresa un monto valido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final amount = double.parse(_salaryController.text.replaceAll(',', ''));
                      await context.read<FinanceProvider>().saveIncome(amount);
                      _salaryController.clear();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ingreso guardado')),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar ingreso'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: MediaQuery.sizeOf(context).width > 620 ? 3 : 1,
          childAspectRatio: 2.4,
          children: [
            SummaryCard(
              title: 'Salario',
              amount: provider.salary,
              icon: Icons.payments,
              color: Colors.teal,
            ),
            SummaryCard(
              title: 'Gastos 80%',
              amount: provider.expenseBudget,
              icon: Icons.account_balance_wallet,
              color: Colors.indigo,
            ),
            SummaryCard(
              title: 'Ahorro/Inversion 20%',
              amount: provider.savingsBudget,
              icon: Icons.savings,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}
