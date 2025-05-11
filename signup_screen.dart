import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back to login
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, size: 16, color: Colors.black87),
                    SizedBox(width: 4),
                    Text(
                      'Back to login',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sign Up heading
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14452F), // Dark green
                ),
              ),

              const SizedBox(height: 32),

              // Username
              TextField(
                decoration: inputFieldDecoration('Username', Icons.person_outline),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                decoration: inputFieldDecoration('Email', Icons.email_outlined),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                obscureText: true,
                decoration: inputFieldDecoration('Password', Icons.lock_outline),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextField(
                obscureText: true,
                decoration: inputFieldDecoration('Confirm Password', Icons.lock_outline),
              ),
              const SizedBox(height: 16),

              // Phone
              TextField(
                keyboardType: TextInputType.phone,
                decoration: inputFieldDecoration('Phone', Icons.phone_outlined),
              ),
              const SizedBox(height: 32),

              // Sign Up Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14452F),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Sign up logic
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // White text as per screenshot
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputFieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
