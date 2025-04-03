import 'package:sqflite/sqflite.dart';

const String INITIALIZE_DATABASE_SQL = '''CREATE TABLE IF NOT EXISTS entry(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_id INTEGER,
      amount FLOAT,
      month_id INTEGER,
      FOREIGN KEY(category_id) REFERENCES categories(id)
      FOREIGN KEY(month_id) REFERENCES months(month_id)
      )''';

class Entry {
  final int? id;
  final int? categoriesID;
  final double amount;
  final int? month_id;

  Entry(
      {this.id,
      this.categoriesID,
      required this.amount, this.month_id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoriesID,
      'amount': amount,
      'month_id': month_id
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
        id: map['id'],
        categoriesID: map['category_id'],
        amount: map['amount'],
        month_id: map['month_id']);
  }

  static Future<void> initializeDatabase(Database database) async {
    await database.execute(INITIALIZE_DATABASE_SQL);
  }
}
