import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Notification plugin instance

  // Constructor to initialize the notification service
  NotificationService() {
    _initializeNotifications();
  }

  // Function to initialize notifications
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to schedule a notification
  Future<void> scheduleNotification(DateTime scheduledNotificationDateTime) async {
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Scheduled Notification', // Notification Title
      'This is your notification', // Notification Body
      scheduledDate, // Time the notification should appear
      NotificationDetails( // Removed 'const' here
        android: AndroidNotificationDetails(
          'your_channel_id', // Channel ID
          'your_channel_name', // Channel Name
          channelDescription: 'your_channel_description', // Named argument for description
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Only match the time
    );
  }
}



