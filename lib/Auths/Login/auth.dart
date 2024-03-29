import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Drawers/AdminHmPg.dart';
import '../../Drawers/HomePage.dart';
import '../../session.dart';
import 'login.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                /* if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } */
                if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                }
                final userData =
                    userSnapshot.data?.data() as Map<String, dynamic>?;

                if (userData != null && userData['isAdmin'] == true) {
                  return AdminHomePage();
                } else {
                  bool isAdmin = false;
                  SessionManager.loginUser(context, isAdmin);
                  return HomePage();
                }
              },
            );
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
