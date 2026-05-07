import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../models/movement.dart';
import '../models/report_models.dart';
import '../models/savings_account.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gastos_personales.db');
    _database = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createDb,
    );
    return _database!;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categorias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        color INTEGER NOT NULL,
        icon TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ingresos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        expense_budget REAL NOT NULL,
        savings_budget REAL NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(month, year)
      )
    ''');

    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        description TEXT NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        FOREIGN KEY(category_id) REFERENCES categorias(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ahorros_inversiones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE movimientos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        FOREIGN KEY(account_id) REFERENCES ahorros_inversiones(id)
      )
    ''');

    await _seedCategories(db);
  }

  Future<void> _seedCategories(Database db) async {
    final categories = [
      const Category(name: 'food', color: 0xFFE76F51, icon: 'restaurant'),
      const Category(name: 'transport', color: 0xFF457B9D, icon: 'commute'),
      const Category(name: 'housing', color: 0xFF2A9D8F, icon: 'home'),
      const Category(name: 'services', color: 0xFFE9C46A, icon: 'bolt'),
      const Category(name: 'health', color: 0xFF8AB17D, icon: 'health'),
      const Category(name: 'leisure', color: 0xFF9B5DE5, icon: 'movie'),
      const Category(name: 'other', color: 0xFF6C757D, icon: 'more'),
    ];

    for (final category in categories) {
      await db.insert('categorias', category.toMap());
    }
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final maps = await db.query('categorias', orderBy: 'name ASC');
    return maps.map(Category.fromMap).toList();
  }

  Future<int> upsertIncome(double amount, int month, int year) async {
    final db = await database;
    return db.insert(
      'ingresos',
      Income(
        amount: amount,
        expenseBudget: amount * 0.8,
        savingsBudget: amount * 0.2,
        month: month,
        year: year,
        createdAt: DateTime.now(),
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Income?> getIncome(int month, int year) async {
    final db = await database;
    final maps = await db.query(
      'ingresos',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Income.fromMap(maps.first);
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert('gastos', expense.toMap());
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return db.update(
      'gastos',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Expense>> getExpenses(int month, int year) async {
    final db = await database;
    final maps = await db.query(
      'gastos',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
      orderBy: 'date DESC',
    );
    return maps.map(Expense.fromMap).toList();
  }

  Future<double> getExpenseTotal(int month, int year) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM gastos WHERE month = ? AND year = ?',
      [month, year],
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<List<CategoryTotal>> getCategoryTotals(int month, int year) async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT c.id AS category_id, c.name AS category_name, c.color, COALESCE(SUM(g.amount), 0) AS total
      FROM gastos g
      JOIN categorias c ON c.id = g.category_id
      WHERE g.month = ? AND g.year = ?
      GROUP BY c.id, c.name, c.color
      ORDER BY total DESC
    ''',
      [month, year],
    );

    return rows
        .map(
          (row) => CategoryTotal(
            categoryId: row['category_id'] as int,
            categoryName: row['category_name'] as String,
            color: row['color'] as int,
            total: (row['total'] as num).toDouble(),
          ),
        )
        .toList();
  }

  Future<List<PeriodTotal>> getDailyExpenseTotals(int month, int year) async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT strftime('%d', date) AS label, COALESCE(SUM(amount), 0) AS total
      FROM gastos
      WHERE month = ? AND year = ?
      GROUP BY label
      ORDER BY label ASC
    ''',
      [month, year],
    );
    return rows
        .map(
          (row) => PeriodTotal(
            label: row['label'] as String,
            total: (row['total'] as num).toDouble(),
          ),
        )
        .toList();
  }

  Future<List<PeriodTotal>> getWeeklyExpenseTotals(int month, int year) async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT ('Semana ' || strftime('%W', date)) AS label, COALESCE(SUM(amount), 0) AS total
      FROM gastos
      WHERE month = ? AND year = ?
      GROUP BY label
      ORDER BY label ASC
    ''',
      [month, year],
    );
    return rows
        .map(
          (row) => PeriodTotal(
            label: row['label'] as String,
            total: (row['total'] as num).toDouble(),
          ),
        )
        .toList();
  }

  Future<int> insertAccount(SavingsAccount account) async {
    final db = await database;
    return db.insert('ahorros_inversiones', account.toMap());
  }

  Future<List<SavingsAccount>> getAccounts() async {
    final db = await database;
    final maps = await db.query(
      'ahorros_inversiones',
      orderBy: 'created_at DESC',
    );
    return maps.map(SavingsAccount.fromMap).toList();
  }

  Future<int> insertMovement(Movement movement) async {
    final db = await database;
    return db.insert('movimientos', movement.toMap());
  }

  Future<int> updateMovement(Movement movement) async {
    final db = await database;
    return db.update(
      'movimientos',
      movement.toMap(),
      where: 'id = ?',
      whereArgs: [movement.id],
    );
  }

  Future<int> deleteMovement(int id) async {
    final db = await database;
    return db.delete('movimientos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Movement>> getMovements(int month, int year) async {
    final db = await database;
    final maps = await db.query(
      'movimientos',
      where: 'month = ? AND year = ?',
      whereArgs: [month, year],
      orderBy: 'date DESC',
    );
    return maps.map(Movement.fromMap).toList();
  }

  Future<double> getSavingsMovementTotal(int month, int year) async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(
        CASE WHEN type = 'retiro' THEN -amount ELSE amount END
      ), 0) AS total
      FROM movimientos
      WHERE month = ? AND year = ?
    ''',
      [month, year],
    );
    return (rows.first['total'] as num).toDouble();
  }

  Future<List<MonthlyComparison>> getMonthlyComparison({int limit = 6}) async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT
        i.year,
        i.month,
        i.amount AS income,
        COALESCE((SELECT SUM(amount) FROM gastos g WHERE g.month = i.month AND g.year = i.year), 0) AS expenses,
        COALESCE((SELECT SUM(CASE WHEN type = 'retiro' THEN -amount ELSE amount END)
          FROM movimientos m WHERE m.month = i.month AND m.year = i.year), 0) AS savings
      FROM ingresos i
      ORDER BY i.year DESC, i.month DESC
      LIMIT ?
    ''',
      [limit],
    );

    return rows.reversed
        .map(
          (row) => MonthlyComparison(
            label: '${row['month']}/${row['year']}',
            income: (row['income'] as num).toDouble(),
            expenses: (row['expenses'] as num).toDouble(),
            savings: (row['savings'] as num).toDouble(),
          ),
        )
        .toList();
  }
}
