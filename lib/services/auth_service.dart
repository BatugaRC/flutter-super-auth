// ignore_for_file: body_might_complete_normally_nullable

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';
import 'package:super_auth/api.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  EmailOTP otpAuth = EmailOTP();
  final LocalAuthentication localAuth = LocalAuthentication();
  final twitterAuth = TwitterLogin(
    apiKey: twitterApi,
    apiSecretKey: twitterApiSecret,
    redirectURI: twitterURL,
  );
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: githubClientId,
        clientSecret: githubClientSecret,
        redirectUrl: githubURL,
        );

  Future<String> signInAnon() async {
    try {
      await auth.signInAnonymously();
      return "0";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "0";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "0";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "0";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendOtp(String email) async {
    otpAuth.setConfig(
      appEmail: "batu.oztanmet.643@gmail.com",
      appName: "Super Auth",
      userEmail: email,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );
    await otpAuth.sendOTP();
  }

  Future<bool> verifyOtp(String otp) async {
    return await otpAuth.verifyOTP(otp: otp);
  }

  Future<String> signInWithFaceId() async {
    final bool canAuthenticateWithBiometrics =
        await localAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        try {
          await localAuth.authenticate(
              localizedReason: "Please authenticate",
              options: const AuthenticationOptions(biometricOnly: true),
              authMessages: const <AuthMessages>[
                AndroidAuthMessages(biometricHint: "Face ID"),
                IOSAuthMessages(cancelButton: "Cancel")
              ]);
          return "0";
        } catch (e) {
          return e.toString();
        }
      } else {
        return "Your device does not support face id.";
      }
    } else {
      return "Your device does not support local authentication";
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await auth.signInWithCredential(credential);
      return "0";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithTwitter() async {
    try {
      AuthResult authResult = await twitterAuth.login();
      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!,
          );
          await auth.signInWithCredential(credential);
          return "0";
        case TwitterLoginStatus.cancelledByUser:
          return "cancel";
        case TwitterLoginStatus.error:
          return "error";
        default:
      }

      return "0";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    catch (e) {
      return e.toString();
    }
  }

  Future<String> signInWithGithub(final context) async {
    
    var result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:

        AuthCredential credential = GithubAuthProvider.credential(result.token!);
        await auth.signInWithCredential(credential);
        return "0";

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        return result.errorMessage;
    }
  }
}
