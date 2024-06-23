import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/components/submit_button.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/aduan.dart';
import 'package:mtsp/services/aduan_service.dart';

class AduanForm extends StatefulWidget {
  final Aduan? aduan;
  final String? aduanDocID;

  const AduanForm({super.key, this.aduan, this.aduanDocID});
  
  @override
  State<AduanForm> createState() => _AduanFormState();
}

class _AduanFormState extends State<AduanForm> {
  final TextEditingController aduanSubjectController = TextEditingController();
  final TextEditingController aduanDescriptionController = TextEditingController();

  String aduanType = 'Aduan';
  var aduanTypeList = ['Aduan', 'Cadangan'];

  @override
  void initState() {
    super.initState();
    if (widget.aduan != null) {
      aduanType = widget.aduan!.type;
      aduanSubjectController.text = widget.aduan!.subject;
      aduanDescriptionController.text = widget.aduan!.comment;
    }
  }

  void submitAduan(bool isDraft) {
    if (aduanSubjectController.text.isNotEmpty && aduanDescriptionController.text.isNotEmpty) {
      String aduanStatus = 'PENDING';

      if (isDraft) {
        aduanStatus = 'DRAFT';
      }

      if (widget.aduanDocID != null) {
        Aduan updatedAduan = Aduan(
          userEmail: widget.aduan!.userEmail,
          type: aduanType,
          subject: aduanSubjectController.text,
          comment: aduanDescriptionController.text,
          reply: widget.aduan?.reply,
          status: aduanStatus,
          timestamp: Timestamp.now(),
        );
        // Update existing aduan
        AduanService().updateAduan(
          widget.aduanDocID!,
          updatedAduan,
        );
      } else {
        // Add new aduan
        AduanService().addAduan(
          aduanType,
          aduanSubjectController.text,
          aduanDescriptionController.text,
          aduanStatus,
        );
      }

      aduanSubjectController.clear();
      aduanDescriptionController.clear();
      Navigator.popUntil(context, ModalRoute.withName('/aduan'));
    }
  }

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
              Icons.arrow_back_ios_new_rounded,
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Form body
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Aduan OR Cadangan
                    Text('Aduan / Cadangan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                    const SizedBox(height: 5),
                    // Aduan OR Cadangan Dropdown
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton<String>(
                        value: aduanType,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                        isExpanded: true,
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: aduanTypeList.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            aduanType = newValue!;
                          });
                        },
                      ),
                    ),
              
                    const SizedBox(height: 25),
              
                    // Aduan Subjek
                    Text('Subjek', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                    const SizedBox(height: 5),
                    // Aduan Subjek TextField
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: aduanSubjectController,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          hintText: 'Tulis subjek aduan anda',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(size: 20, Icons.clear, color: Colors.grey),
                            onPressed: () {
                              aduanSubjectController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
              
                    const SizedBox(height: 25),
              
                    // Aduan Description
                    Text('Komen', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                    const SizedBox(height: 5),
                    // Aduan Description TextField
                    SizedBox(
                      height: 280,
                      child: TextField(
                        controller: aduanDescriptionController,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: 'Nyatakan komen anda disini...',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
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
          
              const SizedBox(height: 25),
          
              // Submit Button
              SubmitButton(
                text: 'Submit', 
                buttonColor: primaryButtonColor,
                onTap: () {
                  submitAduan(false);
                },
              ),
          
              const SizedBox(height: 15),
          
              // Save Draft Button
              SubmitButton(
                text: 'Simpan Draft', 
                buttonColor: secondaryButtonColor,
                onTap: () {
                  submitAduan(true);
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
    );
  }
}