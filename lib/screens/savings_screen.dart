import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
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
  Movement? _editingMovement;

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
    final l10n = AppLocalizations.of(context);
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
              title: l10n.t('goal20'),
              amount: provider.savingsBudget,
              icon: Icons.flag,
              color: Colors.green,
            ),
            SummaryCard(
              title: l10n.t('netMovements'),
              amount: provider.savingsTotal,
              icon: Icons.swap_vert,
              color: Colors.teal,
              subtitle:
                  '${l10n.t('remaining')} ${currencyFormat.format(provider.savingsRemaining)}',
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
                  Text(
                    l10n.t('newAccount'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _accountNameController,
                    decoration: InputDecoration(labelText: l10n.t('name')),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? l10n.t('validName')
                        : null,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<AccountType>(
                    segments: AccountType.values
                        .map(
                          (type) => ButtonSegment(
                            value: type,
                            label: Text(l10n.t(type.label)),
                          ),
                        )
                        .toList(),
                    selected: {_accountType},
                    onSelectionChanged: (values) =>
                        setState(() => _accountType = values.first),
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
                    label: Text(l10n.t('createAccount')),
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
                  Text(
                    _editingMovement == null
                        ? l10n.t('movement')
                        : l10n.t('updateMovement'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SavingsAccount>(
                    initialValue: _selectedAccount,
                    items: provider.accounts
                        .map(
                          (account) => DropdownMenuItem(
                            value: account,
                            child: Text(
                              '${account.name} · ${account.type.label}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedAccount = value),
                    decoration: InputDecoration(labelText: l10n.t('account')),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<MovementType>(
                    initialValue: _movementType,
                    items: MovementType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(l10n.t(type.label)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(
                      () => _movementType = value ?? MovementType.deposito,
                    ),
                    decoration: InputDecoration(labelText: l10n.t('type')),
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
                    onPressed: provider.accounts.isEmpty
                        ? null
                        : () async {
                            if (!_movementFormKey.currentState!.validate() ||
                                _selectedAccount?.id == null) {
                              return;
                            }
                            final amount = double.parse(
                              _amountController.text.replaceAll(',', ''),
                            );
                            final finance = context.read<FinanceProvider>();
                            if (_editingMovement == null) {
                              await finance.addMovement(
                                accountId: _selectedAccount!.id!,
                                type: _movementType,
                                amount: amount,
                                date: _date,
                                description: _descriptionController.text.trim(),
                              );
                            } else {
                              await finance.updateMovement(
                                id: _editingMovement!.id!,
                                accountId: _selectedAccount!.id!,
                                type: _movementType,
                                amount: amount,
                                date: _date,
                                description: _descriptionController.text.trim(),
                              );
                            }
                            _resetMovementForm();
                          },
                    icon: const Icon(Icons.save),
                    label: Text(
                      _editingMovement == null
                          ? l10n.t('saveMovement')
                          : l10n.t('updateMovement'),
                    ),
                  ),
                  if (_editingMovement != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _resetMovementForm,
                      icon: const Icon(Icons.close),
                      label: Text(l10n.t('cancel')),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.t('monthlyHistory'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...provider.movements.map((movement) {
          final account = provider.accountById(movement.accountId);
          final isWithdrawal = movement.type == MovementType.retiro;
          return Dismissible(
            key: ValueKey('movement-${movement.id}'),
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
                _startEditingMovement(movement);
                return false;
              }
              return _confirmDeleteMovement(context, movement);
            },
            child: Card(
              child: ListTile(
                leading: Icon(
                  isWithdrawal ? Icons.remove_circle : Icons.add_circle,
                ),
                title: Text(
                  movement.description.isEmpty
                      ? movement.type.label
                      : movement.description,
                ),
                subtitle: Text(
                  '${account?.name ?? l10n.t('account')} · ${shortDateFormat.format(movement.date)}',
                ),
                trailing: Text(
                  '${isWithdrawal ? '-' : '+'}${currencyFormat.format(movement.amount)}',
                ),
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

  void _startEditingMovement(Movement movement) {
    final provider = context.read<FinanceProvider>();
    setState(() {
      _editingMovement = movement;
      _selectedAccount = provider.accountById(movement.accountId);
      _movementType = movement.type;
      _amountController.text = movement.amount.toString();
      _date = movement.date;
      _descriptionController.text = movement.description;
    });
  }

  void _resetMovementForm() {
    setState(() {
      _editingMovement = null;
      _amountController.clear();
      _descriptionController.clear();
      _date = DateTime.now();
    });
  }

  Future<bool> _confirmDeleteMovement(
    BuildContext context,
    Movement movement,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t('deleteMovement')),
        content: Text(l10n.t('deleteMovementMessage')),
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
      await context.read<FinanceProvider>().deleteMovement(movement.id!);
    }
    return false;
  }
}
