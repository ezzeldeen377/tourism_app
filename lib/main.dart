// ignore_for_file: unused_import, avoid_print
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:new_flutter/core/notifications/fcm.dart';
import 'package:new_flutter/core/utils/location_permission_handler.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/splash/presentation/splash_view.dart';
import 'package:new_flutter/start_app/start_page.dart';
import 'package:new_flutter/features/splash/presentation/widgets/splash_body.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocationPermissionHandler.checkAndRequestPermission();
  await LocationPermissionHandler.handleLocationPermission();
  Gemini.init(apiKey: "AIzaSyCk6lnyB8-7Nw1QSODDaSKMVpe5_uEiVcI");


  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("860b853c-cb34-4685-b6b7-9dccd85c5fd7");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    event.preventDefault(); // Prevent OneSignal's default handling
    OneSignal.Notifications.displayNotification(event.notification.notificationId); // Manually show notification
  });
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.grey[50],
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: kMainColor),
      home: const splashview(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              //if user isn't signed in
              return const Login();
            }
            //if user is signed in
            return const StartApp();
          }),
    );
  }
}
