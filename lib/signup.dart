import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:http/http.dart' as http;
import 'dart:convert';
>>>>>>> 58e33d3 (Add eventlet)

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
<<<<<<< HEAD
=======
  final _formKey = GlobalKey<FormState>();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://momhive-992deeb4847a.herokuapp.com/api/v1/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'second_name': _lastNameController.text,
            'first_name': _firstNameController.text,
            'phone_number': _phoneNumberController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 202) {
          // Handle successful signup (Navigate to login or home screen)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign up successful!')),
          );
          // Navigate to login page
          Navigator.pushNamed(context, '/login');
        } else {
          // Handle signup failure
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to sign up')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $error')),
        );
      }
    }
  }
>>>>>>> 58e33d3 (Add eventlet)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDD2C),
<<<<<<< HEAD
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Join the Hive',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // MomHive Logo
            Center(
              child: Image.asset(
                'assets/momhive_logo.png', // Replace with your actual logo asset
                height: 150,
              ),
            ),
            const SizedBox(height: 10),

            // Last Name Input Field
            TextField(
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFCE5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Last Name',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: 10),

            // First Name Input Field
            TextField(
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFCE5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: 'First Name',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: 10),

            // Phone Number Input Field
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFCE5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '+1 ',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                hintText: '(999) 111-0000',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: 10),

            // Email Input Field
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFCE5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your email',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),

            // Password Input Field
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                fillColor: const Color(0xFFFFFCE5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Create a password',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
            const SizedBox(height: 10),

            // Sign Up Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              onPressed: () {
                // Handle Sign Up
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
=======
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Join the Hive',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // MomHive Logo
              Center(
                child: Image.asset(
                  'assets/momhive_logo.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 10),

              // Last Name Input Field
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFFFCE5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Last Name',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // First Name Input Field
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFFFCE5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'First Name',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Phone Number Input Field
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFFFCE5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '+1 ',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  hintText: '(999) 111-0000',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Email Input Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFFFCE5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password Input Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFFFFCE5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Create a password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Sign Up Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                onPressed: _handleSignUp,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
>>>>>>> 58e33d3 (Add eventlet)
        ),
      ),
    );
  }
}
