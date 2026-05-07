import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    return Row(
      children: [
        IconButton(
          tooltip: 'Mes anterior',
          onPressed: () =>
              provider.changeMonth(provider.selectedMonth.previous()),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            provider.selectedMonth.label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          tooltip: 'Mes siguiente',
          onPressed: () => provider.changeMonth(provider.selectedMonth.next()),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
