// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dental/components/drawer.dart';
import 'package:dental/pages/addAppointment.dart';
import 'package:dental/pages/appointment.details.dart';
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
  var appointmentData = null;
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

  goToAddAppointmentPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddAppointmentPage(null)),
    );
  }

  goToAppointmentDetailsPage(appointment) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AppointmentDetailsPage(appointment)),
    );
  }

  String dateConverter(date) {
    return DateFormat('E, MMM dd', 'en_US')
        .format(DateTime.parse('2024-01-10'));
  }

  String timeConverter(time) {
    // Parse the string to a DateTime object (assuming it represents a time)
    String timeString = time;
    DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);

    // Format the DateTime object as "h:mm a" (e.g., "12:42 PM")
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
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
                          //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          //formatted date output using intl package =>  2021-03-16
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
              appointmentData != null
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: appointmentData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => goToAppointmentDetailsPage(
                                  appointmentData[index]),
                              child: Container(
                                  height: 100,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: index % 2 != 0
                                        ? Colors.white
                                        : Color.fromRGBO(199, 233, 238, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        width: 150,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    width: 2,
                                                    color: Colors.white))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  dateConverter(
                                                      appointmentData[index]
                                                          ['appointment_date']),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black),
                                                  softWrap: true,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                appointmentData[index]['appointment_status'] ==
                                                        'Booked'
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color: Colors
                                                                    .black,
                                                                style: BorderStyle
                                                                    .solid),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                        child: Text('BO'))
                                                    : appointmentData[index]['appointment_status'] ==
                                                            'Reschedule'
                                                        ? Container(
                                                            padding: EdgeInsets.all(
                                                                2),
                                                            decoration: BoxDecoration(
                                                                color: Colors.yellow,
                                                                border: Border.all(width: 0.5, color: Colors.black, style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.all(Radius.circular(20))),
                                                            child: Text('RE'))
                                                        : appointmentData[index]['appointment_status'] == 'Completed'
                                                            ? Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(color: Colors.green, border: Border.all(width: 0.5, color: Colors.black, style: BorderStyle.solid), borderRadius: BorderRadius.all(Radius.circular(20))), child: Text('CO'))
                                                            : Container(padding: EdgeInsets.all(2), decoration: BoxDecoration(color: Colors.red, border: Border.all(width: 0.5, color: Colors.black, style: BorderStyle.solid), borderRadius: BorderRadius.all(Radius.circular(20))), child: Text('CA'))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              timeConverter(
                                                  appointmentData[index]
                                                          ['start_time']
                                                      .toString()),
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              ('${appointmentData[index]['treatment_time']} min')
                                                  .toString(),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  appointmentData[index]
                                                      ['patient_name'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromRGBO(
                                                          5, 5, 5, 1)),
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  '(${appointmentData[index]['patient_code']})',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromRGBO(
                                                          5, 5, 5, 0.9)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              appointmentData[index]
                                                  ['treatment_name'],
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                                '${appointmentData[index]['title']} ${appointmentData[index]['doctor_name']}',
                                                style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          }),
                    )
                  : Center(
                      child: Text('No data found!'),
                    )
            ],
          )),
      drawer: NavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToAddAppointmentPage(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30.0), // Set border radius for rounded shape
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
