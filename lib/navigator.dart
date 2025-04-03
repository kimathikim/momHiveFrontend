import 'package:flutter/material.dart';
import 'package:momhive/home_page.dart';
import 'package:momhive/groups.dart';
import 'package:momhive/event.dart';
import 'package:momhive/resources.dart';
import 'package:momhive/messages.dart';

void navigateToPage(int index, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        switch (index) {
          case 1:
            return const HomePage();
          case 2:
            return const GroupsPage(fromBottomNavBar: true);
          case 3:
            return const EventsPage(
              fromBottomNavBar: true,
            );
          case 4:
            return const LibraryPage(
              fromBottomNavBar: true,
            );
          case 5:
            return const MessagesPage(fromBottomNavBar: true);
          default:
            return const HomePage();
        }
      },
    ),
  );
}

class MyNavigationBar extends StatefulWidget {
  final Function(int) onTap;

  const MyNavigationBar({super.key, required this.onTap});

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Group',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
      ],
    );
  }
}
