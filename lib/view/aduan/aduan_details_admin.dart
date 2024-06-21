
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/models/aduan.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/components/submit_button.dart';
import 'package:mtsp/services/aduan_service.dart';

class AduanDetailsAdminPage extends StatefulWidget {
  final String docID;
  final Aduan aduan;

  const AduanDetailsAdminPage({
    super.key,
    required this.docID,
    required this.aduan,
  });

  @override
  State<AduanDetailsAdminPage> createState() => _AduanDetailsAdminPageState();
}

class _AduanDetailsAdminPageState extends State<AduanDetailsAdminPage> {
  final AduanService aduanService = AduanService();
  final TextEditingController aduanReplyController = TextEditingController();

  void updateAduan(String docID) {
    Aduan newAduan = Aduan (
      type: widget.aduan.type,
      subject: widget.aduan.subject,
      comment: widget.aduan.comment,
      status: widget.aduan.status,
      userEmail: widget.aduan.userEmail,
      reply: aduanReplyController.text,
      timestamp: widget.aduan.timestamp,
    );

    aduanService.updateAduan(docID, newAduan);
    Navigator.pop(context);
  }

  void deleteAduan(String docID) {
    // confirm delete
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor,
          title: const Text('Delete Aduan', style: TextStyle(color: Colors.white)),
          content: const Text('Are you sure you want to delete this aduan?', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                aduanService.deleteAduan(docID);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
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
          // height: MediaQuery.of(context).size.height,
          child: Column(
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
                    // Aduan Status Dropdown
                    Container(
                      width: double.infinity,
                      height: 45,
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton<String>(
                        value: widget.aduan.status,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                        isExpanded: true,
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: widget.aduan.statusList.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.aduan.status = newValue!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text('User Email: ${widget.aduan.userEmail}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),

                    const SizedBox(height: 25),
                    
                    Text('Aduan Type: ${widget.aduan.type}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),

                    const SizedBox(height: 25),

                    Text('Subject: ${widget.aduan.subject}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),

                    const SizedBox(height: 25),
                    
                    Text('Comment', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        widget.aduan.comment,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black)
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text('Admin Reply', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 280,
                      child: TextField(
                        controller: aduanReplyController,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: widget.aduan.reply?.isEmpty ?? true ? 'Masih tiada balasan daripada Admin' : widget.aduan.reply!,
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
          
              //Submit Button
              SubmitButton(
                text: 'Update', 
                buttonColor: primaryButtonColor,
                onTap: () {
                  updateAduan(widget.docID);
                },
              ),

              const SizedBox(height: 15),

              SubmitButton(
                text: 'Delete', 
                buttonColor: Colors.red,
                onTap: () {
                  deleteAduan(widget.docID);
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