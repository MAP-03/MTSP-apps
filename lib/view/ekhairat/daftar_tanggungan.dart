// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/tanggungan.dart';
import 'package:mtsp/view/ekhairat/pilih_pelan.dart';
import 'package:mtsp/widgets/toast.dart';

class DaftarTanggungan extends StatefulWidget {
  const DaftarTanggungan({super.key});

  @override
  State<DaftarTanggungan> createState() => _DaftarTanggunganState();
}

class _DaftarTanggunganState extends State<DaftarTanggungan> {

  List<TextEditingController> _nameController = [];
  List<TextEditingController> _icController = [];
  List<TextEditingController> _hubunganController = [];
  List<Tanggungan> tanggungan = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran Ahli', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                    shape: OvalBorder(),
                    color: Color(0xFF0096FF),
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.white, size: 15)
                  ),
                ),
                Container(
                  width: 65,
                  height: 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xFF0096FF),
                  ),
                ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Maklumat Tanggungan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.start),
                    Row(
                      children: [
                        Text('* ', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                        Text('Biarkan kosong jika tiada', style: GoogleFonts.poppins(fontSize: 14, fontWeight : FontWeight.w200 ,color: Colors.white), textAlign: TextAlign.start),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: tanggungan.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildTanggunganCard(index);
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTanggungan,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff023E8A)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                shadowColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text('TAMBAH TANGGUNGAN', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 90),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          if (tanggungan.length > 0) {
            for (int i = 0; i < tanggungan.length; i++) {
              if (_nameController[i].text.isEmpty || _icController[i].text.isEmpty || _hubunganController[i].text.isEmpty) {
                showToast(message: 'Sila lengkapkan semua maklumat tanggungan');
                return;
              }
              tanggungan[i].name = _nameController[i].text;
              tanggungan[i].ic = _icController[i].text;
              tanggungan[i].hubungan = _hubunganController[i].text;
            }
            final ahli = MemoryCache.instance.read<Ahli>('ahli');
            ahli!.tanggungan = tanggungan;
            MemoryCache.instance.update('ahli', ahli);
          }
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PilihPelan()));
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

  Widget _buildTanggunganCard(int index) {
    return Stack(
      children: [
        Card(
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      children: [
                        Text('Nama Penuh', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                        Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController[index],
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
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      children: [
                        Text('No. Kad Pengenalan/Sijil Kelahiran', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                        Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _icController[index],
                      decoration: InputDecoration(
                        hintText: '123456-12-1234',
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
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      children: [
                        Text('Hubungan', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                        Text('*', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _hubunganController[index],
                      decoration: InputDecoration(
                        hintText: 'Ibu',
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
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _removeTanggungan(index),
                    child: Text('Buang', style: GoogleFonts.poppins(fontSize: 14, color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 10,
          child: Container(
            width: 150,
            height: 38,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.cyan[700],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text('Tanggungan ${index + 1}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white))),
          ),
        ),
      ],
    );
  }

  void _addTanggungan() {
    setState(() {
      tanggungan.add(Tanggungan(name: '', ic: '', hubungan: ''));
      _nameController.add(TextEditingController());
      _icController.add(TextEditingController());
      _hubunganController.add(TextEditingController());
    });
  }

  void _removeTanggungan(int index) {
    setState(() {
      tanggungan.removeAt(index);
      _nameController.removeAt(index);
      _icController.removeAt(index);
      _hubunganController.removeAt(index);
    });
  }
}

