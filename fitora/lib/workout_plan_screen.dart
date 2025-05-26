import 'package:flutter/material.dart';

class WorkoutPlansScreen extends StatelessWidget {
  final Color lightGreen = const Color(0xFFEAF3E6);
  final Color green = const Color(0xFF265C2F);

  const WorkoutPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Workout Plans",
          style: TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        iconTheme: IconThemeData(color: green),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/workout.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8), // Reduced the space here
              Center(
                child: Text(
                  "Stay consistent, push your limits,\nand achieve your fitness goals!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: green,
                  ),
                ),
              ),
              const SizedBox(height: 16), // Reduced the space here as well
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildOption(Icons.add_box, "Pre-built\nPlans"),
                  _buildOption(Icons.edit, "Custom\nWorkouts"),
                  _buildOption(Icons.grid_view, "Workout\nCategories"),
                  _buildOption(Icons.show_chart, "Progress\nTracker"),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Featured Plans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: green,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildPlanCard("Strength Training", "Weight Gain", "assets/strength.png"),
                    _buildPlanCard("Cardio", "4 Weeks\nWeight Loss", "assets/cardio.png"),
                    _buildPlanCard("Flexibility", "2 Weeks\nWeight Loss", "assets/flexibility.png"),
                    _buildPlanCard("HIIT", "2 Weeks\nWeight Loss", "assets/hiit.png"),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.add, size: 24),
                  label: Text("Create Custom Workout", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Progress Tracking',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: green),
              ),
              const SizedBox(height: 8),
              Text(
                '4 hrs this Week',
                style: TextStyle(fontSize: 16, color: green),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                width: double.infinity,
                child: CustomPaint(
                  painter: _BarChartPainter(green: green),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Filter", style: TextStyle(color: green)),
                  Text("Focus", style: TextStyle(color: green)),
                  Text("Time", style: TextStyle(color: green)),
                  Text("Equipment", style: TextStyle(color: green)),
                  Text("Most", style: TextStyle(color: green)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFD8EDD0),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.green[800]),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildPlanCard(String title, String subtitle, String imagePath) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final Color green;

  _BarChartPainter({required this.green});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = green;
    final barWidth = size.width / 7;
    final barHeights = [40.0, 60.0, 50.0, 70.0, 30.0, 20.0, 55.0];

    for (int i = 0; i < 7; i++) {
      final left = i * barWidth + 2;
      final top = size.height - barHeights[i];
      final right = left + barWidth - 4;
      final bottom = size.height;
      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
