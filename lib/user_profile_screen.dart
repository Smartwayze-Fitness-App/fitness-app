import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override

 // void initState() {
    //super.initState();
    //fetchUserProfile(); // auto-fetches when screen opens
  //}
/*
  Future<void> fetchUserProfile(String userId) async {
    final url = Uri.parse('https://web-production-d452.up.railway.app/profile');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final profile = jsonDecode(response.body);
      print('User Profile: $profile');
    } else {
      print('Failed to load profile');
    }

  }*/


  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedGoal = 'Weight Loss';
  String selectedLevel = 'Beginner';

  bool isEditing = true;
  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Save your token in login screen with key 'token'
  }

  Future<void> fetchUserProfile() async {
    final token = await _getToken();
    if (token == null) {
      print("No token found");
      return;
    }

    final response = await http.get(
      Uri.parse('https://web-production-d452.up.railway.app/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        nameController.text = data['name'] ?? '';
        ageController.text = data['age']?.toString() ?? '';
        genderController.text = data['gender'] ?? '';
        heightController.text = data['height']?.toString() ?? '';
        weightController.text = data['weight']?.toString() ?? '';
        selectedGoal = data['goal'] ?? 'Weight Loss';
        selectedLevel = data['level'] ?? 'Beginner';
      });
    } else {
      print('Failed to load profile: ${response.body}');
    }
  }

  Future<void> updateUserProfile() async {
    final token = await _getToken();
    if (token == null) {
      print("No token found");
      return;
    }

    final response = await http.put(
      Uri.parse('https://web-production-d452.up.railway.app/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': nameController.text.trim(),
        'age': int.tryParse(ageController.text),
        'gender': genderController.text.trim(),
        'height': double.tryParse(heightController.text),
        'weight': double.tryParse(weightController.text),
        'goal': selectedGoal,
        'level': selectedLevel,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      setState(() => isEditing = false);
    } else {
      print('Failed to update profile: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF6), // splash background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          'User Profile',
            style: TextStyle(
              color: Color(0xFF1E5631),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(nameController, 'Full Name'),
            _buildTextField(ageController, 'Age', keyboardType: TextInputType.number),
            _buildTextField(genderController, 'Gender'),
            _buildTextField(heightController, 'Height (cm)', keyboardType: TextInputType.number),
            _buildTextField(weightController, 'Weight (kg)', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildDropdown('Fitness Goal', ['Weight Loss', 'Muscle Gain', 'Endurance'], selectedGoal, (val) {
              setState(() => selectedGoal = val);
            }),
            const SizedBox(height: 16),
            _buildDropdown('Fitness Level', ['Beginner', 'Intermediate', 'Advanced'], selectedLevel, (val) {
              setState(() => selectedLevel = val);
            }),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7F11), // orange
                    ),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Text('Edit',style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E5631), // green
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isEditing = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile saved!')),
                        );
                      }
                    },
                    child: const Text('Save',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: isEditing,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      List<String> items,
      String selectedValue,
      Function(String) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E5631),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: isEditing ? (val) => onChanged(val!) : null,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
