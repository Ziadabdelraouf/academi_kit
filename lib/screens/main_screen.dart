import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/models/assignment.dart';
import 'package:academi_kit/models/class.dart';
import 'package:academi_kit/models/exam.dart';
import 'package:academi_kit/providers/assignment_provider.dart';
import 'package:academi_kit/providers/course_provider.dart';
import 'package:academi_kit/providers/exam_provider.dart';
import 'package:academi_kit/widgets/card_list.dart';
import 'package:academi_kit/widgets/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  void add_assi(BuildContext context) {
    Assignment assignment = Assignment(
      title: 'Assignment 1',
      description: 'Complete the first assignment',
      dueDate: DateTime.now().add(Duration(days: 3)),
      classCode: 'cs103',
      status: 0,
    );
    ProviderScope.containerOf(
      context,
    ).read(assignmentProvider.notifier).addAssignment(assignment);
  }

  Future<void> add_exam(BuildContext context) async {
    Exam exam = Exam(
      title: 'Midterm Exam',
      description: 'Midterm exam for Computer Science 101',
      examDate: DateTime.now().add(Duration(days: 7)),
      status: 0,
      classCode: 'cs103',
    );

    ProviderScope.containerOf(
      context,
    ).read(examProvider.notifier).addExam(exam);
  }

  Future<void> add_class(BuildContext context) async {
    Class c1 = Class(code: 'cs103', name: 'Computer Science 101', credits: 2);
    ProviderScope.containerOf(
      context,
    ).read(classNotifierProvider.notifier).addClass(c1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        SizedBox(height: 10),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.sizeOf(context).width * 0.95,
          height: MediaQuery.sizeOf(context).height * 0.25,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: GradientRotation(45),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.coolBlue, AppColors.charcoal],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: AssignSummary(),
        ),
        SizedBox(
          height: 100,
          child: Card.filled(
            margin: EdgeInsets.all(5),
            elevation: 2.5,
            color: AppColors.coolBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(AppColors.offWhite),
                  ),
                  label: Text("Quick note"),
                  onPressed: () => add_class(context),
                  icon: Icon(Icons.note_add),
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(AppColors.offWhite),
                  ),
                  label: Text("Add Quiz"),
                  onPressed: () => add_exam(context),
                  icon: Icon(Icons.quiz_rounded),
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(AppColors.offWhite),
                  ),
                  label: Text('Add Assignment'),
                  onPressed: () => add_assi(context),
                  icon: Icon(Icons.assignment_add),
                ),
              ],
            ),
          ),
        ),

        Expanded(child: CardList()),
      ],
    );
  }
}
