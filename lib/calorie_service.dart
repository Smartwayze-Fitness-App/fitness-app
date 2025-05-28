// calorie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> fetchTotalCalories(String userId) async {
  final response = await http.get(
    Uri.parse('https://maryam56.pythonanywhere.com/api/meals/user123/$userId'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> meals = jsonDecode(response.body);
    int totalCalories = meals.fold<int>(0, ( int sum, item) => sum + (item['calories'] as num).toInt());

    return totalCalories;
  } else {
    throw Exception('Failed to load calories');
  }
}
