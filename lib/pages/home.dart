// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dental/components/drawer.dart';
import 'package:dental/pages/notification.dart';
import 'package:dental/services/appointment.service.dart';
import 'package:dental/services/notification.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:session_storage/session_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final session = SessionStorage();
  Notificationservice notificationservice = Notificationservice();
  var notificationData = [];
  var dashboardData = [];
  var appointmentData = [];
  var next7Days = [];
  String selectedDay = '';

  @override
  void initState() {
    super.initState();

    checkPermission();

    if (session['showNotification'] == null) {
      getNotifications();

      showNotification();
      session['showNotification'] = 'shown';
    }

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
      // Request notificatio    getAppointmentData();n permission
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

  String dateConverter(date) {
    String dateString = date;
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object as "MMM d, y" (e.g., "Jun 1, 2024")
    String formattedDate = DateFormat('MMM d, y').format(dateTime);
    return formattedDate;
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
        backgroundColor: Color(0xFF368793),
        title: Center(
          child: SvgPicture.asset(
            'assets/app-logo.svg',
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6,
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  'Welcome, Dr.Nischal Shrestha',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                )),
            Card(
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Color(0xFF368793)),
                            child: Icon(
                              Icons.calendar_month,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '10',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Color(0xFF368793)),
                            child: Icon(
                              Icons.calendar_month,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '10',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Completed',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Color(0xFF368793)),
                            child: Icon(
                              Icons.calendar_month,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '10',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                )),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "This Week's",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              height: 65,
              child: next7Days.length > 0
                  ? ListView.builder(
                      itemCount: next7Days.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setSelectedDay(next7Days[index]),
                          child: Container(
                            // color: selectedDay == next7Days[index]
                            //     ? Color(0xFF368793)
                            //     : Colors.black,
                            margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
                            width: 100,
                            decoration: BoxDecoration(
                                color: selectedDay == next7Days[index]
                                    ? Color(0xFF368793)
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                border: Border.all(
                                    color: Color(0xFF368793), width: 1)),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    index == 0
                                        ? 'Today'
                                        : getDay(next7Days[index]),
                                    style: TextStyle(
                                        color: selectedDay == next7Days[index]
                                            ? Colors.white
                                            : Color(0xFF368793),
                                        fontSize: 13),
                                  ),
                                  Text(
                                    getDate(next7Days[index]),
                                    style: TextStyle(
                                        color: selectedDay == next7Days[index]
                                            ? Colors.white
                                            : Color(0xFF368793),
                                        fontSize: 16),
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
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Time",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            appointmentData.length > 0
                ? Expanded(
                    // ignore: unnecessary_null_comparison
                    child: Container(
                    child: appointmentData != null
                        ? ListView.builder(
                            itemCount: appointmentData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: 120,
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
                                            Text(
                                              appointmentData[index]
                                                  ['doctor_name'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      33, 82, 90, 1)),
                                              softWrap: true,
                                            ),
                                            Text(
                                              dateConverter(
                                                  appointmentData[index]
                                                      ['appointment_date']),
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            Text(
                                              '${timeConverter(appointmentData[index]['start_time'])} - ${timeConverter(appointmentData[index]['end_time'])}',
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
                                            Text(
                                              appointmentData[index]
                                                  ['patient_name'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      5, 5, 5, 1)),
                                            ),
                                            Text(
                                              'Problem:',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            Text(
                                                appointmentData[index]
                                                    ['chief_problem'],
                                                style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            })
                        : Center(child: Text('no data')),
                  ))
                : Container(
                    height: 200,
                    child: Center(child: Text("No Appointments to Display")))
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
