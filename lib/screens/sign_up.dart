// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:super_auth/constants.dart';

import '../services/auth_service.dart';
import '../widgets/text_field.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            hint: "Please type your email",
            label: "Email",
            controller: emailController,
            icon: Icon(Icons.email),
          ),
          SizedBox(
            height: 50,
          ),
          CustomTextField(
            hint: "Please type your password",
            label: "Password",
            controller: passwordController,
            isPassword: true,
            icon: Icon(Icons.lock)
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              fixedSize: Size(150, 75),
            ),
            onPressed: () async {
              String email = emailController.text;
              String password = passwordController.text;
              String result = await auth.signUp(email, password);
              if (result == "0") {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(signInMethod: "firebase"),
                  ),
                  (route) => false,
                );
              }
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
