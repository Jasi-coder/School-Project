import 'package:sqflite/sqflite.dart';

const String INITIALIZE_DATABASE_SQL = '''CREATE TABLE IF NOT EXISTS categories(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    default_category_id INTEGER,
    month_id INTEGER,
    FOREIGN KEY(default_category_id) REFERENCES default_categories(id),
    FOREIGN KEY(month_id) REFERENCES months(month_id)
    )''';

class Categories {
  final int? id;
  final int default_category_id;
  final int month_id;

  Categories(
      {this.id, required this.default_category_id, required this.month_id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'default_category_id': default_category_id,
      'month_id': month_id
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
        id: map['id'],
        default_category_id: map['default_category_id'],
        month_id: map['month_id']);
  }
  static Future<void> initializeDatabase(Database database) async {
    await database.execute(INITIALIZE_DATABASE_SQL);
  }
}
