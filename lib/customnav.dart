import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color(0xFFF7C843),
      buttonBackgroundColor: const Color(0xFFF5B000),
      height: 60,
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.group, size: 30, color: Colors.white),
        Icon(Icons.event, size: 30, color: Colors.white),
        Icon(Icons.library_books, size: 30, color: Colors.white),
        Icon(Icons.message, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        setState(() {
          _page = index;
        });
        // Handle page changes
      },
    );
  }
}
