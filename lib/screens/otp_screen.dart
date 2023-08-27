// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:super_auth/screens/home.dart';
import 'package:super_auth/services/auth_service.dart';
import 'package:super_auth/widgets/text_field.dart';

import '../constants.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final TextEditingController emailController;
  late final TextEditingController otpController;

  @override
  void initState() {
    emailController = TextEditingController();
    otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    late final String _email;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in with one time password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hint: "Enter your email",
              label: "Email",
              controller: emailController,
              icon: Icon(Icons.email),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    String email = emailController.text;
                    _email = email;
                    await auth.sendOtp(email);
                  },
                  child: Text("Send OTP", style: TextStyle(color: appBarColor),),
                ),
              ],
            ),
            CustomTextField(
              hint: "Enter OTP",
              label: "OTP",
              controller: otpController,
              icon: Icon(Icons.password_outlined),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                String otp = otpController.text;
                bool isOtpTrue = await auth.verifyOtp(otp);
                if (isOtpTrue) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(email: _email, signInMethod: "otp",),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                fixedSize: Size(150, 75),
              ),
              child: Text(
                "Verify Otp",
                style: TextStyle(
                  fontSize: 22,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
