import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ChooseActivityPage extends StatefulWidget {
  const ChooseActivityPage({super.key});

  @override
  State<ChooseActivityPage> createState() => _ChooseActivityPageState();
}

class _ChooseActivityPageState extends State<ChooseActivityPage> {
  String? _activity;
  String? _env;
  double? _distance;
  String _unit = 'km';
  TimeOfDay? _selectedTime;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotificationSystem();
  }

  Future<void> _initializeNotificationSystem() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(initSettings);
  }

  Future<void> _scheduleNotification(
    String title,
    String body,
    TimeOfDay time,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final scheduled =
        scheduleTime.isBefore(now)
            ? scheduleTime.add(const Duration(days: 1))
            : scheduleTime;

    const androidDetails = AndroidNotificationDetails(
      'activity_reminder',
      'Activity Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notifications.zonedSchedule(
      0,
      title,
      body,
      scheduled,
      const NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> _saveActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final activities = prefs.getStringList('activities') ?? [];

    final activity = jsonEncode({
      'title': _activity,
      'env': _env,
      'distance': _distance,
      'unit': _unit,
      'time': _selectedTime?.format(context) ?? '',
    });

    activities.add(activity);
    await prefs.setStringList('activities', activities);

    if (_selectedTime != null) {
      await _scheduleNotification(
        'Time to do $_activity!',
        '$_distance $_unit $_env',
        _selectedTime!,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Activity')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: _dec('Activity Type'),
                items: const [
                  DropdownMenuItem(value: 'Walking', child: Text('Walking')),
                  DropdownMenuItem(value: 'Running', child: Text('Running')),
                  DropdownMenuItem(value: 'Cycling', child: Text('Cycling')),
                  DropdownMenuItem(value: 'Swimming', child: Text('Swimming')),
                ],
                onChanged: (v) => setState(() => _activity = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _dec('Environment'),
                items: const [
                  DropdownMenuItem(value: 'Outdoor', child: Text('Outdoor')),
                  DropdownMenuItem(value: 'Indoor', child: Text('Indoor')),
                ],
                onChanged: (v) => setState(() => _env = v),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: _dec('Distance'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _distance = double.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _unit,
                    items: const [
                      DropdownMenuItem(value: 'm', child: Text('m')),
                      DropdownMenuItem(value: 'km', child: Text('km')),
                    ],
                    onChanged: (v) => setState(() => _unit = v!),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() => _selectedTime = picked);
                },
                child: Text(
                  _selectedTime == null
                      ? 'Select Time'
                      : 'Selected: ${_selectedTime!.format(context)}',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    (_activity != null && _env != null && _distance != null)
                        ? _saveActivity
                        : null,
                child: const Text('Save Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());
}
