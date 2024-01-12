import 'package:dental/components/drawer.dart';
import 'package:dental/pages/patient.details.dart';
import 'package:dental/services/patient.service.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  TextEditingController patientName = TextEditingController();
  var patientData = [];
  var currentPage = 0;
  var last = true;
  var first = true;

  @override
  void initState() {
    super.initState();
    getAllPatients();
  }

  void getAllPatients() async {
    var data =
        await PatientService().getAllPAtients(patientName.text, currentPage) ??
            {};
    setState(() {
      patientData = data['content'];
      first = data['first'];
      last = data['last'];
    });
  }

  getPreviousPage() {
    setState(() {
      currentPage = currentPage - 1;
    });
    getAllPatients();
  }

  getNextPage() {
    setState(() {
      currentPage = currentPage + 1;
    });
    getAllPatients();
  }

  goToPatientDetailsPage(patient) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PatientDetailsPage(patient)),
    );
  }

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
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))),
                  child: TextField(
                    controller: patientName,
                    decoration: InputDecoration(
                        hintText: 'Search for Patient',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        border: InputBorder.none),
                  ),
                ),
                GestureDetector(
                  onTap: getAllPatients,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(54, 135, 147, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text('Find', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          patientData.length == 0
              ? Container(
                  height: 500,
                  child: Center(
                    child: Text('No Data to Display!'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: patientData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => goToPatientDetailsPage(patientData[index]),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientData[index]['name'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Address: ${patientData[index]['address']}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Email Address: ${patientData[index]['email_id']}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Mobile No.: ${patientData[index]['name']}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                first == false
                    ? GestureDetector(
                        onTap: getPreviousPage,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text('Prev',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    : Text(''),
                last == false
                    ? GestureDetector(
                        onTap: getNextPage,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text('Next',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    : Text('')
              ],
            ),
          )
        ]),
      ),
      drawer: NavDrawer(),
    );
  }
}
