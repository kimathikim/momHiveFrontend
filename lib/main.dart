import 'package:flutter/material.dart';
import 'package:momhive/mainscreen.dart';
import 'package:momhive/login.dart';

void main() {
  runApp(const MomHiveApp());
}

class MomHiveApp extends StatelessWidget {
  const MomHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MomHive',
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
