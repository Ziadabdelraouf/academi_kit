import 'package:academi_kit/data/Calendar.dart';
import 'package:academi_kit/data/app_color.dart';
import 'package:academi_kit/data/database.dart';
import 'package:academi_kit/data/remote.dart';
import 'package:academi_kit/models/class.dart';
import 'package:academi_kit/providers/provider.dart';
import 'package:academi_kit/screens/start_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();

  // Initialize the database
  final database = await ClassDatabase.init();
  runApp(
    ProviderScope(
      overrides: [classDatabaseProvider.overrideWithValue(database)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AcademiKit',
      theme: ThemeData(
        primaryColor: AppColors.charcoal,
        scaffoldBackgroundColor: AppColors.darkGrey,
        cardColor: AppColors.darkGrey,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.lightGrey),
          labelLarge: TextStyle(color: AppColors.offWhite),
        ),
        iconTheme: IconThemeData(color: AppColors.mediumGrey),
      ),
      debugShowCheckedModeBanner: false,
      home: Startscreen(),
    );
  }
}
