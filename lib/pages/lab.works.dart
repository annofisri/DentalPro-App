import 'package:flutter/material.dart';

class LabWorks extends StatefulWidget {
  const LabWorks({super.key});

  @override
  State<LabWorks> createState() => _LabWorksState();
}

class _LabWorksState extends State<LabWorks> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Lab Works'),
      ),
    );
  }
}
