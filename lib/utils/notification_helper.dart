// lib/utils/notification_helper.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../providers/water_provider.dart';


class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(Function(String?) onNotificationSelect) async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationSelect(response.payload);
      },
    );
  }

  static Future<void> scheduleWaterReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();

    for (int hour = 8; hour <= 22; hour += 2) {
      final id = hour;
      final tzDateTime = _nextInstanceOfHour(hour);

      final totalDrank = await WaterProvider.getTodayTotalFromDB();
      final totalLiters = (totalDrank / 1000).toStringAsFixed(2);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        '💧 Time to drink water!',
        'You’ve had $totalLiters L today. Stay hydrated!',
        tzDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'water_channel',
            'Water Reminders',
            channelDescription: 'Reminds you to hydrate regularly',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'open_water_tracker',
      );
    }
  }

  static tz.TZDateTime _nextInstanceOfHour(int hour) {
  final now = tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'));
  var scheduledDate = tz.TZDateTime(
    tz.getLocation('Asia/Kolkata'),
    now.year,
    now.month,
    now.day,
    hour,
  );

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(Duration(days: 1));
  }
  return scheduledDate;
}
  
}
