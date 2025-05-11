import 'package:fitness_app/login%20page.dart';
import 'package:fitness_app/recepie%20screen.dart';
import 'package:fitness_app/signup%20page.dart';
import 'package:fitness_app/stretching&recovery.dart';
import 'package:fitness_app/user_profile_screen.dart';
import 'package:flutter/material.dart';

import 'Calorie Counter Screen.dart';
import 'fitness_stats_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FitnessApp",
      home: UserProfileScreen(),
    );
  }}

