import 'dart:developer';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mtsp/widgets/prayer_time.dart';

class Azan extends StatefulWidget {
  
  const Azan({Key? key}) : super(key: key);

  @override
  State<Azan> createState() => _AzanState();
}

List months=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
List hijri=["Muharram","Safar","Rabi'ul Awwal","Rabi'ul Akhir","Jumadal Ula","Jumadal Akhir","Rajab","Sha'ban","Ramadan","Shawwal","Dhul Qa'dah","Dhul Hijjah"];
class _AzanState extends State<Azan> {
  HijriCalendar _hijriCalendar = HijriCalendar.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PrayerTimes prayerTimes;
  late DateTime date;
  late Coordinates coordinates;
  late CalculationParameters params;
  @override
  void initState() {
    super.initState();
    coordinates = Coordinates(1.5638129487418682, 103.61735116456667);
    date = DateTime.now();
    params = CalculationMethod.Malaysia();
    params.madhab = Madhab.Shafi;
  }
  

  @override
  Widget build(BuildContext context) {
    prayerTimes = PrayerTimes(coordinates, date, params, precision: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(
            'Waktu Azan',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: primaryColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 2,
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center, // Align the column in the center vertically
          children: [
            Container( // Wrap the text with a container
            padding: const EdgeInsets.only(left: 10), 
        alignment: Alignment.centerLeft, // Align the text to the left
        child: const Text(
          "Lokasi:\nPulai, Johor Bahru",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 20),
            Container(
              width: 300,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                gradient: const LinearGradient(
                  end: Alignment(0.97, -0.26),
                  begin: Alignment(-0.97, 0.26),
                  colors: [Color(0xFF62CFF4), Color(0xFF2C67F2)],
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() {
                          date = date.subtract( const Duration(days: 1));
                          prayerTimes = PrayerTimes(coordinates, date, params, precision: true);
                          _hijriCalendar = HijriCalendar.fromDate(date);
                        }),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "${date.day} ${months[date.month-1]} ${date.year}\n${_hijriCalendar.hDay} ${hijri[_hijriCalendar.hMonth-1]}  ${_hijriCalendar.hYear} AH",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                         textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() {
                          date = date.add(const Duration(days: 1));
                          prayerTimes = PrayerTimes(coordinates, date, params, precision: true);
                           _hijriCalendar = HijriCalendar.fromDate(date);
                        }),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            PrayTime(
              azanTime:timePresenter(prayerTimes.fajr!.toLocal()),
              azanName: 'Subuh',
              isAlarmOn: true,
              isCurrentPrayer:prayerTimes.fajr!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.dhuhr!.toLocal()),
              isNextPrayer: DateTime.now().isAfter(prayerTimes.fajr!.add(const Duration(days: -1)).toLocal()) && DateTime.now().isBefore(prayerTimes.fajr!.add(const Duration(days: 0)).toLocal()),

              prayerTimes: prayerTimes,
             
              
            ),
            PrayTime(
              azanTime:timePresenter(prayerTimes.sunrise!.toLocal()),            
              azanName: 'Syuruk',
              isAlarmOn: false,
              isCurrentPrayer:prayerTimes.sunrise!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.dhuhr!.toLocal()),
              isNextPrayer:prayerTimes.fajr!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.dhuhr!.toLocal()),
              prayerTimes: prayerTimes,
            ),
            PrayTime(
              azanTime:timePresenter(prayerTimes.dhuhr!.toLocal()),
              azanName: 'Zohor',
              isAlarmOn: false,
              isCurrentPrayer:prayerTimes.dhuhr!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.asr!.toLocal()),
              isNextPrayer:prayerTimes.sunrise!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.dhuhr!.toLocal()),
              prayerTimes: prayerTimes,
            ),
             PrayTime(
              azanTime:timePresenter(prayerTimes.asr!.toLocal()),
              azanName: 'Asar',
              isAlarmOn: false,
              isCurrentPrayer:prayerTimes.asr!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.maghrib!.toLocal()),
              isNextPrayer:prayerTimes.dhuhr!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.asr!.toLocal()),
              prayerTimes: prayerTimes,
            ),
             PrayTime(
              azanTime:timePresenter(prayerTimes.maghrib!.toLocal()),
              azanName: 'Maghrib',
              isAlarmOn: false,
              isCurrentPrayer:prayerTimes.maghrib!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.isha!.toLocal()),
              isNextPrayer: prayerTimes.asr!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.maghrib!.toLocal()),
              prayerTimes: prayerTimes,
            ),
             PrayTime(
              azanTime:timePresenter(prayerTimes.isha!.toLocal()),
              azanName: 'Isyak',
              isAlarmOn: false,
              isCurrentPrayer:prayerTimes.isha!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.fajr!.add(const Duration(days: 1)).toLocal()),
              isNextPrayer: prayerTimes.maghrib!.toLocal().isBefore(DateTime.now()) && DateTime.now().isBefore(prayerTimes.isha!.toLocal()),
              prayerTimes: prayerTimes,
            ),
          ],
        ),
      ),
    );
  }
}



