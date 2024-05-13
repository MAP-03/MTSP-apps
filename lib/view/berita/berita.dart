// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/widgets/drawer.dart';

class Berita extends StatefulWidget {
  const Berita({Key? key}) : super(key: key);

  @override
  State<Berita> createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Berita Masjid',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white, size: 30),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        backgroundColor: primaryColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 2,
          ),
        ),
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Berita Terbaru',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Dapatkan Informasi terkini seputar kegiatan di masjid',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200, 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('lib/images/Ustaz Kazim Elias.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '28 Julai 2019 (Ahad)',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Ceramah Khas Ustaz Kazim Elias : Kitab Anak Kunci Syurga',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: 2, 
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200, 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('lib/images/Prof Madya Mohd Nor.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.black,
                          size: 24,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '9 Disember 2023 (Ahad)',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Ceramah Parenting “Ibu Bapa Gemilang, Anak Cemerlang” oleh Prof Madya DR Mohd Nor Mamat',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: 2, 
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
