import 'package:dental/components/drawer.dart';
import 'package:dental/services/patient.service.dart';
import 'package:flutter/material.dart';

class PatientDetailsPage extends StatefulWidget {
  final id;
  const PatientDetailsPage(this.id, {super.key});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  var patient;

  @override
  void initState() {
    super.initState();

    getPatientDetails();
  }

  getPatientDetails() async {
    var data = await PatientService().getPatientById(widget.id) ?? {};
    print(data);
    setState(() {
      patient = data ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'Patient Information',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: patient != null
          ? ListView(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/teeth_background.png'), // Replace with your image path
                        fit: BoxFit.fitWidth,
                      ),
                      color: Color.fromRGBO(54, 135, 147, 1)),
                  child: Center(
                    child: Text(
                      patient['name'],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Patient Code',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['registration_no'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'PAN No.',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['pan_no'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Patient Name',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['name'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Age',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['age'].toString() ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Blood Group',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['blood_group'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Gender',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['gender'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Address',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['address'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Contact No.',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['contact_number'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Email Address',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['email_id'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Emergency No.',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['emergency_number'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Emergency Relation',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['emergency_relation'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  padding: EdgeInsets.fromLTRB(16, 6, 16, 0),
                  child: Text(
                    'Medical History',
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 15),
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  child: SizedBox(
                    height: 12,
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Allergies',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['allergies'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  child: SizedBox(
                    height: 12,
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Pre-existing Medical Conditions',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(
                            patient['pre_existing_medical_conditions'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  child: SizedBox(
                    height: 12,
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Medications',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(patient['medications'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  child: SizedBox(
                    height: 12,
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Previous Dental Procedures',
                        style: TextStyle(fontSize: 13),
                      )),
                      Expanded(
                        child: Text(
                            patient['previuos_dental_procedures'] ?? '-',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color.fromRGBO(249, 249, 250, 1),
                  child: SizedBox(
                    height: 6,
                  ),
                ),
              ],
            )
          : Center(child: Text('Unable to load Patient')),
      drawer: NavDrawer(),
    );
  }
}
