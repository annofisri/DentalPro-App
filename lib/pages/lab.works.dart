import 'package:flutter/material.dart';

class LabWorks extends StatefulWidget {
  final patientId;
  const LabWorks(this.patientId, {super.key});

  @override
  State<LabWorks> createState() => _LabWorksState();
}

class _LabWorksState extends State<LabWorks> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'Lab Works',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Text('Lab Works'),
      ),
    );
  }
}
