// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:intl/intl.dart';

class InfaqModel {
  final String email;
  String infaqId;
  String amaun;
  DateTime tarikh;
  String status;
  String paymentMethod;

  InfaqModel({
    required this.email,
    required this.infaqId,
    required this.amaun,
    required this.tarikh,
    required this.status,
    required this.paymentMethod,
  });

  void setInfaqId(String infaqId) {
    this.infaqId = infaqId;
  }

  void setStatus(String status) {
    this.status = status;
  }

  String getAmaun() {
    return amaun.replaceAll(".", "0");
  }

  String getPaymentMthod() {
    return paymentMethod;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'infaqId': infaqId,
      'amaun': amaun,
      'tarikh': DateFormat('dd-MM-yyyy').format(tarikh),
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }
}
