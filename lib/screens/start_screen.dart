import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/data/dummy.dart';
import 'package:academi_kit/screens/calendar_screen.dart';
import 'package:academi_kit/screens/main_screen.dart';
import 'package:academi_kit/widgets/modal.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Startscreen extends StatefulWidget {
  const Startscreen({super.key});
  @override
  State<Startscreen> createState() {
    return _StartScreenState();
  }
}

class _StartScreenState extends State<Startscreen> {
  List<Widget> screens = [];
  int currentScreen = 0;
  @override
  void initState() {
    super.initState();
    screens = [MainScreen(), CalendarScreen()];
    currentScreen = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => addDummyData(context),
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            icon: Icon(Icons.add),
            color: AppColors.offWhite,
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: true,
                backgroundColor: AppColors.darkGrey,
                context: context,
                builder: (context) {
                  return Modal();
                },
              );
            },
          ),
        ],
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Academi",
                style: GoogleFonts.marckScript(
                  // fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: AppColors.offWhite,
                ),
              ),
              TextSpan(
                text: "Kit",
                style: GoogleFonts.marckScript(
                  // fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppColors.coolBlue,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.charcoal,
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: AppColors.charcoal,
        elevation: 8,
        activeColor: Colors.white,
        color: AppColors.offWhite,
        shadowColor: Colors.black.withOpacity(0.1),
        initialActiveIndex: 0,
        items: [
          TabItem(title: 'Home', icon: Icon(Icons.home)),
          TabItem(title: 'Calendar', icon: Icon(Icons.calendar_month_rounded)),
        ],
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
          print(currentScreen);
        },
      ),
      resizeToAvoidBottomInset: false,
      body: screens[currentScreen],
    );
  }
}
