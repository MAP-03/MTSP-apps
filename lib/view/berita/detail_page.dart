// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imageUrl;
  final Color headerColor;
  final Color backgroundColor;

  DetailPage({
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
    this.headerColor = const Color(0xff06142F),
    this.backgroundColor = const Color(0xff06142F),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: headerColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
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
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                date,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                 textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
