import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtsp/auth/authentication_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Future<void> delayedFunction() async {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (route) => false,
      );
    }

    delayedFunction();
    
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
        Center(
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/mtsp_logo.png',
                height: 200,
              ),
              const SizedBox(
                height: 200,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Jika syurga yang dicari,\nJadikanlah ",
                      style: GoogleFonts.manrope(
                          fontSize: 24,
                          color: Colors.black,
                          letterSpacing: 3.5 / 100,
                          height: 152 / 100),
                      children: const [
                        TextSpan(
                            text: "Masjid",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800)),
                        TextSpan(text: "\nteman sejati")
                      ]))
            ],
          )),
        )
      ]),
    );
  }
}