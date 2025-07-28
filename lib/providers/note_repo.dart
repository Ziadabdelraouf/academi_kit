import 'package:sqflite/sqflite.dart';
import 'package:academi_kit/models/note.dart';

class NoteRepository {
  final Database _database;

  NoteRepository(this._database);

  Future<int> createNote(Note note) async {
    final map = note.toMap()..remove('id');
    return await _database.insert('notes', map);
  }

  Future<List<Note>> getNotesByClass(String classCode) async {
    final maps = await _database.query(
      'notes',
      where: 'classCode = ?',
      whereArgs: [classCode],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    return await _database.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    return await _database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteNotesByClass(String classCode) async {
    return await _database.delete(
      'notes',
      where: 'classCode = ?',
      whereArgs: [classCode],
    );
  }

  Future<List<Note>> getAllNotes() async {
    final maps = await _database.query('notes', orderBy: 'createdAt DESC');
    return maps.map((map) => Note.fromMap(map)).toList();
  }
}
