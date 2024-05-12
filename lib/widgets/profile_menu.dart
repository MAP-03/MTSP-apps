import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child:  Icon(icon, color: Colors.black),
      ),
      title:  Text(title, style: TextStyle(color: textColor ?? Colors.white)),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
      
        child: const Icon(Icons.arrow_forward_ios, color: Colors.white)) : null,
      );
  }
}