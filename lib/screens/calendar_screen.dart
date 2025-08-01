import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/widgets/assignment_list.dart';
import 'package:academi_kit/widgets/quiz_list.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              color: AppColors.darkGrey,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.96,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Upcoming Assignments',
                          style: TextStyle(
                            color: AppColors.offWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(child: AssignmentsList()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.darkGrey,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.96,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Upcoming Quizzes',
                          style: TextStyle(
                            color: AppColors.offWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(child: QuizList()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.note_alt, size: 24),
              style: ButtonStyle(
                elevation: WidgetStateProperty.all(5),
                backgroundColor: WidgetStateProperty.all(AppColors.charcoal),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                fixedSize: WidgetStateProperty.all(
                  Size(MediaQuery.sizeOf(context).width * 0.9, 70),
                ),
                foregroundColor: WidgetStateProperty.all(AppColors.offWhite),
              ),
              label: Text('View Notes'),
            ),
          ],
        );
      },
    );
  }
}
