// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:punarjani/presentation/homepage/profile/profileinfo.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../theme/theme.dart';
import '../signup/auth.dart';
import '../signup/authservices.dart';
import 'carousel.dart';
import 'storypage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key, this.id});
  final dynamic id;

  // Function to retrieve data from recovery-stories collection
  Future<List<Map<String, dynamic>>> getRecoveryStories() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('recovery-stories').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> menuVisible = ValueNotifier(false);
    ValueNotifier<bool> visible = ValueNotifier(true);

    return SafeArea(
      child: Scaffold(
        body: Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: getRecoveryStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading stories'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No stories available'));
              }

              final stories = snapshot.data!;
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    _homebackground(context, themeprovider, menuVisible),
                    ValueListenableBuilder<bool>(
                      valueListenable: menuVisible,
                      builder: (context, isVisible, child) {
                        return isVisible
                            ? menu(visible: visible, id: id)
                            : const SizedBox();
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.45,
                        decoration: const BoxDecoration(
                            color: Color(0xFFEAE0C8),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                final story = stories[index];
                                final title = story['title'] ?? 'No Title';
                                final description = story['content'] ?? '';
                                final preview = description.length > 30
                                    ? '${description.substring(0, 30)}...'
                                    : description;

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => StoryPage(
                                                      title: title,
                                                      content: description,
                                                    )));
                                      },
                                      child: Container(
                                        height: 80,
                                        width: 360,
                                        decoration: BoxDecoration(
                                            color: themeprovider
                                                .themeData.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: TextStyle(
                                                        color: themeprovider
                                                                .themeData
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color ??
                                                            Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                  Text(
                                                    preview,
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/dummy_square.png'),
                                                      fit: BoxFit.cover)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: stories.length),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Update homemenubar to show different icons based on menu visibility
  Padding homemenubar(BuildContext context, ValueNotifier<bool> menuVisible) {
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
          const Text('Good Day,User',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins')),
          const Spacer(),
          GestureDetector(
            onTap: () {
              menuVisible.value = !menuVisible.value;
            },
            child: ValueListenableBuilder<bool>(
              valueListenable: menuVisible,
              builder: (context, isVisible, _) {
                return Icon(
                  isVisible ? Icons.close : Icons.menu_outlined,
                  color: Colors.black,
                  size: 30,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Update _homebackground to accept menuVisible parameter
  Stack _homebackground(BuildContext context, ThemeProvider themeprovider,
      ValueNotifier<bool> menuVisible) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFFFF4500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homemenubar(context, menuVisible),
              const SizedBox(
                height: 2,
              ),
              const CarouselSlidebar(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
                color: Color(0xFFEAE0C8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const StoryPage(
                                      title: 'Recovery Stories',
                                      content: 'Read more...',
                                    )));
                          },
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Recovery Stories',
                                        style: TextStyle(
                                            color: themeprovider
                                                    .themeData
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color ??
                                                Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      ),
                                      const Text(
                                        'Read more...',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ],
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
                                          image: AssetImage(
                                              'assets/dummy_square.png'),
                                          fit: BoxFit.cover)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 5),
            ),
          ),
        ),
      ],
    );
  }
}

class menu extends StatelessWidget {
  const menu({
    super.key,
    required this.visible,
    this.id,
  });
  final dynamic id;
  final ValueNotifier<bool> visible;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 45,
      right: 10,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 200,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: const BoxDecoration(
              color: Color(0xFFEAE0C8),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PersonalInfoPage(
                              id: id,
                            )));
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder(
                    valueListenable: visible,
                    builder: (context, isVisible, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: isVisible,
                            child: const Text('Light \nMode',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold)),
                          ),
                          SwitcherButton(
                              onColor: Colors.black,
                              offColor: Colors.white,
                              onChange: (value) {
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .toggleTheme();
                                visible.value = !isVisible;
                              }),
                          Visibility(
                            visible: !isVisible,
                            child: const Text('Dark \nMode',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      );
                    }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const AuthPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
