import 'package:flutter/material.dart';

class StretchingRecoveryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> exercises = [
    {
      "name": "Quad Stretch",
      "duration": "30 sec",
      "icon": Icons.accessibility_new,
    },
    {
      "name": "Hamstring Stretch",
      "duration": "30 sec",
      "icon": Icons.self_improvement,
    },
    {
      "name": "Shoulder Roll",
      "duration": "20 sec",
      "icon": Icons.swap_calls,
    },
    {
      "name": "Neck Stretch",
      "duration": "20 sec",
      "icon": Icons.accessibility,
    },
    {
      "name": "Child’s Pose",
      "duration": "1 min",
      "icon": Icons.airline_seat_recline_extra,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF6), // Same background as stats screen
      appBar: AppBar(
        title: Text(
          "Stretching & Recovery",
            style: TextStyle(
              color: Color(0xFF1E5631),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )
        ),
        backgroundColor: const Color(0xFFF5FFF6), // Match background
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade800),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return InkWell(
            onTap: (){
              /*
               if (exercise["name"] == "Quad Stretch") {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => QuadStretchScreen()));
             } else if (exercise["name"] == "Hamstring Stretch") {
               Navigator.push(context, MaterialPageRoute(builder: (context) => HamstringStretchScreen()));
              }
             // and so on...
               */
            },
            child:Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF50C878),
                  child: Icon(
                    exercise["icon"],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise["name"],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Duration: ${exercise["duration"]}"),
                  ],
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
