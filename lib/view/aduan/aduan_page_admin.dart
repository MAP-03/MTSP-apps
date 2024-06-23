import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/aduan_service.dart';
import 'package:mtsp/view/aduan/aduanList_tile.dart';
import 'package:mtsp/view/aduan/aduan_details_admin.dart';
import 'package:mtsp/models/aduan.dart';
import 'package:mtsp/widgets/drawer.dart';

class AduanPageAdmin extends StatefulWidget {
  const AduanPageAdmin({super.key});

  @override
  State<AduanPageAdmin> createState() => _AduanPageAdminState();
}

class _AduanPageAdminState extends State<AduanPageAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _searchController = TextEditingController();

  void navigateToAduanDetails(Aduan aduan, String docID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AduanDetailsAdminPage(
          aduan: aduan,
          docID: docID,
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
          title: Text('Aduan & Cadangan',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
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
            
            _buildSearchBar(),

            const SizedBox(height: 20),

            //list of aduan
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: AduanService().getAduanListExcludeDraftStream(),
                  builder: (context, snapshot) {
                    // show loading circle
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                
                    if (snapshot.hasData){
                      List aduanList = snapshot.data!.docs;
                
                      return ListView.builder(
                        itemCount: aduanList.length,
                        itemBuilder: (context, index) {
                          // get each individual doc
                          DocumentSnapshot aduanDoc = aduanList[index];
                          String docID = aduanDoc.id;
 
                          // get aduan from each doc
                          Aduan aduan = Aduan.fromDocument(aduanDoc);
                          
                          // display as a list tile
                          return AduanListTile(
                            aduan: aduan,
                            aduanDocID: docID,
                            onTap: () => navigateToAduanDetails(aduan, docID),
                          );
                        }
                      );
                    }
                
                    // no data?
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Tiada aduan atau cadangan yang dihantar.',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xffD9D9D9))
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //search bar
        SizedBox(
          width: 260,
          height: 30,
          child: TextField(
            controller: _searchController,
            style:
                GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle:
                  GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(
                    size: 14, Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                },
              ),
            ),
          ),
        ),

        //filter icon
        IconButton(
          icon: const Icon(size: 25, Icons.filter_list, color: Colors.white),
          onPressed: () {},
        ),

        //search icon
        IconButton(
          icon: const Icon(size: 25, Icons.search, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
