import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/components/submit_button.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/services/aduan_service.dart';
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

  final _searchController = TextEditingController();

  List<Aduan> aduanList = [];
  
  Future<void> getAduanList() async {
    final aduanList = await AduanService().getAduanListByUser();
    setState(() {
      this.aduanList = aduanList;
    });
  }

  void navigateToAduanForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AduanForm(),
      ),
    );
  }

  void navigateToAduanDetails(Aduan aduan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AduanDetailsPage(
          aduan: aduan,
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
            //search container
            Row(
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
                child: FutureBuilder(
                  future: getAduanList(),
                  builder: (context, snapshot) {
                    // show loading circle
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }

                    // no data?
                    if (aduanList.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Tiada aduan atau cadangan yang dihantar.',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xffD9D9D9))
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: aduanList.length,
                      itemBuilder: (context, index) {
                        return AduanListTile(
                          aduan: aduanList[index],
                          onTap: () => navigateToAduanDetails(aduanList[index]),
                        );
                      }
                    );
                  },
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
