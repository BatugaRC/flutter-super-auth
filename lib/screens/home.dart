// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_auth/constants.dart';
import 'package:super_auth/screens/welcome.dart';
import 'package:super_auth/services/auth_service.dart';

class Home extends StatefulWidget {
  final String? email;
  final String signInMethod;

  const Home({
    Key? key,
    this.email,
    required this.signInMethod,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService auth = AuthService();

  Widget _buildContent() {
    if (FirebaseAuth.instance.currentUser == null && widget.signInMethod == "firebase") {
      return const CircularProgressIndicator();
    } else if (widget.signInMethod == "firebase" && FirebaseAuth.instance.currentUser != null) {
      final String? email = FirebaseAuth.instance.currentUser!.email;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "You are signed in as",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            email!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      );
    } else if (widget.signInMethod == "anon") {
      return const Text(
        "You are signed in anonymously",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      );
    } else if (widget.signInMethod == "otp") {
      return const Text(
        "You have signed in with OTP",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      );
    } else if (widget.signInMethod == "faceID") {
      return const Text(
        "You have signed in with face ID",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      );
    } else {
      return const Text(
        "Unknown sign in method",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      );
    }
  }

  Future<void> _handleSignOut() async {
    String result = await auth.signOut();
    if (result == "0") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Welcome(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Builder(builder: (context) => _buildContent()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleSignOut,
        backgroundColor: buttonColor,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
