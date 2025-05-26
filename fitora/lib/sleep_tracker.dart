import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(SleepTrackerApp());
}

class SleepTrackerApp extends StatelessWidget {
  const SleepTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SleepTrackerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SleepTrackerPage extends StatefulWidget {
  const SleepTrackerPage({super.key});

  @override
  _SleepTrackerPageState createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;
  double? duration;
  Map<String, double> weeklyData = {};

  @override
  void initState() {
    super.initState();
    loadWeeklyData();
  }

  Future<void> pickTime(bool isSleepTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 22, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isSleepTime) {
          sleepTime = picked;
        } else {
          wakeTime = picked;
        }
      });
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  double calculateDuration(TimeOfDay sleep, TimeOfDay wake) {
    DateTime now = DateTime.now();
    DateTime sleepDate = DateTime(now.year, now.month, now.day, sleep.hour, sleep.minute);
    DateTime wakeDate = DateTime(now.year, now.month, now.day, wake.hour, wake.minute);

    if (wakeDate.isBefore(sleepDate)) {
      wakeDate = wakeDate.add(Duration(days: 1));
    }

    return wakeDate.difference(sleepDate).inMinutes / 60.0;
  }

  Future<void> saveSleepData() async {
    if (sleepTime == null || wakeTime == null) return;

    double hours = calculateDuration(sleepTime!, wakeTime!);
    setState(() {
      duration = hours;
    });

    final prefs = await SharedPreferences.getInstance();
    final day = DateFormat('EEE').format(DateTime.now());
    weeklyData[day] = hours;
    prefs.setString('weeklyData', jsonEncode(weeklyData));
  }

  Future<void> loadWeeklyData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('weeklyData');
    setState(() {
      weeklyData = Map<String, double>.from(jsonDecode(data));
    });
    }

  Widget buildBarChart() {
    final days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, _) {
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(days[value.toInt()], style: TextStyle(fontSize: 12)),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (i) {
          final d = days[i];
          final val = weeklyData[d] ?? 0;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: val.clamp(0, 10), // Limit to 10 hours max
                color: val < 6 ? Colors.red : Color(0xFF1D503B),
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
        gridData: FlGridData(show: false),
        maxY: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9E8D2),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sleep Tracker',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D503B),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Track your sleep and improve recovery',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Enter Sleep and Wake Times',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.black12),
                                  ),
                                ),
                                onPressed: () => pickTime(true),
                                icon: Icon(Icons.nightlight_round),
                                label: Text(formatTime(sleepTime)),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: Colors.black12),
                                  ),
                                ),
                                onPressed: () => pickTime(false),
                                icon: Icon(Icons.wb_sunny),
                                label: Text(formatTime(wakeTime)),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1D503B),
                              elevation: 6,
                              shadowColor: Colors.black45,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: saveSleepData,
                            child: Text('Save Sleep Data', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    if (duration != null)
                      Text(
                        'You slept for ${duration!.floor()} hr ${(duration! % 1 * 60).round()} min',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.all(20),
                      height: 490, // Increased height
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Weekly Sleep Summary',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),

                          SizedBox(height: 20),
                          Expanded(child: buildBarChart()),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}