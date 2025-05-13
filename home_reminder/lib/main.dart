import 'package:flutter/material.dart';
import 'reminder_screen.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Start", style: TextStyle(color: Colors.black, fontSize: 16)),
                    Icon(Icons.play_arrow, color: Colors.black),
                  ],
                ),
              ),
              child: SizedBox(height: 10),
            ),

            // Calories Consumed
            _buildCard(
              title: "Calories Consumed",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("1,250 Kcal", style: TextStyle(fontSize: 18)),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Increased size of the circular progress indicator
                      SizedBox(
                        height: 60, // Adjusted size of the circle
                        width: 60, // Adjusted size of the circle
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 6, // Adjusted stroke width to make the circle thicker
                          backgroundColor: Colors.green.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade900),
                        ),
                      ),
                      // Smaller font size for the "1250" text to fit better
                      Text(
                        "1,250",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Reduced font size
                      ),
                    ],
                  ),
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
               constraints: BoxConstraints(minHeight: 100),
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
                  if (subtitle != null)
                    Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.black87)),
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
