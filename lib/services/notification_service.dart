import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mtsp/view/kalendar/acara.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request permission for notifications on Android and iOS
    await requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      if (granted != true) {
        // Handle the case when permission is denied
        print("Notification permission denied");
      }
    }
  }

  //
  // EVENT NOTIFICATIONS
  //
  Future<void> scheduleEventNotification(Event event) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'event_channel_id',
      'Event Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime eventTime = tz.TZDateTime.from(event.startDate, tz.local);

    // Schedule notification for today's date and time if it's not past
    if (eventTime.isAfter(now) && isSameDay(now, eventTime)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.id.hashCode,
        'Event Reminder - Today',
        'Your event "${event.note}" is starting today!',
        eventTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    // Schedule notification 24 hours before the event if it's tomorrow
    tz.TZDateTime notificationTime = eventTime.subtract(const Duration(days: 1));

    // Ensure the notification is scheduled for today
    if (notificationTime.isAfter(now) && isSameDay(now, notificationTime)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.id.hashCode + 1, // Use a different ID for this notification
        'Event Reminder - Tomorrow',
        'Your event "${event.note}" is starting in 24 hours!',
        notificationTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  //
  // AZAN NOTIFICATIONS
  //
  Future<void> scheduleAzanNotification(String azanName, DateTime azanTime, bool isAlarmOn) async {
    if (!isAlarmOn) return; // Only schedule if the alarm toggle is on

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'azan_channel_id',
      'Azan Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime notificationTime = tz.TZDateTime.from(azanTime, tz.local);

    // Schedule notification for the azan time
    if (notificationTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        azanName.hashCode,
        'Prayer Reminder',
        'It\'s time for $azanName prayer.',
        notificationTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Schedule daily at this time
      );
    }

    // Schedule a reminder 10 minutes before the azan time
    tz.TZDateTime reminderTime = notificationTime.subtract(const Duration(minutes: 10));
    if (reminderTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        (azanName + '_reminder').hashCode,
        'Upcoming Prayer Reminder',
        '$azanName prayer is in 10 minutes.',
        reminderTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Schedule daily 10 minutes before azan time
      );
    }

    // Schedule the debug notification
    await scheduleAzanDebugNotification(azanName, azanTime);
  }

  Future<void> scheduleAzanDebugNotification(String azanName, DateTime azanTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'azan_debug_channel_id',
      'Debug Azan Notifications',
      importance: Importance.low, // Lower importance for debug notifications
      priority: Priority.low,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // Set the debug notification to trigger 2 minutes after scheduling
    tz.TZDateTime debugTime = now.add(const Duration(minutes: 2));

    // Schedule the debug notification
    if (debugTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        (azanName + '_debug').hashCode,
        'Debug Prayer Notification',
        'Debug: $azanName notification is set and will notify in 2 minutes.',
        debugTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void cancelAzanNotification(String azanName) {
    flutterLocalNotificationsPlugin.cancel(azanName.hashCode);
    flutterLocalNotificationsPlugin.cancel((azanName + '_reminder').hashCode);
    flutterLocalNotificationsPlugin.cancel((azanName + '_debug').hashCode);
  }

  void cancelEventNotification(int eventId) {
    flutterLocalNotificationsPlugin.cancel(eventId);
    flutterLocalNotificationsPlugin.cancel(eventId + 1);
  }

  bool isSameDay(tz.TZDateTime dateTime1, tz.TZDateTime dateTime2) {
    return dateTime1.year == dateTime2.year &&
           dateTime1.month == dateTime2.month &&
           dateTime1.day == dateTime2.day;
  }
}
