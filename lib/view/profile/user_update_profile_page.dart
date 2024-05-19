// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/auth/authentication_page.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';
import 'package:mtsp/widgets/toast.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  final newUserNameController = TextEditingController();
  final newFullNameController = TextEditingController();
  final newTelephoneController = TextEditingController();

  void updateProfileDetail() {
    if (newUserNameController.text.isNotEmpty) {
      usersCollection
          .doc(currentUser.email)
          .update({'username': newUserNameController.text});
    }

    if (newFullNameController.text.isNotEmpty) {
      usersCollection
          .doc(currentUser.email)
          .update({'fullName': newFullNameController.text});
    }

    if (newTelephoneController.text.isNotEmpty) {
      usersCollection
          .doc(currentUser.email)
          .update({'phoneNumber': newTelephoneController.text});
    }
    
    showToast(message: 'Profile updated successfully');
  }

  void _deleteAccount() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .delete();

    await currentUser.delete();

    showToast(message: "Akaun berjaya dipadam");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
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
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        title:
            Text("Edit Profile", style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff06142F),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(
              child: Text('No user data available', style: TextStyle(color: Colors.white)),
            );
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
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
                          controller: newUserNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Username",
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: userData['username'],
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextFormField(
                          controller: newFullNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Nama Penuh",
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: userData['fullName'],
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextFormField(
                          controller: newTelephoneController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "No. Telefon",
                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: userData['phoneNumber'],
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: userData['email'],
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: updateProfileDetail,
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
                          onTap:() {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Padam Akaun'),
                                  content: const Text('Adakah anda pasti untuk memadam akaun ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed: _deleteAccount,
                                      child: const Text('Ya'),
                                    ),
                                  ],
                                );
                              },
                            );
                          
                          },
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xffFF0000),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Center(
                              child: const Text('Padam Akaun',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            text: "Joined ",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            children: [
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
