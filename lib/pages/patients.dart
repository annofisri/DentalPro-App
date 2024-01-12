import 'package:dental/components/drawer.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  TextEditingController patientName = TextEditingController();

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
                Container(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(54, 135, 147, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text('Find', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ]),
      ),
      drawer: NavDrawer(),
    );
  }
}
