import 'package:intl/intl.dart';

class MonthKey {
  const MonthKey(this.year, this.month);

  final int year;
  final int month;

  factory MonthKey.fromDate(DateTime date) => MonthKey(date.year, date.month);

  DateTime get firstDay => DateTime(year, month);

  String get label => DateFormat.yMMMM('es_MX').format(firstDay);

  MonthKey previous() {
    final date = DateTime(year, month - 1);
    return MonthKey(date.year, date.month);
  }

  MonthKey next() {
    final date = DateTime(year, month + 1);
    return MonthKey(date.year, date.month);
  }
}
