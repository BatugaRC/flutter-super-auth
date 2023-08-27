// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:super_auth/screens/home.dart';
import 'package:super_auth/screens/password_reset.dart';
import 'package:super_auth/services/auth_service.dart';
import 'package:super_auth/utils/show_error_dialog.dart';
import 'package:super_auth/widgets/square_tile.dart';
import 'package:super_auth/widgets/text_field.dart';

import '../constants.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                    String result = await auth.signInWithGoogle();
                    if (result == "0") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(signInMethod: "firebase",),
                        ),
                        (route) => false,
                      );
                    } else if (result != "'package:firebase_auth_platform_interface/src/providers/google_auth.dart': Failed assertion: line 43 pos 12: 'accessToken != null || idToken != null': At least one of ID token and access token is required") {
                      showErrorDialog(context, result);
                    }
                  },
                  child: SquareTile(
                    image: "assets/google_icon.svg",
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    String? result = await auth.signInWithTwitter();
                    if (result == "0") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(signInMethod: "firebase"),
                        ),
                        (route) => false,
                      );
                    } else if(result != "cancel") {
                      showErrorDialog(context, result!);
                    }
                  },
                  child: SquareTile(
                    image: "assets/twitter_icon.svg",
                  ),
                ),
                Builder(
                  builder: ((context) {
                    return GestureDetector(
                      onTap: () async {
                        String? result = await auth.signInWithGithub(context);
                        if (result == "0") {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(signInMethod: "firebase"),
                            ),
                            (route) => false,
                          );
                        } else {
                          showErrorDialog(context, result);
                        }
                      },
                      child: SquareTile(
                        image: "assets/github_icon.svg",
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await auth.signInAnon();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(signInMethod: "anon"),
                      ),
                      (route) => false,
                    );
                  },
                  icon: Icon(Icons.no_accounts),
                  label: Text("Sign in anonymously"),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(buttonColor)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    String result = await auth.signInWithFaceId();
                    if (result == "0") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(signInMethod: "faceID"),
                        ),
                        (route) => false,
                      );
                    } else {
                      showErrorDialog(context, result);
                    }
                  },
                  icon: Icon(Icons.face),
                  label: Text("Sign in with face id"),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(buttonColor)),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            CustomTextField(
              hint: "Please type your email",
              label: "Email",
              controller: email,
              icon: Icon(Icons.email),
            ),
            SizedBox(
              height: 30,
            ),
            CustomTextField(
              hint: "Please type your password",
              label: "Password",
              controller: password,
              isPassword: true,
              icon: Icon(Icons.lock),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(buttonColor)),
                  child: Text("Forgot Password?"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordReset(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                fixedSize: Size(250, 50),
              ),
              onPressed: () async {
                String _email = email.text;
                String _password = password.text;
                String result =
                    await auth.signInWithEmailAndPassword(_email, _password);
                if (result == "0") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(signInMethod: "firebase"),
                    ),
                    (route) => false,
                  );
                } else {
                  showErrorDialog(context, result);
                }
              },
              child: Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 26,
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
