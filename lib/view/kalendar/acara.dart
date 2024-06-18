import 'package:flutter/material.dart';

class Event {
  final String id;
  final String note;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String userId;
  final DateTime creationDate; // Add creationDate field

  Event({
    required this.id,
    required this.note,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.userId,
    required this.creationDate, // Initialize creationDate
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'note': note,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'color': color.value,
        'userId': userId,
        'creationDate': creationDate.toIso8601String(), // Add to JSON
      };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      note: json['note'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      color: Color(json['color']),
      userId: json['userId'] ?? '',
      creationDate: DateTime.parse(json['creationDate']), // Initialize from JSON
    );
  }

  @override
  String toString() => '$note: $startDate to $endDate';
}
