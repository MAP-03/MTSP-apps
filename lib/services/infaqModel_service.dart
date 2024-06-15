
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtsp/models/ahli.dart';
import 'package:mtsp/models/infaqModel.dart';
import 'package:mtsp/models/tanggungan.dart';

class InfaqService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addInfaqModel(InfaqModel infaq) async{

    await _firestore.collection('infaq').doc(infaq.email).set(infaq.toJson());

  }

  /* Future<bool> checkInfaq(String? email) async{
    final doc = await _firestore.collection('ahli').doc(email).get();
    return doc.exists;
  } */

  Future<InfaqModel> getInfaqByEmail(String? email) async{
    final doc = await _firestore.collection('infaq').doc(email).get();
    return InfaqModel(
      email: doc['email'],
      infaqId: doc['infaqId'],
      amaun: doc['amaun'],
      tarikh: doc['tarikh'],
      status: doc['status'],
      paymentMethod: doc['paymentMethod'],
    );
  }
}