import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String name;

  ExerciseDetailScreen({required this.name});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  Map<String, dynamic> details = {};
  List variations = [];
  bool isLoading = true;
  final Color green = const Color(0xFF265C2F);

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      final detailRes = await http.get(Uri.parse(
          "https://taheera12.pythonanywhere.com/exercise-details/${Uri.encodeComponent(widget.name)}"));

      final variationRes = await http.get(Uri.parse(
          "https://taheera12.pythonanywhere.com/exercise-variations/${Uri.encodeComponent(widget.name)}"));

      if (detailRes.statusCode == 200 && variationRes.statusCode == 200) {
        setState(() {
          details = json.decode(detailRes.body);
          variations = json.decode(variationRes.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load detail data");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: green))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Instructions:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: green)),
            SizedBox(height: 8),
            ...List.generate((details["steps"] ?? []).length, (i) {
              return Text("- ${details["steps"][i]}",
                  style: TextStyle(fontSize: 16));
            }),
            SizedBox(height: 20),
            if (details["video_url"] != null &&
                details["video_url"].toString().isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: green),
                onPressed: () async {
                  final url = details["video_url"];
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  }
                },
                child: Text("Watch Video"),
              ),
            SizedBox(height: 20),
            if (variations.isNotEmpty) ...[
              Text("Variations:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: green)),
              SizedBox(height: 8),
              ...variations.map((v) => Text("- $v", style: TextStyle(fontSize: 16))).toList()
            ],
          ],
        ),
      ),
    );
  }
}
