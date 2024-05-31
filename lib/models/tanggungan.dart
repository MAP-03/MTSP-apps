// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Tanggungan {
  String name;
  String ic;
  String hubungan;

  Tanggungan({
    required this.name, 
    required this.ic, 
    required this.hubungan
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'ic': ic,
      'hubungan': hubungan,
    };
  }

  factory Tanggungan.fromMap(Map<String, dynamic> map) {
    return Tanggungan(
      name: map['name'] as String,
      ic: map['ic'] as String,
      hubungan: map['hubungan'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tanggungan.fromJson(String source) => Tanggungan.fromMap(json.decode(source) as Map<String, dynamic>);
}
