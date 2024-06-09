/* import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'package:jhijri_picker/jhijri_picker.dart';
import 'package:hijri/hijri_calendar.dart' as hijri;

class Kalendar extends StatefulWidget {
  const Kalendar({super.key});

  @override
  State<Kalendar> createState() => _KalendarState();
}

class _KalendarState extends State<Kalendar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  hijri.HijriCalendar _selectedDate = hijri.HijriCalendar.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(
            'Kalendar',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected Hijri Date:',
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
            ),
            Text(
              '${_selectedDate.toFormat("dd-MM-yyyy")}',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Hijri Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Button color
                foregroundColor: Colors.white, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final hijri.HijriCalendar? picked = await showHijriDatePicker(
      context: context,
      initialDate: _selectedDate,
      lastDate: hijri.HijriCalendar()
        ..hYear = 1450
        ..hMonth = 9
        ..hDay = 25,
      firstDate: hijri.HijriCalendar()
        ..hYear = 1430
        ..hMonth = 9
        ..hDay = 25,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
 */