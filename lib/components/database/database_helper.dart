import 'package:capture_costs_for_household/components/database/categories.dart';
import 'package:capture_costs_for_household/components/database/current_selected_attribute.dart';
import 'package:capture_costs_for_household/components/database/default_categories.dart';
import 'package:capture_costs_for_household/components/database/default_months.dart';
import 'package:capture_costs_for_household/components/database/entry.dart';
import 'package:capture_costs_for_household/components/database/monthData.dart';
import 'package:capture_costs_for_household/components/database/months.dart';
import 'package:capture_costs_for_household/components/database/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'capture_costs_new_26.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await DefaultMonths.initializeDatabase(db);
    await Months.initializeDatabase(db);
    await DefaultCategories.initializeDatabase(db);
    await Categories.initializeDatabase(db);
    await Entry.initializeDatabase(db);
    await Note.initializeDatabase(db);
    await CurrentSelectedAttribute.initializeDatabase(db);
  }

  //---------------------------------------------------------------------------------------------------


  Future<int> insertInCurrentSelectedAttributeCategory(int id) async {
    final db = await database;
    return await db.update('current_selected_attribute ', {"value": id},
        where: 'name = ?', whereArgs: ["selected_category"]);
  }

  Future<int> insertInCurrentSelectedAttributeMonths(int id) async {
    final db = await database;

    return await db.update('current_selected_attribute ', {"value": id},
        where: 'name = ?', whereArgs: ["selected_month"]);
  }

  Future<List<dynamic>> selectedCategory() async {
    final db = await database;

    List<Map<String, dynamic>> allRows = await db.rawQuery('''
    SELECT * FROM current_selected_attribute
    ''');
    List<dynamic> category = allRows
        .map((category) => CurrentSelectedAttribute.fromMap(category))
        .toList();

    return category;
  }

  Future<List<CurrentSelectedAttribute>> selectedMonth() async {
    final db = await database;

    List<Map<String, dynamic>> allRows = await db.rawQuery('''
    SELECT * FROM current_selected_attribute
    ''');
    List<CurrentSelectedAttribute> months = allRows
        .map((month) => CurrentSelectedAttribute.fromMap(month))
        .toList();

    return months;
  }

  Future<List<dynamic>> getDefaultMonthByMonthId(int monthId) async {
    print("Monats id $monthId");
    final db = await database;
    return await db.rawQuery('''
    SELECT * FROM months JOIN default_months
    ON months.default_month_id = default_months.default_month_id WHERE months.default_month_id = $monthId''');
    // List<Monthdata> months =
    //     allRows.map((month) => Monthdata.fromMap(month)).toList();
    //
    // print("solution $months");
    // return months;
  }


  Future<List<dynamic>> getEntryByMonthId(int monthId, int categoryId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT * FROM entry JOIN months ON entry.month_id = months.month_id WHERE  entry.month_id = $monthId AND entry.category_id = $categoryId''');
  }

  Future<List<dynamic>> getEntrySumOfPrices(
      int monthId, int categoryId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT SUM(amount) AS sum_of_prices FROM entry WHERE entry.category_id = $categoryId AND entry.month_id = $monthId''');
  }



  // insert entry
  Future<int> insertEntry(Entry entry) async {
    final db = await database;
    return await db.insert('entry', entry.toMap());
  }

  //update entry
  Future<int> updateEntry(Entry entry) async {
    final db = await database;
    return await db
        .update('entry', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  // delete entry
  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.rawDelete('''DELETE FROM entry WHERE entry.id = $id ''');
  }



  // insert month
  Future<int> insertMonth(Months month) async {
    final db = await database;
    return await db.insert('months', month.toMap());
  }

  Future<void> createAllCategories() async {
    final db = await database;
    final monthId = (await db
            .rawQuery('''SELECT MAX(month_id) AS month_id FROM months'''))[0]
        ['month_id'];
    await db.rawInsert(
        'INSERT INTO categories (default_category_id, month_id) VALUES (1, $monthId)');
    await db.rawInsert(
        'INSERT INTO categories (default_category_id, month_id) VALUES (2,$monthId)');
    await db.rawInsert(
        'INSERT INTO categories (default_category_id, month_id) VALUES (3,$monthId)');
    await db.rawInsert(
        'INSERT INTO categories (default_category_id, month_id) VALUES (4,$monthId)');
  }

  // get months and defaultMonths together
  Future<List<Monthdata>> getDefaultMonthsByMonths() async {
    final db = await database;
    List<Map<String, dynamic>> allRows = await db.rawQuery('''
    SELECT * FROM months JOIN default_months
    ON months.default_month_id = default_months.default_month_id
    ''');
    List<Monthdata> months =
        allRows.map((month) => Monthdata.fromMap(month)).toList();
    return months;
  }

  Future<List<dynamic>> getDefaultCategoriesByDefaultCategoryId(
      int defaultCategoryId, int monthId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT * FROM categories JOIN default_categories
    ON categories.default_category_id = default_categories.id WHERE categories.month_id = $monthId  AND categories.default_category_id =  $defaultCategoryId
    ''');

    // List<dynamic> categories = allRows
    //     .map((category) => CategoryWithDefaultCategory.fromMap(category))
    //     .toList();
    // print("cathegory $categories");
    // return categories;
  }

  //---------------------------------------------------------------------------------------------------

  Future<dynamic> close() async {
    final db = await database;
    db.close();
  }

  // database handler for notes

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

}
