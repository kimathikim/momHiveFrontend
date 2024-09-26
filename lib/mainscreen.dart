import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:momhive/home_page.dart';
import 'package:momhive/groups.dart';
import 'package:momhive/event.dart';
import 'package:momhive/resources.dart';
import 'package:momhive/messages.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const GroupsPage(),
    const EventsPage(),
    const LibraryPage(),
    const MessagesPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFFF7C843),
        buttonBackgroundColor: const Color(0xFFF5B000),
        height: 60,
        onTap: onTabTapped,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.group, size: 30, color: Colors.white),
          Icon(Icons.event, size: 30, color: Colors.white),
          Icon(Icons.library_books, size: 30, color: Colors.white),
          Icon(Icons.message, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
