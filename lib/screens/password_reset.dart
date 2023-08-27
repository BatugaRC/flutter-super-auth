// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:super_auth/services/auth_service.dart';
import 'package:super_auth/widgets/text_field.dart';

import '../constants.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  late final TextEditingController email;

  @override
  void initState() {
    email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Your Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hint: "Type your email",
              label: "Email",
              controller: email,
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                fixedSize: Size(150, 75),
              ),
              onPressed: () {
                String _email = email.text;
                auth.sendResetPasswordEmail(_email);
              },
              child: Text(
                "Send Email",
                style: TextStyle(fontSize: 20, color: textColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
