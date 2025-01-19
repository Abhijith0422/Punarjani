import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('report').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reports = snapshot.data!.docs;

        // Calculate statistics
        int totalReports = reports.length;
        int actionTaken = reports
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['status'] == 'completed')
            .length;
        int pending = reports
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['status'] == 'pending')
            .length;
        int rejected = reports
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['status'] == 'rejected')
            .length;
        int underReview = reports
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['status'] ==
                'under_review')
            .length;
        int onInvestigation = reports
            .where((doc) =>
                (doc.data() as Map<String, dynamic>)['status'] ==
                'investigating')
            .length;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _historyelements(
                          'Total no of Reports', totalReports.toString()),
                      _historyelements('Action Taken', actionTaken.toString()),
                      _historyelements('Pending', pending.toString()),
                      _historyelements('Rejected', rejected.toString()),
                      _historyelements('Under Review', underReview.toString()),
                      _historyelements(
                          'On Investigation', onInvestigation.toString())
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row _historyelements(String element, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              element,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
