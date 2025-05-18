import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Reminder {
  String title;
  String subtitle;
  TimeOfDay time;
  bool completed;

  Reminder({
    required this.title,
    required this.subtitle,
    required this.time,
    this.completed = false,
  });
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Reminder> reminders = [
    Reminder(title: 'Workout Reminder', subtitle: 'Time for leg day', time: TimeOfDay(hour: 18, minute: 0)),
    Reminder(title: 'Water Reminder', subtitle: 'Time to drink water', time: TimeOfDay(hour: 14, minute: 0), completed: true),
    Reminder(title: 'Meal Reminder', subtitle: 'Track your lunch', time: TimeOfDay(hour: 12, minute: 0)),
  ];

  void _toggleCompletion(int index) {
    setState(() {
      reminders[index].completed = !reminders[index].completed;
    });
  }

  void _addReminder(String title, String subtitle, TimeOfDay time) {
    setState(() {
      reminders.add(Reminder(title: title, subtitle: subtitle, time: time));
    });
  }

  void _showAddReminderDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Set Reminder"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: subtitleController, decoration: InputDecoration(labelText: "Description")),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) selectedTime = picked;
              },
              child: Text("Pick Time"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addReminder(titleController.text, subtitleController.text, selectedTime);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: Color(0xFFD6EAD9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Reminder", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                        SizedBox(width: 5),
                        Text(today, style: TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _showAddReminderDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade200,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Set Reminder", style: TextStyle(color: Colors.green.shade900)),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...reminders.asMap().entries.map((entry) {
              int index = entry.key;
              Reminder reminder = entry.value;

              IconData iconData;
              switch (reminder.title) {
                case 'Workout Reminder':
                  iconData = Icons.fitness_center;
                  break;
                case 'Water Reminder':
                  iconData = Icons.water_drop;
                  break;
                case 'Meal Reminder':
                  iconData = Icons.restaurant_menu;
                  break;
                default:
                  iconData = Icons.alarm;
              }

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(iconData, color: Colors.green.shade800, size: 28),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reminder.subtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              decoration: reminder.completed ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Colors.black54),
                        SizedBox(width: 4),
                        Text(reminder.time.format(context), style: TextStyle(fontSize: 14)),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () => _toggleCompletion(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: reminder.completed ? Colors.green.shade800 : Colors.white,
                            side: BorderSide(color: Colors.green.shade800),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            reminder.completed ? "Completed" : "Mark as Done",
                            style: TextStyle(color: reminder.completed ? Colors.white : Colors.black87),
                          ),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Snoozed")));
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text("Snooze", style: TextStyle(color: Colors.black87)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
