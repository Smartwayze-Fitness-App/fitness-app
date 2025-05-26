import 'package:flutter/material.dart';

class MealPlansScreen extends StatefulWidget {
  const MealPlansScreen({super.key});

  @override
  MealPlansScreenState createState() => MealPlansScreenState();
}

class MealPlansScreenState extends State<MealPlansScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';
  double dailyCalories = 1200;
  double calorieGoal = 2000;

  final List<String> knownTypes = ['Vegetarian', 'Keto', 'High Protein'];

  final Map<String, List<Map<String, dynamic>>> categorizedMeals = {
    "Morning": [
      {
        "name": "Oatmeal with Berries",
        "calories": 300.0,
        "protein": "10g",
        "carbs": "40g",
        "fats": "5g",
        "imagePath": "assets/images/oatmeal.jpg",
        "icon": Icons.breakfast_dining,
        "serving": "1 Bowl",
        "type": "Vegetarian",
      },
      {
        "name": "Boiled Eggs & Toast",
        "calories": 250.0,
        "protein": "12g",
        "carbs": "20g",
        "fats": "10g",
        "imagePath": "assets/images/toast.jpg",
        "icon": Icons.egg_alt,
        "serving": "2 Eggs & 1 Slice Toast",
        "type": "High Protein",
      },
    ],
    "Afternoon": [
      {
        "name": "Grilled Chicken Salad",
        "calories": 350.0,
        "protein": "25g",
        "carbs": "15g",
        "fats": "10g",
        "imagePath": "assets/images/grilled chicken.jpg",
        "icon": Icons.lunch_dining,
        "serving": "1 Plate",
        "type": "Keto",
      },
      {
        "name": "Brown Rice & Veggies",
        "calories": 400.0,
        "protein": "15g",
        "carbs": "50g",
        "fats": "12g",
        "imagePath": "assets/images/brown_rice.jpg",
        "icon": Icons.rice_bowl,
        "serving": "1 Bowl",
        "type": "Vegetarian",
      },
    ],
    "Evening": [
      {
        "name": "Tofu Stir Fry",
        "calories": 420.0,
        "protein": "20g",
        "carbs": "25g",
        "fats": "18g",
        "imagePath": "assets/images/tofu.jpeg",
        "icon": Icons.dinner_dining,
        "serving": "1 Plate",
        "type": "Vegetarian",
      },
      {
        "name": "Greek Yogurt Parfait",
        "calories": 200.0,
        "protein": "12g",
        "carbs": "18g",
        "fats": "6g",
        "imagePath": "assets/images/parfait.jpg",
        "icon": Icons.icecream,
        "serving": "1 Glass",
        "type": "High Protein",
      },
    ],
  };

  List<MapEntry<String, List<Map<String, dynamic>>>> _filterCategorizedMeals() {
    final lowerSearch = searchQuery.toLowerCase();
    final isTypeSearch = knownTypes.map((e) => e.toLowerCase()).contains(lowerSearch);

    return categorizedMeals.entries.map((entry) {
      final filtered = entry.value.where((meal) {
        final nameMatch = meal['name'].toLowerCase().contains(lowerSearch);
        final typeMatch = isTypeSearch
            ? meal['type'].toLowerCase() == lowerSearch
            : (selectedFilter == 'All' || meal['type'] == selectedFilter);
        return (isTypeSearch || nameMatch) && typeMatch;
      }).toList();

      return MapEntry(entry.key, filtered);
    }).where((entry) => entry.value.isNotEmpty).toList();
  }

  void _addMealCalories(double calories) {
    if (dailyCalories + calories > calorieGoal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You've exceeded your daily calorie goal!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade400,
        ),
      );
    } else {
      setState(() {
        dailyCalories += calories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedFilteredMeals = _filterCategorizedMeals();

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade800, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text("Meal Plans", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search meals...',
                      prefixIcon: Icon(Icons.search, color: Colors.green.shade800),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.redAccent),
                        onPressed: () => setState(() => searchQuery = ''),
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Row(
                    children: ['All', ...knownTypes].map((type) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ChoiceChip(
                          label: Text(type),
                          selectedColor: Colors.green.shade300,
                          backgroundColor: Colors.grey.shade300,
                          labelStyle: TextStyle(
                            color: selectedFilter == type ? Colors.green.shade900 : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          selected: selectedFilter == type,
                          onSelected: (_) => setState(() => selectedFilter = type),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: LinearProgressIndicator(
              value: dailyCalories / calorieGoal,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green.shade700,
              minHeight: 12,
            ),
          ),
          Text(
            "You've consumed ${dailyCalories.toInt()} / ${calorieGoal.toInt()} kcal today",
            style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: groupedFilteredMeals.isEmpty
                ? Center(
              child: Text(
                knownTypes.map((e) => e.toLowerCase()).contains(searchQuery.toLowerCase()) || searchQuery.isEmpty
                    ? "No meals found. Try another search or filter."
                    : "No meals found for \"$searchQuery\". Try a valid food type like Vegetarian, Keto, or High Protein.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: groupedFilteredMeals.length,
              itemBuilder: (context, i) {
                final entry = groupedFilteredMeals[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        entry.key,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                      ),
                    ),
                    ...entry.value.map((meal) => Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            meal['imagePath'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                        title: Text(
                          meal['name'],
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: [
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                                  SizedBox(width: 4),
                                  Text("Calories: ${meal['calories'].toStringAsFixed(0)} kcal"),
                                ]),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.restaurant, size: 16, color: Colors.blueGrey),
                                  SizedBox(width: 4),
                                  Text(meal['serving']),
                                ]),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text("Protein: ${meal['protein']} | Carbs: ${meal['carbs']} | Fats: ${meal['fats']}", style: TextStyle(fontSize: 13)),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.category, size: 16, color: Colors.teal),
                                SizedBox(width: 4),
                                Flexible(child: Text("Type: ${meal['type']}", overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add_circle_outline, color: Colors.green.shade900),
                          onPressed: () => _addMealCalories(meal['calories']),
                        ),
                      ),
                    )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
