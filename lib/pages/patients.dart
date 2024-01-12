import 'package:dental/components/drawer.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'Patient',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Text('Patients'),
      ),
      drawer: NavDrawer(),
    );
  }
}
