
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/models/aduan.dart';
import 'package:mtsp/global.dart';

class AduanDetailsPage extends StatefulWidget {
  final Aduan aduan;

  const AduanDetailsPage({
    super.key,
    required this.aduan,
  });

  @override
  State<AduanDetailsPage> createState() => _AduanDetailsPageState();
}

class _AduanDetailsPageState extends State<AduanDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: primaryColor,
          title: Text('Aduan & Cadangan', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30
            ),
            onPressed: () {
              // _scaffoldKey.currentState!.openDrawer();
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 2,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Aduan Details'),
      ),
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
    );
  }
}