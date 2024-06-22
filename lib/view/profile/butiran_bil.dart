import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/models/butiranBayaran.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ButiranBil extends StatefulWidget {
  const ButiranBil({super.key});

  @override
  State<ButiranBil> createState() => _ButiranBilState();
}

class _ButiranBilState extends State<ButiranBil> {
  EkhairatService ekhairatService = EkhairatService();
  List<ButiranBayaran> butiranBayaran = [];

  @override
  void initState() {
    super.initState();
    fetchButiranBayaran();
  }

  fetchButiranBayaran() async {
    butiranBayaran = await ekhairatService.getButiranBayaran(FirebaseAuth.instance.currentUser!.email!);
    setState(() {
      butiranBayaran = butiranBayaran;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06142F),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text('Butiran Bil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xff06142F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: butiranBayaran.length,
          itemBuilder: (context, index) {
            return buildButiranBayaranTile(butiranBayaran[index]);
          },
        ),
      ),
    );
  }

  Widget buildButiranBayaranTile(ButiranBayaran butiran) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Pembayaran: ${butiran.bayaranId}',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff06142F)),
            ),
            const SizedBox(height: 8),
            buildDetailRow('Amaun', 'RM ${butiran.amaun}'),
            buildDetailRow('Pelan', butiran.pelan),
            buildDetailRow('Tarikh', Jiffy.parseFromDateTime(butiran.tarikh).yMMMMEEEEd),
            buildDetailRow('Status', butiran.status),
            buildDetailRow('Kaedah Pembayaran', butiran.paymentMethod),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff06142F)),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff06142F)),
          ),
        ],
      ),
    );
  }
}
