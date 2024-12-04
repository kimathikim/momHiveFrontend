import 'dart:convert';
import 'message_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'groupD.dart';

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
        Uri.parse('https://momhive-backend.onrender.com/api/v1/mygroups'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final exploreGroupsResponse = await http.get(
        Uri.parse('https://momhive-backend.onrender.com/api/v1/groups'),
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

  Future<void> _leaveGroup(String groupId) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse(
            'https://momhive-backend.onrender.com/api/v1/groups/leave/$groupId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final SnackBar snackBar;
      if (response.statusCode == 200) {
        _fetchGroups(); // Refresh the group list after leaving
        snackBar = const SnackBar(
          content: Text('Successfully left the group'),
          backgroundColor: Colors.green,
        );
      } else {
        snackBar = SnackBar(
          content: Text('Failed to leave group: ${response.body}'),
          backgroundColor: Colors.red,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      final snackBar = SnackBar(
        content: Text('Error leaving group: $error'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _navigateToChatRoom(
      BuildContext context, String contactName, String senderID, bool isGroup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPage(
          contactName: contactName,
          senderID: senderID,
          isGroup: isGroup,
        ),
      ),
    );
  }

  Future<void> _createGroup(String name, String description) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://momhive-backend.onrender.com/api/v1/create'),
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
            'https://momhive-backend.onrender.com/api/v1/groups/join/$groupId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      final SnackBar snackBar;
      if (response.statusCode == 200) {
        _fetchGroups();
        snackBar = const SnackBar(
          content: Text('Group joined successfully\n Check My Groups tab'),
          backgroundColor: Colors.green,
        );
      } else {
        snackBar = SnackBar(
          content: Text('Failed to join group: ${response.body}'),
          backgroundColor: Colors.red,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      print('Error joining group: $error');
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
            title: const Text(
              'Create New Group',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (groupName.isNotEmpty && groupDescription.isNotEmpty) {
                    _createGroup(groupName, groupDescription);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Create',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ]);
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
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
        ),
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
          backgroundColor: const Color(0xFFF7C843),
        ),
        body: Column(
          children: [
            TabBarWidget(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGroupList(myGroups, false),
                  _buildGroupList(exploreGroups, true),
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

  Widget _buildGroupList(List<dynamic> groups, bool isExplore) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return GestureDetector(
          onTap: () {
            _navigateToChatRoom(context, group['name'], group['id'], true);
          },
          child: GroupCard(
            title: group['name'],
            description: group['description'],
            members: group['members'] ?? 0,
            color: isExplore ? Colors.green : Colors.blueAccent,
            showJoinButton: isExplore,
            showLeaveButton: !isExplore,
            onJoin: isExplore ? () => _joinGroup(group['id']) : null,
            onLeave: !isExplore ? () => _leaveGroup(group['id']) : null,
            groupId: group['id'],
          ),
        );
      },
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
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
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
  final bool showLeaveButton;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final String groupId;

  const GroupCard({
    super.key,
    required this.title,
    required this.description,
    required this.members,
    required this.color,
    this.showJoinButton = true,
    this.showLeaveButton = false,
    this.onJoin,
    this.onLeave,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8.0),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8.0),
            Text('Members: $members',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupDetailsPage(
                              groupId: groupId, groupName: title)),
                    );
                  },
                  child: const Text('View Details'),
                ),
                if (showJoinButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: onJoin,
                    child: const Text(
                      'Join Group',
                    ),
                  ),
                if (showLeaveButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: onLeave,
                    child: const Text('Leave Group'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
