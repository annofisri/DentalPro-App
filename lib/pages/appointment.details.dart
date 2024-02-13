import 'package:dental/components/drawer.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final Object appointment;
  const AppointmentDetailsPage(this.appointment, {super.key});

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  @override
  void initState() {
    super.initState();

    print(widget.appointment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'Appointment Details',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(child: Text('Appointment Details')),
      drawer: NavDrawer(),
    );
  }
}
