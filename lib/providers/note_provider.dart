import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import './note_repo.dart';
import './course_provider.dart';

// Repository Provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final db = ref.read(courseDatabaseProvider);
  return NoteRepository(db.database);
});

// Main State Provider
final notesProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>((ref) {
      final repository = ref.read(noteRepositoryProvider);
      return NotesNotifier(repository);
    });

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NoteRepository _repo;

  NotesNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadNotes();
  }
  Future<void> loadNotes() async {
    state = const AsyncValue.loading();
    try {
      final notes = await _repo.getAllNotes();
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _repo.createNote(note);
      await loadNotes();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Derived Providers
final classNotesProvider = Provider.family<List<Note>, String>((
  ref,
  classCode,
) {
  final notes = ref.watch(notesProvider).value ?? [];
  return notes.where((n) => n.classCode == classCode).toList();
});
