// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mtsp/auth/authentication_page.dart';
import 'package:mtsp/auth/login_or_register.dart';
import 'package:mtsp/view/kalendar/kalendar.dart';
import 'package:mtsp/view/login/login_page.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';
import 'package:mtsp/widgets/toast.dart';



class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void _deleteAccount() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06142F),
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
        title:
            Text("Edit Profile", style: const TextStyle(color: Colors.white)),
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
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Update',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _deleteAccount();
                      FirebaseAuth.instance.currentUser!.delete().then((value) => {
                          showToast(message: "Akaun berjaya dipadam"),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AuthPage()),
                          ),
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xffFF0000),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Center(
                        child: const Text(' Padam Akaun',
                            style: TextStyle(color: Colors.white)),
                      ),
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
