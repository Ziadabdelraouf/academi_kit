import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/providers/assignment_provider.dart';
import 'package:academi_kit/providers/course_provider.dart';
import 'package:academi_kit/providers/exam_provider.dart';
import 'package:academi_kit/screens/course_details.dart';
import 'package:academi_kit/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardList extends ConsumerWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(classNotifierProvider);

    return classesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (classes) {
        return ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classItem = classes[index];
            return Card(
              color: AppColors.lightGrey,
              child: ListTile(
                splashColor: AppColors.coolBlue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CourseDetails()),
                  );
                },
                onLongPress: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete Class'),
                        content: Text(
                          'Are you sure you want to delete this class?',
                        ),
                        actions: [
                          TextButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  print('Editing class: ${classItem.toMap()}');
                                  return Modal(reClass: classItem);
                                },
                              );
                            },
                            label: Text(
                              'Edit instead',
                              style: TextStyle(color: AppColors.coolBlue),
                            ),
                            icon: Icon(Icons.edit, color: AppColors.coolBlue),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(classNotifierProvider.notifier)
                                  .deleteClass(classItem.code, context);
                              ref.invalidate(assignmentProvider);
                              ref.invalidate(examProvider);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(color: AppColors.coolBlue),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                title: Text(classItem.name),
                leading: CircleAvatar(
                  backgroundColor: AppColors.coolBlue,
                  child: Text(
                    classItem.code.substring(0, 3).toUpperCase(),
                    style: TextStyle(color: AppColors.offWhite),
                  ),
                ),
                trailing: Text(
                  '${classItem.credits} credits',
                  style: TextStyle(color: AppColors.offWhite),
                ),
                subtitle: Text(
                  'Assignments: ${classItem.assignmentsCount} | Exams: ${classItem.examsCount}',
                  style: TextStyle(color: AppColors.darkGrey),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
