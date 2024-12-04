import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  Map<String, dynamic>? eventDetails;
  bool isLoading = true;
  bool isAttending = false;

  // get the token from the storage
  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  Future<void> fetchEventDetails() async {
    final token = await getToken();
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.parse(
            'https://momhive-backend.onrender.com/api/v1/events/${widget.eventId}'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (response.statusCode == 200) {
      setState(() {
        eventDetails = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> attendEvent() async {
    final token = await getToken();
    final response = await http.post(
        Uri.parse(
            'https://momhive-backend.onrender.com/api/v1/events/${widget.eventId}/attend'),
        headers: {
          "Authorization": "Bearer $token",
        });

    if (response.statusCode == 201) {
      setState(() {
        isAttending = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to attend the event')),
      );
    }
    print(response.body);
  }

  @override
  void initState() {
    super.initState();
    fetchEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.yellow[600],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventDetails?['name'] ?? 'No name',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date: ${eventDetails?['date'] ?? 'No date'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${eventDetails?['location'] ?? 'No location'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isAttending ? null : attendEvent,
                    child: Text(isAttending
                        ? 'Already Attending'
                        : 'Attend this Event'),
                  ),
                ],
              ),
            ),
    );
  }
}
