import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:intl/intl.dart';
import 'package:mtsp/services/berita_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewEventLinkedBeritaWidget extends StatelessWidget {
  final BeritaService beritaService = BeritaService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: beritaService.getEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text("Something went wrong", style: GoogleFonts.poppins(color: Colors.white));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No Data Found", style: GoogleFonts.poppins(color: Colors.white));
        }

        var docs = snapshot.data!.docs;
        return CarouselSlider.builder(
          itemCount: docs.length,
          itemBuilder: (context, index, realIndex) {
            var doc = docs[index];
            var data = doc.data() as Map<String, dynamic>;

            DateTime date = (data['date'] as Timestamp).toDate();
            String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Container(
                height: 100,  // Set a fixed height for the card
                width: MediaQuery.of(context).size.width * 0.92,  // Make the card wider
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? 'No Title',
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                            image: NetworkImage(data['imageLink'] ?? 'https://via.placeholder.com/150'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 150,  // Ensure the height is set to maintain the size
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 2.0,  // Adjust aspect ratio to make the carousel wider
            viewportFraction: 1.0,  // Adjust viewport fraction to make the carousel wider
            enableInfiniteScroll: true,
          ),
        );
      },
    );
  }
}
