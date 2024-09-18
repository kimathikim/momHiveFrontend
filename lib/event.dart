import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  final bool fromBottomNavBar;

  const EventsPage({super.key, this.fromBottomNavBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        leading: fromBottomNavBar
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        backgroundColor: Colors.yellow[600],
        elevation: 0,
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
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String date;
  final String location;

  const EventCard(
      {super.key,
      required this.eventName,
      required this.date,
      required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(eventName, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text('Date: $date\nLocation: $location'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to event details
        },
      ),
    );
  }
}
