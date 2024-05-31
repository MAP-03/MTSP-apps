
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/tanggungan.dart';

class EkhairatService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAhli(Ahli ahli) async{

    await _firestore.collection('ahli').doc(ahli.email).set(ahli.toJson());

  }

  Future<bool> checkAhli(String? email) async{
    final doc = await _firestore.collection('ahli').doc(email).get();
    return doc.exists;
  }

  Future<Ahli> getAhli(String? email) async{
    final doc = await _firestore.collection('ahli').doc(email).get();
    return Ahli(
      name: doc['name'],
      email: doc['email'],
      ic: doc['ic'],
      alamat: doc['alamat'],
      phone: doc['phone'],
      emergencyPhone: doc['emergencyPhone'],
    )..tanggungan = (doc['tanggungan'] as List).map((e) => Tanggungan.fromMap(e)).toList()
     ..pelan = doc['pelan']
     ..tarikhDaftar = doc['tarikhDaftar']
     ..status = doc['status'];
  }
}