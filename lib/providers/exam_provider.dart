import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academi_kit/models/exam.dart';
import 'package:academi_kit/providers/exam_repo.dart';
import 'package:academi_kit/providers/course_provider.dart';

// Provider for exam database operations
final examDbProvider = Provider<ExamRepository>((ref) {
  final db = ref.read(courseDatabaseProvider);
  return ExamRepository(db.database);
});

// StateNotifier for exam management
class ExamNotifier extends StateNotifier<AsyncValue<List<Exam>>> {
  final ExamRepository _repository;

  ExamNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadExams();
  }

  Future<void> loadExams() async {
    state = const AsyncValue.loading();
    try {
      final exams = await _repository.getAllExams();
      state = AsyncValue.data(exams);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addExam(Exam exam) async {
    try {
      await _repository.insertExam(exam);
      await loadExams(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateExam(Exam exam) async {
    try {
      await _repository.updateExam(exam);
      await loadExams(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExam(int id) async {
    try {
      await _repository.deleteExam(id);
      await loadExams(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<Exam>> getUpcomingExams() async {
    final exams = state.value ?? [];
    final now = DateTime.now();
    return exams.where((e) => e.examDate.isAfter(now)).toList();
  }

  Future<List<Exam>> getExamsForCourse(String courseCode) async {
    final exams = state.value ?? [];
    return exams.where((e) => e.classCode == courseCode).toList();
  }
}

// StateNotifier provider
final examProvider =
    StateNotifierProvider<ExamNotifier, AsyncValue<List<Exam>>>((ref) {
      final repository = ref.read(examDbProvider);
      return ExamNotifier(repository);
    });

// Derived providers
final upcomingExamsProvider =
    Provider<({List<Exam> upcoming, int total, int completed})>((ref) {
      final exams = ref.watch(examProvider).value ?? [];
      final now = DateTime.now();

      final upcoming = exams.where((e) => e.examDate.isAfter(now)).toList();
      final completed = upcoming.where((e) => e.status == 2).length;

      return (upcoming: upcoming, total: upcoming.length, completed: completed);
    });

final courseExamsProvider = Provider.family<List<Exam>, String>((
  ref,
  courseCode,
) {
  final exams = ref.watch(examProvider).value ?? [];
  return exams.where((e) => e.classCode == courseCode).toList();
});
