// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'package:mtsp/widgets/text_field.dart';

class Infaq extends StatefulWidget {
  const Infaq({super.key});

  @override
  State<Infaq> createState() => _InfaqState();
}

class _InfaqState extends State<Infaq> {
  var infaqAmount = 0;
  bool isProcessing = false;
  bool button1 = false;
  bool button2 = false;

  final infaqTextController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void donate() {
    setState(() {
      isProcessing = true;
    });

    infaqAmount = 0;
    button1 = false;
    button2 = false;

    if (infaqAmount != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Infaq berjaya!' + ' RM $infaqAmount'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (infaqTextController.text.isNotEmpty) {
      infaqAmount = int.parse(infaqTextController.text);
      infaqTextController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Infaq berjaya!' + ' RM $infaqAmount'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sila masukkan amaun infaq'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: secondaryColor,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('Infaq',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'lib/images/masejid_mtsp.png',
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.white,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 305,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: MediaQuery.of(context).size.width / 2 - 175,
                    width: 350,
                    height: 350,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pilih jumlah infaq anda',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      button1 = true;
                                      button2 = false;
                                    });
                                    infaqAmount = 10;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: button1 ? Colors.white : Colors.blue,
                                    backgroundColor: button1 ? Colors.blue : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
                                    child: Text(
                                      'RM 10',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: button1 ? Colors.white : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 5),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      button1 = false;
                                      button2 = true;
                                    });
                                    infaqAmount = 50;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: button2 ? Colors.white : Colors.blue,
                                    backgroundColor: button2 ? Colors.blue : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 5),
                                    child: Text(
                                      'RM 50',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: button2 ? Colors.white : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 5),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(children: [
                                  Expanded(
                                      child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey.shade500)),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        'Atau',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade800),
                                      )),
                                  Expanded(
                                      child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey.shade500)),
                                ])),
                            const SizedBox(height: 7),
                            
                            SizedBox(
                              width: 250,
                              height: 50,
                              child: Center(
                                child: TextField(
                                    onTap: () {
                                      setState(() {
                                        button1 = false;
                                        button2 = false;
                                      });
                                    },
                                    textAlign: TextAlign.center,
                                    controller: infaqTextController,
                                    obscureText: false,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(30.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(10.0)),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: 'Amaun Lain',
                                        hintStyle:
                                            TextStyle(fontSize: 15, color: Colors.grey.shade400))),
                              ),
                            ),

                            const SizedBox(height: 25),
                            GestureDetector(
                              onTap: () {
                                donate();
                              },
                              child: Container(
                                width: 250,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xff050A30),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                  child: isProcessing
                                      ? CircularProgressIndicator()
                                      : Text(
                                          'Infaq',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
