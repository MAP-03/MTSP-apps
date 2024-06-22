
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/butiranBayaran.dart';
import 'package:mtsp/models/tanggungan.dart';
import 'package:http/http.dart' as http;

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

  Future<void> updateAhli(Ahli ahli) async{
    await _firestore.collection('ahli').doc(ahli.email).update(ahli.toJson());
  }

  Future<void> deleteAhli(String? email) async{
    await _firestore.collection('ahli').doc(email).delete();
  }

  Future<List<Ahli>> getAllAhli() async{
    final snapshot = await _firestore.collection('ahli').get();
    return snapshot.docs.map((e) => Ahli(
      name: e['name'],
      email: e['email'],
      ic: e['ic'],
      alamat: e['alamat'],
      phone: e['phone'],
      emergencyPhone: e['emergencyPhone'],
    )..tanggungan = (e['tanggungan'] as List).map((e) => Tanggungan.fromMap(e)).toList()
     ..pelan = e['pelan']
     ..tarikhDaftar = e['tarikhDaftar']
     ..status = e['status']).toList();
  }

  Future<void> updateAhliStatus(String? email, String? status) async{
    await _firestore.collection('ahli').doc(email).update({'status': status});
  }

  Future<void> bayarEkhairat() async{
    
  }

  Future<void> addButiranBayaran(ButiranBayaran butiranBayaran, String email) async{
    await _firestore.collection('ahli').doc(email).collection('bayaran').doc().set(butiranBayaran.toMap());
  }

  Future<List<ButiranBayaran>> getButiranBayaran(String email) async{
    final snapshot = await _firestore.collection('ahli').doc(email).collection('bayaran').get();
    return snapshot.docs.map((e) => ButiranBayaran.fromMap(e.data())).toList();
  }

}