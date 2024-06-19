// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/services/berita_service.dart';
import 'package:mtsp/view/berita/detail_page.dart';
import 'package:mtsp/view/ekhairat/ekhairat.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';
import 'package:mtsp/widgets/drawer.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/view/azan/azan_layout.dart';
import 'package:mtsp/view/azan/waktu_solat.dart';
  
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HijriCalendar _hijriCalendar = HijriCalendar.now();
  late PrayerTimes prayerTimes;
  late DateTime date;
  late Coordinates coordinates;
  late CalculationParameters params;
  BeritaService beritaService = BeritaService();
  List<Map<String, dynamic>> berita = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    // Initialize the PrayerTimes instance with the required parameters
    coordinates = Coordinates(1.5638129487418682, 103.61735116456667);
    date = DateTime.now();
    params = CalculationMethod.Malaysia();
    params.madhab = Madhab.shafi;
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    berita = await beritaService.getEvents();
    setState(() {
      berita = berita;
    }); 
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    prayerTimes = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params, precision: true);
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
                icon: const Icon(Icons.account_circle_rounded, size: 30, color: Colors.white),// TODO tambah gambar profile
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
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 208.58, 
                            child: CarouselSlider(
                              items: berita.map((item) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => DetailPage(
                                          title: item['title'],
                                          date: Jiffy.parseFromDateTime(item['date'].toDate()).yMMMMEEEEd.toString(),
                                          description: item['description'],
                                          imageUrl: item['imageLink'],
                                          headerColor: Color(0xff06142F),
                                          backgroundColor: Color(0xff06142F),
                                        ),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(0.0, 1.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween =
                                              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Center(
                                      child: Image.network(
                                        item['imageLink'],
                                        fit: BoxFit.fill,
                                        width: double.infinity, 
                                        height: 210,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              carouselController: _controller,
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                                disableCenter: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: berita.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                      color: (Theme.of(context).brightness == Brightness.light
                                              ? Colors.white
                                              : Colors.black)
                                          .withOpacity(_current == entry.key ? 0.9 : 0.4),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
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
                          Navigator.pushNamed(context, '/forum');
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
                              SvgPicture.asset('assets/svg/forum.svg', width: 100),
                              Text('Forum', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/azan');
                },
                child: Container(
                  width: 300,
                  height: 80, // Increased height to accommodate the additional text
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      end: Alignment(0.97, -0.26),
                      begin: Alignment(-0.97, 0.26),
                      colors: [Color(0xFF62CFF4), Color(0xFF2C67F2)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row( // Use Row instead of Center
                      mainAxisAlignment: MainAxisAlignment.start, // Center the content horizontally
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10), // Added SizedBox for spacing
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prayerTimes.nextPrayer(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5), // Added SizedBox for spacing
                                Text(
                                  getNextPrayerTime(prayerTimes), // Replace with your desired text
                                  style: GoogleFonts.notoSans(
                                    color: Color(0xFFD9D9D9),
                                    fontSize: 24, // Adjust the font size as needed
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Added SizedBox for spacing between texts
                        Row(
                          children: [
                            Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5), // Add left padding to move the text a bit to the right
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${_hijriCalendar.hDay} ${hijri[_hijriCalendar.hMonth-1]}  ${_hijriCalendar.hYear} AH", // First text
                                        style: GoogleFonts.notoSans(
                                          color: Color(0xFFD9D9D9),
                                          fontSize: 12, // Adjust the font size as needed
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${months[date.month-1]} ${date.day}, ${date.year}", // Second text
                                        style: GoogleFonts.notoSans(
                                          color: Color(0xFFD9D9D9),
                                          fontSize: 10, // Adjust the font size as needed
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
