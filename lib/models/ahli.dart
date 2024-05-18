import 'package:mtsp/models/tanggungan.dart';

class Ahli{
  final String name;
  final String email;
  final String ic;
  final String alamat;
  final String phone;
  final String emergencyPhone;
  List<Tanggungan> tanggungan = [];
  String pelan = '';
  DateTime tarikhDaftar = DateTime.now();

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
      'pelan': pelan
    };
  }
  
}