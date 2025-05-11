import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CommunityChallengeScreen extends StatefulWidget {
  @override
  State<CommunityChallengeScreen> createState() => _CommunityChallengeScreenState();
}

class _CommunityChallengeScreenState extends State<CommunityChallengeScreen> {
  final Color lightGreen = const Color(0xFFEAF3E6);
  final Color green = const Color(0xFF265C2F);
  final Color orange = Colors.orange;

  bool _isLoading = true;
  List<Map<String, dynamic>> topUsers = [];
  List<Map<String, dynamic>> leaderboard = [];

  int steps = 0;
  DateTime lastUpdated = DateTime.now();
  Timer? _timer;

  List<int> dailySteps = [3000, 4500, 5000, 7000, 6500, 8500, 9200];

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        steps += 100;
        lastUpdated = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      topUsers = [
        {"name": "Sarah", "progress": 95},
        {"name": "Ali", "progress": 90},
        {"name": "Zara", "progress": 88},
      ];
      leaderboard = [
        {"name": "User 4", "progress": 78},
        {"name": "User 5", "progress": 65},
        {"name": "User 6", "progress": 50},
        {"name": "User 7", "progress": 42},
        {"name": "User 8", "progress": 38},
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Community Challenge", style: TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 28)),
        iconTheme: IconThemeData(color: green),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChallengeTitle("🏃 7-Day Step Challenge"),
              const SizedBox(height: 24),
              _buildSectionTitle("Your Progress"),
              const SizedBox(height: 12),
              _buildProgressTracker("Rank: 5", 65),
              const SizedBox(height: 24),
              _buildSectionTitle("Progress Chart"),
              const SizedBox(height: 12),
              _buildLineChart(),
              const SizedBox(height: 24),
              _buildSectionTitle("Daily Goal Tracker"),
              const SizedBox(height: 12),
              _buildDailyGoalTracker(),
              const SizedBox(height: 24),
              _buildSectionTitle("Challenges"),
              const SizedBox(height: 12),
              _buildInteractiveCards(),
              const SizedBox(height: 24),
              _buildSectionTitle("Top Performers"),
              const SizedBox(height: 12),
              _buildTopUsers(),
              const SizedBox(height: 24),
              _buildSectionTitle("Leaderboard"),
              const SizedBox(height: 12),
              _buildLeaderboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [green, Colors.green.shade400]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Center(
        child: Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: green, letterSpacing: 1.2));
  }

  Widget _buildProgressTracker(String rankLabel, int percentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.emoji_events, color: orange, size: 28),
          const SizedBox(width: 10),
          Text(rankLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: green)),
        ]),
        const SizedBox(height: 12),
        Text("Steps: $steps", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: green)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(green),
          minHeight: 12,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 8),
        Text("$percentage% Completed", style: TextStyle(color: green, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text("Last Updated: ${lastUpdated.hour.toString().padLeft(2, '0')}:${lastUpdated.minute.toString().padLeft(2, '0')}:${lastUpdated.second.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ]),
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      padding: const EdgeInsets.all(16),
      child: LineChart(LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
          return Text(["M", "T", "W", "T", "F", "S", "S"][value.toInt()], style: TextStyle(fontSize: 12));
        }, interval: 1))),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(dailySteps.length, (i) => FlSpot(i.toDouble(), dailySteps[i] / 1000)),
            isCurved: true,
            barWidth: 3,
            color: green,
            dotData: FlDotData(show: true),
          ),
        ],
      )),
    );
  }

  Widget _buildDailyGoalTracker() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Goal: 10,000 steps", style: TextStyle(fontWeight: FontWeight.bold, color: green, fontSize: 16)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: steps / 10000,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(green),
            minHeight: 12,
          ),
          const SizedBox(height: 8),
          Text("${(steps / 10000 * 100).toStringAsFixed(1)}% Completed", style: TextStyle(color: green, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInteractiveCards() {
    final List<Map<String, String>> challenges = [
      {"title": "Climb 10 Floors", "icon": "🏢"},
      {"title": "Walk 3 km", "icon": "🚶‍♂️"},
      {"title": "Run 15 mins", "icon": "🏃‍♀️"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: challenges.map((challenge) {
        return Expanded(
          child: InkWell(
            onTap: () => print("Selected: ${challenge['title']}"),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
              child: Column(
                children: [
                  Text(challenge['icon']!, style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 10),
                  Text(challenge['title']!, style: TextStyle(color: green, fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopUsers() {
    return Column(
      children: topUsers.map((user) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Colors.green.shade100]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.orangeAccent, child: Icon(Icons.star, color: Colors.white)),
                  const SizedBox(width: 12),
                  Text(user["name"], style: TextStyle(fontWeight: FontWeight.bold, color: green, fontSize: 16)),
                ],
              ),
              Text("${user["progress"]}%", style: TextStyle(fontWeight: FontWeight.bold, color: green)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLeaderboard() {
    return Column(
      children: leaderboard.map((user) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
          child: Row(
            children: [
              const CircleAvatar(backgroundColor: Color(0xFFD9EAD3), child: Icon(Icons.person, color: Colors.black54)),
              const SizedBox(width: 10),
              Expanded(child: Text(user["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: green))),
              SizedBox(
                width: 90,
                child: LinearProgressIndicator(
                  value: user["progress"] / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(green),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 10),
              Text("${user["progress"]}%", style: TextStyle(fontWeight: FontWeight.w500, color: green)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
