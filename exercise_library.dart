import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'exercise_detail_screen.dart'; // Import the new screen

class ExerciseLibraryScreen extends StatefulWidget {
  @override
  _ExerciseLibraryScreenState createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final Color lightGreen = const Color(0xFFEAF3E6);
  final Color green = const Color(0xFF265C2F);

  List exercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    final Uri url = Uri.parse("https://taheera12.pythonanywhere.com/exercises");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          exercises = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load exercises");
      }
    } catch (e) {
      print("Error fetching exercises: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Exercise Library",
          style: TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        iconTheme: IconThemeData(color: green),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: green))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: exercises.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseDetailScreen(
                      name: exercise["name"] ?? "",
                    ),
                  ),
                );
              },
              child: _buildExerciseCard(exercise["name"] ?? ""),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExerciseCard(String name) {
    String imagePath;
    switch (name.toLowerCase()) {
      case 'cardio blast':
        imagePath = 'assets/cardio.jpg';
        break;
      case 'strength training':
        imagePath = 'assets/dumbell.png';
        break;
      case 'yoga flow':
        imagePath = 'assets/yoga.jpg';
        break;
      case 'hiit burn':
        imagePath = 'assets/hiit.jpg';
        break;
      case 'flexibility boost':
        imagePath = 'assets/flexibility.jpg';
        break;
      case 'pilates core':
        imagePath = 'assets/pilates.png';
        break;
      default:
        imagePath = 'assets/dumbell.png';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              color: lightGreen,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: green,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
