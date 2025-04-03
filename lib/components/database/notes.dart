import 'package:sqflite/sqflite.dart';

const String INITIALIZE_DATABASE_SQL = '''
      CREATE TABLE IF NOT EXISTS notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT,
      color TEXT)
      ''';

class Note {
  final int? id;
  final String title;
  final String content;
  final String color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content, 'color': color};
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
    );
  }

  static Future<void> initializeDatabase(Database database) async {
    await database.execute(INITIALIZE_DATABASE_SQL);
  }
}
