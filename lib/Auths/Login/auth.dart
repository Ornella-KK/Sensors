import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Drawers/HomePage.dart';
import 'login.dart';

class AuthPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
              /* name: snapshot.data?.displayName ?? '', // Pass name if available, otherwise use an empty string
              email: snapshot.data?.email ?? '', */ // Pass email if available, otherwise use an empty string
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
