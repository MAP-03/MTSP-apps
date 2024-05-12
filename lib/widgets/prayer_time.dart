import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:mtsp/global.dart';

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

  void toggleAlarm(String azanName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAlarmOnMap[azanName] = !(isAlarmOnMap[azanName] ?? false); // Toggle alarm state, default to false if null
      prefs.setBool('$azanName' + 'AlarmOn', isAlarmOnMap[azanName] ?? false); // Save the updated alarm state to SharedPreferences
    });
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
            if (widget.isNextPrayer)
              StreamBuilder(
                stream: remainsTime(),
                builder: (context, snapshot) {
                    // Display the remaining time if data is available
                    return Text(
                      '${snapshot.data??''}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    );
                  },   
              ),
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


String getCurrentPrayerTime(PrayerTimes prayerTimes) {
  DateTime now = DateTime.now();

  // Determine which prayer time it currently is
  if (now.isBefore(prayerTimes.fajr!)) {
    return timePresenter(prayerTimes.fajr!.toLocal());
  } else if (now.isBefore(prayerTimes.sunrise!)) {
    return timePresenter(prayerTimes.fajr!.toLocal());
  } else if (now.isBefore(prayerTimes.dhuhr!)) {
    return timePresenter(prayerTimes.sunrise!.toLocal());
  } else if (now.isBefore(prayerTimes.asr!)) {
    return timePresenter(prayerTimes.dhuhr!.toLocal());
  } else if (now.isBefore(prayerTimes.maghrib!)) {
    return timePresenter(prayerTimes.asr!.toLocal());
  } else if (now.isBefore(prayerTimes.isha!)) {
    return timePresenter(prayerTimes.maghrib!.toLocal());
  } else {
    return timePresenter(prayerTimes.isha!.toLocal());
  }
}