import 'package:flutter/material.dart';

class GroupsPage extends StatelessWidget {
  final bool fromBottomNavBar;
  const GroupsPage({super.key, this.fromBottomNavBar = true});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Groups',
        theme: ThemeData(
          primaryColor: const Color(0xFFF7C843),
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            headlineSmall: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            bodyMedium: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
            ),
            bodyLarge: TextStyle(
              color: Colors.grey[800],
              fontSize: 18,
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.grey[800]),
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
            leading: fromBottomNavBar
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
              const TabBarWidget(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    GroupCard(
                      title: 'Parenting Tips',
                      description:
                          'A group for sharing parenting tips and advice.',
                      members: 150,
                      color: Colors.blueAccent,
                      onJoin: () {
                        // Handle join action
                      },
                    ),
                    GroupCard(
                      title: 'Health & Wellness',
                      description: 'Discuss health and wellness tips.',
                      members: 200,
                      color: Colors.green,
                      onJoin: () {
                        // Handle join action
                      },
                    ),
                    GroupCard(
                      title: 'Local Meetups',
                      description: 'Find and join local meetups in your area.',
                      members: 85,
                      color: Colors.redAccent,
                      onJoin: () {
                        // Handle join action
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFF7C843),
            onPressed: () {
              // Handle create new group action
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFFF7C843),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFFF7C843),
              tabs: [
                Tab(text: 'My Groups'),
                Tab(text: 'Explore'),
              ],
            ),
          ),
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
  final VoidCallback onJoin;

  const GroupCard({
    super.key,
    required this.title,
    required this.description,
    required this.members,
    required this.color,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Members: $members',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
