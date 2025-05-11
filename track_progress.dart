import 'package:flutter/material.dart';

class TrackProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed the title here
        backgroundColor: Color(0xFFF3FFF0),  // Match the background color with the screen
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF3FFF0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Track Progress Illustration with adjusted size and rounded corners
              Container(
                width: 220, // Adjust width to a more appropriate size
                height: 300, // Adjust height to fit the content well
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/workout.png'), // Replace with your image asset
                    fit: BoxFit.contain, // Ensures the image is contained within the box
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Title Text
              Text(
                'Track Your Progress',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003C1A),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Subtitle Text
              Text(
                'Monitor your activity and improvements',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Arrow button
              GestureDetector(
                onTap: () {
                  // Action when the user clicks the arrow (Optional)
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
