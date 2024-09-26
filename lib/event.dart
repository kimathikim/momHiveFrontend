import 'package:flutter/material.dart';
<<<<<<< HEAD

class EventsPage extends StatelessWidget {
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventsPage extends StatefulWidget {
>>>>>>> 58e33d3 (Add eventlet)
  final bool fromBottomNavBar;

  const EventsPage({super.key, this.fromBottomNavBar = true});

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        leading: fromBottomNavBar
=======
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

  // get the token from the storage
  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  Future<void> fetchExploreEvents() async {
    final token = await getToken();
    setState(() {
      isLoadingExplore = true;
    });
    final response = await http.get(
        Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/events'),
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
        title: const Text('Events'),
        leading: widget.fromBottomNavBar
>>>>>>> 58e33d3 (Add eventlet)
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        backgroundColor: Colors.yellow[600],
        elevation: 0,
<<<<<<< HEAD
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const <Widget>[
          EventCard(
              eventName: 'Online Parenting Webinar',
              date: 'July 20, 2024',
              location: 'Zoom'),
          EventCard(
              eventName: 'Local Mothers Meetup',
              date: 'August 5, 2024',
              location: 'Nakuru Park'),
=======
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Explore Events'), // Only one tab now
          ],
        ),
      ),
      body: TabBarView(
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
                      eventName: event['name'] ?? 'No name',
                      date: event['date'] ?? 'No date',
                      location: event['location'] ?? 'No location',
                    );
                  },
                ),
>>>>>>> 58e33d3 (Add eventlet)
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String date;
  final String location;

<<<<<<< HEAD
  const EventCard(
      {super.key,
      required this.eventName,
      required this.date,
      required this.location});
=======
  const EventCard({
    super.key,
    required this.eventName,
    required this.date,
    required this.location,
  });
>>>>>>> 58e33d3 (Add eventlet)

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(eventName, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text('Date: $date\nLocation: $location'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
<<<<<<< HEAD
          // Navigate to event details
=======
          // Handle event details or attend action
>>>>>>> 58e33d3 (Add eventlet)
        },
      ),
    );
  }
}
