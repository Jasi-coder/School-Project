import 'package:sqflite/sqflite.dart';

const String INITIALIZE_DATABASE_SQL = '''CREATE TABLE IF NOT EXISTS months(
      month_id INTEGER PRIMARY KEY AUTOINCREMENT,
      year INTEGER,
      default_month_id INTEGER,
      FOREIGN KEY(default_month_id) REFERENCES default_months(default_month_id)
      )''';

class Months {
  final int? month_id;
  final int year;
  final int default_month_id;

  Months({this.month_id, required this.year, required this.default_month_id});

  Map<String, dynamic> toMap() {
    return {
      'month_id': month_id,
      'year': year,
      'default_month_id': default_month_id,
    };
  }

  factory Months.fromMap(Map<String, dynamic> map) {
    return Months(
      month_id: map['month_id'],
      year: map['year'],
      default_month_id: map['default_month_id'],
    );
  }

  static Future<void> initializeDatabase(Database database) async {
    await database.execute(INITIALIZE_DATABASE_SQL);
  }
}
