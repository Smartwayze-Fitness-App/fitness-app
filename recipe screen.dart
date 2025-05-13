import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeSuggestionsScreen extends StatefulWidget {
  @override
  _RecipeSuggestionsScreenState createState() => _RecipeSuggestionsScreenState();
}

class _RecipeSuggestionsScreenState extends State<RecipeSuggestionsScreen> {
  List<dynamic> recipes = [];
  bool isLoading = true;

  // Map recipe names to asset image paths
  final Map<String, String> recipeImages = {
    'Oatmeal with Berries': 'assets/oatmeal_with_berries.jpg',
    'Boiled Eggs & Toast': 'assets/boiled_eggs_and_toast.jpg',
    'Grilled Chicken Salad': 'assets/grilled_chicken_salad.jpg',
    'Stir Fry Veggies with Tofu': 'assets/stir_fry_veggies_with_tofu.jpg',
  };

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse('https://meal-api-production-614c.up.railway.app/recipes'));
    if (response.statusCode == 200) {
      setState(() {
        recipes = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // You can handle errors here
      print('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Healthy Recipes',
          style: TextStyle(
            color: Color(0xFF1E5631),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _buildRecipeCard(context, recipe);
        },
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    final imageAsset = recipeImages[recipe['name']] ?? 'assets/recipes/default.jpg';

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imageAsset,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1E5631),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ingredients: ${recipe['ingredients'].join(', ')}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  'Instructions: ${recipe['instructions']}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                      // Handle "View" action
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
