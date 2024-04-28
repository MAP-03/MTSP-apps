// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "MTSP",
              style: (
                TextStyle(
                  color: Colors.white
                )
              )
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              icon: Icon(
                Icons.account_circle,
                color: Colors.white
              )
            ),
          ],
          backgroundColor: Colors.blue.shade900,
        ),
        body: Center(
          child: Text("This is Homepage, user is " + user.email!),
        ));
  }
}