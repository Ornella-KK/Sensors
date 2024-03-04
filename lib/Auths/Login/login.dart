import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Drawers/HomePage.dart';
import '../SignUp/signup.dart';
import 'googleIn.dart';
import 'loginFom.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
                "Welcome Back!!",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              /* Text(
                "Your Maths companion.",
                style: Theme.of(context).textTheme.bodyLarge,
              ), */
              //Login Form Begins
              LoginForm(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("OR"),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image(
                        image: AssetImage('assets/images/Logo-google-icon.png'),
                        width: 20.0,
                      ),
                      onPressed: () {
                        LoginAPI().signInWithGoogle(context);
                      },
                      label: Text("Sign In With Google"),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => SignUp()),
                    child: Text.rich(TextSpan(
                      text: "Don't Have An Account?",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: "SignUp",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    )),
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
