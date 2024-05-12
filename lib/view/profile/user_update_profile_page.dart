// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mtsp/view/kalendar/kalendar.dart';
import 'package:mtsp/view/login/login_page.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({Key? key}) : super(key: key);

Future<void> _deleteAccount(BuildContext context) async {
  print('Attempting to delete account...');
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }

    // Delete the user's account
    await user.delete();
    print('Account deleted successfully');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } catch (e) {
    print('Error deleting account: ${e.toString()}');
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Failed to delete account. Please try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          },
        ),
        title: Text("Edit Profile", style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xff06142F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user.png'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Nama Penuh",
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "No. Phone",
                        prefixIcon: Icon(Icons.phone, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "E-Mail",
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Kata Laluan",
                        prefixIcon: Icon(Icons.password, color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Update', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Joined ",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          children: [
                            TextSpan(
                                text: "tarikh pengguna buat akaun",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  // Trigger account deletion
                  _deleteAccount(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.red, // Delete button color
                ),
                child: const Text(' Padam Akaun', style: TextStyle(color: Colors.white)),
              ),
            ),
          ]
        ),
    )
        ],
        ),
      ),
      backgroundColor: const Color(0xff06142F),
    );
  }
}