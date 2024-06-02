import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final void Function()? onTap;

  const SubmitButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}