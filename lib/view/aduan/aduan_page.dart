import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/components/submit_button.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/view/aduan/aduanList_tile.dart';
import 'package:mtsp/view/aduan/aduan_form.dart';
import 'package:mtsp/view/aduan/aduan_details.dart';
import 'package:mtsp/models/aduan.dart';
import 'package:mtsp/widgets/drawer.dart';

class AduanPage extends StatefulWidget {
  const AduanPage({super.key});

  @override
  State<AduanPage> createState() => _AduanPageState();
}

class _AduanPageState extends State<AduanPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _textController = TextEditingController();

  //test2
  final List<Aduan> _aduanList = [
    Aduan(type: 'Aduan 1', subject: 'Aduan Subject', comment: 'Aduan Comment'),
    Aduan(type: 'Aduan 2', subject: 'Aduan Subject', comment: 'Aduan Comment'),
    Aduan(type: 'Cadangan 1', subject: 'Aduan Subject', comment: 'Cadangan Comment'),
    Aduan(type: 'Cadangan 2', subject: 'Cadangan Subject', comment: 'Cadangan Comment'),
    Aduan(type: 'Cadangan 3', subject: 'Cadangan Subject', comment: 'Cadangan Comment'),
  ];

  void navigateToAduanForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AduanForm(),
      ),
    );
  }

  void navigateToAduanDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AduanDetailsPage(
          aduan: _aduanList[index],
        ),
      ),
    );
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            //search container
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //search bar
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: GoogleFonts.poppins(color: const Color(0xFFB5ADAD)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: primaryColor),
                        onPressed: () {
                          _textController.clear();
                        },
                      ),
                    ),
                  ),
                ),
                
                //filter icon
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {},
                ),
                    
                //search icon
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
        
            const SizedBox(height: 20),
        
            //list of aduan
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: _aduanList.length,
                  itemBuilder: (context, index) => AduanListTile(
                    aduan: _aduanList[index],
                    onTap: () => navigateToAduanDetails(index),
                  ),
                ),
              ),
            ),
        
            const SizedBox(height: 20),
        
            //add button
            SubmitButton(
              text: 'Tambah Baru',
              buttonColor: primaryButtonColor,
              onTap: navigateToAduanForm,
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
    );
  }
}