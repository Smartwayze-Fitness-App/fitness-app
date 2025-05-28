import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled6/dashboardscreen.dart';
import 'package:untitled6/fitness_stats_screen.dart';
import 'package:untitled6/fitness_weekly%20stat.dart';
import 'package:untitled6/signup%20page.dart';


class LoginScreen extends StatefulWidget {
  @override
  @override
  State<LoginScreen> createState() => _LoginScreenState(); //


}
  class _LoginScreenState extends State<LoginScreen>{
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool isLoading = false;
    Future<void> loginUserwithfirebase() async {
      setState(() {
        isLoading = true;
      });

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      print("Trying login with email: $email and password: $password"); // Debug log

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful")),
        );

        // Navigate to dashboard
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } on FirebaseAuthException catch (e) {
        print("Firebase login error: ${e.code}"); // Debug log

        String message = "Login failed";
        if (e.code == 'user-not-found') {
          message = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          message = "Wrong password provided.";
        } else if (e.code == 'invalid-credential') {
          message = "Invalid email or password.";
        } else {
          message = e.message ?? message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }

      setState(() {
        isLoading = false;
      });
    }


    @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }
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
    Future<String> loginUser1(String email, String password) async {
      final url = Uri.parse('https://web-production-d452.up.railway.app/login'); // 🔁 replace with your actual API URL

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['userId']; // ✅ API should return a userId in response
      } else {
        throw Exception('Login failed: ${response.body}');
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
                  onPressed: () async{
                    try {
                      setState(() => isLoading = true);

                      await loginUserwithfirebase();
                      await loginUser();
                     String email = emailController.text.trim();
                     String password = passwordController.text.trim();
                      String userId= await loginUser1(email,password);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen(userId: userId)));

                  } catch(e){
                      print('Error :$e');
                    }

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