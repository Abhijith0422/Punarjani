// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'signup.dart';

class ResetPass extends StatefulWidget {
  ResetPass({super.key});

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool _isButtonDisabled = false;
  int _remainingTime = 0;

  resetPass(BuildContext context) async {
    if (_formKey.currentState!.validate() && !_isButtonDisabled) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password reset link sent to your email'),
        ));
        setState(() {
          _isButtonDisabled = true;
          _remainingTime = 60;
        });
        Future.delayed(const Duration(minutes: 1), () {
          setState(() {
            _isButtonDisabled = false;
            _remainingTime = 0;
          });
        });
        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_remainingTime == 0) {
            timer.cancel();
          } else {
            setState(() {
              _remainingTime--;
            });
          }
        });
        if (_isButtonDisabled) {
          Future.delayed(const Duration(seconds: 90), () {
            Navigator.pop(context);
          });
        } else {
          Future.delayed(const Duration(seconds: 20), () {
            Navigator.pop(context);
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No User found for this email'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send reset email: ${e.message}'),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Reset Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Enter your email address ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      resetPass(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Reset Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            if (_isButtonDisabled)
              Text(
                'Please wait $_remainingTime seconds before trying again',
                style: const TextStyle(color: Colors.white),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const SignupPage();
                    }));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ])),
      backgroundColor: Colors.black,
    );
  }
}
