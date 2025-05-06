import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
class HomePage extends StatelessWidget {
  void startWorkout() {
    FirebaseFirestore.instance.collection('workouts').add({
      'type': "HIIT Cardio",
      'startedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Ali")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Today's Workout: HIIT Cardio"),
            ElevatedButton(
              onPressed: startWorkout,
              child: Text("Start Workout"),
            ),
            SizedBox(height: 16),
            Text("Calories Consumed: 1250"),
            SizedBox(height: 8),
            Text("Steps: 4500 | 35 Min | 2.4 km"),
            SizedBox(height: 8),
            Text("Quote: Push yourself, no one else is going to do it for you."),
          ],
        ),
      ),
    );
  }
}