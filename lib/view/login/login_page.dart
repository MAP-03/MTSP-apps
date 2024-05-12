// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mtsp/services/auth_service.dart';
import 'package:mtsp/widgets/sign_in.dart';
import 'package:mtsp/widgets/toast.dart';
import '../../widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSigningIn = false;

  //function
  void signInUser() async {
    setState(() {
      isSigningIn = true;
    });
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      setState(() {
        isSigningIn = false;
      });
      
    } on FirebaseAuthException catch (e) {
        showToast(message: e.code);

        setState(() {
        isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('lib/images/loginpage_bg.png'),
            fit: BoxFit.cover, // Adjust as needed (cover, contain, etc.)
          )),
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
                              fontSize: 15, color: Colors.grey.shade100, decoration: TextDecoration.underline, decorationColor: Colors.grey.shade100)),
                    ],
                  ),
                ),

                const SizedBox(height: 25.0),

                GestureDetector(
                    onTap: () => signInUser(),
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      decoration: BoxDecoration(
                          color: Color(0xff050A30), borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: isSigningIn
                            ? CircularProgressIndicator()
                            : Text(
                              'Log Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                  ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0
                        ),
                        child: Text(
                          'atau log masuk melalui',
                          style: TextStyle(color: Colors.white),
                        )
                      ),

                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white
                        )
                      ),
                    ]
                  )
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () => AuthService().signInWithGoogle(),
                  child: Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/images/Google_logo.png',
                          height: 45.0,
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                //New Account
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Tiada Akaun ? ', style: TextStyle(fontSize: 15, color: Colors.grey.shade300)),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Daftar Sekarang',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue.shade200)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    ));
  }
}
