import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navigation/Auths/Login/auth.dart';
import 'package:navigation/Drawers/HomePage.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void userSignUp(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Navigate to the main page after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AuthPage()), // Replace HomePage() with your main page widget
        );
      } else {
        // Show error message for password mismatch
        Navigator.pop(context); // Pop the loading circle
        showErrorMessage("Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.pop(context);
      // Show error message for Firebase auth exception
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  //for password visibility
  void togglePasswordVisibility(String passwordType) {
    setState(() {
      if (passwordType == 'password') {
        _isPasswordVisible = !_isPasswordVisible;
      } else if (passwordType == 'confirmPassword') {
        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: "Email",
                hintText: "Enter Your Email",
                border: OutlineInputBorder(),
              ),
              controller: emailController,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint_outlined),
                labelText: "Password",
                hintText: "Enter Your Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => togglePasswordVisibility('password'),
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              obscureText: !_isPasswordVisible,
              controller: passwordController,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint_outlined),
                labelText: "Confirm Password",
                hintText: "Confirm Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => togglePasswordVisibility('confirmPassword'),
                  icon: Icon(_isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              obscureText: !_isConfirmPasswordVisible,
              controller: confirmPasswordController,
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  userSignUp(context);
                },
                child: Text("SIGN UP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
