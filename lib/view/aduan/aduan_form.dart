import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/components/submit_button.dart';
import 'package:mtsp/global.dart';

class AduanForm extends StatefulWidget {
  const AduanForm({super.key});
  
  @override
  _AduanFormState createState() => _AduanFormState();
}

class _AduanFormState extends State<AduanForm> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
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
      body: Column(
        children: [
          //form body
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Aduan Type
                Container(
                  child: Column(
                    children: [
                      Text('Aduan / Cadangan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 5),
                      Container(
                        
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //Aduan Subject
                Container(
                  child: Column(
                    children: [
                      Text('Subjek', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Tulis subjek aduan anda',
                          hintStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //Aduan Description
                Container(
                  child: Column(
                    children: [
                      Text('Komen', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 5),
                      Container(
                        
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          //Submit Button
          SubmitButton(
            text: 'Submit', 
            buttonColor: const Color(0xFF0096C7),
            onTap: () {},
          ),

          const SizedBox(height: 15),

          //Save Draft Button
          SubmitButton(
            text: 'Simpan Draft', 
            buttonColor: const Color(0xFF023E8A),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}