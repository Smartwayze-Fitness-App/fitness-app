import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealPlansScreen extends StatefulWidget {
  @override
  _MealPlansScreenState createState() => _MealPlansScreenState();
}

class _MealPlansScreenState extends State<MealPlansScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';
  double dailyCalories = 1200;
  double calorieGoal = 2000;

  bool isLoading = true;
  List<String> knownTypes = ['Vegetarian', 'Keto', 'High Protein'];
  Map<String, List<Map<String, dynamic>>> categorizedMeals = {};

  @override
  void initState() {
    super.initState();
    fetchMealPlans();
  }

  Future<void> fetchMealPlans() async {
    final url = Uri.parse("https://meal-api-production-614c.up.railway.app/meal-plans");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, List<Map<String, dynamic>>> loadedMeals = {};

        data.forEach((category, meals) {
          loadedMeals[category] = List<Map<String, dynamic>>.from(meals);
        });

        setState(() {
          categorizedMeals = loadedMeals;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load meal plans');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error fetching meal plans: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  List<MapEntry<String, List<Map<String, dynamic>>>> _filterCategorizedMeals() {
    final lowerSearch = searchQuery.toLowerCase();
    final isTypeSearch = knownTypes.map((e) => e.toLowerCase()).contains(lowerSearch);

    return categorizedMeals.entries.map((entry) {
      final filtered = entry.value.where((meal) {
        final nameMatch = meal['name'].toString().toLowerCase().contains(lowerSearch);
        final typeMatch = isTypeSearch
            ? meal['type'].toString().toLowerCase() == lowerSearch
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
          content: Text("You've exceeded your daily calorie goal!"),
          backgroundColor: Colors.red.shade400,
        ),
      );
    } else {
      setState(() {
        dailyCalories += calories;
      });
    }
  }

  String _getImagePath(String mealName) {
    final normalized = mealName.toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9_]+'), '');
    return 'assets/$normalized.jpg';
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                ? Center(child: Text("No meals found matching your search."))
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                      ),
                    ),
                    ...entry.value.map((meal) => Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            _getImagePath(meal['name']),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.fastfood,
                              size: 40,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        title: Text(
                          meal['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green.shade900),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Calories: ${meal['calories']} kcal"),
                            Text(
                                "Protein: ${meal['protein']} | Carbs: ${meal['carbs']} | Fats: ${meal['fats']}"),
                            Text("Serving: ${meal['serving']}"),
                            Text("Type: ${meal['type']}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add_circle_outline, color: Colors.green.shade900),
                          onPressed: () => _addMealCalories(
                              double.tryParse(meal['calories'].toString()) ?? 0),
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

