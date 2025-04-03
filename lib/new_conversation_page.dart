import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'message_detail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NewConversationPage extends StatefulWidget {
  const NewConversationPage({super.key});

  @override
  _NewConversationPageState createState() => _NewConversationPageState();
}

class _NewConversationPageState extends State<NewConversationPage> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse(
          'https://momhive-backend.onrender.com/api/v1/messages/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        users = data
            .map((user) => {
                  'id': user['id'],
                  'name': '${user['first_name']} ${user['second_name']}',
                  'email': user['email'],
                  'phone': user['phone_number'],
                  'imageUrl':
                      'https://dummyimage.com/100x100/000/fff&text=${user['first_name'][0]}',
                })
            .toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _startConversation(String userId, String userName) {
    // navigate to message detail page
    // pass userId and userName to the page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPage(
          senderID: userId,
          contactName: userName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Conversation'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['imageUrl']),
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    onTap: () => _startConversation(user['id'], user['name']),
                  ),
                );
              },
            ),
    );
  }
}
