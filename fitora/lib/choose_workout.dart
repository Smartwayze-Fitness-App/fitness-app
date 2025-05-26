import 'package:flutter/material.dart';

class ChooseWorkoutScreen extends StatelessWidget {
  const ChooseWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Workout')),
      body: Center(
        child: Text(
          'This is the Choose Workout Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
