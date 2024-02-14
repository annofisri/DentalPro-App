import 'package:dental/components/drawer.dart';
import 'package:dental/services/patient.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                SizedBox(
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(199, 233, 238, 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/health_record.svg', // Replace with your image path
                            width: 18, // Set the desired height for the image
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Electronic Health Record',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/arrow_right.png', // Replace with your image path
                        width: 18, // Set the desired height for the image
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(199, 233, 238, 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/dental_surgery.png', // Replace with your image path
                            width: 24, // Set the desired width for the image
                            fit: BoxFit
                                .fitHeight, // Use 'contain' to maintain the aspect ratio
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Lab Work',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/arrow_right.png', // Replace with your image path
                        width: 18, // Set the desired height for the image
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 10),
                  padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(199, 233, 238, 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Image.asset(
                          //   'assets/dental_surgery.png', // Replace with your image path
                          //   width: 24, // Set the desired width for the image
                          //   fit: BoxFit
                          //       .fitHeight, // Use 'contain' to maintain the aspect ratio
                          // ),
                          Icon(Icons.attach_file),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Attachments',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/arrow_right.png', // Replace with your image path
                        width: 18, // Set the desired height for the image
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                )
              ],
            )
          : Center(child: Text('Unable to load Patient')),
      drawer: NavDrawer(),
    );
  }
}
