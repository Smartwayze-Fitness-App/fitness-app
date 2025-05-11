import 'package:flutter/material.dart';
import 'package:untitled/Achievements_screen.dart';
import 'package:untitled/exercise_library.dart';
import 'package:untitled/meal_planscreen.dart';
import 'package:untitled/workout_plan_screen.dart';
import 'community_challengescreen.dart';
import 'progress_trackerscreen.dart';  // Import the screen you created

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitora Fitness App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF14452F)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3FFF0),
        fontFamily: 'SansSerif',
      ),
      debugShowCheckedModeBanner: false,
      home:  MealPlansScreen(), // Set the Progress Tracker as home
    );
  }
}
