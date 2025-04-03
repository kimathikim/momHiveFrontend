import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:momhive/messages.dart';
import 'message_detail.dart';
import 'dart:convert';

class MentoringPage extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  const MentoringPage({super.key});

  Future<List<Map<String, dynamic>>> fetchMentors() async {
    final String? token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('https://momhive-backend.onrender.com/api/v1/mentors'),
      headers: {
        'Authorization': 'Bearer $token'
      }, // Add authentication if required
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load mentors');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMentees() async {
    final String? token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('https://momhive-backend.onrender.com/api/v1/mentees'),
      headers: {
        'Authorization': 'Bearer $token'
      }, // Add authentication if required
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load mentees');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mentoring',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Implement more options here
            },
          ),
        ],
        elevation: 6, // Gives the app bar a subtle shadow
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mentors',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Dynamic Mentors List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchMentors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No mentors available.'));
                }

                final mentors = snapshot.data!;
                return ListView.builder(
                  itemCount: mentors.length,
                  itemBuilder: (context, index) {
                    final mentor = mentors[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(mentor[
                                    'avatar_url'] ??
                                'assets/avatar_placeholder.png'), // Use actual mentor's avatar
                          ),
                          title: Text(
                            mentor['name'] ?? 'Mentor Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            mentor['expertise'] ??
                                'Expert in Parenting, Wellness',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () {
                            // Navigate to the messaging page when a mentor is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessageDetailPage(
                                      contactName: mentor['name'],
                                      senderID: mentor['id'])),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mentees',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Dynamic Mentees List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchMentees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No mentees available.'));
                }

                final mentees = snapshot.data!;
                return ListView.builder(
                  itemCount: mentees.length,
                  itemBuilder: (context, index) {
                    final mentee = mentees[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(mentee[
                                    'avatar_url'] ??
                                'assets/momhive_logo.png'), // Use actual mentee's avatar
                          ),
                          title: Text(
                            mentee['name'] ?? 'Mentee Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            mentee['help_needed'] ??
                                'Needs help in Parenting, Wellness',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () {
                            // Navigate to the messaging page when a mentee is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessageDetailPage(
                                      contactName: mentee['name'] ?? "kim",
                                      senderID: mentee['id'] ?? "kimathi")),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
