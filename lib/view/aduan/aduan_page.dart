import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/components/submit_button.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/view/aduan/aduanList_tile.dart';
import 'package:mtsp/widgets/drawer.dart';

class AduanPage extends StatefulWidget {
  const AduanPage({super.key});

  @override
  State<AduanPage> createState() => _AduanPageState();
}

class _AduanPageState extends State<AduanPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List _aduanList = [
    {
      'type': 'Aduan 1',
      'subject': 'Aduan Subject',
    },
    {
      'type': 'Aduan 2',
      'subject': 'Aduan Subject',
    },
    {
      'type': 'Cadangan 1',
      'subject': 'Aduan Subject',
    },
    {
      'type': 'Cadangan 2',
      'subject': 'Cadangan Subject',
    },
    {
      'type': 'Cadangan 3',
      'subject': 'Cadangan Subject',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('Aduan & Cadangan', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: primaryColor,
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
          //search container
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                //saeach bar
                Column(

                ),
                
                //filter icon

                //search icon
              ],
            ),
          ),

          const SizedBox(height: 20),

          //list of aduan
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ListView.builder(
              itemCount: _aduanList.length,
              itemBuilder: (context, index) {
                return AduanListTile();
              },
            ),
          ),

          const SizedBox(height: 20),

          //add button
          SubmitButton(
            text: 'Tambah Baru',
            buttonColor: Colors.green,
            onTap: () {
              Navigator.pushNamed(context, '/aduan_form');
            },
          ) 
        ],
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
    );
  }
}