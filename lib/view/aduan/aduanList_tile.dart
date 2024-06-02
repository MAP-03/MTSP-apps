import 'package:flutter/material.dart';
import 'package:mtsp/models/aduan.dart';

class AduanListTile extends StatelessWidget {
  final Aduan aduan;
  final void Function() onTap;

  const AduanListTile({
    super.key,
    required this.aduan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 350,
          height: 75,
          // padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Aduan Type
              Text(aduan.type),
      
              // Aduan Subject
              Text(aduan.subject),
      
              const Text('MM/DD/YYYY'),
            ],
          ),
        ),
      ),
    );
  }
}