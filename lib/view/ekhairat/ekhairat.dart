// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/view/ekhairat/daftar_ahli.dart';
import 'package:mtsp/widgets/drawer.dart';

class Ekhairat extends StatefulWidget {
  const Ekhairat({super.key});

  @override
  State<Ekhairat> createState() => _EkhairatState();
}

class _EkhairatState extends State<Ekhairat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('E-Khairat', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: double.infinity,
              height: 310,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Tabung Khairat Kematian Masjid Taman Sri Pulai, Skudai, Johor (TKKMTSP) adalah satu tabung kebajikan yang ditubuhkan oleh Ahli Jawatan Kuasa dan Pegawai Masjid, Masjid Taman Sri Pulai (MTSP) (sebelum ini Masjid Intan Abu Bakar, Taman Sri Pulai, MIAB) pada tahun 2000. TKKMTSP diamanahkan kepada Biro Kebajikan, Sosial dan Kebudayaan, MTSP untuk diuruskan dengan lebih teratur dan berkesan mulai tahun 2006.',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xff0096C7),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Lebih Lanjut',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaftarAhli()));
                },
                child: Container(
                  width: 130,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff023E8A),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Daftar Ahli',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}