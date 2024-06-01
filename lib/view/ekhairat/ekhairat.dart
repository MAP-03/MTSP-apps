// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/auth_service.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:mtsp/view/ekhairat/daftar_ahli.dart';
import 'package:mtsp/view/ekhairat/semak_ahli.dart';
import 'package:mtsp/view/ekhairat/senarai_ahli.dart';
import 'package:mtsp/widgets/drawer.dart';

class Ekhairat extends StatefulWidget {
  const Ekhairat({super.key});

  @override
  State<Ekhairat> createState() => _EkhairatState();
}

class _EkhairatState extends State<Ekhairat> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAhli = false;
  String? role;
  AuthService authService = AuthService();
  final Map<String, dynamic> userData = {}; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAhli();
    setState(() {
      authService.getCurrentUserData().then((value) {
        setState(() {
          userData.addAll(value);
          role = userData['role'];
        });
      });
    });
  }

  void checkAhli() async {
    final bool ahli = await EkhairatService().checkAhli(FirebaseAuth.instance.currentUser!.email);
    setState(() {
      isAhli = ahli;
    });
  }

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
                    'LEBIH LANJUT',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  if(role == 'user'){
                    if(isAhli){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SemakAhli()));
                    }
                    else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaftarAhli()));
                    }
                  }
                  else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SenaraiAhli()));
                  }
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
                    child: 
                    role == 'user' 
                    ? isAhli
                      ? Text(
                        'SEMAK AHLI',
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      )
                      : Text(
                        'DAFTAR AHLI',
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      )
                    : Text(
                      'SENARAI AHLI',
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
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