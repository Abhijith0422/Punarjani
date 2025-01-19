import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return gUser;
    } catch (e) {
      log("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<bool> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      log('$e');
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Credentials')),
        );
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      log("Error during email sign-in: $e");
    }
    return false;
  }

  Future<bool> registerWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user != null;
    } catch (e) {
      log("Error during email registration: $e");
      return false;
    }
  }
}

Future<bool> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
    }
    return true;
  } on FirebaseAuthException catch (e) {
    log('Error while signing out: ${e.message}');
  } on PlatformException catch (e) {
    log('PlatformException while signing out: ${e.message}');
  } catch (e) {
    log("Error while signing out: $e");
  }
  return false;
}
