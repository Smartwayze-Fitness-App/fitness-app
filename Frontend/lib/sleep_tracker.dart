import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SleepTracker extends StatelessWidget {
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