import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      backgroundColor: const Color(0xFFF5FFF6),
      appBar: AppBar(
        title: Text(
          "Stretching & Recovery",
          style: TextStyle(
            color: Color(0xFF1E5631),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFFF5FFF6),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade800),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return InkWell(
            onTap: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final userId = user.uid;

              final stretchRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('stretching');

              //  Add stretching session
              await stretchRef.add({
                'exercise': exercise["name"],
                'timestamp': Timestamp.now(),
              });

              //  Count stretching sessions
              final snapshot = await stretchRef.get();
              final stretchCount = snapshot.docs.length;

              // Unlock achievement if 3 or more
              if (stretchCount >= 3) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .set({
                  'achievements': {'stretch_star': true}
                }, SetOptions(merge: true));
              }

    //  Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${exercise["name"]}  completed!')),
              );
            },
            child: Container(
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
            ),
          );
        },
      ),
    );
  }
}
