import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigation/Network/dependency_injection.dart';
import 'package:navigation/theme.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auths/Login/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Menus/Quiz/providers/quiz_provider.dart';
import 'firebase_options.dart';
import 'notifications/notification.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  DependencyInjection.init();

  PushNotifications.init();
  PushNotifications.localNotiInit();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            isDarkMode: prefs.getBool("isDarkTheme"),
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GetMaterialApp(
            theme: themeProvider.getTheme,
            debugShowCheckedModeBanner: false,
            home: AuthPage(),
          );
        },
      ),
    ),
  );

  // for handling in terminated state
  final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!
          .pushNamed("/message", arguments: initialMessage);
    });
  }
}
    // Test notification
    /* await PushNotifications.showSimpleNotification(
    title: 'Test Notification',
    body: 'This is a test notification.',
    payload: 'test_payload',
  ); */