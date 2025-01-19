// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

import '../../core/services.dart';
import '../../core/sharedpref.dart';
import '../navigationbar/navigationbar.dart';
import 'authservices.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_addCountryCode);
  }

  void _addCountryCode() {
    if (!_mobileController.text.startsWith('+91')) {
      _mobileController.text = '+91${_mobileController.text}';
      _mobileController.selection = TextSelection.fromPosition(
        TextPosition(offset: _mobileController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _mobileController.removeListener(_addCountryCode);
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _registerWithEmailPassword() async {
    dynamic id = randomAlphaNumeric(15);
    if (_formKey.currentState?.validate() ?? false) {
      try {
        bool success = await AuthServices().registerWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );
          if (await SharedPreferenceHelper().getUserEmail() ==
              _emailController.text) {
            id = await SharedPreferenceHelper().getUserId();
          } else {
            await SharedPreferenceHelper().saveUserEmail(_emailController.text);
            await SharedPreferenceHelper().saveUserId(id);
            Map<String, dynamic> adduserInfo = {
              'email': _emailController.text,
              'id': id,
              'name': _nameController.text,
              'mobile': _mobileController.text,
            };
            await DatabaseModel().addUserDetail(
              id,
              adduserInfo,
            );
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(
                id: id,
              ),
            ),
          );
          log(id); // Navigate back to the main page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed')),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already in use')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed')),
          );
        }
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavBar(
                    id: id,
                  )));
      // Navigate back to the login page

      // If the ID does not exist, create a new one and store it

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In canceled')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: Stack(children: [
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "SignUp",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 35),
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        style: const TextStyle(color: Colors.blue),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Mobile number field
                      TextFormField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                        ),
                        style: const TextStyle(color: Colors.blue),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          } else if (!RegExp(r'^\+91\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        style: const TextStyle(
                            color: Colors.blue), // Change text color here
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
                      const SizedBox(height: 16.0),
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        style: const TextStyle(
                            color: Colors.blue), // Change text color here
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          final regex = RegExp(
                              r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                          if (!regex.hasMatch(value)) {
                            return 'Password must be at least 8 characters long, include an uppercase letter, a number, and a special symbol';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _confirmpasswordController,
                        decoration: const InputDecoration(
                          labelText: ' Confirm Password',
                        ),
                        style: const TextStyle(
                            color: Colors.blue), // Change text color here
                        obscureText: true,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please re-enter password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30.0),
                      // Register button
                      GestureDetector(
                        onTap: () {
                          if (_passwordController.text ==
                              _confirmpasswordController.text) {
                            _registerWithEmailPassword();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Passwords do not match')),
                            );
                          }
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
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Google login button
                      GestureDetector(
                        onTap: _signInWithGoogle,
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const LoginPage();
                            })),
                            child: const Text(
                              "Login",
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
            ),
          ),
        ]),
      ),
      backgroundColor: const Color.fromARGB(255, 23, 31, 43),
    );
  }
}
