import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
class SleepTrackerPage extends StatelessWidget {
  final sleepTime = "11:00 PM";
  final wakeTime = "6:30 AM";

  void saveSleepData() {
    FirebaseFirestore.instance.collection('sleep_data').add({
      'sleep': sleepTime,
      'wake': wakeTime,
      'duration': '8 hr 30 min',
      'date': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sleep Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Sleep Time: $sleepTime"),
            Text("Wake Time: $wakeTime"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveSleepData,
              child: Text("Save Sleep Data"),
            ),
            SizedBox(height: 10),
            Text("You slept for 8 hr 30 min"),
          ],
        ),
      ),
    );
  }
}

class ReminderPage extends StatelessWidget {
  void markDone(String task) {
    FirebaseFirestore.instance.collection('reminders_done').add({
      'task': task,
      'completedAt': DateTime.now().toIso8601String(),
    });
  }

  Widget reminderCard(String title, String subtitle, String time) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text("$subtitle\nTime: $time"),
        trailing: ElevatedButton(
          onPressed: () => markDone(title),
          child: Text("Done"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Today's Reminders")),
      body: ListView(
        children: [
          reminderCard("Workout Reminder", "Leg Day", "6:00 PM"),
          reminderCard("Water Reminder", "Drink Water", "2:00 PM"),
          reminderCard("Meal Reminder", "Track Lunch", "12:00 PM"),
        ],
      ),
    );
  }
}