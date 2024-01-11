// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dental/components/drawer.dart';
import 'package:dental/services/appointment.service.dart';
import 'package:dental/services/dashboard.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  var appointmentData;
  final DashboardService dashboardService = DashboardService();
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    dateInput.text = formattedDate;
    getAppointmentData();
  }

  getAppointmentData() async {
    var data =
        await AppointmentService().getAppointmentData(dateInput.text) ?? {};
    ;
    print(data);
    setState(() {
      appointmentData = data['content'];
    });
  }

  void filterAppointment() {
    // ignore: unnecessary_null_comparison
    if (dateInput.text == null || dateInput.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Date is required!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    getAppointmentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'Appointments',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 250,
                    child: TextField(
                      controller: dateInput,
                      //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateInput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: filterAppointment,
                      child: Container(
                        child: Text('Find'),
                      ))
                ],
              )),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  // ignore: unnecessary_null_comparison
                  child: appointmentData != null
                      ? ListView.builder(
                          itemCount: appointmentData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(54, 135, 147, 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Date: ',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${appointmentData[index]['appointment_date']}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Status: ',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${appointmentData[index]['appointment_status']}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ]),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Patient's Name: ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${appointmentData[index]['patient_name']}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Treatment: ',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${appointmentData[index]['treatment_name']}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ]),
                            );
                          })
                      : Text('no data')),
            ],
          )),
      drawer: NavDrawer(),
    );
  }
}
