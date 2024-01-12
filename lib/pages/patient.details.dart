import 'package:flutter/material.dart';

class PatientDetailsPage extends StatefulWidget {
  final int id;
  const PatientDetailsPage(this.id, {super.key});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  @override
  void initState() {
    super.initState();
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Patient Details'),
      ),
    );
  }
}
