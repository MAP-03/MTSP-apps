// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/view/ekhairat/bayaran.dart';
import 'package:mtsp/widgets/toast.dart';

class PilihPelan extends StatefulWidget {
  const PilihPelan({super.key});

  @override
  State<PilihPelan> createState() => _PilihPelanState();
}

class _PilihPelanState extends State<PilihPelan> {

  bool _isSelect1 = false;
  bool _isSelect2 = false;

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
              children: [
                SizedBox(width: 15),
                Text('Pelan Ahli', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelect1 = true;
                    _isSelect2 = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: 
                  _isSelect1 == false
                  ? BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    )
                  :BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment(0.97, -0.26),
                        begin: Alignment(-0.97, 0.26),
                        colors: const [Color(0xFF62CFF4), Color(0xFF2C67F2)],
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 25),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: ShapeDecoration(
                          shape: OvalBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Colors.blue,
                            ),
                          ),
                          color: _isSelect1 == false ? null : primaryColor,
                        ),
                        child: Center(
                          child: _isSelect1 == false ? null : Icon(Icons.check, color: Colors.white, size: 20),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bulanan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text('Bayaran ansuran setiap bulan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('RM5', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white)),
                              Text('/bulan', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white)),
                            ],
                          ),
                
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelect1 = false;
                    _isSelect2 = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: 
                  _isSelect2 == false
                  ? BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    )
                  :BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment(0.97, -0.26),
                        begin: Alignment(-0.97, 0.26),
                        colors: const [Color(0xFF62CFF4), Color(0xFF2C67F2)],
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                  child: Banner(
                    message: 'DIGALAKKAN',
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 25),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: ShapeDecoration(
                            shape: OvalBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Colors.blue,
                              ),
                            ),
                            color: _isSelect2 == false ? null : primaryColor,
                          ),
                          child: Center(
                            child: _isSelect2 == false ? null : Icon(Icons.check, color: Colors.white, size: 20),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tahunan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                            Text('Bayaran penuh untuk setahun', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('RM60', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white)),
                                Text('/tahun', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text('* Ahli baru perlu membayar yuran pendaftaran sebanyak RM10', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w200, color: Colors.white), textAlign: TextAlign.justify,),
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          if(!_isSelect1 && !_isSelect2) {
            showToast(message: 'Sila pilih pelan yang diinginkan');
            return;
          }
          else {
            final ahli = MemoryCache.instance.read<Ahli>('ahli');
            ahli!.pelan = _isSelect1 ? 'Bulanan' : 'Tahunan';
            MemoryCache.instance.update('ahli', ahli!);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BayaranPage()));
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