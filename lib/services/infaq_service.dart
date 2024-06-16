import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/butiranInfaq.dart';
import 'package:mtsp/models/infaqModel.dart';
import 'package:mtsp/models/tanggungan.dart';

class InfaqService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkInfaq(String? email) async {
    final doc = await _firestore.collection('infaq').doc(email).get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createInfaq(InfaqModel infaq) async {
    await _firestore.collection('infaq').doc(infaq.email).set(infaq.toJson());
  }

  Future<void> updateInfaq(InfaqModel infaq) async {
    await _firestore
        .collection('infaq')
        .doc(infaq.email)
        .update(infaq.toJson());
  }

  Future<List<InfaqModel>> getAllInfaq() async {
    final snapshot = await _firestore.collection('infaq').get();
    return snapshot.docs
        .map((e) => InfaqModel(email: e['email'])
          ..butiranInfaq = (e['butiranInfaq'] as List)
              .map((e) => ButiranInfaq.fromMap(e))
              .toList())
        .toList();
  }

  Future<InfaqModel> getInfaqByEmail(String? email) async {
    final doc = await _firestore.collection('infaq').doc(email).get();
    return InfaqModel(email: doc['email'])
      ..butiranInfaq = (doc['butiranInfaq'] as List)
          .map((e) => ButiranInfaq.fromMap(e))
          .toList();
  }
}
