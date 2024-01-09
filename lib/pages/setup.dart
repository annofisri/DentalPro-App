// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
// import 'dart:async';
import 'package:dental/pages/home.dart';
import 'package:dental/pages/login.dart';
import 'package:dental/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final TextEditingController _controller = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    checkURL();
  }

  checkURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');

    if (name != null && name.isNotEmpty) {
      checkLoggedIn();
    }
  }

  void checkLoggedIn() async {
    bool isLoggedIn = await authService.isAuthenticated();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  saveURL(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'DPMS',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter URL'),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: ''),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => saveURL(_controller.text),
              // onPressed: () {},
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
