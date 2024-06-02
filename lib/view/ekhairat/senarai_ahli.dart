// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:mtsp/view/ekhairat/maklumat_ahli.dart';

class SenaraiAhli extends StatefulWidget {
  const SenaraiAhli({super.key});

  @override
  State<SenaraiAhli> createState() => _SenaraiAhliState();
}

class _SenaraiAhliState extends State<SenaraiAhli> {
  EkhairatService ekhairatService = EkhairatService();
  List<Ahli> ahliList = [];
  List<Ahli> filteredAhliList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    fetchAhliList();
  }

  Future<void> fetchAhliList() async {
    List<Ahli> ahliData = await ekhairatService.getAllAhli();
    setState(() {
      ahliList = ahliData;
      filteredAhliList = ahliData;
      isLoading = false;
    });
  }

  void filterAhliList(String status) {
    if (status == 'All') {
      setState(() {
        filteredAhliList = ahliList;
      });
    } else {
      setState(() {
        filteredAhliList = ahliList.where((element) => element.status == status).toList();
      });
    }
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: secondaryColor,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Divider(color: Colors.white),
              RadioListTile(
                activeColor: primaryColor,
                title: Text('Semua', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                value: 'All',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value.toString();
                    filterAhliList(selectedStatus);
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile(
                activeColor: primaryColor,
                title: Text('Pending', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                value: 'PENDING',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value.toString();
                    filterAhliList(selectedStatus);
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile(
                activeColor: primaryColor,
                title: Text('Expired', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                value: 'EXPIRED',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value.toString();
                    filterAhliList(selectedStatus);
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile(
                activeColor: primaryColor,
                title: Text('Active', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                value: 'ACTIVE',
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value.toString();
                    filterAhliList(selectedStatus);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senarai Ahli', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
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
      body: isLoading 
      ? const Center(child: CircularProgressIndicator()) 
      : Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari Ahli',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredAhliList = ahliList.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showFilterBottomSheet();
                  },
                  child: Icon(Icons.filter_list, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAhliList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MaklumatAhli(ahli: filteredAhliList[index])));
                    },
                    child: Card(
                      color: primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ListTile(
                          title: Text(filteredAhliList[index].name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(filteredAhliList[index].email, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                              const SizedBox(height: 7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('Status : ', style: GoogleFonts.poppins(fontSize: 14, fontWeight:FontWeight.w300, color: Colors.white)),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: filteredAhliList[index].status == 'PENDING' ? Color(0xffE8D427) : filteredAhliList[index].status == 'EXPIRED' ? Colors.red : Colors.green,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: Text(filteredAhliList[index].status, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black, letterSpacing: 1.8)),
                                      ),
                                    ],
                                  ),
                                  Text('Tarikh Daftar : ${Jiffy.parseFromDateTime(filteredAhliList[index].tarikhDaftar.toDate()).yMMMd}', style: GoogleFonts.poppins(fontSize: 10, fontWeight:FontWeight.w300, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
