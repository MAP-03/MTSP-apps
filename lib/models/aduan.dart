import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Aduan {
  final String userEmail;
  String type;
  String subject;
  String comment;
  String? reply;
  String status;
  final Timestamp timestamp;

  List<String> statusList = ['DRAFT', 'PENDING', 'REPLIED', 'CLOSED'];

  Aduan({
    required this.userEmail,
    required this.type,
    required this.subject,
    required this.comment,
    this.reply,
    required this.status,
    required this.timestamp,
  });

  // Factory constructor to create an Aduan from a Firestore document
  factory Aduan.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Aduan(
      userEmail: data['UserEmail'],
      type: data['Type'],
      subject: data['Subject'],
      comment: data['Comment'],
      reply: data['AdminReply'],
      status: data['Status'],
      timestamp: data['Timestamp'],
    );
  }

  Color getStatusColor() {
    if (status == 'DRAFT') {
      return Colors.red;
    } else if (status == 'PENDING') {
      return Colors.orange;
    } else if (status == 'REPLIED') {
      return Colors.blue;
    } else if (status == 'CLOSED') {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'UserEmail': userEmail,
      'Type': type,
      'Subject': subject,
      'Comment': comment,
      'AdminReply': reply,
      'Status': status,
      'Timestamp': timestamp,
    };
  }
}