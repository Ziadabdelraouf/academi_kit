import 'package:academi_kit/providers/assignment_provider.dart';
import 'package:academi_kit/providers/course_provider.dart';
import 'package:academi_kit/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/class.dart';
import '../models/assignment.dart';
import '../models/exam.dart';

Future<void> addDummyData(BuildContext context) async {
  // 1. Create dummy classes
  final dummyClasses = [
    Class(code: 'CS101', name: 'Introduction to Computer Science', credits: 3),
    Class(code: 'MATH201', name: 'Linear Algebra', credits: 4),
    Class(code: 'PHYS102', name: 'Modern Physics', credits: 4),
  ];

  // 2. Create dummy assignments
  final dummyAssignments = [
    Assignment(
      classCode: 'CS101',
      title: 'Programming Assignment 1',
      description: 'Implement basic algorithms in Dart',
      dueDate: DateTime.now().add(const Duration(days: 7)),
    ),
    Assignment(
      classCode: 'CS101',
      title: 'Data Structures Project',
      description: 'Build a binary search tree implementation',
      dueDate: DateTime.now().add(const Duration(days: 14)),
    ),
    Assignment(
      classCode: 'MATH201',
      title: 'Linear Equations Homework',
      description: 'Solve systems of linear equations',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  // 3. Create dummy exams
  final dummyExams = [
    Exam(
      classCode: 'CS101',
      title: 'Midterm Exam',
      description: 'Covers chapters 1-5',
      examDate: DateTime.now().add(const Duration(days: 21)),
      status: 0,
    ),
    Exam(
      classCode: 'MATH201',
      title: 'Final Exam',
      description: 'Comprehensive exam',
      examDate: DateTime.now().add(const Duration(days: 30)),
      status: 0,
    ),
    Exam(
      classCode: 'PHYS102',
      title: 'Quantum Mechanics Quiz',
      description: 'Basic principles quiz',
      examDate: DateTime.now().add(const Duration(days: 5)),
      status: 0,
    ),
  ];

  // 4. Add to repositories through providers
  final classRepo = ProviderScope.containerOf(
    context,
  ).read(classNotifierProvider.notifier);
  final assignmentRepo = ProviderScope.containerOf(
    context,
  ).read(assignmentProvider.notifier);
  final examRepo = ProviderScope.containerOf(
    context,
  ).read(examProvider.notifier);

  // Add classes and update counts
  for (final classItem in dummyClasses) {
    await classRepo.addClass(classItem);
  }

  // Add assignments
  for (final assignment in dummyAssignments) {
    await assignmentRepo.addAssignment(assignment);
  }

  // Add exams
  for (final exam in dummyExams) {
    await examRepo.addExam(exam);
  }
}
