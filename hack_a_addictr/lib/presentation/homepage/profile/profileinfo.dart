import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Initialize with default values
TextEditingController nameController = TextEditingController(text: 'Not Set');
TextEditingController phoneController = TextEditingController(text: 'Not Set');
TextEditingController emailController = TextEditingController(text: 'Not Set');

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key, this.id});
  final dynamic id;

  // Updated function to merge data
  Future<void> updateUserData(String field, String value) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        log('Current user UID during update: $id');

        // Get reference to the user document
        final userDocRef =
            FirebaseFirestore.instance.collection('user_info').doc(id);

        // Get current data
        final docSnapshot = await userDocRef.get();
        Map<String, dynamic> updatedData;

        if (docSnapshot.exists) {
          // Merge with existing data
          updatedData = Map<String, dynamic>.from(docSnapshot.data() ?? {});
        } else {
          updatedData = {};
        }

        // Add new field value
        String fieldKey = field.toLowerCase().trim();
        if (fieldKey == 'name') {
          fieldKey = 'name';
        } else if (fieldKey == 'phone') {
          fieldKey = 'mobile';
        } else if (fieldKey == 'email') {
          fieldKey = 'email';
        }

        updatedData[fieldKey] = value;

        // Update Firestore with merged data
        await userDocRef.set(updatedData, SetOptions(merge: true));

        // Update TextEditingController values
        switch (fieldKey) {
          case 'name':
            nameController.text = value;
            break;
          case 'mobile':
            phoneController.text = value;
            break;
          case 'email':
            emailController.text = value;
            break;
        }
      }
    } catch (e) {
      log('Error updating user data: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Personal Info', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF4500),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://media.istockphoto.com/id/1327592506/vector/default-avatar-photo-placeholder-icon-grey-profile-picture-business-man.jpg?s=612x612&w=0&k=20&c=BpR0FVaEa5F24GIw7K8nMWiiGmbb8qmhfkpXcp1dhQg="),
                                fit: BoxFit.contain))),
                    _buildInfoRow('Name ', nameController, context: context),
                    _buildInfoRow('Email ', emailController, context: context),
                    _buildInfoRow('Phone ', phoneController, context: context),
                  ],
                ),
              );
            }
          }),
      backgroundColor: const Color.fromARGB(255, 23, 31, 43),
    );
  }

  Widget _buildInfoRow(String label, TextEditingController controller,
      {required BuildContext context}) {
    return Column(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$label:',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Row(
                        children: [
                          Text(controller.text,
                              style: const TextStyle(color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit $label'),
                                    content: TextField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                        labelText: label,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Update the database
                                          await updateUserData(
                                            label.trim(),
                                            controller.text,
                                          );
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  Future<void> fetchUserData() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // Set email with null check
        emailController.text = firebaseUser.email ?? 'Not Set';

        final docSnapshot = await FirebaseFirestore.instance
            .collection('user_info')
            .doc(id)
            .get();

        log('Document snapshot: ${docSnapshot.data()}');

        if (docSnapshot.exists && docSnapshot.data() != null) {
          final data = docSnapshot.data()!;
          // Use null-aware operators to safely access data
          nameController.text = data['name']?.toString() ?? 'Not Set';
          phoneController.text = data['mobile']?.toString() ?? 'Not Set';
        } else {
          // Set default values if document doesn't exist
          nameController.text = 'Not Set';
          phoneController.text = 'Not Set';
          log('No data found in Firestore');
        }
      } else {
        log('No Firebase user found');
      }
    } catch (e) {
      log('Error fetching user data: $e');
      // Set default values in case of error
      nameController.text = 'Error loading';
      phoneController.text = 'Error loading';
      emailController.text = 'Error loading';
    }
  }
}
