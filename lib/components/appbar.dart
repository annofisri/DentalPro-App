import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0), // Specify the height of the AppBar
      child: AppBar(
        title: const Text('DPMS'),
        backgroundColor: Colors.blue[400],
      ),
    );
  }
}
