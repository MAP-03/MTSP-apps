// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutators

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mtsp/firebase_options.dart';
import 'package:mtsp/services/ekhairat_service.dart';
import 'package:mtsp/services/forum_service.dart';
import 'package:mtsp/services/notification_service.dart';
import 'package:mtsp/services/role_based_route.dart';
import 'package:mtsp/splash_screen.dart';
import 'package:mtsp/view/aduan/aduan_page.dart';
import 'package:mtsp/view/aduan/aduan_page_admin.dart';
import 'package:mtsp/view/azan/azan_layout.dart';
import 'package:mtsp/view/berita/berita.dart';
import 'package:mtsp/view/berita/berita_user.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/view/ekhairat/ekhairat.dart';
import 'package:mtsp/view/ekhairat/senarai_ahli.dart';
import 'package:mtsp/view/forum/create_forum.dart';
import 'package:mtsp/view/forum/forum_page.dart';
import 'package:mtsp/view/infaq/infaq.dart';
import 'package:mtsp/view/kalendar/kalendar_layout.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur')); // Set Malaysia timezone

  Stripe.publishableKey = "pk_test_51OJWJGK4kvnq6xon7sAiBo0H0QmchNFML4vQjoSp1kZvlNDKWhPSEn2RUvniiOcOdfxtg0rSbZGD7MrwgEbRbVii00gSgX0cZG";

  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestNotificationPermission();// Request notification permissions

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ForumsService()),
      ],
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
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
        '/home': (context) => HomePage(),
        '/ekhairat': (context) =>
            RoleBasedRoute(userPage: Ekhairat(), adminPage: SenaraiAhli()),
        '/berita': (context) =>
            RoleBasedRoute(userPage: BeritaUser(), adminPage: Berita()),
        '/infaq': (context) => Infaq(),
        '/azan': (context) => Azan(),
        '/kalendar': (context) => Kalendar(),
        '/aduan': (context) =>
            RoleBasedRoute(userPage: AduanPage(), adminPage: AduanPageAdmin()),
        '/forum': (context) => Forum(),
        '/create_forum': (context) => const CreateForum(),
      },
      home: SplashScreen(),
    );
  }
}