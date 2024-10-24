import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GroupDetailPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupDetailPage({super.key, required this.groupId, required this.groupName});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  List<dynamic> groupMembers = [];
  bool isLoading = true;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchGroupDetails();
  }

  Future<void> _fetchGroupDetails() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/groups/${widget.groupId}/members'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          groupMembers = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to load group members: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Failed to load group members: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _joinGroup() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse(
            'https://momhive-992deeb4847a.herokuapp.com/api/v1/groups/join/${widget.groupId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Joined group successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to join group: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join group: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error joining group: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error joining group: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Group Members',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupMembers.length,
                    itemBuilder: (context, index) {
                      final member = groupMembers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(member['name'][0].toUpperCase()),
                        ),
                        title: Text(member['name']),
                        subtitle: Text(member['email']),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _joinGroup,
                    child: const Text('Join Group'),
                  ),
                ),
              ],
            ),
    );
  }
}

