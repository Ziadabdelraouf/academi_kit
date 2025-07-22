import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academi_kit/models/assignment.dart';
import 'package:academi_kit/providers/assignemnt_repo.dart';
import 'package:academi_kit/providers/course_provider.dart';

// Provider for assignment database operations
final assignmentDbProvider = Provider<AssignmentRepository>((ref) {
  // Assuming your database is already initialized elsewhere
  final db = ref.read(
    courseDatabaseProvider,
  ); // Your existing database provider
  return AssignmentRepository(db.database);
});

// StateNotifier for assignment management
class AssignmentNotifier extends StateNotifier<AsyncValue<List<Assignment>>> {
  final AssignmentRepository _repository;

  AssignmentNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    state = const AsyncValue.loading();
    try {
      final assignments = await _repository.getAllAssignments();
      state = AsyncValue.data(assignments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAssignment(Assignment assignment) async {
    try {
      await _repository.insertAssignment(assignment);
      await loadAssignments(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAssignment(Assignment assignment) async {
    try {
      await _repository.updateAssignment(assignment);
      await loadAssignments(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAssignment(int id) async {
    try {
      await _repository.deleteAssignment(id);
      await loadAssignments(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<Assignment>> getUpcomingAssignments() async {
    final assignments = state.value ?? [];
    final now = DateTime.now();
    return assignments.where((a) => a.dueDate.isAfter(now)).toList();
  }

  Future<List<Assignment>> getAssignmentsForCourse(String courseCode) async {
    final assignments = state.value ?? [];
    return assignments.where((a) => a.classCode == courseCode).toList();
  }
}

// StateNotifier provider
final assignmentProvider =
    StateNotifierProvider<AssignmentNotifier, AsyncValue<List<Assignment>>>((
      ref,
    ) {
      final repository = ref.read(assignmentDbProvider);
      return AssignmentNotifier(repository);
    });

// Derived providers
final upcomingAssignmentsProvider =
    Provider<({List<Assignment> upcoming, int total, int completed})>((ref) {
      final assignments = ref.watch(assignmentProvider).value ?? [];
      final now = DateTime.now();

      final upcoming = assignments
          .where((a) => a.dueDate.isAfter(now))
          .toList();
      final completed = upcoming.where((a) => a.status == 2).length;

      return (upcoming: upcoming, total: upcoming.length, completed: completed);
    });
final courseAssignmentsProvider = Provider.family<List<Assignment>, String>((
  ref,
  courseCode,
) {
  final assignments = ref.watch(assignmentProvider).value ?? [];
  return assignments.where((a) => a.classCode == courseCode).toList();
});
