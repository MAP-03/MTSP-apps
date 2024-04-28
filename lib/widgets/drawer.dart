// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/view/login/authentication_page.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Color(0xff12223C),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xff06142F),
                  ),
                  child: Text(
                    'MTSP',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'E-Khairat',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                  },
                ),
                ListTile(
                  title: Text(
                    'Berita Masjid',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // Handle Berita Masjid tap
                  },
                ),
                ListTile(
                  title: Text(
                    'Infaq',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // Handle Infaq tap
                  },
                ),
                ListTile(
                  title: Text(
                    'Waktu Azan',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // Handle Waktu Azan tap
                  },
                ),
                ListTile(
                  title: Text(
                    'Kalendar',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // Handle Kalendar tap
                  },
                ),
                ListTile(
                  title: Text(
                    'Aduan/Cadangan',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // Handle Aduan/Cadangan tap
                  },
                ),
                ListTile(
                  title: Text(
                    'Cari Kami',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // Handle Cari Kami tap
                  },
                ),
              ]
            )
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.red,
              ),
            ),
            onTap: () async{

              await FirebaseAuth.instance.signOut();
              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              } else { 
              }

            },
          ),
        ],
      ),
    );
  }
}
