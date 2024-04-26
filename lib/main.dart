// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'view/login/login_page.dart';
//import 'package:flutter/foundation.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyAacL4jwzScGB96zV_rfzc6w6rsJOsydLY",
    appId: '743142802789:android:76c882b279b7108f4c8d8c',
    messagingSenderId: '743142802789',
    projectId: 'mtsp-fa9ff',
    storageBucket: 'mtsp-fa9ff.appspot.com',
  ));
  runApp(MyApp());
}
/* {
  runApp(const MyApp());
} */

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
      home: LoginPage(),
    );
  }
}

/* class _HomePageState extends State<HomePage> {
  final ref = FirebaseDatabase.instance.ref('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Setup'),
      ),
      body: FirebaseAnimatedList(
        query: ref,
        itemBuilder: (context, snapshot, animation, index){
          return Text(snapshot.child('user').value.toString());
        },
      ),
    );
  }
} */
