import 'package:flutter/material.dart';

class Event {
  final String id;
  final String note;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String userId; // Add userId field

  Event({
    required this.id,
    required this.note,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.userId, // Initialize userId
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'note': note,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'color': color.value,
        'userId': userId, // Add userId to JSON
      };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      note: json['note'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      color: Color(json['color']),
      userId: json['userId'] ?? '', // Initialize userId from JSON
    );
  }

  @override
  String toString() => '$note: $startDate to $endDate';
}
