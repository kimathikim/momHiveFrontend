import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';
import 'theme_notifier.dart';

class AccountSettingsPage extends StatelessWidget {
  final bool fromBottomNavBar;
  const AccountSettingsPage({super.key, this.fromBottomNavBar = true});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Account Settings'),
        backgroundColor: Colors.yellow[600],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SettingsCard(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ));
            },
          ),
          SettingsCard(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Navigate to Change Password page
            },
          ),
          const Divider(),
          const SectionTitle(title: 'Notification Preferences'),
          SwitchSettingsCard(
            icon: Icons.notifications,
            title: 'Push Notifications',
            value: true,
            onChanged: (bool newValue) {
              // Update push notification preference
            },
          ),
          const Divider(),
          const SectionTitle(title: 'App Theme'),
          SwitchSettingsCard(
            icon: themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: themeNotifier.isDarkMode ? 'Dark Theme' : 'Light Theme',
            value: themeNotifier.isDarkMode,
            onChanged: (bool value) {
              themeNotifier.toggleTheme(); // Toggle the theme
            },
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black87),
        onTap: onTap,
      ),
    );
  }
}

class SwitchSettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchSettingsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.yellow[600],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
