import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool fromBottomNavBar;

<<<<<<< HEAD
  const SettingsPage({Key? key, this.fromBottomNavBar = false})
      : super(key: key);
=======
  const SettingsPage({super.key, this.fromBottomNavBar = false});
>>>>>>> 58e33d3 (Add eventlet)

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
<<<<<<< HEAD
            onTap: () {
              // Navigate to Account Settings
            },
=======
            onTap: () {},
>>>>>>> 58e33d3 (Add eventlet)
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
