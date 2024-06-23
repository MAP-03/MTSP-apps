import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/models/aduan.dart';
import 'package:mtsp/view/aduan/aduan_form.dart';
import 'package:mtsp/global.dart';

class AduanDetailsPage extends StatelessWidget {
  final Aduan aduan;
  final String aduanDocID;

  const AduanDetailsPage({
    super.key,
    required this.aduan,
    required this.aduanDocID,
  });
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //form body
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Aduan Type
                        Text(
                          aduan.type,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),

                        // Aduan Status
                        Container(
                          width: 80,
                          height: 25,
                          decoration: BoxDecoration(
                            color: aduan.getStatusColor(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              aduan.status,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                            ),
                          )
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Aduan Subject
                    Text(
                      'Subjek:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      )
                    ),
                    const SizedBox(height: 5),
                    Text(
                      aduan.subject,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white
                      )
                    ),

                    const SizedBox(height: 20),
                    
                    // Aduan Description
                    Text(
                      'Komen',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        aduan.comment,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Admin Reply
                    if (aduan.status != "DRAFT") ...[
                      Text(
                        'Dari Admin',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          aduan.reply?.isEmpty ?? true
                            ? 'Masih tiada balasan daripada Admin'
                            : aduan.reply!,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: aduan.status == "DRAFT"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AduanForm(
                      aduan: aduan,
                      aduanDocID: aduanDocID,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.edit, color: primaryColor),
            )
          : null,
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Text(
        'Aduan & Cadangan',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: Colors.black,
          height: 2,
        ),
      ),
    );
  }
}