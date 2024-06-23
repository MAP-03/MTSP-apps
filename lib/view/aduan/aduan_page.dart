import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String selectedType = 'All';
  String selectedStatus = 'All';
  bool sortByDateDesc = true;

  void navigateToAduanForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AduanForm(),
      ),
    );
  }

  void navigateToAduanDetails(Aduan aduan, String aduanDocID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AduanDetailsPage(
          aduan: aduan,
          aduanDocID: aduanDocID,
        ),
      ),
    );
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      searchQuery = '';
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter by type
              DropdownButton<String>(
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
                items: <String>['All', 'Aduan', 'Cadangan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Filter by status
              DropdownButton<String>(
                value: selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
                items: <String>['All', 'Draft', 'Pending', 'Replied', 'Closed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Sort by date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort by date'),
                  Switch(
                    value: sortByDateDesc,
                    onChanged: (bool value) {
                      setState(() {
                        sortByDateDesc = value;
                      });
                    },
                  ),
                  Text(sortByDateDesc ? 'Newest-Oldest' : 'Oldest-Newest'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Apply', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {}); // Apply the filters
              },
            ),
            TextButton(
              child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
                  stream: AduanService().getAduanListByUserStream(),
                  builder: (context, snapshot) {
                    // show loading circle
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasData) {
                      List<DocumentSnapshot> aduanList = snapshot.data!.docs;

                      // Apply filters
                      aduanList = aduanList.where((aduanDoc) {
                        final data = aduanDoc.data() as Map<String, dynamic>;
                        final matchesSearchQuery = data['Subject']
                                .toString()
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                              data['Comment']
                                .toString()
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                        final matchesType = selectedType == 'All' ||
                            data['Type'] == selectedType;
                        final matchesStatus = selectedStatus == 'All' ||
                            data['Status'] == selectedStatus;
                        return matchesSearchQuery && matchesType && matchesStatus;
                      }).toList();

                      // Sort by date
                      aduanList.sort((a, b) {
                        final aTimestamp =
                            (a.data() as Map<String, dynamic>)['Timestamp']
                                as Timestamp;
                        final bTimestamp =
                            (b.data() as Map<String, dynamic>)['Timestamp']
                                as Timestamp;
                        return sortByDateDesc
                            ? bTimestamp.compareTo(aTimestamp)
                            : aTimestamp.compareTo(bTimestamp);
                      });

                      if (aduanList.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Tiada aduan atau cadangan yang dihantar.',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xffD9D9D9)),
                          ),
                        );
                      }

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
                        },
                      );
                    }

                    // no data?
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Tiada aduan atau cadangan yang dihantar.',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffD9D9D9)),
                        ),
                      );
                    }
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
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            textAlignVertical: TextAlignVertical.bottom,
            onChanged: _updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(size: 14, Icons.clear, color: Colors.grey),
                onPressed: _clearSearchQuery,
              ),
            ),
          ),
        ),

        //filter icon
        IconButton(
          icon: const Icon(size: 25, Icons.filter_list, color: Colors.white),
          onPressed: _showFilterDialog,
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