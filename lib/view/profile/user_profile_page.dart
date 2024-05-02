import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/view/login/authentication_page.dart';
import 'package:mtsp/view/profile/user_update_profile_page.dart';
import 'package:mtsp/widgets/profile_menu.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  // Function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
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
        title: const Text(
        'Profile',
        style: TextStyle(color: Colors.white),
       ),
        centerTitle: true,
          iconTheme: const IconThemeData(
          color: Colors.white,
        
          ),
 
        backgroundColor: const Color(0xff06142F),
      
      ),
      
      body: Center(
  child: Column( 
    children: [
       Stack(
    children: [
      const SizedBox(
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
          child: const Icon(Icons.edit, color: Colors.black)),
      ) 
      ],
      ),
      const SizedBox(height: 10),
      const Text("Thoriq", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      const Text("thoriqkahairi@yahoo.com", style: TextStyle(color: Colors.white, fontSize: 15 )),
      const SizedBox(height: 20),
      SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProfile(),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
            ),
            backgroundColor: Colors.white, // Background color
          ),
          child: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
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
        title: 'Log keluar',
        icon: Icons.logout,
        endIcon: false,
        textColor: Colors.red,
        onPress: () async {
              await FirebaseAuth.instance.signOut();
              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  
                );
                
              } else {
                print('Sign out failed!'); 
              }
            },// Single function call},
      ),
      
   
      
      
    ],
  ),
),

       backgroundColor:const Color(0xff06142F),
    );
  }
}


