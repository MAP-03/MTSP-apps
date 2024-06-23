import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:mtsp/view/kalendar/acara.dart'; // Assuming Event class is defined in this package

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Coordinates coordinates =
      Coordinates(1.5638129487418682, 103.61735116456667); // Coordinates for prayer time calculations
  final CalculationParameters params = CalculationMethod.Malaysia()
    ..madhab = Madhab.shafi;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Request permission for notifications on Android
    await requestNotificationPermission();

    // Schedule daily prayer time update
    await scheduleDailyPrayerTimeUpdate();
  }

  Future<void> requestNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      if (granted != true) {
        // Handle the case when permission is denied
        print("Notification permission denied");
      }
    }
  }

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

    if (eventTime.isAfter(now) && isSameDay(now, eventTime)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.id.hashCode,
        'Peringatan Acara - Hari Ini',
        'Acara anda "${event.note}" akan bermula hari ini!',
        eventTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    tz.TZDateTime notificationTime =
        eventTime.subtract(const Duration(days: 1));

    if (notificationTime.isAfter(now) && isSameDay(now, notificationTime)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.id.hashCode + 1,
        'Peringatan Acara - Esok',
        'Acara anda "${event.note}" akan bermula dalam 24 jam!',
        notificationTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> scheduleAzanNotification(String azanName, DateTime azanTime, bool isAlarmOn) async {
    if (!isAlarmOn) return;

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

    if (notificationTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        azanName.hashCode,
        'Peringatan Solat',
        'Sudah tiba masanya untuk solat $azanName.',
        notificationTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    tz.TZDateTime reminderTime = notificationTime.subtract(const Duration(minutes: 10));
    if (reminderTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        (azanName + '_reminder').hashCode,
        'Peringatan Solat Akan Datang',
        'Solat $azanName akan bermula dalam 10 minit.',
        reminderTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleDailyPrayerTimeUpdate() async {
    final DateTime now = DateTime.now();
    final PrayerTimes prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: now,
      calculationParameters: params,
      precision: true,
    );

    // Load alarm states from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, bool> alarmStates = {
      'Subuh': prefs.getBool('SubuhAlarmOn') ?? false,
      'Syuruk': prefs.getBool('SyurukAlarmOn') ?? false,
      'Zohor': prefs.getBool('ZohorAlarmOn') ?? false,
      'Asar': prefs.getBool('AsarAlarmOn') ?? false,
      'Maghrib': prefs.getBool('MaghribAlarmOn') ?? false,
      'Isyak': prefs.getBool('IsyakAlarmOn') ?? false,
    };

    // Schedule notifications based on prayer times
    await scheduleAzanNotification('Subuh', prayerTimes.fajr!.toLocal(), alarmStates['Subuh']!);
    await scheduleAzanNotification('Syuruk', prayerTimes.sunrise!.toLocal(), alarmStates['Syuruk']!);
    await scheduleAzanNotification('Zohor', prayerTimes.dhuhr!.toLocal(), alarmStates['Zohor']!);
    await scheduleAzanNotification('Asar', prayerTimes.asr!.toLocal(), alarmStates['Asar']!);
    await scheduleAzanNotification('Maghrib', prayerTimes.maghrib!.toLocal(), alarmStates['Maghrib']!);
    await scheduleAzanNotification('Isyak', prayerTimes.isha!.toLocal(), alarmStates['Isyak']!);

    // Schedule this function to run daily at midnight
    tz.TZDateTime nowTz = tz.TZDateTime.now(tz.local);
    tz.TZDateTime nextMidnight = tz.TZDateTime(tz.local, nowTz.year, nowTz.month, nowTz.day + 1);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      'daily_update'.hashCode,
      'Daily Prayer Time Update',
      'Updating prayer times for the day.',
      nextMidnight,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_update_channel_id',
          'Daily Update',
          channelDescription: 'Updates the daily prayer times',
          importance: Importance.low,
          priority: Priority.low,
          showWhen: false,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void cancelAzanNotification(String azanName) {
    flutterLocalNotificationsPlugin.cancel(azanName.hashCode);
    flutterLocalNotificationsPlugin.cancel((azanName + '_reminder').hashCode);
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
