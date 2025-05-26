import 'package:flutter/material.dart';

class CalorieCounterScreen extends StatefulWidget {
  const CalorieCounterScreen({super.key});

  @override
  State<CalorieCounterScreen> createState() => _CalorieCounterScreenState();
}

class _CalorieCounterScreenState extends State<CalorieCounterScreen> {
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  final List<Map<String, dynamic>> _meals = [];

  void _addMeal() {
    String meal = _mealController.text.trim();
    String caloriesText = _calorieController.text.trim();

    if (meal.isEmpty || caloriesText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out both fields.')),
      );
      return;
    }

    int? calories = int.tryParse(caloriesText);
    if (calories == null || calories <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calories must be a valid number.')),
      );
      return;
    }

    setState(() {
      _meals.add({'meal': meal, 'calories': calories});
      _mealController.clear();
      _calorieController.clear();
    });
  }

  int _getTotalCalories() {
    return _meals.fold(0, (sum, item) => item['calories'] + sum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF6), // light green theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Calorie Counter',
          style: TextStyle(
            color: Color(0xFF1E5631),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputSection(),
            const SizedBox(height: 16),
            _buildMealList(),
            const SizedBox(height: 16),
            _buildTotalCalories(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        TextField(
          controller: _mealController,
          decoration: InputDecoration(

            labelText: 'Meal Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16,),
            ),

            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _calorieController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Calories',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7F11),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _addMeal,
          child: const Text('Add Meal',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  Widget _buildMealList() {
    return Expanded(
      child: _meals.isEmpty
          ? const Center(child: Text('No meals added yet.'))
          : ListView.builder(
        itemCount: _meals.length,
        itemBuilder: (context, index) {
          final meal = _meals[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(meal['meal']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${meal['calories']} cal',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _meals.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),

          );
        },
      ),
    );
  }

  Widget _buildTotalCalories() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E5631),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Calories:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            '${_getTotalCalories()} cal',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
