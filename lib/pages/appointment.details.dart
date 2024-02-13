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
    return const Scaffold(
      body: Center(child: Text('Appointment Details')),
    );
  }
}
