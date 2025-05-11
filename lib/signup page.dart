
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
                                                                                                                                                                                       import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
@override
void dispose() {
  nameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();
  contactController.dispose();
  super.dispose();
}
  Future<void> signupUser() async {
    print('SignUp button pressed'); // Debug print

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final url = Uri.parse('https://web-production-d452.up.railway.app/register');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "confirm_password":confirmPasswordController.text.trim(),
        "contact": contactController.text.trim(),
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${response.body}")),
      );
    }
  }

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
                controller: nameController,
                decoration: inputFieldDecoration('Username', Icons.person_outline),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                decoration: inputFieldDecoration('Email', Icons.email_outlined),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: inputFieldDecoration('Password', Icons.lock_outline),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: inputFieldDecoration('Confirm Password', Icons.lock_outline),
              ),
              const SizedBox(height: 16),

              // Phone
              TextField(
                controller: contactController,
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
                    signupUser();
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