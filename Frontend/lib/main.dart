import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/home_screen.dart';
import 'todays_reminder.dart';
import 'sleep_tracker.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await
  Firebase.initializeApp(); // Firebase initialization
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Add this line

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SleepTracker(),
    );
  }
}


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = [
    HomePage(),
    ReminderPage(),
    SleepTracker(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.bed), label: 'Sleep'),
        ],
      ),
    );
  }
}