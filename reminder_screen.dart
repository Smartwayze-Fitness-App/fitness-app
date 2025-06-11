import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const androidInit = AndroidInitializationSettings('app_icon');
  const initSettings = InitializationSettings(android: androidInit);
  await notificationPlugin.initialize(initSettings);
  tz.initializeTimeZones();
  runApp(const ReminderApp());
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

  String get timeString =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: ReminderScreen());
  }
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});
  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  List<Reminder> reminders = [];
  static const String baseUrl = 'https://taheera12.pythonanywhere.com';

  @override
  void initState() {
    super.initState();
    _loadReminderFromBackend();
  }

  Future<void> _setReminderTimeBackend(Reminder r) async {
    final url = Uri.parse('$baseUrl/reminders');
    final body = jsonEncode({
      'title': r.title,
      'subtitle': r.subtitle,
      'time': r.timeString,
    });
    try {
      final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 200) debugPrint('✅ Reminder saved');
    } catch (e) {
      debugPrint('❌ Network error while saving: $e');
    }
  }

  Future<void> _loadReminderFromBackend() async {
    final url = Uri.parse('$baseUrl/reminders');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        setState(() {
          reminders = data.map((e) {
            final parts = (e['time'] as String).split(':');
            return Reminder(
              title: e['title'] ?? 'Reminder',
              subtitle: e['subtitle'] ?? '',
              time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('❌ Network error while fetching: $e');
    }
  }

  Future<void> _scheduleNotification(Reminder r, {int? customId, int? minutesLater}) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);

    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      r.time.hour,
      r.time.minute,
    );

    if (minutesLater != null) {
      scheduledTime = now.add(Duration(minutes: minutesLater));
    }

    await notificationPlugin.zonedSchedule(
      customId ?? r.hashCode,
      r.title,
      r.subtitle,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: minutesLater == null ? DateTimeComponents.time : null,
    );
  }

  void _toggleCompletion(int idx) {
    setState(() => reminders[idx].completed = !reminders[idx].completed);
  }

  void _deleteReminder(int idx) {
    setState(() => reminders.removeAt(idx));
  }

  void _editReminder(int idx) {
    final r = reminders[idx];
    final titleController = TextEditingController(text: r.title);
    final subtitleController = TextEditingController(text: r.subtitle);
    TimeOfDay pickedTime = r.time;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: subtitleController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final res = await showTimePicker(context: context, initialTime: pickedTime);
                if (res != null) pickedTime = res;
              },
              child: const Text('Pick Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                reminders[idx] = Reminder(
                  title: titleController.text,
                  subtitle: subtitleController.text,
                  time: pickedTime,
                );
              });
              _setReminderTimeBackend(reminders[idx]);
              _scheduleNotification(reminders[idx]);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addReminder(String title, String subtitle, TimeOfDay time) {
    final newReminder = Reminder(title: title, subtitle: subtitle, time: time);
    setState(() => reminders.add(newReminder));
    _setReminderTimeBackend(newReminder);
    _scheduleNotification(newReminder);
  }

  void _showAddReminderDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    TimeOfDay pickedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: subtitleController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final resTime = await showTimePicker(context: context, initialTime: pickedTime);
                if (resTime != null) pickedTime = resTime;
              },
              child: const Text('Pick Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addReminder(titleController.text, subtitleController.text, pickedTime);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFD6EAD9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Today's Reminder",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(today, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ]),
              ]),
              ElevatedButton(
                onPressed: _showAddReminderDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade200,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Set Reminder', style: TextStyle(color: Colors.green.shade900)),
              ),
            ]),
            const SizedBox(height: 20),
            ...reminders.asMap().entries.map((entry) {
              final idx = entry.key;
              final r = entry.value;

              IconData icon;
              switch (r.title) {
                case 'Workout Reminder':
                  icon = Icons.fitness_center;
                  break;
                case 'Water Reminder':
                  icon = Icons.water_drop;
                  break;
                case 'Meal Reminder':
                  icon = Icons.restaurant_menu;
                  break;
                default:
                  icon = Icons.alarm;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(r.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') _editReminder(idx);
                        if (value == 'Delete') _deleteReminder(idx);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(icon, color: Colors.green.shade800, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        r.subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          decoration: r.completed ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(r.time.format(context), style: const TextStyle(fontSize: 14)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _toggleCompletion(idx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: r.completed ? Colors.green.shade800 : Colors.white,
                        side: BorderSide(color: Colors.green.shade800),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        r.completed ? 'Completed' : 'Mark as Done',
                        style: TextStyle(color: r.completed ? Colors.white : Colors.black87),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        _scheduleNotification(r, customId: r.hashCode + 999, minutesLater: 10);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Snoozed for 10 minutes')));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Snooze', style: TextStyle(color: Colors.black87)),
                    ),
                  ]),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }
}
