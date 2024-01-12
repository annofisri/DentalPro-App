import 'package:flutter/material.dart';

class Charting extends StatefulWidget {
  const Charting({super.key});

  @override
  State<Charting> createState() => _ChartingState();
}

class _ChartingState extends State<Charting> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Charting'),
      ),
    );
  }
}
