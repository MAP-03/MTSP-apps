import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtsp/models/tanggungan.dart';

class Ahli{
  String name;
  String email;
  String ic;
  String alamat;
  String phone;
  String emergencyPhone;
  List<Tanggungan> tanggungan = [];
  String pelan = '';
  String status = 'PENDING';
  Timestamp tarikhDaftar = Timestamp.now();

  Ahli({
    required this.name,
    required this.email,
    required this.ic,
    required this.alamat,
    required this.phone,
    required this.emergencyPhone,
  });

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'email': email,
      'ic': ic,
      'alamat': alamat,
      'phone': phone,
      'emergencyPhone': emergencyPhone,
      'tanggungan': tanggungan.map((e) => e.toMap()).toList(),
      'pelan': pelan,
      'tarikhDaftar': tarikhDaftar,
      'status': status,
    };
  }
  
}