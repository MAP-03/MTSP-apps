// ignore_for_file: unused_element, dead_code

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:mtsp/models/infaqModel.dart';
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static Future<dynamic> createPaymentIntent(InfaqModel infaq) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': infaq.getAmaun(),
        'currency': 'myr',
        'payment_method_types[]': infaq.getPaymentMthod()
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          //'Authorization': 'Bearer ${dotenv.env['SECRET_KEY']}',
          'Authorization':
              'Bearer sk_test_51OJWJGK4kvnq6xonXDzIf3Q4bV0dsmzYF76TWOJuiJUqBA46pYNHXMly2MqRh7XLIBqKf4SV3kDgfhLR6YqLM77j00AXGvTyv7', //TODO try check balik
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      infaq.setStatus('Gagal');
      throw Exception(err.toString());
    }
  }

  static void displayPaymentSheet(infaq) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        infaq.setStatus('Berjaya');
      }).onError((error, stackTrace) {
        infaq.setStatus('Gagal');
        throw Exception(error);
      });
    } on StripeException catch (e) {
      infaq.setStatus('Gagal');
    } catch (e) {
      infaq.setStatus('Gagal');
    }
  }

  static Future<void> makePayment(InfaqModel infaq) async {
    try {
      Map<String, dynamic> paymentIntent;

      paymentIntent = await createPaymentIntent(infaq);

      infaq.setInfaqId(paymentIntent['id']);

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: 'MTSP'))
          .then((value) => null);

      displayPaymentSheet(infaq);
      infaq.setStatus('Berjaya');
      print(infaq.toJson());

    } catch (e) {
      infaq.setStatus('Gagal');
      print(e.toString());
    }
  }
}
