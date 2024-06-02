import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/components/submit_button.dart';
import 'package:mtsp/global.dart';

class AduanForm extends StatefulWidget {
  const AduanForm({super.key});
  
  @override
  State<AduanForm> createState() => _AduanFormState();
}

class _AduanFormState extends State<AduanForm> {
  final TextEditingController aduanSubjectController = TextEditingController();
  final TextEditingController aduanDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: primaryColor,
          title: Text('Aduan & Cadangan', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 30
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            //form body
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Aduan OR Cadangan
                    Text('Aduan / Cadangan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 5),
                    //Aduan OR Cadangan Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton<String>(
                        value: 'Aduan',
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF595858)),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? newValue) {
                          // setState(() {
                          //   dropdownValue = newValue!;
                          // });
                        },
                        items: <String>['Aduan', 'Cadangan']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      ),
                    ),
              
                    const SizedBox(height: 25),
              
                    //Aduan Subjek
                    Text('Subjek', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 5),
                    //Aduan Subjek TextField
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: aduanSubjectController,
                        decoration: InputDecoration(
                          hintText: 'Tulis subjek aduan anda',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF595858)),
                          filled: true,
                          fillColor: Colors.white,
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          // ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primaryButtonColor, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, color: primaryColor),
                            onPressed: () {
                              aduanSubjectController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
              
                    const SizedBox(height: 25),
              
                    //Aduan Description
                    Text('Komen', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 5),
                    //Aduan Description TextField
                    Container(
                      child: TextField(
                        controller: aduanDescriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF595858)),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primaryButtonColor, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            const SizedBox(height: 25),
        
            //Submit Button
            SubmitButton(
              text: 'Submit', 
              buttonColor: primaryButtonColor,
              onTap: () {},
            ),
        
            const SizedBox(height: 15),
        
            //Save Draft Button
            SubmitButton(
              text: 'Simpan Draft', 
              buttonColor: secondaryButtonColor,
              onTap: () {},
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
    );
  }
}