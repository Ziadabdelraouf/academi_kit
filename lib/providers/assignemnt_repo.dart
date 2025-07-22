import 'package:sqflite/sqflite.dart';
import '../models/assignment.dart';

class AssignmentRepository {
  final Database _database;

  AssignmentRepository(this._database);

  // 1. CREATE - Add new assignment
  Future<int> insertAssignment(Assignment assignment) async {
    // The id column is omitted because it's auto-incremented
    final map = assignment.toMap()..remove('id');

    final id = await _database.insert(
      'assignments',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  // 2. READ - Get all assignments
  Future<List<Assignment>> getAllAssignments() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'assignments',
    );
    return List.generate(maps.length, (i) {
      return Assignment.fromMap(maps[i]);
    });
  }

  // 3. READ - Get single assignment by ID
  Future<Assignment?> getAssignment(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Assignment.fromMap(maps.first);
    }
    return null;
  }

  // 4. READ - Get upcoming assignments (not completed and due in future)
  Future<List<Assignment>> getUpcomingAssignments() async {
    final now = DateTime.now().toIso8601String();
    final maps = await _database.query(
      'assignments',
      where: 'dueDate > ? AND status = 0',
      whereArgs: [now],
      orderBy: 'dueDate ASC',
    );
    return maps.map((map) => Assignment.fromMap(map)).toList();
  }

  // 5. READ - Get assignments for specific course
  Future<List<Assignment>> getAssignmentsByCourse(String courseCode) async {
    final maps = await _database.query(
      'assignments',
      where: 'classCode = ?',
      whereArgs: [courseCode],
      orderBy: 'dueDate ASC',
    );
    return maps.map((map) => Assignment.fromMap(map)).toList();
  }

  // 6. UPDATE - Modify existing assignment
  Future<int> updateAssignment(Assignment assignment) async {
    return await _database.update(
      'assignments',
      assignment.toMap(),
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  // 7. UPDATE - Mark assignment as complete/incomplete
  Future<int> updateAssignmentStatus(int id, int status) async {
    return await _database.update(
      'assignments',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 8. DELETE - Remove assignment
  Future<int> deleteAssignment(int id) async {
    return await _database.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 9. DELETE - Remove all assignments for a course
  Future<int> deleteAssignmentsByCourse(String courseCode) async {
    return await _database.delete(
      'assignments',
      where: 'classCode = ?',
      whereArgs: [courseCode],
    );
  }
}
