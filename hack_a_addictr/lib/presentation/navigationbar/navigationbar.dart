// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:punarjani/presentation/homepage/hompage.dart';
import 'package:punarjani/presentation/report/report.dart';
import 'package:punarjani/presentation/support/supporthome.dart';
import 'package:punarjani/presentation/to%20know/toknow.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import '../../theme/theme.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, this.id});
  final dynamic id;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor:
              themeprovider.themeData.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
          systemNavigationBarIconBrightness:
              themeprovider.themeData.brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
        child: Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              Homepage(id: widget.id),
              const SupportHome(),
              Report(id: widget.id),
              const Toknow(),
            ],
          ),
          bottomNavigationBar: WaterDropNavBar(
            iconSize: 24,
            backgroundColor: themeprovider.themeData.primaryColor,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
              pageController.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad);
            },
            selectedIndex: selectedIndex,
            barItems: [
              BarItem(
                filledIcon: Icons.home,
                outlinedIcon: Icons.home_outlined,
                label: 'Home',
              ),
              BarItem(
                  filledIcon: Icons.group,
                  outlinedIcon: Icons.group_outlined,
                  label: 'Support'),
              BarItem(
                filledIcon: Icons.bookmark,
                outlinedIcon: Icons.bookmark_border,
                label: 'Report',
              ),
              BarItem(
                filledIcon: CupertinoIcons.book_fill,
                outlinedIcon: CupertinoIcons.book,
                label: 'To Know',
              ),
            ],
          ),
        ),
      );
    });
  }
}
