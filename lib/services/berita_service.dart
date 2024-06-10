import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mtsp/widgets/toast.dart';

class BeritaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> AddEvent(String title, String description, DateTime? date, TimeOfDay? time, String location, File? image) async {
    if (image != null) {
      String imageUrl;

      final storageRef = storage.ref().child('event/$title');
      await storageRef.putFile(image);
      imageUrl = await storageRef.getDownloadURL();

      _firestore.collection('Berita').doc(title).set({
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'imageLink': imageUrl,
      });

      showToast(message: 'Berita berjaya dihantar');
      return imageUrl;
    }
    return '';
  }

  uploadImage(File image, String title) {}
}
