import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movement.dart';
import '../models/savings_account.dart';
import '../providers/finance_provider.dart';
import '../utils/formatters.dart';
import '../widgets/month_selector.dart';
import '../widgets/summary_card.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final _accountFormKey = GlobalKey<FormState>();
  final _movementFormKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  AccountType _accountType = AccountType.ahorro;
  MovementType _movementType = MovementType.deposito;
  SavingsAccount? _selectedAccount;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _accountNameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    if (_selectedAccount == null && provider.accounts.isNotEmpty) {
      _selectedAccount = provider.accounts.first;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const MonthSelector(),
        const SizedBox(height: 12),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: MediaQuery.sizeOf(context).width > 620 ? 2 : 1,
          childAspectRatio: 2.3,
          children: [
            SummaryCard(
              title: 'Meta 20%',
              amount: provider.savingsBudget,
              icon: Icons.flag,
              color: Colors.green,
            ),
            SummaryCard(
              title: 'Movimientos netos',
              amount: provider.savingsTotal,
              icon: Icons.swap_vert,
              color: Colors.teal,
              subtitle: 'Queda ${currencyFormat.format(provider.savingsRemaining)}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _accountFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nueva cuenta', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _accountNameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Ingresa un nombre' : null,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<AccountType>(
                    segments: AccountType.values
                        .map((type) => ButtonSegment(value: type, label: Text(type.label)))
                        .toList(),
                    selected: {_accountType},
                    onSelectionChanged: (values) => setState(() => _accountType = values.first),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () async {
                      if (!_accountFormKey.currentState!.validate()) return;
                      await context.read<FinanceProvider>().addAccount(
                            name: _accountNameController.text.trim(),
                            type: _accountType,
                          );
                      _accountNameController.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crear cuenta'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _movementFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Movimiento', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SavingsAccount>(
                    value: _selectedAccount,
                    items: provider.accounts
                        .map(
                          (account) => DropdownMenuItem(
                            value: account,
                            child: Text('${account.name} · ${account.type.label}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _selectedAccount = value),
                    decoration: const InputDecoration(labelText: 'Cuenta'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<MovementType>(
                    value: _movementType,
                    items: MovementType.values
                        .map((type) => DropdownMenuItem(value: type, child: Text(type.label)))
                        .toList(),
                    onChanged: (value) => setState(() => _movementType = value ?? MovementType.deposito),
                    decoration: const InputDecoration(labelText: 'Tipo'),
                  ),
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
                    onPressed: provider.accounts.isEmpty
                        ? null
                        : () async {
                            if (!_movementFormKey.currentState!.validate() || _selectedAccount?.id == null) return;
                            await context.read<FinanceProvider>().addMovement(
                                  accountId: _selectedAccount!.id!,
                                  type: _movementType,
                                  amount: double.parse(_amountController.text.replaceAll(',', '')),
                                  date: _date,
                                  description: _descriptionController.text.trim(),
                                );
                            _amountController.clear();
                            _descriptionController.clear();
                          },
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar movimiento'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('Historial mensual', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...provider.movements.map((movement) {
          final account = provider.accountById(movement.accountId);
          final isWithdrawal = movement.type == MovementType.retiro;
          return Card(
            child: ListTile(
              leading: Icon(isWithdrawal ? Icons.remove_circle : Icons.add_circle),
              title: Text(movement.description.isEmpty ? movement.type.label : movement.description),
              subtitle: Text('${account?.name ?? 'Cuenta'} · ${shortDateFormat.format(movement.date)}'),
              trailing: Text(
                '${isWithdrawal ? '-' : '+'}${currencyFormat.format(movement.amount)}',
              ),
            ),
          );
        }),
      ],
    );
  }
}
