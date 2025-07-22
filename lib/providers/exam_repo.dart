import 'package:sqflite/sqflite.dart';
import '../models/exam.dart';

class ExamRepository {
  final Database _database;

  ExamRepository(this._database);

  // 1. CREATE - Add new exam
  Future<int> insertExam(Exam exam) async {
    final map = exam.toMap()..remove('id');

    final id = await _database.insert(
      'exams',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  // 2. READ - Get all exams
  Future<List<Exam>> getAllExams() async {
    final List<Map<String, dynamic>> maps = await _database.query('exams');
    return List.generate(maps.length, (i) {
      return Exam.fromMap(maps[i]);
    });
  }

  // 3. READ - Get single exam by ID
  Future<Exam?> getExam(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'exams',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Exam.fromMap(maps.first);
    }
    return null;
  }

  // 4. READ - Get upcoming exams (not completed and date in future)
  Future<List<Exam>> getUpcomingExams() async {
    final now = DateTime.now().toIso8601String();
    final maps = await _database.query(
      'exams',
      where: 'examDate > ?',
      whereArgs: [now],
      orderBy: 'examDate ASC',
    );
    return maps.map((map) => Exam.fromMap(map)).toList();
  }

  // 5. READ - Get exams for specific course
  Future<List<Exam>> getExamsByCourse(String courseCode) async {
    final maps = await _database.query(
      'exams',
      where: 'classCode = ?',
      whereArgs: [courseCode],
      orderBy: 'examDate ASC',
    );
    return maps.map((map) => Exam.fromMap(map)).toList();
  }

  // 6. UPDATE - Modify existing exam
  Future<int> updateExam(Exam exam) async {
    return await _database.update(
      'exams',
      exam.toMap(),
      where: 'id = ?',
      whereArgs: [exam.id],
    );
  }

  // 7. UPDATE - Mark exam as complete/incomplete
  Future<int> updateExamStatus(int id, int status) async {
    return await _database.update(
      'exams',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 8. DELETE - Remove exam
  Future<int> deleteExam(int id) async {
    return await _database.delete('exams', where: 'id = ?', whereArgs: [id]);
  }

  // 9. DELETE - Remove all exams for a course
  Future<int> deleteExamsByCourse(String courseCode) async {
    return await _database.delete(
      'exams',
      where: 'classCode = ?',
      whereArgs: [courseCode],
    );
  }
}
