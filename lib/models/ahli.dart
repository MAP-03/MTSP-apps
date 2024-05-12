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

  Ahli({
    required this.name, 
    required this.email, 
    required this.ic, 
    required this.alamat, 
    required this.phone, 
    required this.emergencyPhone,
  });
}