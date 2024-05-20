import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtsp/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    await _firestore.collection('Users').doc(user.email).set(user.toJson());
  }

  Future<bool> checkUser(String? email) async {
    final doc = await _firestore.collection('Users').doc(email).get();
    return doc.exists;
  }

  Future<User> getUser(String? email) async {
    final doc = await _firestore.collection('Users').doc(email).get();
    return User(
      fullName: doc['fullName'],
      userName: doc['userName'],
      email: doc['email'],
      phoneNumber: doc['phoneNumber'],
    );
  }
}
