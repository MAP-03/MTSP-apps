// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SignInComponents extends StatelessWidget {
  final Function() ? onTap;
  const SignInComponents({
    super.key,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
        decoration: BoxDecoration(
          color: Color(0xff050A30),
          borderRadius: BorderRadius.circular(10)),
        child: Text(
          "Log Masuk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
      ),
    );
  }
}
