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
      body: ListView(children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(
            children: [
              Icon(
                Icons.image,
                size: 40,
              ),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. Nischal Thapa',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '- | -',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Appointment No.',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('APN 0006', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Date',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Time',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Patient Name',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Patient Code',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Contact No.',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Address',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Chief Problem',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Treatment',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Treatment Time',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Buffer Time',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Note',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Status',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
          decoration: BoxDecoration(color: Color.fromRGBO(238, 248, 239, 1)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Created By',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    'Created Date',
                    style: TextStyle(fontSize: 13),
                  )),
                  Expanded(
                    child: Text('24/10/50', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
      drawer: NavDrawer(),
    );
  }
}
