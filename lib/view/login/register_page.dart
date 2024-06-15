// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mtsp/services/auth_service.dart';
import 'package:mtsp/view/login/register_credential.dart';
import 'package:mtsp/widgets/sign_in.dart';
import 'package:mtsp/widgets/toast.dart';
import '../../widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controller

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isSigningUp = false;

  Future<bool> checkExistingAcount(String? email) async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();

    return doc.exists;
  }

  //function
  void signUpUser() async {
    setState(() {
      isSigningUp = true;
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        showToast(message: 'Pendaftaran Berjaya!');

        FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.email)
            .set({
          'username': emailController.text.split('@')[0],
          'email': emailController.text,
          'phoneNumber': '-',
          'role' : 'user',
          'timestamp': DateTime.now()
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterCredentialPage(
            email: emailController.text,
            onTap: widget.onTap,
          )),
        );
      } else {
        showToast(message: 'Kata laluan tidak sama');
      }

      setState(() {
        isSigningUp = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isSigningUp = false;
      });

      showToast(message: e.code.replaceAll('-', ' '));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        //height: MediaQuery.of(context).size.height,
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('lib/images/loginpage_bg.png'),
            fit: BoxFit.cover, // Adjust as needed (cover, contain, etc.)
          )),
        ),
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 120),

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

                const SizedBox(height: 10),

                //text "Ulang Kata Laluan"
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Ulang Kata Laluan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ),

                //Repeat Password Container
                TextFieldComponents(
                  controller: confirmPasswordController,
                  hintText: '********',
                  obscureText: true,
                ),

                const SizedBox(height: 30.0),

                GestureDetector(
                  onTap: () => signUpUser(),
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 15),
                    decoration: BoxDecoration(
                        color: Color(0xff050A30),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: isSigningUp
                          ? CircularProgressIndicator()
                          : Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 15.0),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(children: [
                      Expanded(
                          child: Divider(thickness: 0.5, color: Colors.white)),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'atau daftar melalui',
                            style: TextStyle(color: Colors.white),
                          )),
                      Expanded(
                          child: Divider(thickness: 0.5, color: Colors.white)),
                    ])),

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
                      Text('Sudah mempunyai akaun ? ',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Log masuk',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue.shade400)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
