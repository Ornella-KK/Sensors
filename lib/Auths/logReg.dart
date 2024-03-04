import 'package:flutter/material.dart';
import 'package:navigation/Auths/Login/login.dart';
import 'package:navigation/Auths/SignUp/signup.dart';

class LogOrReg extends StatefulWidget {
  const LogOrReg({super.key});

  @override
  State<LogOrReg> createState() => _LogOrRegState();
}

class _LogOrRegState extends State<LogOrReg> {
  bool showLogInPage = true;

  void togglePages() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return Login();
    } else {
      return SignUp();
    }
  }
}
