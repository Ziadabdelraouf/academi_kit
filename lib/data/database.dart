import 'package:academi_kit/models/class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ClassDatabase {
  static const _dbName = 'school.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<ClassDatabase> init() async {
    final database = ClassDatabase();
    await database._initDatabase(); // Ensure DB is ready
    return database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS classes(
        code TEXT PRIMARY KEY,
        name TEXT,
        credits INTEGER,
        assignmentsCount INTEGER,
        examsCount INTEGER
      )
    ''');
  }

  // CRUD Operations
  Future<List<Class>> fetchClasses() async {
    final db = await database;
    final maps = await db.query('classes');
    return maps.map((map) => Class.fromMap(map)).toList();
  }

  Future<void> insertClass(Class class_) async {
    final db = await database;
    await db.insert('classes', class_.toMap());
  }

  Future<void> updateClass(Class class_) async {
    final db = await database;
    await db.update(
      'classes',
      class_.toMap(),
      where: 'code = ?',
      whereArgs: [class_.code],
    );
  }

  Future<void> deleteClass(String code) async {
    final db = await database;
    await db.delete('classes', where: 'code = ?', whereArgs: [code]);
  }
}
