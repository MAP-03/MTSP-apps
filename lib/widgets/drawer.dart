// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/auth/authentication_page.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name;
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
                  child: Center(
                    child: Text(
                      'MTSP',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: currentRoute == '/home' ? Colors.blue : Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Home',
                        style: GoogleFonts.poppins(
                          color: currentRoute == '/home' ? Colors.blue : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  title: Text(
                    'E-Khairat',
                    style: GoogleFonts.poppins(
                      color: currentRoute == '/ekhairat' ? Colors.blue : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/ekhairat');
                  },
                ),
                ListTile(
                  title: Text(
                    'Berita Masjid',
                    style: GoogleFonts.poppins(
                      color: currentRoute == '/berita' ? Colors.blue : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/berita');
                  },
                ),
                ListTile(
                  title: Text(
                    'Infaq',
                    style: GoogleFonts.poppins(
                      color: currentRoute == '/infaq' ? Colors.blue : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/infaq');
                  },
                ),
                ListTile(
                  title: Text(
                    'Waktu Azan',
                    style: GoogleFonts.poppins(
                      color: currentRoute == '/azan' ? Colors.blue : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/azan');
                  },
                ),
                ListTile(
                  title: Text(
                    'Kalendar',
                    style: GoogleFonts.poppins(
                      color: currentRoute == '/kalendar' ? Colors.blue : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/kalendar');
                  },
                ),
                ListTile(
                  title: Text(
                    'Aduan/Cadangan',
                    style: GoogleFonts.poppins(
                      color: currentRoute == '/aduan' ? Colors.blue : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/aduan');
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
