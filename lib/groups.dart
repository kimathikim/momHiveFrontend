import 'dart:convert';
import 'message_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GroupsPage extends StatefulWidget {
  final bool fromBottomNavBar;
  const GroupsPage({super.key, this.fromBottomNavBar = true});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _storage = const FlutterSecureStorage();
  List<dynamic> myGroups = [];
  List<dynamic> exploreGroups = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    try {
      final myGroupsResponse = await http.get(
        Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/mygroups'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final exploreGroupsResponse = await http.get(
        Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/groups'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (myGroupsResponse.statusCode == 200 &&
          exploreGroupsResponse.statusCode == 200) {
        setState(() {
          myGroups = jsonDecode(myGroupsResponse.body);
          exploreGroups = jsonDecode(exploreGroupsResponse.body);
        });
      } else {
        print(
            'Failed to load groups: ${myGroupsResponse.statusCode}, ${exploreGroupsResponse.statusCode}');
      }
    } catch (error) {
      print('Failed to load groups: $error');
    }
  }

  Future<void> _createGroup(String name, String description) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        _fetchGroups(); // Refresh the group list
      } else {
        print('Failed to create group: ${response.body}');
      }
    } catch (error) {
      print('Error creating group: $error');
    }
  }

  Future<void> _joinGroup(String groupId) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse(
            'https://momhive-992deeb4847a.herokuapp.com/api/v1/groups/join/$groupId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final SnackBar snackBar;
      if (response.statusCode == 200) {
        _fetchGroups();
        // display a success message
        snackBar = const SnackBar(
          content: Text('Group joined successfully\n Check My Groups tab'),
          backgroundColor: Colors.green,
        );
      } else {
        print('Failed to join group: ${response.body}');
        // display an error message
        snackBar = SnackBar(
          content: Text('Failed to join group: ${response.body}'),
          backgroundColor: Colors.red,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      print('Error joining group: $error');
      // display an error message
      final snackBar = SnackBar(
        content: Text('Error joining group: $error'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String groupName = '';
        String groupDescription = '';

        return AlertDialog(
          title: const Text('Create New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                ),
                onChanged: (value) {
                  groupName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  groupDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (groupName.isNotEmpty && groupDescription.isNotEmpty) {
                  _createGroup(groupName, groupDescription);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groups',
      theme: ThemeData(
        primaryColor: const Color(0xFFF7C843),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search groups...',
              filled: true,
              fillColor: const Color(0xFFF7C843),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
            ),
          ),
          centerTitle: true,
          leading: widget.fromBottomNavBar
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
        ),
        body: Column(
          children: [
            TabBarWidget(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: myGroups
                        .map((group) => GroupCard(
                              title: group['name'],
                              description: group['description'],
                              members: group['members'] ?? 0,
                              color: Colors.blueAccent,
                              showJoinButton: false,
                              groupId: group['id'], // Pass groupId here
                            ))
                        .toList(),
                  ),
                  ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: exploreGroups
                        .map((group) => GroupCard(
                              title: group['name'],
                              description: group['description'],
                              members: group['members'] ?? 0,
                              color: Colors.green,
                              showJoinButton: true,
                              onJoin: () {
                                _joinGroup(group['id']);
                              },
                              groupId: group['id'], // Pass groupId here
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFF7C843),
          onPressed: () {
            _showCreateGroupDialog();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TabBarWidget extends StatelessWidget {
  final TabController tabController;
  const TabBarWidget({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        labelColor: const Color(0xFFF7C843),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFFF7C843),
        tabs: const [
          Tab(text: 'My Groups'),
          Tab(text: 'Explore'),
        ],
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String title;
  final String description;
  final int members;
  final Color color;
  final bool showJoinButton;
  final VoidCallback? onJoin;
  final String groupId;

  const GroupCard({
    super.key,
    required this.title,
    required this.description,
    required this.members,
    required this.color,
    this.showJoinButton = true,
    this.onJoin,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to MessageDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailPage(
              contactName: title,
              userId: groupId,
              isGroup: true,
            ),
          ),
        );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8.0),
              Text(description),
              const SizedBox(height: 8.0),
              Text('Members: $members'),
              if (showJoinButton)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                    ),
                    onPressed: onJoin,
                    child: const Text('Join Group'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
