// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:mtsp/global.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class PrayTime extends StatefulWidget {
  const PrayTime({
    Key? key,
    required this.azanTime,
    required this.azanName,
    required this.isAlarmOn,
    required this.isCurrentPrayer,
    required this.isNextPrayer,
    required this.prayerTimes,

  }) : super(key: key);

  final String azanTime;
  final String azanName;
  final bool isAlarmOn;
  final bool isCurrentPrayer;
  final bool isNextPrayer;
  final PrayerTimes prayerTimes;

  @override
  State<PrayTime> createState() => _PrayTimeState();
}

class _PrayTimeState extends State<PrayTime> {
  
 Stream remainsTime() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (i) {
      String nextprayer = widget.prayerTimes.nextPrayer(); // Access widget.prayerTimes instead of prayerTimes
      DateTime nextPrayerTime = widget.prayerTimes.timeForPrayer(nextprayer)!.toLocal(); // Access widget.prayerTimes instead of prayerTimes
      DateTime now = DateTime.now();
      Duration remains = nextPrayerTime.difference(now);
      return secondToHour(remains.inSeconds);
    });
  }

secondToHour(int seconds){
  int minutes = seconds ~/ 60;
  int hours = minutes ~/ 60;
  seconds = seconds - minutes * 60;
  minutes = minutes - hours * 60;

  return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}
  
  late Map<String, bool> isAlarmOnMap = {}; // Initialize isAlarmOnMap as an empty map

  @override
  void initState() {
    super.initState();
    loadAlarmStates(); // Load the alarm states when the widget initializes
  }

  void loadAlarmStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve the alarm states from SharedPreferences, defaulting to false if not found
      isAlarmOnMap = {
        'Subuh': prefs.getBool('SubuhAlarmOn') ?? false,
        'Syuruk': prefs.getBool('SyurukAlarmOn') ?? false,
        'Zohor': prefs.getBool('ZohorAlarmOn') ?? false,
        'Asar': prefs.getBool('AsarAlarmOn') ?? false,
        'Maghrib': prefs.getBool('MaghribAlarmOn') ?? false,
        'Isyak': prefs.getBool('IsyakAlarmOn') ?? false,
      };
    });
  }

 void schedulePrayerNotification(String azanName, DateTime azanTime) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: azanName.hashCode,
      channelKey: 'basic_channel',
      title: 'Prayer Time',
      body: 'It\'s time for $azanName prayer.',
      notificationLayout: NotificationLayout.Default,
    ),
    schedule: NotificationCalendar.fromDate(date: azanTime),
  );

  DateTime upcomingAzanTime = azanTime.subtract(Duration(hours: 4, minutes: 03));
    print('Scheduling upcoming notification for $azanName at $upcomingAzanTime'); // Debug statement
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: (azanName + '_upcoming').hashCode,
        channelKey: 'basic_channel',
        title: 'Upcoming Prayer Time',
        body: '$azanName prayer is in 4 hours and 03 minutes.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: upcomingAzanTime),
    );
}

void cancelPrayerNotification(String azanName) {
  AwesomeNotifications().cancel(azanName.hashCode);
  AwesomeNotifications().cancel((azanName + '_upcoming').hashCode);
}
  void toggleAlarm(String azanName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    isAlarmOnMap[azanName] = !(isAlarmOnMap[azanName] ?? false); // Toggle alarm state
    prefs.setBool('$azanName' + 'AlarmOn', isAlarmOnMap[azanName] ?? false); // Save the updated alarm state

    if (isAlarmOnMap[azanName] == true) {
      // Schedule notification for the azan time
      DateTime azanTime;
      switch (azanName) {
        case 'Subuh':
          azanTime = widget.prayerTimes.fajr!.toLocal();
          break;
        case 'Syuruk':
          azanTime = widget.prayerTimes.sunrise!.toLocal();
          break;
        case 'Zohor':
          azanTime = widget.prayerTimes.dhuhr!.toLocal();
          break;
        case 'Asar':
          azanTime = widget.prayerTimes.asr!.toLocal();
          break;
        case 'Maghrib':
          azanTime = widget.prayerTimes.maghrib!.toLocal();
          break;
        case 'Isyak':
          azanTime = widget.prayerTimes.isha!.toLocal();
          break;
        default:
          return;
      }
      print('Scheduling notification for $azanName at $azanTime');
      schedulePrayerNotification(azanName, azanTime);
    } else {
      // Cancel notification for the azan time
      cancelPrayerNotification(azanName);
    }
  });
}

 /*   void triggerTestNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 9999, // Unique ID for the test notification
        channelKey: 'basic_channel',
        title: 'Test Notification',
        body: 'This is a test notification to check if the system works correctly.',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }  */
  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.isCurrentPrayer ? Colors.blue : primaryColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 45,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: bgColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  widget.azanName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                toggleAlarm(widget.azanName); 
                // Toggle alarm state when tapped
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: isAlarmOnMap[widget.azanName] ?? false
                    ? Icon(
                        Icons.alarm_on,
                        color: Colors.white,
                        size: 20,
                      )
                    : Icon(
                        Icons.alarm_off,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
            widget.isNextPrayer
            ? StreamBuilder(
                stream: remainsTime(),
                builder: (context, snapshot) {
                  // Display the remaining time if data is available
                  return Container(
                    width: 50,
                    child: Text(
                      '${snapshot.data ?? ''}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  );
                },   
              )
            : SizedBox(width: 50),
              
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  widget.azanTime,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}


String timePresenter(DateTime dateTime){
  bool isPM = dateTime.hour >= 12; // Check if hour is greater than or equal to 12 to determine PM
  
  int hour = isPM ? dateTime.hour - 12 : dateTime.hour % 12; // Adjust hour for PM if necessary
  if(hour == 0) hour = 12; // Handle midnight (0 hour)
  
  int minute = dateTime.minute;
  String hourInString = hour.toString().padLeft(2, '0'); // Pad single digit hours with leading zero
  String minuteInString = minute.toString().padLeft(2, '0'); // Pad single digit minutes with leading zero
  
  return "$hourInString:$minuteInString ${isPM ? 'PM' : 'AM'}"; // Use isPM flag to determine AM/PM
}


String getNextPrayerTime(PrayerTimes prayerTimes) {
  DateTime now = DateTime.now();

  if (now.isBefore(prayerTimes.fajr!)) {
    return timePresenter(prayerTimes.fajr!.toLocal());
  } else if (now.isBefore(prayerTimes.sunrise!)) {
    return timePresenter(prayerTimes.sunrise!.toLocal());
  } else if (now.isBefore(prayerTimes.dhuhr!)) {
    return timePresenter(prayerTimes.dhuhr!.toLocal());
  } else if (now.isBefore(prayerTimes.asr!)) {
    return timePresenter(prayerTimes.asr!.toLocal());
  } else if (now.isBefore(prayerTimes.maghrib!)) {
    return timePresenter(prayerTimes.maghrib!.toLocal());
  } else if (now.isBefore(prayerTimes.isha!)) {
    return timePresenter(prayerTimes.isha!.toLocal());
  } else {
    // If it's after Isha, return Fajr of the next day
    return timePresenter(prayerTimes.fajr!.add(const Duration(days: 1)).toLocal());
  }
}