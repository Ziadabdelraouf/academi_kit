import 'package:academi_kit/data/database.dart';
import 'package:academi_kit/models/class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Database Provider
final courseDatabaseProvider = Provider<CourseDatabase>((ref) {
  return CourseDatabase();
});

// StateNotifier for Class Management
class ClassNotifier extends StateNotifier<AsyncValue<List<Class>>> {
  final CourseDatabase _database;

  ClassNotifier(this._database) : super(const AsyncValue.loading()) {
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    state = const AsyncValue.loading();
    try {
      final classes = await _database.fetchClasses();
      state = AsyncValue.data(classes);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addClass(Class class_) async {
    print('-------------------------------------------');
    print(class_.toMap());
    print('-------------------------------------------');
    await _database.insertClass(class_);
    await fetchClasses(); // Refresh state
  }

  Future<void> updateClass(Class class_, String oldCode) async {
    await _database.updateClass(class_, oldCode);
    await fetchClasses(); // Refresh state
  }

  Future<void> deleteClass(String code, BuildContext context) async {
    await _database.deleteClass(code);
    await fetchClasses(); // Refresh state
  }
}

// StateNotifier Provider
final classNotifierProvider =
    StateNotifierProvider<ClassNotifier, AsyncValue<List<Class>>>((ref) {
      final database = ref.read(courseDatabaseProvider);
      return ClassNotifier(database);
    });
