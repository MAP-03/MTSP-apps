import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mtsp/services/auth_service.dart';

class RoleBasedRoute extends StatefulWidget {
  final Widget userPage;
  final Widget adminPage;

  RoleBasedRoute({required this.userPage, required this.adminPage});

  @override
  _RoleBasedRouteState createState() => _RoleBasedRouteState();
}

class _RoleBasedRouteState extends State<RoleBasedRoute> {
  String role = '';
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  void initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      authService.getCurrentUserData().then((value) {
        setState(() {
          role = value['role'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (role == '') {
      return Center(child: CircularProgressIndicator());
    } else if (role == 'admin') {
      return widget.adminPage;
    } else {
      return widget.userPage;
    }
  }
}
