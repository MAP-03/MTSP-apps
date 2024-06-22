// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/tanggungan.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:mtsp/view/ekhairat/senarai_ahli.dart';
import 'package:mtsp/view/ekhairat/update_ahli.dart';

class MaklumatAhli extends StatefulWidget {
  const MaklumatAhli({super.key, required this.ahli});

  final Ahli? ahli;

  @override
  State<MaklumatAhli> createState() => _MaklumatAhliState();
}

class _MaklumatAhliState extends State<MaklumatAhli> {
  EkhairatService ekhairatService = EkhairatService();
  bool isLoading = true;
  String? expiredDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
      expiredDate = getExpiryDate(widget.ahli!);
    });
  }

  String getExpiryDate(Ahli ahli) {
    DateTime registrationDate = ahli.tarikhDaftar.toDate();
    int duration = ahli.pelan == 'Bulanan' ? 1 : 12;
    return Jiffy.parseFromDateTime(registrationDate).add(months: duration).yMMMMd.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maklumat Keahlian', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SenaraiAhli()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return UpdateAhli(ahli: widget.ahli!);
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 2,
          ),
        ),
      ),
      backgroundColor: secondaryColor,
      body: isLoading 
      ? Center(child: CircularProgressIndicator()) 
      : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Card(
                color: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.card_membership, color: Colors.blue, size: 30),
                              SizedBox(width: 10),
                              Text('Pelan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          Text(widget.ahli!.pelan, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.date_range, color: Colors.blue, size: 30),
                              SizedBox(width: 10),
                              Text('Tamat Tempoh', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                          Text(expiredDate!, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 400,
              padding: EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryColor,
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Status  :  ', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.ahli!.status == 'PENDING' ? pendingColor : widget.ahli!.status == 'EXPIRED' ? expiredColor : activeColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(widget.ahli!.status, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black, letterSpacing: 1.8))
                ),
              ],
            ),
            SizedBox(height: 30),
            widget.ahli!.status == 'PENDING'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ekhairatService.updateAhliStatus(widget.ahli!.email, 'ACTIVE');
                      setState(() {
                        widget.ahli!.status = 'ACTIVE';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(140, 30),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        Text('Terima', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green)),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox(),
          ],
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
            buildDataRow('Nama', widget.ahli!.name),
            buildDataRow('No. Kad Pengenalan', widget.ahli!.ic),
            buildDataRow('Alamat', widget.ahli!.alamat),
            buildDataRow('No. Telefon', widget.ahli!.phone),
            buildDataRow('No. Telefon Kecemasan', widget.ahli!.emergencyPhone),
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
            children: widget.ahli!.tanggungan.asMap().entries.map((entry) {
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
                SizedBox(height: 4),
                Text(
                  data,
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 3, 
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),
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
