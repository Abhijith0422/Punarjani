import 'package:flutter/material.dart';
import '../signup/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/punarjani.png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
                bottom: 100,
                left: MediaQuery.of(context).size.width / 2 - 20,
                child: const Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
