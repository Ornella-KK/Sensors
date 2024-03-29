import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('quiz_channel', 'QuizChannel',
            channelDescription: 'Quiz Notification',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    print("Device token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      final Map<String, dynamic> data = message.data ?? Map<String, dynamic>();
      final String title = data['title'] ?? '';
      final String body = data['body'] ?? '';

      showSimpleNotification(
        title: title,
        body: body,
        payload: jsonEncode(data),
      );
    });

    // Listen to changes in the "Quizzes" collection
    FirebaseFirestore.instance
        .collection("Quizzes")
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.added) {
          // Trigger a notification for the added document only if the user is not an admin
          final quizData = change.doc.data() as Map<String, dynamic>;

          FirebaseAuth.instance.authStateChanges().listen((user) {
            if (user != null) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get()
                  .then((userSnapshot) {
                if (userSnapshot.exists) {
                  final userData = userSnapshot.data() as Map<String, dynamic>;
                  final isAdmin = userData['isAdmin'] ?? false;

                  if (!isAdmin) {
                    PushNotifications.showSimpleNotification(
                      title: 'New Quiz',
                      body: '${quizData['title']}\n"New Quiz Added!!"',
                      payload: jsonEncode(quizData),
                    );
                  }
                } else {
                  print('User document does not exist');
                  PushNotifications.showSimpleNotification(
                    title: 'New Quiz',
                    body: '${quizData['title']}\n"New Quiz Added!!"',
                    payload: jsonEncode(quizData),
                  );
                }
              }).catchError((error) {
                print('Error fetching user document: $error');
              });
            }
          });
        }
      }
    });
  }

  static Future<void> localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/message", arguments: notificationResponse);
  }
}
