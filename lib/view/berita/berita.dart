import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'add_event_page.dart';
import 'package:mtsp/widgets/berita_card.dart';

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
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white, size: 30),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        backgroundColor: primaryColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(color: Colors.black, height: 2),
        ),
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
                return EventCard(
                  title: data['title'] ?? 'No Title',
                  date: data['date']?.toDate().toString() ?? 'No Date',
                  description: data['description'] ?? 'No Description',
                  imageUrl:
                      data['imageLink'] ?? 'https://via.placeholder.com/150',
                  onEdit: () {},
                  onDelete: () {
                    FirebaseFirestore.instance
                        .collection('Berita')
                        .doc(doc.id)
                        .delete();
                  },
                );
              },
            );
          }
          return Text("No Data Found",
              style: GoogleFonts.poppins(color: Colors.white));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddEventPage()));
        },
        child: Icon(Icons.add, color: primaryColor),
        backgroundColor: Colors.white,
      ),
    );
  }
}
