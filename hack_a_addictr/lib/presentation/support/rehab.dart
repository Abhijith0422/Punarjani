import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RehabCenters extends StatelessWidget {
  const RehabCenters({super.key});

  // Function to retrieve data from rehab-centers collection
  Future<List<Map<String, dynamic>>> getRehabCenters() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('rehab-centers').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Color(0xFFFF4500)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'))),
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning, User',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '“Let’s win this battle”',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFFEAE0C8),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: getRehabCenters(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading centers'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No centers available'));
                      }

                      final centers = snapshot.data!;
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 50,
                              width: 300,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFA9D0D4),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: const Center(
                                child: Text(
                                  'Rehab Centers',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 21,
                                      decoration: TextDecoration.none,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: centers.length,
                              itemBuilder: (context, index) {
                                final center = centers[index];
                                final name = center['name'] ?? 'No Name';
                                final subText = center['place'] ?? 'No SubText';

                                String phoneNumber =
                                    center['phone'] ?? '1234567890';
                                if (phoneNumber.length == 10) {
                                  phoneNumber = '+91$phoneNumber';
                                }
                                final mapUrl = center['locatioLink'] ??
                                    'https://www.google.com/maps/search/?api=1&query=rehab+center';

                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Poppins',
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              subText,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                decoration: TextDecoration.none,
                                                fontFamily: 'Poppins',
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                final Uri phoneUri = Uri(
                                                  scheme: 'tel',
                                                  path: phoneNumber,
                                                );
                                                if (await canLaunchUrl(
                                                    phoneUri)) {
                                                  await launchUrl(phoneUri);
                                                } else {
                                                  throw 'Could not launch $phoneNumber';
                                                }
                                              },
                                              child: const Icon(
                                                Icons.call,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                final Uri mapUri =
                                                    Uri.parse(mapUrl);
                                                if (await canLaunchUrl(
                                                    mapUri)) {
                                                  await launchUrl(mapUri);
                                                } else {
                                                  throw 'Could not launch $mapUrl';
                                                }
                                              },
                                              child: const Icon(
                                                Icons.directions,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
