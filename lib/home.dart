import 'package:flutter/material.dart';
import 'package:navigation/Auths/googleIn.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  final String name;
  final String email;
  const WelcomePage({Key? key, required this.name, required this.email}) : super(key: key);

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
              'Welcome Back, $name!',
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
