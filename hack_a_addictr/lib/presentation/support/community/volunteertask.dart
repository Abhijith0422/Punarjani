import 'package:flutter/material.dart';

class VolunteerTaskPage extends StatelessWidget {
  const VolunteerTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFF4500),
          title: const Text(
            'Volunteer Tasks',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Volunteer Tasks to Help Reduce Drug Addiction',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TaskCard(
                title: 'Organize a Community Event',
                description:
                    'Plan and organize events to raise awareness about drug addiction.',
              ),
              TaskCard(
                title: 'Support Group Meetings',
                description:
                    'Facilitate support group meetings for individuals struggling with addiction.',
              ),
              TaskCard(
                title: 'Educational Workshops',
                description:
                    'Conduct workshops to educate people about the dangers of drug abuse.',
              ),
              TaskCard(
                title: 'Fundraising Campaigns',
                description:
                    'Organize fundraising campaigns to support addiction recovery programs.',
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFEAE0C8),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String description;

  const TaskCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(description),
          ],
        ),
      ),
    );
  }
}
