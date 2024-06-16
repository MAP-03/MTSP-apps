// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mtsp/services/infaq_service.dart';
import 'package:mtsp/view/infaq/infaq.dart';

class ButiranInfaq {
  String infaqId;
  String amaun;
  DateTime tarikh;
  String status;
  String paymentMethod;

  ButiranInfaq({
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
      'infaqId': infaqId,
      'amaun': amaun,
      'tarikh': DateFormat('dd-MM-yyyy').format(tarikh),
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  factory ButiranInfaq.fromMap(Map<String, dynamic> map) {
    return ButiranInfaq(
      infaqId: map['infaqId'] as String,
      amaun: map['amaun'] as String,
      tarikh: DateFormat('dd-MM-yyyy').parse(map['tarikh'] as String),
      status: map['status'] as String,
      paymentMethod: map['paymentMethod'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ButiranInfaq.fromJson(String source) =>
      ButiranInfaq.fromMap(json.decode(source) as Map<String, dynamic>);
}
