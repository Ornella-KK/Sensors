import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigation/Auths/login.dart';
import 'package:navigation/Auths/signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage('assets/images/calculator-app.jpg'),
              height: height * 0.6,
            ),
            Text(
              "Calculator",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "Making Your Calculations Easy",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const Login()),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors
                                .white // Use white color for border in dark mode
                            : Colors
                                .black, // Use black color for border in light mode
                      ),
                    ),
                    child: Text("LOGIN"),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const SignUp()),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Theme.of(context).brightness ==
                              Brightness.dark
                          ? Colors
                              .black // Use black color for background in dark mode
                          : Colors.white,
                      shape: RoundedRectangleBorder(),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      backgroundColor: Theme.of(context).brightness ==
                              Brightness.dark
                          ? Colors
                              .white // Use white color for background in dark mode
                          : Colors
                              .black, // Use black color for background in light mode
                    ),
                    child: Text("SIGNUP"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
