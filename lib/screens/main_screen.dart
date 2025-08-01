import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/data/notification.dart';
import 'package:academi_kit/models/class.dart';
import 'package:academi_kit/providers/course_provider.dart';
import 'package:academi_kit/widgets/add_assignment.dart';
import 'package:academi_kit/widgets/add_quiz.dart';
import 'package:academi_kit/widgets/card_list.dart';
import 'package:academi_kit/widgets/summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  void add_assi(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return AddAssignment();
      },
    );
  }

  Future<void> add_exam(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,

      context: context,
      builder: (context) {
        return FocusScope(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddQuiz(),
          ),
        );
      },
    );
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
                  onPressed: () {
                    // NotificationService().showNotification(
                    //   id: 1,
                    //   title: 'Quick Note',
                    //   body: 'This is a quick note reminder.',
                    // );
                    NotificationService()
                        .scheduleNotification(
                          id: 2,
                          title: 'Quiz stf',
                          body: 'You have a quiz scheduled for ',
                          scheduledDate: DateTime.now().add(
                            const Duration(seconds: 5),
                          ),
                        )
                        .then((value) {
                          print('Notification scheduled successfully');
                        })
                        .catchError((error) {
                          print('Error scheduling notification: $error');
                        });
                    NotificationService().getPendingNotifications();
                    // NotificationService().scheduleNotification(
                    //   id: 3,
                    //   scheduledDate: DateTime.now().add(
                    //     const Duration(seconds: 5),
                    //   ),
                    //   title: 'dsdsdsd',
                    //   body: 'ddsdsd',
                    // );
                  },
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
