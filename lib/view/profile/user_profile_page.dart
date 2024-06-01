// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/auth/authentication_page.dart';
import 'package:mtsp/view/profile/user_update_profile_page.dart';
import 'package:mtsp/widgets/profile_menu.dart';
import 'package:mtsp/widgets/toast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void _deleteAccount() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .delete();

    showToast(message: "Akaun berjaya dipadam");

    await FirebaseAuth.instance.currentUser!.delete();

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
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            }),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
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
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: 
                    userData['profileImage'] == null
                    ? CircleAvatar(
                        backgroundImage: const AssetImage('assets/images/profileMan.png'),
                        radius: 60,
                      )
                    : GestureDetector(
                        onTap: () {
                          showImageViewer(
                            doubleTapZoomable: true,
                              context,
                              NetworkImage(
                                userData['profileImage'],
                              ),
                          );
                        },
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(userData['profileImage']),
                          radius: 60,
                        ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(userData['username'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text(currentUser.email!,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfile()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius as needed
                        ),
                        backgroundColor:
                            Colors.blue, // Background color
                      ),
                      child: const Text('Edit Profile',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),

                  ///MENU
                  ProfileMenuWidget(
                    title: 'Pengurusan Pengguna',
                    icon: Icons.person,
                    onPress: () {},
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: 'Tetapan',
                    icon: Icons.settings,
                    onPress: () {},
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: 'Butiran Bil',
                    icon: Icons.credit_card,
                    onPress: () {},
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: 'Padam Akaun',
                    icon: Icons.logout,
                    //backgroundColor: Colors.red,
                    endIcon: false,
                    textColor: Colors.red,
                    onPress: () async {
                      _deleteAccount();
                    }, // Single function call},
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
