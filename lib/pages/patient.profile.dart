import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PatientProfile extends StatefulWidget {
  var patient;
  PatientProfile(this.patient, {super.key});

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  @override
  void initState() {
    super.initState();
    print(widget.patient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.patient['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Code:')),
                      Text(widget.patient['registration_no'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Age:')),
                      Text(widget.patient['age'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Blood Group:')),
                      Text(widget.patient['blood_group'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Gender:')),
                      Text(widget.patient['gender'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Pan No.:')),
                      Text(widget.patient['pan_no'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Address:')),
                      Text(widget.patient['address'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Contact No.:')),
                      Text(widget.patient['contact_number'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Email Address:')),
                      Text(widget.patient['email_id'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(width: 120, child: Text('Emergency No.:')),
                      Text(widget.patient['emergency_number'].toString())
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                          width: 120, child: Text('Emergency Relation.:')),
                      Text(widget.patient['emergency_relation'].toString())
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
