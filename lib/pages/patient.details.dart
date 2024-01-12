import 'package:dental/components/drawer.dart';
import 'package:dental/pages/attachment.dart';
import 'package:dental/pages/billing.dart';
import 'package:dental/pages/charting.dart';
import 'package:dental/pages/healthrecord.dart';
import 'package:dental/pages/lab.works.dart';
import 'package:dental/pages/patient.profile.dart';
import 'package:flutter/material.dart';

class PatientDetailsPage extends StatefulWidget {
  final Object patient;
  const PatientDetailsPage(this.patient, {super.key});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  var activeNav = 'Profile';

  @override
  void initState() {
    super.initState();
  }

  setActiveNav(nav) {
    setState(() {
      activeNav = nav;
    });
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
      body: Column(
        children: [
          Container(
            height: 50,
            child: Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () => setActiveNav('Profile'),
                  child: Container(
                    color:
                        activeNav == 'Profile' ? Colors.orange : Colors.black,
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setActiveNav('Billing Details'),
                  child: Container(
                    color: activeNav == 'Billing Details'
                        ? Colors.orange
                        : Colors.black,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Billing Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setActiveNav('Health Record'),
                  child: Container(
                    color: activeNav == 'Health Record'
                        ? Colors.orange
                        : Colors.black,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Health Record',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setActiveNav('Lab Works'),
                  child: Container(
                    color:
                        activeNav == 'Lab Works' ? Colors.orange : Colors.black,
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Lab Works',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setActiveNav('Charting'),
                  child: Container(
                    color:
                        activeNav == 'Charting' ? Colors.orange : Colors.black,
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Charting',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setActiveNav('Attachment'),
                  child: Container(
                    color: activeNav == 'Attachment'
                        ? Colors.orange
                        : Colors.black,
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Attachment',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )),
          ),
          Expanded(
              child: activeNav == 'Billing Details'
                  ? Billing()
                  : activeNav == 'Health Record'
                      ? HealthRecord()
                      : activeNav == 'Lab Works'
                          ? LabWorks()
                          : activeNav == 'Charting'
                              ? Charting()
                              : activeNav == 'Attachment'
                                  ? AttachmentPage()
                                  : PatientProfile(widget.patient))
        ],
      ),
      drawer: NavDrawer(),
    );
  }
}
