// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mtsp/firebase_options.dart';
import 'package:mtsp/global.dart';
import 'package:mtsp/view/aduan/aduan.dart';
import 'package:mtsp/view/azan/azan.dart';
import 'package:mtsp/view/berita/berita.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/view/ekhairat/ekhairat.dart';
import 'package:mtsp/view/infaq/infaq.dart';
import 'package:mtsp/view/kalendar/kalendar.dart';
import 'package:mtsp/auth/authentication_page.dart';
import 'package:mtsp/notification_controller.dart';
import 'view/login/login_page.dart';
//import 'package:flutter/foundation.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey = "pk_test_51OJWJGK4kvnq6xon7sAiBo0H0QmchNFML4vQjoSp1kZvlNDKWhPSEn2RUvniiOcOdfxtg0rSbZGD7MrwgEbRbVii00gSgX0cZG"; //TODO try check balik
  //Stripe.publishableKey = dotenv.env['PUBLISH_KEY']!;
  
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: 'grouped',
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      defaultColor: Color(0xFF9D50DD),
      ledColor: Colors.white,
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: 'grouped',
      channelGroupName: 'Grouped notifications',
    )
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink,
        ),
      ),
      routes: {
        /* '/login': (context) => LoginPage(onTap: ),
        '/register': (context) => RegisterPage(onTap: ), */
        '/home': (context) => HomePage(),
        '/ekhairat': (context) => Ekhairat(),
        '/berita': (context) => Berita(),
        '/infaq': (context) => Infaq(),
        '/azan': (context) => Azan(),
        '/kalendar': (context) => Kalendar(),
        '/aduan': (context) => Aduan(),
      },
      home: AuthPage(),
    );
  }
}
