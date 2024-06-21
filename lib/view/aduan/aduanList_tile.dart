import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/models/aduan.dart';

class AduanListTile extends StatelessWidget {
  final Aduan aduan;
  final void Function() onTap;

  const AduanListTile({
    super.key,
    required this.aduan,
    required this.onTap,
  });

  DateTime getDateCreated() {
    DateTime dateCreated = aduan.timestamp.toDate();
    return dateCreated;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 350,
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: const Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Aduan Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(aduan.type, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black)),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: aduan.getStatusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            
              // Aduan Subject
              Text(
                aduan.subject,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)
              ),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tarikh Hantar: ${getDateCreated().day}/${getDateCreated().month}/${getDateCreated().year}',
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w200, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}