// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mtsp/firebase_options.dart';
import 'package:mtsp/view/aduan/aduan_page.dart';
import 'package:mtsp/view/azan/azan.dart';
import 'package:mtsp/view/berita/berita.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/view/ekhairat/ekhairat.dart';
import 'package:mtsp/view/infaq/infaq.dart';
import 'package:mtsp/view/kalendar/kalendar.dart';
import 'package:mtsp/view/login/authentication_page.dart';
import 'view/login/login_page.dart';
//import 'package:flutter/foundation.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink,
        ),
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/home' : (context) => HomePage(),
        '/ekhairat' : (context) => Ekhairat(),
        '/berita' : (context) => Berita(),
        '/infaq' : (context) => Infaq(),
        '/azan' : (context) => Azan(),
        '/kalendar' : (context) => Kalendar(),
        '/aduan' : (context) => AduanPage(),
      },
      home: AuthPage(),
    );
  }
}
