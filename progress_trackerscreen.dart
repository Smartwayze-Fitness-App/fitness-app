import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progress Tracker',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF14452F),
                ),
              ),
              const SizedBox(height: 24),

              // Circular indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _circleProgress(
                    label: 'Weight',
                    valueText: '-2',
                    unit: 'kg',
                    percentage: 0.85,
                    primaryColor: Color(0xFF14452F),
                    secondaryColor: Color(0xFFAED6B3),
                    icon: Icons.fitness_center,
                  ),
                  _circleProgress(
                    label: 'kcal',
                    valueText: '760',
                    unit: '',
                    percentage: 0.76,
                    primaryColor: Colors.orange,
                    secondaryColor: Colors.orange.shade100,
                    icon: Icons.local_fire_department,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Workout Completion Bar
              const Text(
                'Workout completion',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.5,
                backgroundColor: Colors.green.shade100,
                valueColor: AlwaysStoppedAnimation(Color(0xFF14452F)),
                minHeight: 12,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('50%', style: TextStyle(fontWeight: FontWeight.w500)),
              ),

              const SizedBox(height: 24),

              // Line Chart (mock)
              SizedBox(
                height: 120,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            return Text(days[value.toInt() % 7],
                                style: TextStyle(fontSize: 12));
                          },
                          reservedSize: 24,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 5,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Color(0xFF14452F),
                        dotData: FlDotData(show: true),
                        spots: const [
                          FlSpot(0, 4),
                          FlSpot(1, 3),
                          FlSpot(2, 3.5),
                          FlSpot(3, 4),
                          FlSpot(4, 2.5),
                          FlSpot(5, 2),
                          FlSpot(6, 1.5),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Achievements Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.verified, color: Color(0xFF14452F)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Achievements\nCompleted 5 workouts',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom nav bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFF3FFF0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.bar_chart, size: 28, color: Color(0xFF14452F)),
              SizedBox(width: 24),
              Icon(Icons.calendar_today, size: 24, color: Color(0xFF14452F)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF14452F),
        child: const Icon(Icons.add, color: Colors.white), // White icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _circleProgress({
    required String label,
    required String valueText,
    required String unit,
    required double percentage,
    required Color primaryColor,
    required Color secondaryColor,
    required IconData icon,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                value: percentage,
                backgroundColor: secondaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                strokeWidth: 8,
              ),
            ),
            Column(
              children: [
                Text(
                  valueText,
                  style: TextStyle(
                    fontSize: 24, // Increased size
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(fontSize: 14, color: primaryColor),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
