import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/view/login/authentication_page.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  // Function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              } else {
                print('Sign out failed!'); 
              }
            },// Single function call
            icon: const Icon(
              Icons.logout,
              color: Colors.white
              ),
          ),
        ],
        backgroundColor: Colors.blue.shade900,
      ),
      body: const Center(
        child: Text("This is Profile page"),
      ),
    );
  }
}
