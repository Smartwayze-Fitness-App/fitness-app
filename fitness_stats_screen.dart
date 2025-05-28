import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FitnessStatsScreen extends StatefulWidget {
  @override
  State<FitnessStatsScreen> createState() => _FitnessStatsScreenState();
}

class _FitnessStatsScreenState extends State<FitnessStatsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _workoutsController = TextEditingController();
  final TextEditingController _weightChangeController = TextEditingController();

  List<TextEditingController> _intensityControllers =
  List.generate(7, (_) => TextEditingController());

  double calories = 0;
  int workouts = 0;
  double weightChange = 0;

  List<FlSpot> workoutData = [];

  @override
  void initState() {
    super.initState();
    _fetchStatsFromFirebase();
  }

  Future<void> _fetchStatsFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('fitness_stats')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          calories = (data['calories'] ?? 0).toDouble();
          workouts = data['workouts'] ?? 0;
          weightChange = (data['weightChange'] ?? 0).toDouble();
          if (data['weeklyIntensity'] != null) {
            workoutData = List<double>.from(data['weeklyIntensity'])
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList();
          } else {
            workoutData = List.generate(7, (i) => FlSpot(i.toDouble(), 0));
          }
        });
      }
    }
  }

  Future<void> _submitStats() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        calories = double.parse(_caloriesController.text);
        workouts = int.parse(_workoutsController.text);
        weightChange = double.parse(_weightChangeController.text);
      });

      List<double> weeklyIntensity = _intensityControllers
          .map((controller) => double.tryParse(controller.text) ?? 0.0)
          .toList();

      workoutData = weeklyIntensity
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
          .toList();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('fitness_stats')
              .doc(user.uid)
              .set({
            'calories': calories,
            'workouts': workouts,
            'weightChange': weightChange,
            'weeklyIntensity': weeklyIntensity,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fitness stats saved with graph data!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save stats: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF6),
      appBar: AppBar(
        title: const Text("Weekly Fitness Stats", style: TextStyle(
          color: Color(0xFF1E5631),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        )),
        backgroundColor: const Color(0xFFF5FFF6),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter This Week's Stats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _caloriesController,
                    decoration: const InputDecoration(labelText: 'Calories Burned (kcal)'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _workoutsController,
                    decoration: const InputDecoration(labelText: 'Workouts Completed'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _weightChangeController,
                    decoration: const InputDecoration(labelText: 'Weight Change (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text("Daily Workout Intensity (0-10)", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Column(
                    children: List.generate(7, (index) {
                      return TextFormField(
                        controller: _intensityControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Day ${index + 1}'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitStats,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E5631), // Dark green color
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Save Weekly Fitness Stats",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),


                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildStatCard("Calories Burned", "${calories.toStringAsFixed(1)} kcal", Icons.local_fire_department),
            const SizedBox(height: 12),
            _buildStatCard("Workouts Completed", "$workouts", Icons.fitness_center),
            const SizedBox(height: 12),
            _buildStatCard("Weight Change", "${weightChange.toStringAsFixed(1)} kg", Icons.monitor_weight),
            const SizedBox(height: 24),
            _buildLineChart(),
            const SizedBox(height: 24),
            _buildSummary(),
            const SizedBox(height: 24),
            _buildMotivationalWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Color(0xFF50C878)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Workout Intensity',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
              axisNameSize: 24,
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Text(days[value.toInt()]);
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
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: workoutData,
              isCurved: true,
              barWidth: 4,
              color: const Color(0xFF50C878),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}

// Leave your _buildSummary() and _buildMotivationalWidget() methods unchanged.
Widget _buildSummary() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFDFF5E1),
      border: Border.all(),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 16,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: const Text(
      "Progress happens one workout at a time. Stay consistent, stay strong, and trust the journey.",
      style: TextStyle(fontSize: 16),
    ),
  );
}

Widget _buildMotivationalWidget() {
  final List<String> quoteImages = [
    'assets/img_1.png',
    "assets/img_2.png",
    "assets/img_3.png",
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