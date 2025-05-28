import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> badgeTemplates = [
    {
      'key': '7_day_streak',
      'title': '7-Day Workout Streak',
      'description': 'Completed workouts for 7 days in a row!',
      'icon': Icons.fitness_center,
    },
    {
      'key': 'early_bird',
      'title': 'Early Bird',
      'description': 'Logged a workout before 7 AM',
      'icon': Icons.wb_twilight,
    },
    {
      'key': 'consistency_champ',
      'title': 'Consistency Champ',
      'description': 'Completed 5 workouts in a week',
      'icon': Icons.check_circle_outline,
    },
    {
      'key': 'hydration_hero',
      'title': 'Hydration Hero',
      'description': 'Tracked water intake 5 times',
      'icon': Icons.water_drop_outlined,
    },
    {
      'key': 'stretch_star',
      'title': 'Stretch Star',
      'description': 'Completed 3 stretch sessions',
      'icon': Icons.accessibility_new,
    },
    {
      'key': 'step_master',
      'title': 'Step Master',
      'description': 'Walked 10,000 steps in a day',
      'icon': Icons.directions_walk,
    },
  ];

  AchievementsScreen({super.key});

  Future<Map<String, dynamic>> fetchAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data()?['achievements'] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFDFF5DB),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Achievements & Badges',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003C1A),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchAchievements(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final achievements = snapshot.data ?? {};

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: badgeTemplates.length,
                    itemBuilder: (context, index) {
                      final badge = badgeTemplates[index];
                      final isEarned = achievements[badge['key']] == true;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: isEarned ? Colors.white : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: isEarned
                                ? const Color(0xFF003C1A)
                                : Colors.grey.shade500,
                            child: Icon(
                              badge['icon'],
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          title: Opacity(
                            opacity: isEarned ? 1.0 : 0.5,
                            child: Text(
                              badge['title'],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isEarned
                                    ? Colors.black
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                          subtitle: Opacity(
                            opacity: isEarned ? 1.0 : 0.7,
                            child: Text(
                              badge['description'],
                              style: TextStyle(
                                fontSize: 15,
                                color: isEarned
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            isEarned ? Icons.check_circle : Icons.lock_outline,
                            color: isEarned ? Colors.green : Colors.grey.shade700,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
