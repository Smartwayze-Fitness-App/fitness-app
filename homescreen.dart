import 'package:flutter/material.dart';
import 'package:untitled/dashboardscreen.dart';
import 'package:untitled/progress_trackerscreen.dart';
import 'package:untitled/workout_plan_screen.dart';
import 'package:untitled/Calorie Counter Screen.dart';
import 'package:untitled/community_challengescreen.dart';
import 'package:untitled/Achievements_screen.dart';
import 'package:untitled/exercise_library.dart';
import 'package:untitled/fitness_stats_screen.dart';
import 'package:untitled/meal_planscreen.dart';
import 'package:untitled/recipe screen.dart';
import 'package:untitled/stretching&recovery.dart';

class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Header Section
                _buildHeader(),
                const SizedBox(height: 25),

                // Stats Cards Row
                _buildStatsRow(),
                const SizedBox(height: 25),

                // Quick Actions Title
                const Text(
                  'What would you like to do?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E5631),
                  ),
                ),
                const SizedBox(height: 15),

                // Main Navigation Grid
                _buildMainNavigation(context),
                const SizedBox(height: 20),

                // Additional Features Title
                const Text(
                  'More Features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E5631),
                  ),
                ),
                const SizedBox(height: 15),

                // Additional Features Grid
                _buildAdditionalFeatures(context),
                const SizedBox(height: 25),

                // Today's Recommendation
                _buildTodaysRecommendation(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavigation(context),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick workout action
        },
        backgroundColor: const Color(0xFFFF7F11),
        child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Profile Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E5631), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 15),

        // Welcome Text
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, Alex!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E5631),
                ),
              ),
              Text(
                'Ready for today\'s workout?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF527B61),
                ),
              ),
            ],
          ),
        ),

        // Notifications
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF1E5631),
                  size: 22,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7F11),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('🔥', '1,240', 'Calories', const Color(0xFFFF7F11))),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('⏱️', '45m', 'Minutes', const Color(0xFF1E5631))),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('🎯', '12', 'Day Streak', const Color(0xFF4CAF50))),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String value, String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E5631),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF527B61),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainNavigation(BuildContext context) {
    return Column(
      children: [
        // Top Row - Primary Actions
        Row(
          children: [
            Expanded(
              child: _buildNavigationCard(
                context,
                'Workout Plans',
                'Personalized routines',
                Icons.fitness_center,
                const Color(0xFF1E5631),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPlansScreen()));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNavigationCard(
                context,
                'Progress',
                'Track your gains',
                Icons.trending_up,
                const Color(0xFFFF7F11),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressTrackerScreen()));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Bottom Grid - Secondary Actions
        Row(
          children: [
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Nutrition',
                Icons.restaurant,
                const Color(0xFF4CAF50),
                    () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DashboardScreen(userId: '',)));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Challenges',
                Icons.emoji_events,
                const Color(0xFFFFC107),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityChallengeScreen()));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Fitness Stats',
                Icons.bar_chart,
                const Color(0xFF9C27B0),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessStatsScreen()));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalFeatures(BuildContext context) {
    return Column(
      children: [
        // First Row of Additional Features
        Row(
          children: [
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Achievements',
                Icons.military_tech,
                const Color(0xFFFFD700),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AchievementsScreen()));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Exercise Library',
                Icons.library_books,
                const Color(0xFF3F51B5),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExerciseLibraryScreen()));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Meal Plans',
                Icons.menu_book,
                const Color(0xFF8BC34A),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MealPlansScreen()));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Second Row of Additional Features
        Row(
          children: [
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Recipes',
                Icons.restaurant_menu,
                const Color(0xFFE91E63),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeSuggestionsScreen()));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Stretching',
                Icons.accessibility_new,
                const Color(0xFF00BCD4),
                    () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StretchingRecoveryScreen()));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallNavigationCard(
                context,
                'Community',
                Icons.people,
                const Color(0xFF2196F3),
                    () {
                  // Navigate to Community/Social screen if you have one
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallNavigationCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E5631),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysRecommendation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended for Today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E5631),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7F11), Color(0xFFFF9800)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HIIT Cardio Blast',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E5631),
                      ),
                    ),
                    Text(
                      '25 min • High Intensity',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF527B61),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text('⭐⭐⭐⭐⭐', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 5),
                        Text('4.8 • 2.1k reviews', style: TextStyle(fontSize: 10, color: Color(0xFF527B61))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7F11),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.fitness_center, 'Workouts', false),
          const SizedBox(width: 40), // Space for FAB
          _buildNavItem(Icons.bar_chart, 'Stats', false),
          _buildNavItem(Icons.person, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF1E5631) : const Color(0xFF527B61),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? const Color(0xFF1E5631) : const Color(0xFF527B61),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}