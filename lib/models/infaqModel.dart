// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mtsp/models/butiranInfaq.dart';

class InfaqModel {
  final String email;
  List<ButiranInfaq> butiranInfaq = [];

  InfaqModel({
    required this.email,
  });

  void addButiranInfaq(ButiranInfaq bbutiranInfaq) {
    this.butiranInfaq.add(bbutiranInfaq);
  }

  List<ButiranInfaq> getButiranInfaqList() {
    return this.butiranInfaq;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'butiranInfaq': butiranInfaq.map((e) => e.toMap()).toList(),
    };
  }
}
