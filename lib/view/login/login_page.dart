// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mtsp/view/login/sign_in.dart';
import 'text_field.dart';

class LoginPage extends StatelessWidget {
  //Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //function
  void signIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Color(0xff274472),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //logo MTSP
              Center(
                child: Image.asset(
                  'lib/images/mtsp_logo.png',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.fill, // Adjust fit as needed
                ),
              ),

              const SizedBox(height: 30),

              //text "Email"
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),

              //Email Container
              TextFieldComponents(
                controller: emailController,
                hintText: 'ali123@gmail.com',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              //text "Kata Laluan"
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Kata Laluan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),

              //Password Container
              TextFieldComponents(
                controller: passwordController,
                hintText: '********',
                obscureText: true,
              ),

              //text "Lupa Kata Laluan"
              Padding(
                padding: const EdgeInsets.only(right: 25, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Lupa Kata Laluan',
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade600)),
                  ],
                ),
              ),

              const SizedBox(height: 100),

              //Log Masuk Button
              SignInComponents(
                onTap: signIn,
              ),

              const SizedBox(height: 20),

              //New Account
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tiada Akaun ? ',
                      style: TextStyle(
                          fontSize: 15
                      )
                    ),
                    Text('Daftar Sekarang',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue.shade700
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}

/* return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/loginpage_bg.png'),
            fit: BoxFit.cover, // Adjust fit as needed
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 60),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Text("MTSP",
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 20),
                ),
              ]),
            ),
            /* Expanded(
              child:  Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                )
              ),
            ) */
          ],
        ),
      )
    );
  } */