import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class FitnessStatsScreen1 extends StatefulWidget {
  @override
  State<FitnessStatsScreen1> createState() => _FitnessStatsScreenState();
}

class _FitnessStatsScreenState extends State<FitnessStatsScreen1> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  final _weightChangeController = TextEditingController();
  final _workoutsController = TextEditingController();

  List<FlSpot> workoutData = [];
  double weightChange = 0.0;
  int totalWorkouts = 0;
  double totalCalories = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _weightChangeController.dispose();
    _workoutsController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    setState(() => isLoading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday of current week
      final endOfWeek = startOfWeek.add(Duration(days: 6)); // Sunday of current week

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dailyWorkouts')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
          .orderBy('date')
          .get();

      // Initialize map for the entire week
      Map<int, Map<String, dynamic>> weeklyData = {};
      for (int i = 0; i < 7; i++) {
        weeklyData[i] = {
          'workouts': 0,
          'calories': 0.0,
          'weightChange': 0.0,
        };
      }

      // Process Firestore documents
      double weightSum = 0.0;
      int workoutSum = 0;
      double calorieSum = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final weekday = date.weekday - 1; // 0=Monday, 6=Sunday

        weeklyData[weekday] = {
          'workouts': data['workouts'] ?? 0,
          'calories': data['calories'] ?? 0.0,
          'weightChange': data['weightChange'] ?? 0.0,
        };
        workoutSum += int.tryParse(data['workouts'].toString()) ?? 0;
        calorieSum += double.tryParse(data['calories'].toString()) ?? 0.0;
        weightSum += double.tryParse(data['weightChange'].toString()) ?? 0.0;

        /*weightSum += (data['weightChange'] as num).toDouble();
        workoutSum += (data['workouts'] as num).toInt();
        calorieSum += (data['calories'] as num).toDouble();*/
      }

      // Prepare chart data
      List<FlSpot> spots = [];
      for (int i = 0; i < 7; i++) {
        spots.add(FlSpot(i.toDouble(), (weeklyData[i]!['workouts'] as num).toDouble()));
      }

      setState(() {
        workoutData = spots;
        weightChange = weightSum;
        totalWorkouts = workoutSum;
        totalCalories = calorieSum;
        isLoading = false;
      });

    } catch (e) {
      print('Error loading stats: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _saveStats() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw "User not logged in";

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('dailyWorkouts')
          .doc(today.toIso8601String())
          .set({
        'date': Timestamp.fromDate(today),
        'workouts': int.parse(_workoutsController.text.trim()),
        'calories': double.parse(_caloriesController.text.trim()),
        'weightChange': double.parse(_weightChangeController.text.trim()),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stats saved successfully!')),
      );

      // Clear form and reload data
      _caloriesController.clear();
      _weightChangeController.clear();
      _workoutsController.clear();
      _loadStats();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF6),
      appBar: AppBar(
        title: Text(
          "Weekly Fitness Stats",
          style: TextStyle(
            color: Color(0xFF1E5631),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFFF5FFF6),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "This Week",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Summary Cards
              _buildSummaryCards(),
              SizedBox(height: 16),

              // Input Form
              Text("Enter today's stats:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),

              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Calories Burned'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter calories';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),

              SizedBox(height: 12),
              TextFormField(
                controller: _workoutsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number of Workouts'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter workout count';
                  if (int.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),

              SizedBox(height: 12),
              TextFormField(
                controller: _weightChangeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Weight Change (e.g., -1.5)'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter weight change';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),

              SizedBox(height: 24),
              _buildWorkoutChart(),
              SizedBox(height: 24),
              _buildMotivationalWidget(),
              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveStats,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E5631),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text("Save Today's Stats",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Calories', '${totalCalories.toStringAsFixed(0)}', Icons.local_fire_department)),
        SizedBox(width: 8),
        Expanded(child: _buildStatCard('Weight Change', '${weightChange.toStringAsFixed(1)} kg', Icons.monitor_weight)),
        SizedBox(width: 8),
        Expanded(child: _buildStatCard('Workouts', '$totalWorkouts', Icons.fitness_center)),
        SizedBox(width: 8),

      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Color(0xFF50C878)),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWorkoutChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(value.toInt().toString(),
                        style: TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Text(weekdays[value.toInt()],
                      style: TextStyle(fontSize: 12));
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: workoutData.isEmpty ? 5 : workoutData.map((e) => e.y).reduce(max).ceilToDouble() + 1,
          lineBarsData: [
            LineChartBarData(
              spots: workoutData,
              isCurved: true,
              barWidth: 4,
              color: const Color(0xFF50C878),
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                  show: true,
                  color: Color(0xFF50C878).withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalWidget() {
    final List<String> quoteImages = [
      'assets/images/img_1.png',
      "assets/images/img_2.png",
      "assets/images/img_3.png",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Motivational Quotes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        FlutterCarousel(
          options: FlutterCarouselOptions(
            height: 320,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 3),
          ),
          items: quoteImages.map((imgPath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}