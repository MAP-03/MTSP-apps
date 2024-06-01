
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'detail_page.dart';
import 'add_event_page.dart';  // Import the AddEventPage

class Berita extends StatefulWidget {
  const Berita({Key? key}) : super(key: key);

  @override
  State<Berita> createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void navigateToDetail(String title, String date, String description, String imageUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DetailPage(
          title: title,
          date: date,
          description: description,
          imageUrl: imageUrl,
          headerColor: Color(0xff06142F),
          backgroundColor: Color(0xff06142F),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

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
            GestureDetector(
              onTap: () {
                navigateToDetail(
                  'Ceramah Khas Ustaz Kazim Elias : Kitab Anak Kunci Syurga',
                  '28 Julai 2019 (Ahad)',
                  'Ceramah ini akan membahas isi penting dalam Kitab Anak Kunci Syurga, yang pasti memberi manfaat kepada kita semua dalam meningkatkan pemahaman agama dan keimanan.',
                  'lib/images/Ustaz Kazim Elias.jpg',
                );
              },
              child: Padding(
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
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Handle edit
                            },
                            child: Text(
                              'EDIT',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle delete
                            },
                            child: Text(
                              'DELETE',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add more GestureDetector widgets for other events
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.event),
                  title: Text('Add Event'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEventPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.article),
                  title: Text('Add News'),
                  onTap: () {
                    // Handle Add News
                  },
                ),
                ListTile(
                  leading: Icon(Icons.announcement),
                  title: Text('Add Announcement'),
                  onTap: () {
                  },
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }
}
