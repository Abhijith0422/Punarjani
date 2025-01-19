import 'package:flutter/material.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Healthy Activities',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF4500),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildActivitySection(
            'Physical Activities',
            [
              ActivityItem(
                title: 'Walking',
                description: '30 minutes of walking in nature',
                icon: Icons.directions_walk,
              ),
              ActivityItem(
                title: 'Yoga',
                description: 'Mindful stretching and breathing',
                icon: Icons.self_improvement,
              ),
              ActivityItem(
                title: 'Exercise',
                description: 'Regular workout routine',
                icon: Icons.fitness_center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActivitySection(
            'Mindfulness Activities',
            [
              ActivityItem(
                title: 'Meditation',
                description: '10 minutes of guided meditation',
                icon: Icons.spa,
              ),
              ActivityItem(
                title: 'Journaling',
                description: 'Write about your feelings and progress',
                icon: Icons.edit_note,
              ),
              ActivityItem(
                title: 'Deep Breathing',
                description: 'Practice breathing exercises',
                icon: Icons.air,
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEAE0C8),
    );
  }

  Widget _buildActivitySection(String title, List<ActivityItem> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 12),
        ...activities.map((activity) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ActivityCard(activity: activity),
            )),
      ],
    );
  }
}

class ActivityItem {
  final String title;
  final String description;
  final IconData icon;

  ActivityItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class ActivityCard extends StatefulWidget {
  final ActivityItem activity;

  const ActivityCard({super.key, required this.activity});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.activity.icon, color: Colors.teal, size: 32),
            title: Text(
              widget.activity.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.activity.description),
            trailing: IconButton(
              icon: Icon(
                isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isCompleted = !isCompleted;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isCompleted
                          ? 'Completed ${widget.activity.title}!'
                          : 'Unmarked ${widget.activity.title}',
                    ),
                    backgroundColor: isCompleted ? Colors.teal : Colors.grey,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
          if (isCompleted)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Completed!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
