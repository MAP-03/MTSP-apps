// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';

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
    if (newUserNameController.text != currentUser.email!) {
      usersCollection
          .doc(currentUser.email)
          .update({'username': newUserNameController.text});
    }

    if (newUserNameController.text != currentUser.email!) {
      usersCollection
          .doc(currentUser.email)
          .update({'fullName': newUserNameController.text});
    }
    if (newUserNameController.text != currentUser.email!) {
      usersCollection
          .doc(currentUser.email)
          .update({'username': newUserNameController.text});
    }

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
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Container(
                  //height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(kDefaultFontSize),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              const SizedBox(
                                width: 120,
                                height: 120,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
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
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.black)),
                              )
                            ],
                          ),
                          const SizedBox(height: 50),
                          Form(
                            child: Column(children: [
                              TextFormField(
                                controller: newUserNameController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    label: Text('Username'),
                                    prefixIcon:
                                        Icon(Icons.person, color: Colors.white),
                                    labelStyle: TextStyle(color: Colors.white),
                                    hintText: userData['username'],
                                    hintStyle: TextStyle(color: Colors.white)),
                                /* onChanged: (value) {
                                  newValue = value;
                                }, */
                              ),
                              TextFormField(
                                controller: newFullNameController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    label: Text('Nama Penuh'),
                                    prefixIcon:
                                        Icon(Icons.person, color: Colors.white),
                                    labelStyle: TextStyle(color: Colors.white),
                                    hintText: userData['fullname'],
                                    hintStyle: TextStyle(color: Colors.white)),
                                /* onChanged: (value) {
                                  newValue = value;
                                }, */
                              ),
                              TextFormField(
                                  controller: newTelephoneController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      label: Text('No. Telefon'),
                                      prefixIcon: Icon(Icons.phone,
                                          color: Colors.white),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      hintText: userData['phoneNumber'],
                                      hintStyle:
                                          TextStyle(color: Colors.white))),
                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    label: Text('Email'),
                                    prefixIcon:
                                        Icon(Icons.email, color: Colors.white),
                                    labelStyle: TextStyle(color: Colors.white),
                                    hintText: userData['email'],
                                    hintStyle: TextStyle(color: Colors.white)),
                                readOnly: true,
                              ),
                              /* TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    label: Text('password'),
                                    prefixIcon: Icon(Icons.password,
                                        color: Colors.white),
                                    labelStyle: TextStyle(color: Colors.white)),
                              ), */
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    updateProfileDetail();
                                    /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProfile(),
                                      ),
                                    ); */
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Adjust the radius as needed
                                    ),
                                    backgroundColor:
                                        Colors.white, // Background color
                                  ),
                                  child: const Text('Update',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              const SizedBox(height: 210),
                            ]),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text.rich(TextSpan(
                              text: "Joined",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              children: [
                                TextSpan(
                                    text: (" tarikh pengguna buat akaun"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))
                              ]))
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
