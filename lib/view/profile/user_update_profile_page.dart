// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/auth/authentication_page.dart';
import 'package:mtsp/services/auth_service.dart';
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
  File? imageFile;
  AuthService authService = AuthService();

  final newUserNameController = TextEditingController();
  final newFullNameController = TextEditingController();
  final newTelephoneController = TextEditingController();

  void updateProfileDetail() async{
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

    if (imageFile != null) {
      authService.saveProfilePicture(currentUser.email, imageFile!);
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
            newUserNameController.text = userData['username'] ?? '';
            newFullNameController.text = userData['fullName'] ?? '';
            newTelephoneController.text = userData['phoneNumber'] ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: imageFile != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(imageFile!),
                            radius: 60,
                            )
                        : userData['profileImage'] == null
                          ? CircleAvatar(
                            backgroundImage: const AssetImage('assets/images/profileMan.png'),
                            radius: 60,
                            )
                          : CircleAvatar(
                            backgroundImage: NetworkImage(userData['profileImage']),
                            radius: 60,
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
                          child: GestureDetector(
                            onTap: () {
                              FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png'],
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    imageFile = File(value.files.single.path!);
                                  });
                                }
                              });
                            },
                            child: Icon(Icons.edit, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                          child: TextField(
                            controller: newUserNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person, color: Colors.blue),
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 2),
                          child: TextField(
                            controller: newFullNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person, color: Colors.blue),
                              labelText: 'Nama Penuh',
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 2),
                          child: TextField(
                            controller: newTelephoneController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone, color: Colors.blue),
                              labelText: 'No. Telefon',
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 2),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email, color: Colors.blue),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                            ),
                            readOnly: true,
                            controller: TextEditingController()..text = userData['email'] ?? '',
                          ),
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
                          onTap: () {
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
                              TextSpan(
                                text: Jiffy.parseFromDateTime(userData['timestamp'].toDate()).yMMMMEEEEdjm,
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
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
