// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/view/ekhairat/ekhairat.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'package:mtsp/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            title: Text('MTSP', style: GoogleFonts.oswald(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            actions:[
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 30, color: Colors.white) ,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.account_circle_rounded, size: 30, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },
              ),
            ],
            backgroundColor: primaryColor,
          ),
        ),
      ),
      backgroundColor: primaryColor,
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 318.72,
                      height: 208.58,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                        image: AssetImage('assets/images/uai.jpg'),
                        fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                    Icon(Icons.circle_outlined, color: Colors.grey, size: 15),
                    Icon(Icons.circle_outlined, color: Colors.grey, size: 15),
                  ],
                ),
                
              ],
            ),
            Container(
              width: double.infinity,
              height: height * 0.5,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/ekhairat');
                        },
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/ekhairat.svg', width: 100),
                              Text('E-Khairat', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/berita');
                        },
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/berita.svg', width: 100),
                              Text('Berita Masjid', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/infaq');
                        },
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/infaq.svg', width: 100),
                              Text('Infaq', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/azan');
                        },
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/azan.svg', width: 100),
                              Text('Waktu Azan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/kalendar');
                        },
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/kalendar.svg', width: 100),
                              Text('Kalendar', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/aduan');
                        },
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/aduan.svg', width: 100),
                              Text('Aduan Dan Cadangan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white), textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: height * 0.5 - (height * 0.16), 
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    end: Alignment(0.97, -0.26),
                    begin: Alignment(-0.97, 0.26),
                    colors: [Color(0xFF62CFF4), Color(0xFF2C67F2)],
                    ),
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
}
