import 'package:cloud_firestore/cloud_firestore.dart';
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
          },
        ),
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
          if (snapshot.hasData) {
            final userData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Center(
              child: Column(
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
                            child: const Icon(Icons.edit,
                                color: Colors.black)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(userData['username'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text(currentUser.email!,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfile()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Adjust the radius as needed
                        ),
                        backgroundColor:
                            Colors.white, // Background color
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
                    title: 'Log Keluar',
                    icon: Icons.logout,
                    //backgroundColor: Colors.red,
                    endIcon: false,
                    textColor: Colors.red,
                    onPress: () async {
                      await FirebaseAuth.instance.signOut();
                      if (FirebaseAuth.instance.currentUser == null) {
                        showToast(message: 'Log Keluar Berjaya!');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthPage()),
                        );
                      } else {
                        showToast(message: 'Log Keluar Gagal!');
                      }
                    }, // Single function call},
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
        },
      ),
    );
  }
}
