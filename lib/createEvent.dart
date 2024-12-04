import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  String _eventDate = '';
  String _eventLocation = '';
  String _eventDescription = '';
  bool isSubmitting = false;

  Future<void> submitEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      isSubmitting = true;
    });

    final token = await const FlutterSecureStorage().read(key: 'auth_token');

    final response = await http.post(
      Uri.parse('https://momhive-backend.onrender.com/api/v1/events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': _eventName,
        'date': _eventDate,
        'location': _eventLocation,
        'description': _eventDescription,
      }),
    );

    print(response.body);
    setState(() {
      isSubmitting = false;
    });

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print(response);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to create event.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.yellow[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Name'),
                onSaved: (value) {
                  _eventName = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Date'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(
                      new FocusNode()); // to prevent opening the onscreen keyboard
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _eventDate = DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
                controller: TextEditingController(
                    text:
                        _eventDate), // to display the selected date in the text field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event date';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Location'),
                onSaved: (value) {
                  _eventLocation = value ?? '';
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Event Description'),
                onSaved: (value) {
                  _eventDescription = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: submitEvent,
                      child: const Text('Submit Event'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
