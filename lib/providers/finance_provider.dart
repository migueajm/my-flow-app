import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../models/movement.dart';
import '../models/report_models.dart';
import '../models/savings_account.dart';
import '../utils/date_utils.dart';

class FinanceProvider extends ChangeNotifier {
  final AppDatabase _db = AppDatabase.instance;

  MonthKey selectedMonth = MonthKey.fromDate(DateTime.now());
  bool isLoading = true;

  List<Category> categories = [];
  List<Expense> expenses = [];
  List<SavingsAccount> accounts = [];
  List<Movement> movements = [];
  List<CategoryTotal> categoryTotals = [];
  List<PeriodTotal> dailyTotals = [];
  List<PeriodTotal> weeklyTotals = [];
  List<MonthlyComparison> monthlyComparison = [];
  Income? income;

  double expenseTotal = 0;
  double savingsTotal = 0;

  double get salary => income?.amount ?? 0;
  double get expenseBudget => income?.expenseBudget ?? 0;
  double get savingsBudget => income?.savingsBudget ?? 0;
  double get expenseRemaining => expenseBudget - expenseTotal;
  double get savingsRemaining => savingsBudget - savingsTotal;
  double get expenseUsagePercent {
    if (expenseBudget <= 0) return 0;
    return (expenseTotal / expenseBudget).clamp(0, 1);
  }

  bool get isNearExpenseLimit =>
      expenseBudget > 0 && expenseUsagePercent >= 0.85;
  bool get isOverExpenseLimit =>
      expenseBudget > 0 && expenseTotal > expenseBudget;

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();
    categories = await _db.getCategories();
    accounts = await _db.getAccounts();
    await refreshMonth();
    isLoading = false;
    notifyListeners();
  }

  Future<void> changeMonth(MonthKey month) async {
    selectedMonth = month;
    isLoading = true;
    notifyListeners();
    await refreshMonth();
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshMonth() async {
    final month = selectedMonth.month;
    final year = selectedMonth.year;
    income = await _db.getIncome(month, year);
    expenses = await _db.getExpenses(month, year);
    movements = await _db.getMovements(month, year);
    expenseTotal = await _db.getExpenseTotal(month, year);
    savingsTotal = await _db.getSavingsMovementTotal(month, year);
    categoryTotals = await _db.getCategoryTotals(month, year);
    dailyTotals = await _db.getDailyExpenseTotals(month, year);
    weeklyTotals = await _db.getWeeklyExpenseTotals(month, year);
    monthlyComparison = await _db.getMonthlyComparison();
  }

  Future<void> saveIncome(double amount) async {
    await _db.upsertIncome(amount, selectedMonth.month, selectedMonth.year);
    await refreshMonth();
    notifyListeners();
  }

  Future<void> addExpense({
    required DateTime date,
    required int categoryId,
    required double amount,
    required String description,
  }) async {
    await _db.insertExpense(
      Expense(
        date: date,
        categoryId: categoryId,
        amount: amount,
        description: description,
        month: date.month,
        year: date.year,
      ),
    );
    selectedMonth = MonthKey.fromDate(date);
    await refreshMonth();
    notifyListeners();
  }

  Future<void> updateExpense({
    required int id,
    required DateTime date,
    required int categoryId,
    required double amount,
    required String description,
  }) async {
    await _db.updateExpense(
      Expense(
        id: id,
        date: date,
        categoryId: categoryId,
        amount: amount,
        description: description,
        month: date.month,
        year: date.year,
      ),
    );
    selectedMonth = MonthKey.fromDate(date);
    await refreshMonth();
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    await _db.deleteExpense(id);
    await refreshMonth();
    notifyListeners();
  }

  Future<void> addAccount({
    required String name,
    required AccountType type,
  }) async {
    await _db.insertAccount(
      SavingsAccount(name: name, type: type, createdAt: DateTime.now()),
    );
    accounts = await _db.getAccounts();
    notifyListeners();
  }

  Future<void> addMovement({
    required int accountId,
    required MovementType type,
    required double amount,
    required DateTime date,
    required String description,
  }) async {
    await _db.insertMovement(
      Movement(
        accountId: accountId,
        type: type,
        amount: amount,
        date: date,
        description: description,
        month: date.month,
        year: date.year,
      ),
    );
    selectedMonth = MonthKey.fromDate(date);
    await refreshMonth();
    notifyListeners();
  }

  Future<void> updateMovement({
    required int id,
    required int accountId,
    required MovementType type,
    required double amount,
    required DateTime date,
    required String description,
  }) async {
    await _db.updateMovement(
      Movement(
        id: id,
        accountId: accountId,
        type: type,
        amount: amount,
        date: date,
        description: description,
        month: date.month,
        year: date.year,
      ),
    );
    selectedMonth = MonthKey.fromDate(date);
    await refreshMonth();
    notifyListeners();
  }

  Future<void> deleteMovement(int id) async {
    await _db.deleteMovement(id);
    await refreshMonth();
    notifyListeners();
  }

  Category? categoryById(int id) {
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  SavingsAccount? accountById(int id) {
    for (final account in accounts) {
      if (account.id == id) return account;
    }
    return null;
  }
}
