import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool fromBottomNavBar;

  const SettingsPage({Key? key, this.fromBottomNavBar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: fromBottomNavBar
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account Settings'),
            onTap: () {
              // Navigate to Account Settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Preferences'),
            onTap: () {
              // Navigate to Notification Preferences
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('App Theme'),
            onTap: () {
              // Navigate to App Theme Settings
            },
          ),
        ],
      ),
    );
  }
}
