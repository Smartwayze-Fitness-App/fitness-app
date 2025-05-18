import 'package:flutter/material.dart';
import 'reminder_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Implement navigation if needed
    print("Navigated to index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7EAD4),
      appBar: AppBar(
        backgroundColor: Color(0xFFD7EAD4),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
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
            SizedBox(height: 4),
            Text(
              'April 19,2025',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 15),

            // Today's Workout Card
            _buildCard(
              title: "Today's Workout",
              subtitle: "HIIT Cardio",
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFB800),
                  elevation: 4,
                  shadowColor: Colors.black54,
                ),
                onPressed: () {
                  print("Start workout tapped");
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Start", style: TextStyle(color: Colors.black, fontSize: 16)),
                    Icon(Icons.play_arrow, color: Colors.black),
                  ],
                ),
              ),
              child: SizedBox(height: 15),
            ),

            // Calories Consumed
            _buildCard(
              title: "Calories Consumed",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("1,250 Kcal", style: TextStyle(fontSize: 18)),



                ],
              ),
            ),


            // Progress Summary
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

            // Motivational Quote
            _buildCard(
              title: "Motivational Quote of the Day",
              child: Container(
                constraints: BoxConstraints(minHeight: 120),
                child: Text(
                  "Push yourself, because no one else is going to do it for you.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Add this line
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

  Widget _buildCard({required String title, String? subtitle, Widget? trailing, Widget? child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    SizedBox(height: 15), // <-- adds spacing
                    Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ],

                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          if (child != null) ...[
            SizedBox(height: 16),
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
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }
}
