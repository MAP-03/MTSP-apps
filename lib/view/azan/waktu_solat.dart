import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/notification_service.dart';

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
  final NotificationService _notificationService = NotificationService();

  Stream remainsTime() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (i) {
      String nextprayer = widget.prayerTimes.nextPrayer();
      DateTime nextPrayerTime = widget.prayerTimes.timeForPrayer(nextprayer)!.toLocal();
      DateTime now = DateTime.now();
      Duration remains = nextPrayerTime.difference(now);
      return secondToHour(remains.inSeconds);
    });
  }

  String secondToHour(int seconds) {
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    seconds = seconds - minutes * 60;
    minutes = minutes - hours * 60;

    return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  late Map<String, bool> isAlarmOnMap = {};

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    loadAlarmStates();
  }

  void loadAlarmStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
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

 void toggleAlarm(String azanName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool currentAlarmState = isAlarmOnMap[azanName] ?? false;  // Get the current state
  bool newAlarmState = !currentAlarmState;  // Toggle the current state

  setState(() {
    isAlarmOnMap[azanName] = newAlarmState;  // Update the map with the new state
    prefs.setBool('$azanName' + 'AlarmOn', newAlarmState);  // Save the new state to SharedPreferences
  });

  DateTime azanTime;
  // Determine the correct azan time based on the azanName
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

  // Depending on the new alarm state, schedule or cancel the notification
  if (newAlarmState) {
    print('Scheduling notification for $azanName at $azanTime');
    _notificationService.scheduleAzanNotification(azanName, azanTime, newAlarmState);
    _notificationService.scheduleAzanDebugNotification(azanName, azanTime);  // Schedule the debug notification
  } else {
    print('Canceling notification for $azanName');
    _notificationService.cancelAzanNotification(azanName);
  }
}
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

String timePresenter(DateTime dateTime) {
  bool isPM = dateTime.hour >= 12;

  int hour = isPM ? dateTime.hour - 12 : dateTime.hour % 12;
  if (hour == 0) hour = 12;

  int minute = dateTime.minute;
  String hourInString = hour.toString().padLeft(2, '0');
  String minuteInString = minute.toString().padLeft(2, '0');

  return "$hourInString:$minuteInString ${isPM ? 'PM' : 'AM'}";
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
    return timePresenter(prayerTimes.fajr!.add(const Duration(days: 1)).toLocal());
  }
}
