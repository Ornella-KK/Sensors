import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navigation/Auths/SignUp/SignUpForm.dart';
import 'package:navigation/Auths/Login/googleIn.dart';
import 'package:navigation/Auths/Login/login.dart';
import '../../Drawers/HomePage.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
/*     final size = MediaQuery.of(context).size;
 */
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign Up",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 20.0),
              // Signup Form Begins
              const SignupForm(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () => Get.to(() => const Login()),
                    child: Text.rich(TextSpan(
                      text: "Have an Account?",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: "LogIn",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image(
                        image: AssetImage(
                          'assets/images/Logo-google-icon.png',
                        ),
                        width: 20.0,
                      ),
                      onPressed: () {
                        LoginAPI().signInWithGoogle(context);
                      },
                      label: Text("Continue With Google"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
