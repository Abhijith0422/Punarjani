import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'motivationvideo.dart';

class Carousel extends StatelessWidget {
  const Carousel(
      {super.key,
      required this.imageUrl,
      required this.videoUrl,
      required this.title});

  final String imageUrl;
  final String videoUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MotivationVideo(
                    videoUrl: videoUrl,
                    title: title,
                  )));
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final carouselIndex = 0.obs;

  void updatePageIndicator(index) {
    carouselIndex.value = index;
  }
}

class CarouselSlidebar extends StatelessWidget {
  const CarouselSlidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('video-links').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            }
            final docs = snapshot.data!.docs;
            return CarouselSlider(
              items: List.generate(docs.length, (index) {
                final data = docs[index].data() as Map<String, dynamic>;
                return Carousel(
                  imageUrl: data['thumbnail'],
                  videoUrl: data['url'],
                  title: data['title'],
                );
              }),
              options: CarouselOptions(
                height: 300,
                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, _) {
                  return controller.updatePageIndicator(index);
                },
              ),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Discover the world',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins')),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 5; i++)
                    Circlecontainer(
                        background: controller.carouselIndex.value == i
                            ? const Color(0xFF2487CE)
                            : Colors.white)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Circlecontainer extends StatelessWidget {
  const Circlecontainer({
    super.key,
    required this.background,
  });
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
        ),
      ),
    );
  }
}
