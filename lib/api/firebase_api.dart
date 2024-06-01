import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin? _localNotifications;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $FCMToken');
    await initPushNotification();
    await initLocalNotification();
  }

  Future<void> initLocalNotification() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    _localNotifications = FlutterLocalNotificationsPlugin();
    await _localNotifications?.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification payload: ${response.payload}');
      },
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlatform = _localNotifications?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlatform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      if (notification == null) return;

      _localNotifications?.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    });
  }

  Future<void> scheduleAzanNotification(String azanName, DateTime azanTime) async {
    if (_localNotifications == null) return;
    tz.initializeTimeZones();
    await _localNotifications!.zonedSchedule(
      azanName.hashCode,
      'Azan $azanName',
      'It\'s time for $azanName prayer',
      tz.TZDateTime.from(azanTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAzanNotification(String azanName) async {
    if (_localNotifications == null) return;
    await _localNotifications!.cancel(azanName.hashCode);
  }
}
