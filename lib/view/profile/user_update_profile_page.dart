
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mtsp/view/profile/user_profile_page.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

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
                      builder: (context) => Profile(),
                    ),
                  );
                },
        ),
        title: Text("Edit Profile", style: const TextStyle(color: Colors.white)),
        centerTitle: true,
          iconTheme: const IconThemeData(
          color: Colors.white,
        
          ),
  
        backgroundColor: const Color(0xff06142F),
      
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(kDefaultFontSize),
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
          child: const Icon(Icons.camera_alt, color: Colors.black)),
      ) 
      ],
      ),
      const SizedBox(height: 50),
      Form(child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text("Nama Penuh"), prefixIcon: Icon(Icons.person, color: Colors.white), labelStyle: TextStyle(color: Colors.white)),
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text("No. Phone"), prefixIcon: Icon(Icons.phone, color: Colors.white), labelStyle: TextStyle(color: Colors.white)),
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text("E-Mail"), prefixIcon: Icon(Icons.email, color: Colors.white), labelStyle: TextStyle(color: Colors.white)),
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text("Kata Laluan"), prefixIcon: Icon(Icons.password, color: Colors.white), labelStyle: TextStyle(color: Colors.white)),
          ),
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
          child: const Text('Update', style: TextStyle(color: Colors.black)),
        ),
      ),
      const SizedBox(height: 30),
      const Row(
        children: [
        Text.rich(
          TextSpan(
            text:"Joined",
            style: TextStyle(color: Colors.white, fontSize: 12),
            children: [
              TextSpan(
                text: (" tarikh pengguna buat akaun"),
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
              )
            ]
          )
          )  
        ],
      )
      ]
      ))
      ],
      ),
      ),
      ),
      backgroundColor: const Color(0xff06142F),
    );
  }
}

