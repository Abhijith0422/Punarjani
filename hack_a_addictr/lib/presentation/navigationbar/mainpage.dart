import 'package:flutter/material.dart';

import 'navigationbar.dart';

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
