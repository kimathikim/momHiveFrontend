import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'eventdetail.dart';
import 'createEvent.dart';

class EventsPage extends StatefulWidget {
  final bool fromBottomNavBar;

  const EventsPage({super.key, this.fromBottomNavBar = true});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> exploreEvents = [];
  bool isLoadingExplore = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this); // Only 1 tab now
    fetchExploreEvents();
  }

  // Get the token from the secure storage
  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  // Fetch the list of events
  Future<void> fetchExploreEvents() async {
    final token = await getToken();
    setState(() {
      isLoadingExplore = true;
    });
    final response = await http.get(
        Uri.parse('https://momhive-backend.onrender.com/api/v1/events'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (response.statusCode == 200) {
      setState(() {
        exploreEvents = json.decode(response.body);
        isLoadingExplore = false;
      });
    } else {
      setState(() {
        isLoadingExplore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: widget.fromBottomNavBar
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        backgroundColor: Colors.yellow[600],
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Explore Events'), // Only one tab now
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[600],
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigate to create event page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateEventPage()),
                );
              },
              child: const Text(
                'Create Event',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Explore Events Tab
                isLoadingExplore
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: exploreEvents.length,
                        itemBuilder: (context, index) {
                          final event = exploreEvents[index];
                          return EventCard(
                            eventId: event['id'],
                            eventName: event['name'] ?? 'No name',
                            date: event['date'] ?? 'No date',
                            location: event['location'] ?? 'No location',
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventId;
  final String eventName;
  final String date;
  final String location;

  const EventCard({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          eventName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Date: $date\nLocation: $location',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          // Navigate to event details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(eventId: eventId),
            ),
          );
        },
      ),
    );
  }
}

