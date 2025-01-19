import 'dart:async';

import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

import '../../core/services.dart';
import '../../core/sharedpref.dart';
import '../navigationbar/navigationbar.dart';
import 'authservices.dart';
import 'resetpass.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Timer? _timer;
  Future<void> _signInWithEmailPassword() async {
    if (_formKey.currentState!.validate()) {
      bool success = await AuthServices().signInWithEmailPassword(
          _emailController.text, _passwordController.text, context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        _navigateToMainPage(0);
        _startAutoRefresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    dynamic id = randomAlphaNumeric(15);
    final googleuser = await AuthServices().signInWithGoogle();
    if (googleuser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In successful')),
      );

      _navigateToMainPage(id);
      _startAutoRefresh();

      if (await SharedPreferenceHelper().getUserEmail() == googleuser.email) {
        id = await SharedPreferenceHelper().getUserId();
      } else {
        await SharedPreferenceHelper().saveUserEmail(googleuser.email);
        await SharedPreferenceHelper().saveUserId(id);
        Map<String, dynamic> adduserInfo = {
          'email': googleuser.email,
          'id': id,
        };
        await DatabaseModel().addUserDetail(
          id,
          adduserInfo,
        );
      }
    }
  }

  void _navigateToMainPage(dynamic id) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => BottomNavBar(
                id: id,
              )),
    );
  }

  void _startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xffff5c30),
                  Color(0xffe74b1a),
                ])),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            height: MediaQuery.of(context).size.height - 100,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 35),
                    // Email field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        style: const TextStyle(
                            color: Colors.black), // Change text color here
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
                    const SizedBox(height: 16.0),
                    // Password field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        style: const TextStyle(
                            color: Colors.black), // Change text color here
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ResetPass()));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    // Login button
                    GestureDetector(
                      onTap: () {
                        _signInWithEmailPassword();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 10.0,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 100),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A75F0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 8),
                            child: const Divider(),
                          ),
                        ),
                        const Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 8, right: 20),
                            child: const Divider(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        _signInWithGoogle();
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'assets/glogo.png',
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const SignupPage();
                            }));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    )));
  }
}
