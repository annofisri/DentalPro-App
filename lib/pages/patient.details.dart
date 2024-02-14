import 'package:dental/components/drawer.dart';
import 'package:flutter/material.dart';

class PatientDetailsPage extends StatefulWidget {
  final patient;
  const PatientDetailsPage(this.patient, {super.key});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
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
          'Patient Details',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Text('Patient Info Page'),
      ),
      drawer: NavDrawer(),
    );
  }
}
