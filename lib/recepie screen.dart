import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeSuggestionsScreen extends StatelessWidget {
  final List<Map<String, String>> recipes = [
    {
      'title': 'Avocado Toast',
      'description': 'Whole grain toast with mashed avocado, olive oil, and boiled egg.',
      'image': 'https://images.unsplash.com/photo-1551183053-bf91a1d81141',
    },
    {
      'title': 'Oatmeal Bowl',
      'description': 'Oats topped with banana, berries, chia seeds & honey.',
      'image': 'https://media1.popsugar-assets.com/files/thumbor/XCocbwk1h5DrNTTfF5yA3MrWtZU/fit-in/1024x1024/filters:format_auto-!!-:strip_icc-!!-/2018/07/17/831/n/1922729/03953fbb89ada551_reg-oats/i/Classic-Oatmeal-Bowl.jpeg',
    },
    {
      'title': 'Grilled Chicken Salad',
      'description': 'Grilled chicken breast on a bed of greens with olive oil dressing.',
      'image': 'https://www.dinneratthezoo.com/wp-content/uploads/2020/12/grilled-chicken-salad-4.jpg',
    },
    {
      'title': 'Smoothie Bowl',
      'description': 'Frozen fruits blended with almond milk, topped with granola.',
      'image': 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF6), // Matches splash theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Healthy Recipes',
            style: TextStyle(
              color: Color(0xFF1E5631),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _buildRecipeCard(context, recipe);
        },
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, String> recipe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: recipe['image']!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1E5631),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  recipe['description']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFFF7F11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to detail screen
                    },
                    child: const Text('View'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
