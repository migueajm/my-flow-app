import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('es'), Locale('en')];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _values = {
    'es': {
      'appName': 'Gastos personales',
      'dashboard': 'Inicio',
      'expenses': 'Gastos',
      'income': 'Ingresos',
      'savings': 'Ahorros',
      'reports': 'Reportes',
      'settings': 'Ajustes',
      'theme': 'Tema',
      'themeSystem': 'Sistema',
      'themeLight': 'Claro',
      'themeDark': 'Oscuro',
      'language': 'Idioma',
      'languageSystem': 'Sistema',
      'languageSpanish': 'Espanol',
      'languageEnglish': 'Ingles',
      'loginTitle': 'Controla tu dinero con claridad',
      'loginSubtitle':
          'Gestiona ingresos, gastos, ahorros e inversiones desde este dispositivo.',
      'email': 'Correo electronico',
      'password': 'Contrasena',
      'signIn': 'Iniciar sesion',
      'guest': 'Continuar como invitado',
      'authSoon': 'La autenticacion se conectara mas adelante.',
      'salaryPrompt':
          'Captura tu salario mensual para activar el presupuesto 80/20.',
      'nearLimit': 'Estas cerca de exceder el presupuesto de gastos.',
      'overLimit': 'Has excedido el presupuesto de gastos del mes.',
      'incomeLabel': 'Ingreso',
      'expenseBudget': '80% gastos',
      'spent': 'Gastado',
      'savingsBudget': '20% ahorro',
      'remaining': 'Queda',
      'available': 'Disponible',
      'budgetUsage': 'Uso del presupuesto',
      'expenseDistribution': 'Distribucion de gastos',
      'latestExpenses': 'Ultimos gastos',
      'noExpensesTitle': 'Aun no hay gastos',
      'noExpensesMessage': 'Los gastos del mes apareceran aqui.',
      'registerExpense': 'Registrar gasto',
      'updateExpense': 'Actualizar gasto',
      'addExpense': 'Agregar gasto',
      'amount': 'Monto',
      'category': 'Categoria',
      'description': 'Descripcion',
      'validAmount': 'Ingresa un monto valido',
      'expenseSaved': 'Gasto registrado',
      'expenseUpdated': 'Gasto actualizado',
      'deleteExpense': 'Eliminar gasto',
      'deleteExpenseMessage':
          'Este gasto se eliminara del presupuesto mensual.',
      'edit': 'Editar',
      'delete': 'Eliminar',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'saveIncome': 'Guardar ingreso',
      'incomeSaved': 'Ingreso guardado',
      'monthlySalary': 'Salario mensual',
      'salary': 'Salario',
      'current': 'Actual',
      'willSaveFor': 'Se guardara para',
      'newAccount': 'Nueva cuenta',
      'name': 'Nombre',
      'validName': 'Ingresa un nombre',
      'createAccount': 'Crear cuenta',
      'movement': 'Movimiento',
      'account': 'Cuenta',
      'type': 'Tipo',
      'saveMovement': 'Guardar movimiento',
      'updateMovement': 'Actualizar movimiento',
      'monthlyHistory': 'Historial mensual',
      'netMovements': 'Movimientos netos',
      'goal20': 'Meta 20%',
      'deleteMovement': 'Eliminar movimiento',
      'deleteMovementMessage':
          'Este movimiento se eliminara de ahorros e inversiones.',
      'monthlyReport': 'Reporte mensual',
      'dailyReport': 'Reporte diario',
      'weeklyReport': 'Reporte semanal',
      'monthlyComparison': 'Comparacion entre meses',
      'categoryExpenses': 'Gastos por categoria',
      'savingsInvestments': 'Ahorros/Inversiones',
      'expenseAvailable': 'Disponible gastos',
      'loading': 'Cargando...',
      'food': 'Comida',
      'transport': 'Transporte',
      'housing': 'Vivienda',
      'services': 'Servicios',
      'health': 'Salud',
      'leisure': 'Ocio',
      'other': 'Otros',
      'no_expenses': 'Sin gastos',
      'register_expenses': 'Registra gastos para ver la distribución por categoría.',
      'empty-data': 'Sin datos',
      'empty-data-message': 'Este periodo todavia no tiene movimientos.',
      'no-history': 'Sin historico',
      'history-message': 'Captura ingresos en varios meses para comparar.',
      'investments': 'Inversiones',
      'deposit': 'Deposito',
      'withdrawal': 'Retiro',
      'performance': 'Rendimiento',
    },
    'en': {
      'appName': 'Personal expenses',
      'dashboard': 'Home',
      'expenses': 'Expenses',
      'income': 'Income',
      'savings': 'Savings',
      'reports': 'Reports',
      'settings': 'Settings',
      'theme': 'Theme',
      'themeSystem': 'System',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'language': 'Language',
      'languageSystem': 'System',
      'languageSpanish': 'Spanish',
      'languageEnglish': 'English',
      'loginTitle': 'Manage your money clearly',
      'loginSubtitle':
          'Track income, expenses, savings and investments from this device.',
      'email': 'Email',
      'password': 'Password',
      'signIn': 'Sign in',
      'guest': 'Continue as guest',
      'authSoon': 'Authentication will be connected later.',
      'salaryPrompt':
          'Capture your monthly salary to activate the 80/20 budget.',
      'nearLimit': 'You are close to exceeding your expense budget.',
      'overLimit': 'You have exceeded this month expense budget.',
      'incomeLabel': 'Income',
      'expenseBudget': '80% expenses',
      'spent': 'Spent',
      'savingsBudget': '20% savings',
      'remaining': 'Remaining',
      'available': 'Available',
      'budgetUsage': 'Budget usage',
      'expenseDistribution': 'Expense distribution',
      'latestExpenses': 'Latest expenses',
      'noExpensesTitle': 'No expenses yet',
      'noExpensesMessage': 'This month expenses will appear here.',
      'registerExpense': 'Register expense',
      'updateExpense': 'Update expense',
      'addExpense': 'Add expense',
      'amount': 'Amount',
      'category': 'Category',
      'description': 'Description',
      'validAmount': 'Enter a valid amount',
      'expenseSaved': 'Expense saved',
      'expenseUpdated': 'Expense updated',
      'deleteExpense': 'Delete expense',
      'deleteExpenseMessage':
          'This expense will be removed from the monthly budget.',
      'edit': 'Edit',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'save': 'Save',
      'saveIncome': 'Save income',
      'incomeSaved': 'Income saved',
      'monthlySalary': 'Monthly salary',
      'salary': 'Salary',
      'current': 'Current',
      'willSaveFor': 'Will be saved for',
      'newAccount': 'New account',
      'name': 'Name',
      'validName': 'Enter a name',
      'createAccount': 'Create account',
      'movement': 'Movement',
      'account': 'Account',
      'type': 'Type',
      'saveMovement': 'Save movement',
      'updateMovement': 'Update movement',
      'monthlyHistory': 'Monthly history',
      'netMovements': 'Net movements',
      'goal20': '20% goal',
      'deleteMovement': 'Delete movement',
      'deleteMovementMessage':
          'This movement will be removed from savings and investments.',
      'monthlyReport': 'Monthly report',
      'dailyReport': 'Daily report',
      'weeklyReport': 'Weekly report',
      'monthlyComparison': 'Monthly comparison',
      'categoryExpenses': 'Expenses by category',
      'savingsInvestments': 'Savings/Investments',
      'expenseAvailable': 'Expense available',
      'loading': 'Loading...',
      'food': 'Food',
      'transport': 'Transport',
      'housing': 'Housing',
      'services': 'Services',
      'health': 'Health',
      'leisure': 'Leisure',
      'other': 'Other',
      'no_expenses': 'No expenses',
      'register_expenses': 'Register expenses to see the distribution by category.',
      'empty-data': 'No data',
      'empty-data-message': 'This period has no movements yet.',
      'no-history': 'No history',
      'history-message': 'Capture your income over several months to compare.',
      'investments': 'Investments',
      'deposit': 'Deposit',
      'withdrawal': 'Withdrawal',
      'performance': 'Performance',
    },
  };

  String t(String key) =>
      _values[locale.languageCode]?[key] ?? _values['es']?[key] ?? key;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(Locale(locale.languageCode)));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
