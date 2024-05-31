import 'package:flutter/material.dart';

class AduanListTile extends StatelessWidget {
  const AduanListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Aduan Type
            Text('Aduan'),

            // Aduan Subject
            Text('Aduan Subject'),

            Text('Aduan Tarikh'),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
  }
}