import 'package:academi_kit/models/class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CourseDatabase {
  static const _dbName = 'school.db';
  static const _dbVersion = 1;

  Database? _database;

  Database get database {
    if (_database != null) return _database!;
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    return _database!;
  }

  static Future<CourseDatabase> init() async {
    final database = CourseDatabase();
    await database._initDatabase(); // Ensure DB is ready
    return database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onOpen: _onOpen,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS classes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE,
        name TEXT,
        credits INTEGER,
        assignmentsCount INTEGER,
        examsCount INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS assignments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        classCode TEXT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        status INTEGER,
        FOREIGN KEY (classCode) REFERENCES classes(code) on DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        classCode TEXT,
        title TEXT,
        description TEXT,
        examDate TEXT,
        status INTEGER,
        FOREIGN KEY (classCode) REFERENCES classes(code) on DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
  }

  Future<void> _onOpen(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    // await db.execute('drop table if exists classes');
    // await db.execute('drop table if exists assignments');
    // await db.execute('drop table if exists exams');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS classes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE,
        name TEXT,
        credits INTEGER,
        assignmentsCount INTEGER,
        examsCount INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS assignments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        classCode TEXT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        status INTEGER,
        FOREIGN KEY (classCode) REFERENCES classes(code)
        on DELETE CASCADE
        on UPDATE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exams(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        classCode TEXT,
        title TEXT,
        description TEXT,
        examDate TEXT,
        status INTEGER,
        FOREIGN KEY (classCode) REFERENCES classes(code) 
        on DELETE CASCADE
        on UPDATE CASCADE
      )
    ''');
  }

  // CRUD Operations
  Future<List<Class>> fetchClasses() async {
    final db = database;
    final maps = await db.query('classes');
    return maps.map((map) => Class.fromMap(map)).toList();
  }

  Future<void> insertClass(Class class_) async {
    final db = database;
    print('-------------------------------------------');
    print(class_.toMap());
    print('-------------------------------------------');
    print(await db.insert('classes', class_.toMap()));
  }

  Future<void> updateClass(Class class_, String oldCode) async {
    final db = database;
    var f = await db.update(
      'classes',
      class_.toMap(),
      where: 'code = ?',
      whereArgs: [oldCode],
    );
    print(f);
  }

  Future<void> deleteClass(String code) async {
    final db = database;
    await db.delete('classes', where: 'code = ?', whereArgs: [code]);
  }
}
