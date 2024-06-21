// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/tanggungan.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/view/ekhairat/payment_details.dart';
import 'package:mtsp/widgets/toast.dart';

class BayaranPage extends StatefulWidget {
  const BayaranPage({super.key});

  @override
  State<BayaranPage> createState() => _BayaranPageState();
}

class _BayaranPageState extends State<BayaranPage> {

  Ahli? ahli;
  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ahli = MemoryCache.instance.read<Ahli>('ahli');
  }



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
      body: Scrollbar(
        child: SingleChildScrollView(
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
                  Text('Bayaran', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.start),
                ],
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 400,
                padding: EdgeInsets.only(left: 15, right: 15),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: ContainedTabBarView(
                    tabs: [
                      Text('Ahli', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                      Text('Tanggungan', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                    tabBarProperties: TabBarProperties(
                      
                      indicator: ContainerTabIndicator(
                        radius: BorderRadius.circular(10.0),
                        width: 195,
                        color: Colors.blueGrey,
                      ),
                    ),
                    views: [
                      _buildAhliTab(),
                      _buildTanggunganTab(),
                    ],
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text( "Pelan (${ahli!.pelan})", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.start),
                          if (ahli!.pelan == 'Tahunan')
                            Text('RM 50', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white), textAlign: TextAlign.start),
                          if (ahli!.pelan == 'Bulanan')
                            Text('RM 5', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white), textAlign: TextAlign.start),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Yuran Pendaftaran', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.start),
                          Text('RM 10', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white), textAlign: TextAlign.start),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Jumlah Keseluruhan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.start),
                          if (ahli!.pelan == 'Tahunan')
                            Text('RM 60', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.start),
                          if (ahli!.pelan == 'Bulanan')
                            Text('RM 15', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.start),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Saya bersetuju dengan syarat dan terma yang dikenakan', 
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white), 
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
       bottomSheet: GestureDetector(
        onTap: () {
          if (isChecked) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetails()));
            /* ahli!.tarikhDaftar = Timestamp.now();
            EkhairatService().addAhli(ahli!);
            showToast(message: 'Pendaftaran berjaya');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())); */

          } else {
            showToast(message: 'Sila setuju dengan syarat dan terma yang dikenakan');
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
              Text('Bayar', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              SizedBox(width: 10),
              Icon(
                Icons.payment,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAhliTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            buildDataRow('Nama', ahli!.name),
            buildDataRow('No. Kad Pengenalan', ahli!.ic),
            buildDataRow('Alamat', ahli!.alamat),
            buildDataRow('No. Telefon', ahli!.phone),
            buildDataRow('No. Telefon Kecemasan', ahli!.emergencyPhone),
          ],
        ),
      ),
    );
  }

 Widget _buildTanggunganTab() {
  return Scrollbar(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: ahli!.tanggungan.asMap().entries.map((entry) {
            int index = entry.key + 1;
            Tanggungan tanggungan = entry.value;
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 38,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.cyan[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Tanggungan $index', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 10),
                  buildDataRow('Nama', tanggungan.name),
                  buildDataRow('No. Kad Pengenalan', tanggungan.ic),
                  buildDataRow('Hubungan', tanggungan.hubungan),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}


  Widget buildDataRow(String label, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                Text(
                  data,
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 3, 
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}