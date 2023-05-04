import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'createprofile.dart';
import 'main.dart';
import 'dart:convert';
import 'api.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // TODO: Add auto login logic

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    Api api = Api();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;

        // Check if the user ID already exists in the database
        if (user != null) {
          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('uid');
          final response = await http
              .post(Uri.parse('${api.getApiHost()}/user/exists/$userId'));
          final data = jsonDecode(response.body);
          //final userExists = data['userExists'];

          if (response.statusCode == 200 && data['message'] == 'User found') {
            // User exists, redirect to main page
            await prefs.setString('uid', user.uid);
            await prefs.setString('email', user.email!);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBottomNavigationbar()));
          } else {
            // User does not exist, redirect to CreateProfile page
            await prefs.setString('uid', user.uid);
            await prefs.setString('email', user.email!);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CreateProfile()));
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          rethrow;
        } else if (e.code == 'invalid-credential') {
          rethrow;
        }
      } catch (e) {
        rethrow;
      }
    }

    return user;
  }

  /*static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          rethrow;
        } else if (e.code == 'invalid-credential') {
          rethrow;
        }
      } catch (e) {
        rethrow;
      }
    }

    return user;
  }*/

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
