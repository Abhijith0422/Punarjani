// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:punarjani/presentation/support/community/community.dart';
import 'package:punarjani/presentation/support/gamespage.dart';

import 'package:punarjani/presentation/support/rehab.dart';
import 'package:punarjani/presentation/support/todo.dart';
import 'package:punarjani/presentation/support/chatbot/chat.dart';
import 'package:punarjani/presentation/support/helpline.dart'; // Add this import

import '../../theme/theme.dart';
import 'activities.dart';
import 'community/volunteertask.dart';

class SupportHome extends StatelessWidget {
  const SupportHome({super.key});

  // Add navigation functions
  void _navigateToRehab(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RehabCenters()),
    );
  }

  void _navigateToTodoList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TodoList()),
    );
  }

  void _navigateToActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ActivitiesPage()),
    );
  }

  void _navigateToVolunteerTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VolunteerTaskPage()),
    );
  }

  // Add navigation function for helpline
  void _navigateToHelpline(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelplinePage()),
    );
  }

  void _navigateToGroup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CommunityPage()),
    );
  }

  void _navigateToGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
        return SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: _supportbackground(context, themeprovider),
              ),
              Positioned(
                bottom: 70,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ChatPage()));
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: themeprovider.themeData.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.chat_bubble_fill,
                        color: Color(0xFF5A75F0),
                        size: 35,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Stack _supportbackground(BuildContext context, ThemeProvider themeprovider) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFFF4500),
        child: Column(
          children: [
            supprtmenubar(context),
            const SizedBox(
              height: 30,
            ),
            _buildIconRow(context)
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
              color: Color(0xFFEAE0C8),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Column(
                  children: [
                    _itemcontainer(
                      themeprovider,
                      'Rehab Centres',
                      onTap: () => _navigateToRehab(context),
                    ),
                    _itemcontainer(
                      themeprovider,
                      'To do List',
                      onTap: () => _navigateToTodoList(context),
                    ),
                    _itemcontainer(
                      themeprovider,
                      'Activities',
                      onTap: () => _navigateToActivities(context),
                    ),
                    _itemcontainer(
                      themeprovider,
                      'Volunteer Task',
                      onTap: () => _navigateToVolunteerTask(context),
                    ),
                  ],
                )),
          ),
        ),
      )
    ]);
  }

  Padding _itemcontainer(ThemeProvider themeprovider, String title,
      {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            width: 360,
            decoration: BoxDecoration(
                color: themeprovider.themeData.primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: themeprovider
                                .themeData.textTheme.bodyLarge?.color ??
                            Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      image: DecorationImage(
                          image: AssetImage('assets/dummy_square.png'),
                          fit: BoxFit.cover)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding supprtmenubar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
          const SizedBox(
            width: 30,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Good Morning,User',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              Text("Let's fight together",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildIconRow(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconContainer(ctx, Icons.group, 'Groups',
            onTap: () => _navigateToGroup(ctx)),
        _buildIconContainer(ctx, Icons.help_center, 'Helpline',
            onTap: () => _navigateToHelpline(ctx)),
        _buildIconContainer(ctx, Icons.gamepad_sharp, 'Games',
            onTap: () => _navigateToGame(ctx)),
      ],
    );
  }

  Container _buildIconContainer(BuildContext ctx, IconData icon, String text,
      {VoidCallback? onTap}) {
    return Container(
      width: 115,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFEAE0C8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 35,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
