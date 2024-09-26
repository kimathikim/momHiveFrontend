import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'groups.dart';
import 'home_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 0,
      height: 60.0,
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.group, size: 30, color: Colors.white),
        Icon(Icons.event, size: 30, color: Colors.white),
        Icon(Icons.library_books, size: 30, color: Colors.white),
        Icon(Icons.message, size: 30, color: Colors.white),
      ],
      color: const Color(0xFFF7C843),
      buttonBackgroundColor: const Color(0xFFF5B000),
      onTap: (index) {
        setState(() {
          _page = index;
        });
        switch (_page) {
          case 0:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
            break;
          case 1:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => GroupsPage()));
            break;
          case 2:
            Navigator.pushNamed(context, '/events');
            break;
          case 3:
            Navigator.pushNamed(context, '/library');
            break;
          case 4:
            Navigator.pushNamed(context, '/messages');
            break;
        }
      },
      letIndexChange: (index) => true,
    );
  }
}
