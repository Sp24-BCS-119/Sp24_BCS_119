import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _plugin.initialize(settings);
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleTask(Task task) async {
    await cancelTask(task.id);

    final notificationTime = task.dueDate.subtract(const Duration(minutes: 30));
    if (task.isCompleted || notificationTime.isBefore(DateTime.now())) {
      return;
    }

    final scheduled = tz.TZDateTime.from(notificationTime, tz.local);
    final body =
        '${task.title} starts at ${DateFormat('hh:mm a').format(task.dueDate)}';

    await _plugin.zonedSchedule(
      task.id.hashCode,
      'Upcoming task reminder',
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'taskflow_channel',
          'Task reminders',
          channelDescription: 'Alerts for upcoming due tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelTask(String taskId) async {
    await _plugin.cancel(taskId.hashCode);
  }
}
