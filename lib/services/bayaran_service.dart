// bayaran_service.dart
// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:mtsp/models/butiranBayaran.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:mtsp/view/ekhairat/ekhairat.dart';
import 'dart:convert';

import 'package:mtsp/widgets/toast.dart';

class BayaranService {
  static const String _apiBaseUrl = 'https://api.stripe.com/v1';
  static const String _secretKey = 'sk_test_51OJWJGK4kvnq6xonXDzIf3Q4bV0dsmzYF76TWOJuiJUqBA46pYNHXMly2MqRh7XLIBqKf4SV3kDgfhLR6YqLM77j00AXGvTyv7';

  static Future<Map<String, dynamic>> createPaymentIntent(String amount) async {

    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': '${amount}00',
          'currency': 'myr',
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent: ${response.body}');
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Failed to create payment intent: ${e.toString()}');
    }
  }

  static Future<String> makePayment(String amount, String pelan) async {

    final paymentIntent = await createPaymentIntent(amount);
    String status = 'Gagal';

    try {
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: 'MTSP'))
          .then((value) => null);

      await Stripe.instance.presentPaymentSheet().then((value) {
        ButiranBayaran butiranBayaran = ButiranBayaran(
          bayaranId: paymentIntent['id'],
          amaun: amount,
          pelan: pelan,
          tarikh: DateTime.now(),
          status: 'Berjaya',
          paymentMethod: 'card',
        );
        updateButiranBayaran(butiranBayaran);
        showToast(message: 'Pembayaran berjaya');
        status = 'Berjaya';
      }).onError((error, stackTrace) {
        showToast(message: 'Pembayaran gagal');
        status = 'Gagal';
      });

    } catch (e) {
      status = 'Gagal';
      throw Exception('Failed to make payment: ${e.toString()}');
    }

    return status;

  }

  static Future<void> updateButiranBayaran(ButiranBayaran butiranBayaran) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    EkhairatService ekhairatService = EkhairatService();
    await ekhairatService.addButiranBayaran(butiranBayaran, email);
  }
}
