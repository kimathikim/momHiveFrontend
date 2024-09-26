import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.yellow[600],
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header
          Container(
            color: Colors.yellow[600],
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.yellow[600],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Jane Doe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'Mother of Two',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Profile Details
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                ProfileDetailCard(
                  title: 'Name',
                  content: 'Jane Doe',
                ),
                ProfileDetailCard(
                  title: 'Email',
                  content: 'jane.doe@example.com',
                ),
                ProfileDetailCard(
                  title: 'Bio',
                  content: 'Loving mother of two wonderful kids.',
                ),
                Divider(),
                ProfileSectionTitle(title: 'Recent Activities'),
                ActivityCard(
                  title: 'Groups Joined',
                  description: 'Parenting Support Group, Healthy Eating Group',
                ),
                ActivityCard(
                  title: 'Events Participated',
                  description: 'Mom\'s Yoga Class, Baby Playdate',
                ),
                ActivityCard(
                  title: 'Articles Read',
                  description:
                      'How to Handle Toddler Tantrums, Healthy Meal Ideas for Busy Moms',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetailCard extends StatelessWidget {
  final String title;
  final String content;

  const ProfileDetailCard(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(content),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Implement edit functionality
          },
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;

  const ActivityCard(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
