import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        SizedBox(height: 10),

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
                  onPressed: () {},
                  icon: Icon(Icons.note_add),
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(AppColors.offWhite),
                  ),
                  label: Text("Add Quiz"),
                  onPressed: () {},
                  icon: Icon(Icons.quiz_rounded),
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(AppColors.offWhite),
                  ),
                  label: Text('Add Assignment'),
                  onPressed: () {},
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
