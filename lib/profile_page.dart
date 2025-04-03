import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:momhive/main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ProfilePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const MomHiveApp(), // Define the login route
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();
  bool isMentor = false;
  bool isMentee = false;
  String firstName = '';
  String email = '';
  String bio = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _logout() async {
    await storage.delete(key: 'auth_token');
    
    await http.post(
      Uri.parse('https://momhive-backend.onrender.com/api/v1/logout'),
    );

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _fetchProfile() async {
    final token = await storage.read(key: 'auth_token');
    if (token != null) {
      final response = await http.get(
        Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          firstName = userData['first_name'];
          email = userData['email'];
          bio = userData['bio'] ?? 'No bio available';
          isMentor = userData['is_mentor'] ?? false;
          isMentee = userData['is_mentee'] ?? false;
        });
      } else {
        setState(() {
          bio = 'Failed to load profile data';
        });
      }
    }
  }

  Future<void> _editProfile() async {
    // Navigate to the edit profile screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentFirstName: firstName,
          currentEmail: email,
          currentBio: bio,
        ),
      ),
    );

    // If profile is updated, refresh the profile details
    if (result == true) {
      _fetchProfile();
    }
  }

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
        actions: [
          // Edit Profile Button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile, // Call the edit profile method when pressed
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Call the logout method when pressed
          ),
        ],
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
                Text(
                  firstName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  bio,
                  style: const TextStyle(
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
              children: [
                ProfileDetailCard(
                  title: 'Name',
                  content: firstName,
                ),
                ProfileDetailCard(
                  title: 'Email',
                  content: email,
                ),
                const Divider(),
                // Mentor/Mentee Switches and Other Details
                const ProfileSectionTitle(title: 'Recent Activities'),
                const ActivityCard(
                  title: 'Groups Joined',
                  description: 'Parenting Support Group, Healthy Eating Group',
                ),
                const ActivityCard(
                  title: 'Events Participated',
                  description: 'Mom\'s Yoga Class, Baby Playdate',
                ),
                const ActivityCard(
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


class ActivityCard extends StatelessWidget {
  final String title;
  final String description;

  const ActivityCard({super.key, required this.title, required this.description});

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

class ProfileDetailCard extends StatelessWidget {
  final String title;
  final String content;

  const ProfileDetailCard({super.key, required this.title, required this.content});

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
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String currentFirstName;
  final String currentEmail;
  final String currentBio;

  const EditProfilePage({
    super.key,
    required this.currentFirstName,
    required this.currentEmail,
    required this.currentBio,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  late String firstName;
  late String email;
  late String bio;

  @override
  void initState() {
    super.initState();
    firstName = widget.currentFirstName;
    email = widget.currentEmail;
    bio = widget.currentBio;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final token = await storage.read(key: 'auth_token');
      if (token != null) {
        final response = await http.put(
          Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/update_profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'first_name': firstName,
            'email': email,
            'bio': bio,
          }),
        );

        if (response.statusCode == 202) {
          Navigator.pop(context, true); // Go back and indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7C843), // Primary theme color
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white), // Ensure title text is white
        ),
        leading: IconButton( // Back arrow button
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the parent page
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Ensure back button is white
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: firstName,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.grey[700],
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) => firstName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.grey[700],
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: bio,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.grey[700],
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 4,
                onSaved: (value) => bio = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: const Color(0xFFF7C843), // Button color matching theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

