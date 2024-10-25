import 'package:flutter/material.dart';
import 'package:momhive/mainscreen.dart';
import 'package:momhive/login.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart'; // Import the ThemeNotifier class


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MomHiveApp(),
    ),
  );
}

class MomHiveApp extends StatelessWidget {
  const MomHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier =
        Provider.of<ThemeNotifier>(context); // Listen to theme changes

    return MaterialApp(
      title: 'MomHive',
      debugShowCheckedModeBanner: false, // Disable the debug banner
      themeMode: themeNotifier.themeMode, // Dynamically change the theme
      theme: ThemeData(
        primaryColor: const Color(0xFFF7C843),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              color: Color(0xFF4D4D4D), fontSize: 16, fontFamily: 'Roboto'),
          headlineSmall: TextStyle(
              color: Color(0xFF4D4D4D),
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7C843),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[850],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              color: Colors.white, fontSize: 16, fontFamily: 'Roboto'),
          headlineSmall: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
