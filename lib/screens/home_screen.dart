import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_settings_provider.dart';
import '../providers/finance_provider.dart';
import 'dashboard_screen.dart';
import 'expenses_screen.dart';
import 'income_screen.dart';
import 'reports_screen.dart';
import 'savings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    ExpensesScreen(),
    IncomeScreen(),
    SavingsScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<FinanceProvider>().isLoading;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('appName')),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: l10n.t('settings'),
            onPressed: () => _showSettingsSheet(context),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(child: _screens[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            label: l10n.t('dashboard'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            label: l10n.t('expenses'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.payments_outlined),
            label: l10n.t('income'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.savings_outlined),
            label: l10n.t('savings'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            label: l10n.t('reports'),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Consumer<AppSettingsProvider>(
          builder: (context, settings, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/favicon.png', height: 120),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.t('settings'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ThemeMode>(
                    initialValue: settings.themeMode,
                    decoration: InputDecoration(labelText: l10n.t('theme')),
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(l10n.t('themeSystem')),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(l10n.t('themeLight')),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(l10n.t('themeDark')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) settings.setThemeMode(value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<AppLanguageMode>(
                    initialValue: settings.languageMode,
                    decoration: InputDecoration(labelText: l10n.t('language')),
                    items: [
                      DropdownMenuItem(
                        value: AppLanguageMode.system,
                        child: Text(l10n.t('languageSystem')),
                      ),
                      DropdownMenuItem(
                        value: AppLanguageMode.es,
                        child: Text(l10n.t('languageSpanish')),
                      ),
                      DropdownMenuItem(
                        value: AppLanguageMode.en,
                        child: Text(l10n.t('languageEnglish')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) settings.setLanguageMode(value);
                    },
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      '@migueajm',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
