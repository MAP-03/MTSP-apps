// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<bool> checkExistingAcount(String? email) async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();

    return doc.exists;
  }

  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final String email = userCredential.user!.email!;

    if (checkExistingAcount(email) == false) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': email.split('@')[0],
        'fullName': '',
        'email': email,
        'phoneNumber': ''
      });
    }

    //sign in user
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkEmailInDatabase(String email) async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();

    return doc.exists;
  }
}
