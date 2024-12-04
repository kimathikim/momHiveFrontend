import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GroupDetailsPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupDetailsPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  final storage = const FlutterSecureStorage();
  List<dynamic> members = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroupMembers(); // Fetch group members when page loads
  }

  Future<void> _fetchGroupMembers() async {
    String? token = await storage.read(key: 'auth_token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse(
          'https://momhive-backend.onrender.com/api/v1/groups/${widget.groupId}/mem'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      print(decodedResponse);
      if (decodedResponse is List) {
        setState(() {
          members = decodedResponse;
          isLoading = false;
        });
        print(members);
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected response format')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load group members')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.groupName),
        backgroundColor: Colors.yellow[600],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : members.isEmpty
              ? const Center(child: Text('No members found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return MemberCard(
                      memberName: member['first_name'] ?? 'No name',
                      email: member['email'] ?? 'No email',
                      bio: member['bio'] ?? 'No bio',
                      isAdmin: member['is_admin'] ?? false,
                    );
                  },
                ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String memberName;
  final String email;
  final String bio;
  final bool isAdmin;

  const MemberCard({
    super.key,
    required this.memberName,
    required this.bio,
    required this.email,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.yellow[600],
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(memberName),
        subtitle: Text(bio),
        trailing: isAdmin
            ? const Chip(
                label: Text('Admin'),
                backgroundColor: Colors.green,
                labelStyle: TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}
