// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutators

import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:mtsp/services/role_based_route.dart';
import 'package:mtsp/splash_screen.dart';
import 'package:mtsp/view/aduan/aduan_page.dart';
import 'package:mtsp/view/azan/azan_widget.dart';
import 'package:mtsp/view/azan/notification_controller.dart';
import 'package:mtsp/view/berita/berita.dart';
import 'package:mtsp/view/berita/berita_user.dart';
import 'package:mtsp/view/dashboard_page.dart';
import 'package:mtsp/view/ekhairat/ekhairat.dart';
import 'package:mtsp/view/ekhairat/senarai_ahli.dart';
import 'package:mtsp/view/forum/create_forum.dart';
import 'package:mtsp/view/forum/forum_page.dart';
import 'package:mtsp/view/infaq/infaq.dart';
import 'package:mtsp/view/kalendar/kalendar_layout.dart';
import 'package:mtsp/auth/authentication_page.dart';
import 'package:provider/provider.dart';
import 'view/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await dotenv.load(fileName: "assets/.env");
  Stripe.publishableKey = "pk_test_51OJWJGK4kvnq6xon7sAiBo0H0QmchNFML4vQjoSp1kZvlNDKWhPSEn2RUvniiOcOdfxtg0rSbZGD7MrwgEbRbVii00gSgX0cZG"; //TODO try check balik
  //Stripe.publishableKey = dotenv.env['PUBLISH_KEY']!;
  
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'grouped',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'grouped',
        channelGroupName: 'Grouped notifications',
      )
    ],
  );
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(MyApp());


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ForumsService()),
      ],
      child: MyApp()
    )
  );

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
          NotificationController.onDismissActionReceivedMethod,
    );
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
        '/home' : (context) => HomePage(),
        '/ekhairat' : (context) => RoleBasedRoute(userPage: Ekhairat(), adminPage: SenaraiAhli()),
        '/berita' : (context) => RoleBasedRoute(userPage: BeritaUser(), adminPage: Berita()),
        '/infaq' : (context) => Infaq(),
        '/azan' : (context) => Azan(),
        '/kalendar' : (context) => Kalendar(),
        '/aduan' : (context) => AduanPage(),
        '/forum': (context) => Forum(),
        '/create_forum': (context) => const CreateForum(),

      },
      home: SplashScreen(),
    );
  }
}
