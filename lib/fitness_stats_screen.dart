import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
class FitnessStatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF5FFF6),
      appBar: AppBar(

        title:  Text("Weekly Fitness Stats",style: TextStyle(
          color: Color(0xFF1E5631),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),),
        backgroundColor: const Color(0xFFF5FFF6),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "This Week",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStatCard("Calories Burned", "3600 kcal", Icons.local_fire_department),
          const SizedBox(height: 12),
          _buildStatCard("Workouts Completed", "5", Icons.fitness_center),
          const SizedBox(height: 12),
          _buildStatCard("Weight Change", "-1.5 kg", Icons.monitor_weight),
          const SizedBox(height: 24),
          _buildLineChartPlaceholder(),
          const SizedBox(height: 24),
          _buildSummary(),
          const SizedBox(height: 24),
          _buildMotivationalWidget(),
        ],
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

  final List<FlSpot> workoutData = [
    FlSpot(0, 1), // Monday: 1 workout
    FlSpot(1, 0), // Tuesday: 0
    FlSpot(2, 2), // Wednesday: 2
    FlSpot(3, 1), // Thursday
    FlSpot(4, 1), // Friday
    FlSpot(5, 0), // Saturday
    FlSpot(6, 3), // Sunday
  ];


  Widget _buildLineChartPlaceholder() {
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
              axisNameWidget: Padding(padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Workout Intensity',style:TextStyle(fontSize: 12,
                 fontWeight: FontWeight.bold,
                  color: Colors.black)),),
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
          maxY: 3,
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
      'asset/images/img_1.png',
      "asset/images/img_2.png",
      "asset/images/img_3.png",

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
          options:FlutterCarouselOptions(
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



