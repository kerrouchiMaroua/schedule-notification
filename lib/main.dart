import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';  // Import the NotificationService class

void main() {
  // Initialize timezones before running the app
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimePickerScreen(),
    );
  }
}

class TimePickerScreen extends StatefulWidget {
  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  TimeOfDay? _selectedTime;  // The time selected by the user
  final NotificationService _notificationService = NotificationService();  // Instance of the notification service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a time for notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the selected time
            Text(
              _selectedTime == null
                  ? 'No time selected'
                  : 'Selected time: ${_selectedTime!.format(context)}',
            ),
            // Button to pick a time
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              child: Text('Pick Time'),
            ),
            // Button to schedule the notification
            ElevatedButton(
              onPressed: _selectedTime != null ? _scheduleNotification : null,
              child: Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to schedule the notification
  void _scheduleNotification() {
    final now = DateTime.now();
    // Create a DateTime object with the selected time for today
    final selectedDate = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    
    // Call the scheduleNotification function from NotificationService
    _notificationService.scheduleNotification(selectedDate);
  }
}
