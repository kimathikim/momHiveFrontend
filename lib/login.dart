import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'signup.dart';
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:momhive/signup.dart';

// Secure Storage Instance
const storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}
>>>>>>> 58e33d3 (Add eventlet)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
<<<<<<< HEAD
=======
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final response = await http.post(
      Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false; // Stop loading indicator
    });

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      print('/n');
      print("");
      String token = jsonResponse['access_token'];
      print(token);

      // Save token securely
      await saveToken(token);

      // Navigate to main screen on success
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Handle login error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid email or password. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
>>>>>>> 58e33d3 (Add eventlet)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MomHive Logo (Placeholder for an actual image)
            Center(
              child: Image.asset(
<<<<<<< HEAD
                'assets/momhive_logo.png', // Replace with your actual logo asset
=======
                'assets/momhive_logo.png',
>>>>>>> 58e33d3 (Add eventlet)
                height: 200,
              ),
            ),
            const SizedBox(height: 20, width: 20),

            Center(
              child: Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 20),

            // Email Input Field
            TextField(
<<<<<<< HEAD
=======
              controller: _emailController,
>>>>>>> 58e33d3 (Add eventlet)
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFCE5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your email',
<<<<<<< HEAD
                hintStyle: const TextStyle(color: Colors.grey), // Add this line
=======
                hintStyle: const TextStyle(color: Colors.grey),
>>>>>>> 58e33d3 (Add eventlet)
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
<<<<<<< HEAD
            TextField(
=======

            // Password Input Field
            TextField(
              controller: _passwordController,
>>>>>>> 58e33d3 (Add eventlet)
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFCE5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your password',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
<<<<<<< HEAD
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Login'),
=======
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login'),
>>>>>>> 58e33d3 (Add eventlet)
            ),

            const SizedBox(height: 20),

            // Forgot Password & Sign Up Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle forgot password action
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
<<<<<<< HEAD
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SignUpPage()), // Replace with your actual sign up page
                    );
=======
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
>>>>>>> 58e33d3 (Add eventlet)
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
