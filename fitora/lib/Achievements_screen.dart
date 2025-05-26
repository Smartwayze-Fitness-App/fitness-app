import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> badges = [
    {
      'title': '7-Day Workout Streak',
      'description': 'Completed workouts for 7 days in a row!',
      'isEarned': true,
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Early Bird',
      'description': 'Logged a workout before 7 AM',
      'isEarned': true,
      'icon': Icons.wb_twilight,
    },
    {
      'title': 'Consistency Champ',
      'description': 'Completed 5 workouts in a week',
      'isEarned': true,
      'icon': Icons.check_circle_outline,
    },
    {
      'title': 'Hydration Hero',
      'description': 'Tracked water intake 5 times',
      'isEarned': false,
      'icon': Icons.water_drop_outlined,
    },
    {
      'title': 'Stretch Star',
      'description': 'Completed 3 stretch sessions',
      'isEarned': false,
      'icon': Icons.accessibility_new,
    },
    {
      'title': 'Step Master',
      'description': 'Walked 10,000 steps in a day',
      'isEarned': false,
      'icon': Icons.directions_walk,
    },
  ];

  AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Validation: Check if all badges have a title, description, isEarned, and icon
    if (badges.any((badge) => badge['title'] == null || badge['description'] == null || badge['icon'] == null)) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3FFF0),
        body: Center(
          child: Text(
            'Error: Some badges are missing required fields (title, description, or icon).',
            style: TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),
            // Rounded title container
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  final isEarned = badge['isEarned'];

                  // Validation: Check if badge data is complete
                  if (badge['title'] == null || badge['description'] == null || badge['icon'] == null) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      color: Colors.red.shade200,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: const Text(
                          'Error: Missing badge data',
                          style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Please check the badge information for missing fields.'),
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20), // Increased vertical spacing
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
                        opacity: isEarned ? 1.0 : 0.5, // Added opacity for locked badges
                        child: Text(
                          badge['title'],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isEarned ? Colors.black : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      subtitle: Opacity(
                        opacity: isEarned ? 1.0 : 0.7, // Added opacity for locked badges
                        child: Text(
                          badge['description'],
                          style: TextStyle(
                            fontSize: 15,
                            color: isEarned ? Colors.black87 : Colors.grey.shade600,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
