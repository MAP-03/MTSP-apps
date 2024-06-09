// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mtsp/widgets/toast.dart';

class AuthService {

  final FirebaseStorage storage = FirebaseStorage.instance;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

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

    if (checkExistingAcount(email) == true) {
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

  Future<void> saveProfilePicture(String? email, File imageFile) async {
    try {
      String imageUrl;

      final storageRef = storage.ref().child('profilePicture/$email');
      await storageRef.putFile(imageFile);
      imageUrl = await storageRef.getDownloadURL();

      await usersCollection.doc(email).update({'profileImage': imageUrl});

    } catch (e) {
      showToast(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final doc = await usersCollection.doc(currentUser!.email).get();

    if (doc.exists) {
      final userData = doc.data() as Map<String, dynamic>;
      return userData;
    } else {
      throw Exception('User not found');
    }
  }
}
