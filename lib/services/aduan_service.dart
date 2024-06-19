import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/aduan.dart';

class AduanService {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;
  
  // get collection of aduan
  final CollectionReference aduanCollection = FirebaseFirestore.instance.collection('Aduan');
  
  // CREATE: add a new aduan
  Future<void> addAduan(String type, String subject, String comment, String status) async {

    Aduan aduan = Aduan(
      userEmail: user!.email!,
      type: type,
      subject: subject,
      comment: comment,
      reply: null,
      status: status,
      timestamp: Timestamp.now(),
    );

    await aduanCollection.add(aduan.toJson());
  }

  // READ: get aduan given a doc id
  Future<Aduan> getAduan(String docID) async {
    final snapshot = await aduanCollection.doc(docID).get();

    return Aduan(
      userEmail: snapshot['UserEmail'],
      type: snapshot['Type'],
      subject: snapshot['Subject'],
      comment: snapshot['Comment'],
      reply: snapshot['AdminReply'],
      status: snapshot['Status'],
      timestamp: snapshot['Timestamp'],
    );
  }

  // READ: get all aduan stream
  Stream<QuerySnapshot> getAduanStream() {
    final aduanStream = aduanCollection
      .where('Status', isNotEqualTo: 'DRAFT')
      .orderBy('Timestamp', descending: true)
      .snapshots();

    return aduanStream;
  }

  // READ: get all aduan
  Future<List<Aduan>> getAduanList() async {
    final snapshot = await aduanCollection
      .orderBy('Timestamp', descending: true)
      .get();

    return snapshot.docs.map((e) => Aduan(
      userEmail: e['UserEmail'],
      type: e['Type'],
      subject: e['Subject'],
      comment: e['Comment'],
      reply: e['AdminReply'],
      status: e['Status'],
      timestamp: e['Timestamp'],
    )).toList();
  }

  // READ: get all aduan except DRAFT
  Future<List<Aduan>> getAduanListExceptDraft() async {
    final snapshot = await aduanCollection
      .where('Status', isNotEqualTo: 'DRAFT')
      .orderBy('Timestamp', descending: true)
      .get();

    return snapshot.docs.map((e) => Aduan(
      userEmail: e['UserEmail'],
      type: e['Type'],
      subject: e['Subject'],
      comment: e['Comment'],
      reply: e['AdminReply'],
      status: e['Status'],
      timestamp: e['Timestamp'],
    )).toList();
  }

  // READ: get all aduan by user
  Future<List<Aduan>> getAduanListByUser() async {
    final snapshot = await aduanCollection
      .where('UserEmail', isEqualTo: user!.email)
      .orderBy('Timestamp', descending: true)
      .get();

    return snapshot.docs.map((e) => Aduan(
      userEmail: e['UserEmail'],
      type: e['Type'],
      subject: e['Subject'],
      comment: e['Comment'],
      reply: e['AdminReply'],
      status: e['Status'],
      timestamp: e['Timestamp'],
    )).toList();
  }

  // UPDATE: update aduan given a doc id
  Future<void> updateAduan(String docID, Aduan newAduan) async {
    await aduanCollection.doc(docID).update({
      'UserEmail': newAduan.userEmail,
      'Type': newAduan.type,
      'Subject': newAduan.subject,
      'Comment': newAduan.comment,
      'AdminReply': newAduan.reply,
      'Status': newAduan.status,
      'Timestamp': newAduan.timestamp,
    });
  }

  // DELETE: delete aduan given a doc id
  Future<void> deleteAduan(String docID) async {
    await aduanCollection.doc(docID).delete();
  }
}