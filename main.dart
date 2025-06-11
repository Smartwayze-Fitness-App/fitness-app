import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app3/homescreen.dart';
import 'dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app3/reminder_screen.dart';
import 'package:fitness_app3/exercise_library.dart';
import 'package:fitness_app3/meditation_timer.dart';
import 'package:fitness_app3/sleep_tracker.dart';
import 'package:fitness_app3/stretching&recovery.dart';
import 'login_page.dart';
import 'user_profile_screen.dart';
import 'Achievements_screen.dart';
import 'Calorie Counter Screen.dart';
import 'fitness_stats_screen.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD7UI2S-Nn0HdniOeew1bi3ij58oMsS9Pg",
      appId: "1:323468451401:android:12a1a09bc52d5c9fe06998",
      messagingSenderId: "323468451401",
      projectId: "fitness-app-bba1b",
    ),
  );

  // Initialize Timezone (for local notifications)
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FitnessApp",
      home: DashboardScreen(userId: 'demo-user'),
    );
  }
}
