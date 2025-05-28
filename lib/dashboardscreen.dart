import 'package:flutter/material.dart';
//import 'reminder_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:untitled6/Calorie%20Counter%20Screen.dart';

import 'calorie_service.dart';
import 'main.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;
  const DashboardScreen({super.key,required this.userId}); //accept user id

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _caloriesConsumed = 0;
  @override
  void initState() {
    super.initState();
    _loadCalories();
  }

  Future<void> _loadCalories() async {
    try {
      int total = await fetchTotalCalories(widget.userId); //  logged-in user ID
      setState(() {
        _caloriesConsumed = total;
      });
    } catch (e) {
      print("Failed to load calories: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index==2){//this navigation is to be remove as its only to check the calorie counter
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CalorieCounterScreen(userId: widget.userId)));
    }
    print("Navigated to index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7EAD4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7EAD4),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: RefreshIndicator(
          onRefresh: _loadCalories,
          child: ListView(
            children: [
              Text(
                'Welcome Ali',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'April 19,2025',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 15),
          
              // Cards with updated spacing
              _buildCard(
                title: "Today's Workout",
                subtitle: "HIIT Cardio",
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB800),
                    elevation: 4,
                    shadowColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    print("Start workout tapped");
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Text("Start", style: TextStyle(color: Colors.black, fontSize: 16)),
                      Icon(Icons.play_arrow, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
          
              _buildCard(
                title: "Calories Consumed",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$_caloriesConsumed Kcal", style: TextStyle(fontSize: 18)),
                    Transform.translate(
                      offset: const Offset(0, -22),
                      child: CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 7.0,
                        animation: true,
                        percent: (_caloriesConsumed / 2200).clamp(0.0, 1.0), // Assuming 2200 Kcal goal
                        center: Text("$_caloriesConsumed", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.green[900],
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: const Color(0xFFE4F1E0),
                        progressColor: const Color(0xFF1B5E20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
          
              _buildCard(
                title: "Progress Summary",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _progressItem(Icons.directions_walk, "4,500", "Steps"),
                    _progressItem(Icons.access_time, "35 min", "Active Minutes"),
                    _progressItem(Icons.location_on, "2.4 km", "Distance"),
                  ],
                ),
              ),
              const SizedBox(height: 15),
          
              _buildCard(
                title: "Motivational Quote of the Day",
                child: Container(
                  constraints: const BoxConstraints(minHeight: 120),
                  child: const Text(
                    "Push yourself, because no one else is going to do it for you.",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.green[200],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Meal'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    Widget? trailing,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: subtitle != null || trailing != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 15),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  ],
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 16),
            child,
          ],
        ],
      ),
    );
  }

  Widget _progressItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.green[900]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }
}