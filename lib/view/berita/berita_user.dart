import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';  // For date formatting
import 'package:mtsp/global.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'detail_page.dart';
import 'package:mtsp/widgets/berita_user_card.dart';  // Ensure this import is added

class BeritaUser extends StatefulWidget {
  const BeritaUser({Key? key}) : super(key: key);

  @override
  State<BeritaUser> createState() => _BeritaUserState();
}

class _BeritaUserState extends State<BeritaUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void navigateToDetail(
      String title, String date, String description, String imageUrl) {
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

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        backgroundColor: primaryColor,
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Berita').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Something went wrong",
                style: GoogleFonts.poppins(color: Colors.white));
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var data = doc.data() as Map<String, dynamic>;
                String formattedDate = data['date'] != null
                    ? DateFormat('dd MMM yyyy, h:mm a').format((data['date'] as Timestamp).toDate())
                    : 'No Date';
                return GestureDetector(
                  onTap: () => navigateToDetail(
                    data['title'] ?? 'No Title',
                    formattedDate,
                    data['description'] ?? 'No Description',
                    data['imageLink'] ?? 'https://via.placeholder.com/150',
                  ),
                  child: EventCard(
                    title: data['title'] ?? 'No Title',
                    date: formattedDate,
                    description: data['description'] ?? 'No Description',
                    imageUrl: data['imageLink'] ?? 'https://via.placeholder.com/150',
                  ),
                );
              },
            );
          }
          return Text("No Data Found",
              style: GoogleFonts.poppins(color: Colors.white));
        },
      ),
    );
  }
}
