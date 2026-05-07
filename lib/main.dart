import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/app_settings_provider.dart';
import 'providers/finance_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_MX');
  await initializeDateFormatting('en_US');
  runApp(const GastosPersonalesApp());
}

class GastosPersonalesApp extends StatelessWidget {
  const GastosPersonalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppSettingsProvider()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => FinanceProvider()..initialize()),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, settings, _) {
          final lightScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
          );
          final darkScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          );
          return MaterialApp(
            title: 'Gastos Personales',
            debugShowCheckedModeBanner: false,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            themeMode: settings.themeMode,
            theme: ThemeData(
              colorScheme: lightScheme,
              useMaterial3: true,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: darkScheme,
              useMaterial3: true,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
            ),
            home: !settings.isReady
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  )
                : settings.isGuest
                    ? const HomeScreen()
                    : const LoginScreen(),
          );
        },
      ),
    );
  }
}
