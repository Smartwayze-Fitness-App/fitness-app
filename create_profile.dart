import 'package:flutter/material.dart';
import 'choose_workout.dart';

class CreateProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FFF0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.center,  // Center the content horizontally
            children: [
              // Image of the user profile creation screen
              Image.asset(
                'assets/create.png',
                height: 220,
                width: double.infinity, // Ensure it uses the full width
                fit: BoxFit.contain,  // Adjust the image to fit the container
              ),
              SizedBox(height: 30),
              // Main title text
              Text(
                'Create Your\nProfile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003C1A),
                ),
              ),
              SizedBox(height: 12),
              // Subtitle text
              Text(
                'Set up your personal info\nand preferences',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 40),
              // Arrow button to navigate
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseWorkoutScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDFFFE6),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 28,
                    color: Color(0xFF003C1A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
