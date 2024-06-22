// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ButiranBayaran {
  String bayaranId;
  String amaun;
  String pelan;
  DateTime tarikh;
  String status;
  String paymentMethod;

  ButiranBayaran({
    required this.bayaranId,
    required this.amaun,
    required this.pelan,
    required this.tarikh,
    required this.status,
    required this.paymentMethod,
  });

  void setbayaranId(String bayaranId) {
    this.bayaranId = bayaranId;
  }

  void setStatus(String status) {
    this.status = status;
  }

  String getStatus() {
    return status;
  }

  String getAmaun() {
    return amaun.replaceAll(".", "0");
  }

  String getPaymentMethod() {
    return paymentMethod;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bayaranId': bayaranId,
      'amaun': amaun,
      'pelan': pelan,
      'tarikh': tarikh,
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  factory ButiranBayaran.fromMap(Map<String, dynamic> map) {
    return ButiranBayaran(
      bayaranId: map['bayaranId'] as String,
      amaun: map['amaun'] as String,
      pelan: map['pelan'] as String,
      tarikh: (map['tarikh'] as Timestamp).toDate(),
      status: map['status'] as String,
      paymentMethod: map['paymentMethod'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ButiranBayaran.fromJson(String source) =>
      ButiranBayaran.fromMap(json.decode(source) as Map<String, dynamic>);
}
