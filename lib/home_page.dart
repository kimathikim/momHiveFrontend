import 'package:flutter/material.dart';
import 'setting_page.dart';
import 'mentorship.dart';
import 'groups.dart';
import 'resources.dart';
import 'event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> upcomingEvents = [];
  List<dynamic> attendingEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final token = await getToken();
    setState(() {
      isLoading = true;
    });

    // Fetch upcoming events
    final upcomingResponse = await http.get(
        Uri.parse('https://momhive-backend.onrender.com/api/v1/events'),
        headers: {
          "Authorization": "Bearer $token",
        });

    // Fetch attending events
    final attendingResponse = await http.get(
        Uri.parse(
            'https://momhive-backend.onrender.com/api/v1/events/attending'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (upcomingResponse.statusCode == 200 &&
        attendingResponse.statusCode == 200) {
      setState(() {
        upcomingEvents = json.decode(upcomingResponse.body);
        attendingEvents = json.decode(attendingResponse.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MomHive',
        theme: ThemeData(
          primaryColor: Colors.black,
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
            backgroundColor: Colors.yellow[600],
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: const Text('MomHive',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      // Handle notifications action
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AccountSettingsPage()));
                    },
                  ),
                ],
                elevation: 0,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      HomeCard(
                        title: 'Groups',
                        description: 'You have joined 5 groups',
                        icon: Icons.group,
                        color: Colors.yellow[600]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GroupsPage()),
                          );
                        },
                      ),
                      HomeCard(
                        title: 'Articles',
                        description: '5 new resources available',
                        icon: Icons.library_books,
                        color: Colors.yellow[600]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LibraryPage()),
                          );
                        },
                      ),
                      HomeCard(
                        title: 'Mentorship',
                        description: 'You are mentoring 2 moms',
                        icon: Icons.school,
                        color: Colors.yellow[600]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MentoringPage()),
                          );
                        },
                      ),
                      HomeCard(
                        title: 'Events',
                        description: 'Next: Book Club Meeting',
                        icon: Icons.event,
                        color: Colors.yellow[600]!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EventsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Upcoming Events',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            ...attendingEvents.map((event) => EventCard(
                                  eventTitle: event['name'] ?? 'No name',
                                  eventTime: event['date'] ?? 'No date',
                                )),
                            ...upcomingEvents.map((event) => EventCard(
                                  eventTitle: event['name'] ?? 'No name',
                                  eventTime: event['date'] ?? 'No date',
                                )),
                          ],
                        ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF55200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        child: Text(
                          'View All Events',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        color: Colors.white,
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventTitle;
  final String eventTime;

  const EventCard({
    super.key,
    required this.eventTitle,
    required this.eventTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          elevation: 7,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  eventTime,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
