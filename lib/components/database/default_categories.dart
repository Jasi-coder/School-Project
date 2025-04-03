import 'package:sqflite/sqflite.dart';

const String INITIALIZE_DATABASE_SQL =
    '''CREATE TABLE IF NOT EXISTS default_categories(
      id INTEGER PRIMARY KEY,
      name TEXT
      )''';

class DefaultCategories {
  final int? id;
  final String categoryName;

  DefaultCategories({this.id, required this.categoryName});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': categoryName};
  }

  factory DefaultCategories.fromMap(Map<String, dynamic> map) {
    return DefaultCategories(id: map['id'], categoryName: map['name']);
  }

  static Future<void> initializeDatabase(Database database) async {
    await database.execute(INITIALIZE_DATABASE_SQL);
    await database.rawInsert(
        'INSERT INTO default_categories (id, name) VALUES (1,"Lebensmittel")');
    await database.rawInsert(
        'INSERT INTO default_categories (id, name) VALUES (2,"Tanken")');
    await database.rawInsert(
        'INSERT INTO default_categories (id, name) VALUES (3,"Kleidung")');
    await database.rawInsert(
        'INSERT INTO default_categories (id, name) VALUES (4,"Sonstiges")');
  }
}
