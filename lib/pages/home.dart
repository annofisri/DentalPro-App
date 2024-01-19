// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dental/components/drawer.dart';
import 'package:dental/pages/notification.dart';
import 'package:dental/services/appointment.service.dart';
import 'package:dental/services/notification.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Notificationservice notificationservice = Notificationservice();
  var notificationData = [];
  var dashboardData;
  var appointmentData;
  List<String> next7Days = [];
  String selectedDay = '';

  @override
  void initState() {
    super.initState();

    checkPermission();

    getNotifications();

    showNotification();

    getNext7DaysFormatted();
  }

  void showNotification() async {
    notificationData = await getNotifications();
    notificationservice.initializeNotification();
    for (var item in notificationData) {
      notificationservice.sendNotification(
          item['id'], item['title'] as String, item['body'] as String);
      // notificationservice.sendNotification('title', 'test');
    }
  }

  getNotifications() async {
    var data = await Notificationservice().getNotifications() ?? {};
    setState(() {
      notificationData = data;
    });
    return data;
  }

  void checkPermission() async {
    // check for permission
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      print("Notification permission is granted");
      // Perform actions requiring notification permission here
    } else {
      print("Notification permission is not granted");
      // Request notification permission
      PermissionStatus newStatus = await Permission.notification.request();

      if (newStatus.isGranted) {
        print("Notification permission granted after request");
        // Perform actions requiring notification permission here
      } else {
        print("Notification permission denied after request");
        // Handle the case where the user denies permission
      }
    }
    // check for permission end
  }

  void getNext7DaysFormatted() async {
    List<String> dateList = [];
    DateTime currentDate = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    for (int i = 0; i < 7; i++) {
      dateList.add(formatter.format(currentDate.add(Duration(days: i))));
    }

    next7Days = await dateList;
    selectedDay = next7Days[0];
    getAppointmentData();
  }

  void setSelectedDay(day) {
    setState(() {
      selectedDay = day;
    });

    getAppointmentData();
  }

  getAppointmentData() async {
    var data = await AppointmentService().getAppointmentData(selectedDay) ?? {};
    ;
    setState(() {
      appointmentData = data['content'];
    });
  }

  void goToNotification() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationPage()),
    );
  }

  String getDate(date) {
    // Parse the string to a DateTime object
    String dateString = date;
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object as "20 Jan"
    String formattedDate = DateFormat('dd MMM').format(dateTime);
    return formattedDate;
  }

  String getDay(date) {
    // Parse the string to a DateTime object
    String dateString = date;
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object as "EEE" (short day of the week format)
    String formattedDay = DateFormat('EEE').format(dateTime);
    return formattedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF368793),
        title: Center(
          child: SvgPicture.asset(
            'assets/login_logo.svg',
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: goToNotification,
              icon: Icon(Icons.notifications_active_outlined))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This Week's",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          Container(
            height: 60,
            child: next7Days.length > 0
                ? ListView.builder(
                    itemCount: next7Days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => setSelectedDay(next7Days[index]),
                        child: Container(
                          color: selectedDay == next7Days[index]
                              ? Colors.orange
                              : Colors.black,
                          width: 100,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  selectedDay == next7Days[index]
                                      ? 'Today'
                                      : getDay(next7Days[index]),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  getDate(next7Days[index]),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : Text('Something went wrong!'),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              // ignore: unnecessary_null_comparison
              child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${appointmentData[index]['appointment_date']}',
                                          style: TextStyle(color: Colors.white),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${appointmentData[index]['appointment_status']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ]),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Patient's Name: ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${appointmentData[index]['patient_name']}',
                                          style: TextStyle(color: Colors.white),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${appointmentData[index]['treatment_name']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ]),
                      );
                    })
                : Center(child: Text('no data')),
          ))
        ],
      ),
      drawer: NavDrawer(),
    );
  }
}
