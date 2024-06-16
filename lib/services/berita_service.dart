import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/widgets/toast.dart';

class BeritaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addEvent(String title, String description, DateTime? date, TimeOfDay? time, String location, File? image) async {
    String imageUrl = '';
    if (image != null) {
      try {
        final storageRef = _storage.ref().child('event_images/${title}_${DateTime.now().toIso8601String()}');
        TaskSnapshot snapshot = await storageRef.putFile(image);
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        showToast(message: 'Error uploading image: $e');
        return;
      }
    }

    try {
      await _firestore.collection('Berita').doc(title).set({
        'title': title,
        'description': description,
        'date': date != null ? Timestamp.fromDate(date) : null,
        'time': time != null ? '${time.hour}:${time.minute}' : null,
        'location': location,
        'imageLink': imageUrl,
      });
      showToast(message: 'Event successfully added');
    } catch (e) {
      showToast(message: 'Error saving event: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    List<Map<String, dynamic>> events = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('Berita').get();
      snapshot.docs.forEach((doc) {
        events.add(doc.data() as Map<String, dynamic>);
      });
    } catch (e) {
      showToast(message: 'Error fetching events: $e');
    }
    return events;
  }
}
