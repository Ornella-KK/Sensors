import 'dart:async';

import 'package:flutter/material.dart';

import 'Auths/Login/login.dart';

class SessionManager {
  static const int sessionTimeout = 30; 
  static Timer? _timer;
  static bool _isLoggedIn = false;

  static void startSessionTimer(BuildContext context) {
    if (_isLoggedIn) {
      _timer = Timer(Duration(minutes: sessionTimeout), () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Session Expired'),
              content: Text('Your session has expired. Please log in again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  static void resetSessionTimer(BuildContext context) {
    if (_isLoggedIn) {
      _timer?.cancel();
      startSessionTimer(context);
    }
  }

  static void endSession() {
    _timer?.cancel();
    _isLoggedIn = false;
  }

  static void loginUser(BuildContext context, bool isAdmin) {
    if (!isAdmin) {
      _isLoggedIn = true;
      startSessionTimer(context);
    }
  }

  static void logoutUser() {
    _isLoggedIn = false;
    endSession();
  }
}
