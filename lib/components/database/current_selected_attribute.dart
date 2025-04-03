import 'package:sqflite/sqflite.dart';

const String INITIALIZE_DATABASE_SQL =
'''CREATE TABLE IF NOT EXISTS current_selected_attribute(
  name TEXT PRIMARY KEY,
  value INTEGER
)''';

class CurrentSelectedAttribute{
  final String? name;
  final int? value;

  CurrentSelectedAttribute({this.name,this.value});
  Map<String, dynamic> toMap() {
    return {'name': name, 'value': value};
  }

  factory CurrentSelectedAttribute.fromMap(Map<String, dynamic> map) {
    return CurrentSelectedAttribute(name: map['name'], value: map['value']);
  }
  static Future<void> initializeDatabase(Database database) async {
    await database.execute(INITIALIZE_DATABASE_SQL);
    await database.rawInsert(
        'INSERT INTO current_selected_attribute (name, value) VALUES ("selected_month",0)');
    await database.rawInsert(
        'INSERT INTO current_selected_attribute (name, value) VALUES ("selected_category",0)');
  }

}
