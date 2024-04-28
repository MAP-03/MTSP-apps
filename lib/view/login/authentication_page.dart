import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/view/login/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //user already login
            if (snapshot.hasData) {
              return HomePage();
            }
            //user has not login
            else {
              return LoginPage();
            }
          }),
    );
  }
}
