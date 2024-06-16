import 'package:flutter/material.dart';

class Event {
  final DateTime startDate;
  final DateTime endDate;
  final String note;
  final Color color;

  Event(this.note, this.startDate, this.endDate, this.color);

  // Convert Event to JSON
  Map<String, dynamic> toJson() => {
        'note': note,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'color': color.value,
      };

  // Create Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      json['note'] ?? '',
      DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      Color(json['color'] ?? 0xFFFFFFFF),
    );
  }

  @override
  String toString() => '$startDate - $endDate - $note';
}
