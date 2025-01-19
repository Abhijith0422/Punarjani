import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../navigationbar/navigationbar.dart';
import 'login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const BottomNavBar();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
