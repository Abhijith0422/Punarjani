import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplinePage extends StatelessWidget {
  const HelplinePage({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Emergency Helpline Numbers',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _helplineCard(
                  context,
                  'National Drug Helpline',
                  '1800-11-0031',
                  'Available 24x7',
                  Icons.local_hospital,
                ),
                _helplineCard(
                  context,
                  'Kerala Drug Helpline',
                  '1800-425-2777',
                  'Available 24x7',
                  Icons.medical_services,
                ),
                _helplineCard(
                  context,
                  'Police Emergency',
                  '100',
                  'Emergency Services',
                  Icons.local_police,
                ),
                _helplineCard(
                  context,
                  'Ambulance',
                  '108',
                  'Emergency Medical Services',
                  Icons.emergency,
                ),
                _helplineCard(
                  context,
                  'Women Helpline',
                  '1091',
                  'Available 24x7',
                  Icons.pregnant_woman,
                ),
                _helplineCard(
                  context,
                  'Child Helpline',
                  '1098',
                  'Available 24x7',
                  Icons.child_care,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _helplineCard(BuildContext context, String title, String number,
      String subtitle, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.phone),
              color: Colors.green,
              onPressed: () => _makePhoneCall(number),
            ),
          ],
        ),
      ),
    );
  }
}
