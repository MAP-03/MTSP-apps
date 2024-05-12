
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/view/ekhairat/daftar_tanggungan.dart';
import 'package:mtsp/widgets/toast.dart';

class DaftarAhli extends StatefulWidget {
  const DaftarAhli({super.key});

  @override
  State<DaftarAhli> createState() => _DaftarAhliState();
}

class _DaftarAhliState extends State<DaftarAhli> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController icController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();
  late Ahli ahli;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran Ahli', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            MemoryCache.instance.delete('ahli');
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
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: ShapeDecoration(
                    shape: OvalBorder(
                      side: BorderSide(width: 3, color: Color(0xFF0096FF)),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 65,
                    height: 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xFFA1A3B0),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: ShapeDecoration(
                      color: Color(0xFFA1A3B0),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 65,
                    height: 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xFFA1A3B0),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: ShapeDecoration(
                      color: Color(0xFFA1A3B0),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 65,
                    height: 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xFFA1A3B0),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: ShapeDecoration(
                      color: Color(0xFFA1A3B0),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('     Ahli', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                Text('  Tanggungan', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                Text('Pelan', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400,color: Colors.grey)),
                Text('    Bayaran', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
              ],
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.white,
              height: 1,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15),
                Text('Maklumat Ahli', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.start),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                height: 700,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Nama Penuh', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                          Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'MUHAMMAD ALI BIN ABU',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Email', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                          Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'mtsp@gmail.com',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('No. Kad Pengenalan', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                          Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10), 
                      TextField(
                        controller: icController,
                        decoration: InputDecoration(
                          hintText: '000000-00-0000',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Alamat', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                          Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: 'Alamat',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('No. Telefon', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                          Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: '0123456789',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('No. Telefon Kecemasan', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                          Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emergencyPhoneController,
                        decoration: InputDecoration(
                          hintText: '0123456789',
                          hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          if (nameController.text.isEmpty || emailController.text.isEmpty || icController.text.isEmpty || addressController.text.isEmpty || phoneController.text.isEmpty || emergencyPhoneController.text.isEmpty) {
            showToast(message: 'Sila lengkapkan semua maklumat yang diperlukan');
            return;
          }
          else{
            setState(() {
              ahli = Ahli(
                name: nameController.text,
                email: emailController.text,
                ic: icController.text,
                alamat: addressController.text,
                phone: phoneController.text,
                emergencyPhone: emergencyPhoneController.text,
              );
            });
            MemoryCache.instance.create('ahli', ahli);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaftarTanggungan()));
          }

        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xff0096FF),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Seterusnya', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}