import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:super_auth/constants.dart';
import 'package:super_auth/firebase_options.dart';
import 'package:super_auth/screens/welcome.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Auth',
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: textColor,
        ),
      ),
      home: const Welcome(
      ),
    );
  }
}
