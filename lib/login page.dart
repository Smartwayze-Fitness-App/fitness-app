import 'dart:convert';
import 'package:fitness_app/signup%20page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginScreen extends StatefulWidget {
  @override
  @override
  State<LoginScreen> createState() => _LoginScreenState(); //


}
  class _LoginScreenState extends State<LoginScreen>{
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
  Future<void> loginUser() async {
    final url = Uri.parse('https://web-production-d452.up.railway.app/login'); // Replace with actual server URL

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      // Save token using SharedPreferences or state
      print("Login success. Token: $token");
    } else {
      print("Login failed: ${response.body}");
    }
  }

    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF0),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top: Text + Girl Image
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left side: Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hello!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14452F),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF527B61),
                            ),
                          ),
                          Text(
                            'to Fitora',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF527B61),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right side: Girl image
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: Image.asset('asset/images/img_6.png'), // make sure this exists
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Email
                TextField(
                  controller:emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Password
                TextField(
                  obscureText: true,
                  controller:passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14452F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  ),
                  onPressed: () {
                    loginUser();
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign up row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account?",
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFF14452F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Icon (use actual multicolor logo)
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Image.asset(
                        'asset/images/img.png', // Replace with actual Google logo image
                        height: 22,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Facebook Icon
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Icon(
                        FontAwesomeIcons.facebookF,
                        size: 20,
                        color: Color(0xFF1877F2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}