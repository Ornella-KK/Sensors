import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome Back, ${user.displayName ?? ''}',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            /* Image.asset(
              'assets/images/calculator.jpeg',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ), */
            SizedBox(height: 20),
            /* Text(
              'Enter a world of convenience with our intuitive tools and easy customization options.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
