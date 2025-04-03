import 'package:sqflite/sqflite.dart';

const String INITIALIZE_DATABASE_SQL =
    '''CREATE TABLE IF NOT EXISTS default_months(
      default_month_id INTEGER PRIMARY KEY,
      name TEXT,
      image_path TEXT
      )''';

class DefaultMonths {
  final int? default_month_id;
  final String name;
  final String image_path;

  DefaultMonths(
      {this.default_month_id, required this.name, required this.image_path});

  Map<String, dynamic> toMap() {
    return {
      'default_month_id': default_month_id,
      'name': name,
      'image_path': image_path
    };
  }

  factory DefaultMonths.fromMap(Map<String, dynamic> map) {
    return DefaultMonths(
        default_month_id: map['default_month_id'],
        name: map['name'],
        image_path: map['image_path']);
  }

  static Future<void> initializeDatabase(Database database) async {
    await database.execute(INITIALIZE_DATABASE_SQL);
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (01, "Januar", "lib/images/january.png")');
    await database.rawInsert(
        ' INSERT INTO default_months (default_month_id, name, image_path) VALUES (02, "Februar", "lib/images/winter-tree.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (03, "März", "lib/images/flowers.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (04, "April", "lib/images/easter.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (05, "Mai", "lib/images/spring-calendar.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (06, "Juni", "lib/images/summer (1).png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (07, "Juli", "lib/images/beach.png")');
    await database.rawInsert(
        '  INSERT INTO default_months (default_month_id, name, image_path) VALUES (08, "August", "lib/images/summer.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (09, "September", "lib/images/thanksgiving.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (10, "Oktober", "lib/images/park.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (11, "November", "lib/images/winter.png")');
    await database.rawInsert(
        'INSERT INTO default_months (default_month_id, name, image_path) VALUES (12, "Dezember", "lib/images/christmas-ball.png")');
  }
}
