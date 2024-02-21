// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:dental/pages/calendar.dart';
import 'package:dental/pages/notification.dart';
import 'package:dental/pages/patients.dart';
import 'package:dental/pages/resetpassword.dart';
import 'package:dental/services/drawer.service.dart';
import 'dart:typed_data';
import 'package:dental/pages/appointment.dart';
import 'package:dental/services/auth.service.dart';
import 'package:flutter/material.dart';
import 'package:dental/pages/login.dart';
import 'package:dental/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final AuthService authService = AuthService();
  var activeUser;
  var image;

  @override
  void initState() {
    super.initState();
    getActiveUser();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('userList') ?? [];

    int? activeUserIndex;
    for (int i = 0; i < userList.length; i++) {
      Map<String, dynamic> userInfo = jsonDecode(userList[i]);
      if (userInfo['active'] == true) {
        activeUserIndex = i;
        break;
      }
    }
    if (activeUserIndex != null) {
      userList.removeAt(activeUserIndex);
      prefs.setStringList('userList', userList);
    }

    prefs.remove('userList');
  }

  getActiveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('userList') ?? [];
    var user;
    for (String userInfoString in userList) {
      Map<String, dynamic> userInfo = jsonDecode(userInfoString);
      if (userInfo['active'] == true) {
        user = userInfo;
        break;
      }
    }
    setState(() {
      activeUser = user;
    });
  }

  getUserImage() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: 200,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: FutureBuilder<Uint8List>(
                          future: DrawerService()
                              .fetchBlobImage(activeUser['userId']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('loading');
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return ClipOval(
                                  child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons
                                        .image, // Display Icon if image is not available
                                    color: Colors.grey,
                                  );
                                },
                              ));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      activeUser != null
                          ? '${activeUser['name']}'
                          : '', // User name
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.home),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarPage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Calendar",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentPage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Appointment",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.notifications_active),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Notifications",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PatientPage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.personal_injury),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Patients",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 300),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordPage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.password),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text("Home"),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => HomePage()),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.calendar_month),
            //   title: Text("Appointment"),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => AppointmentPage()),
            //     );
            //     // getUserImage();
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.notifications_active),
            //   title: Text("Notification"),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => NotificationPage()),
            //     );
            //     // getUserImage();
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.personal_injury),
            //   title: Text("Patients"),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => PatientPage()),
            //     );
            //     // getUserImage();
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.login),
            //   title: Text("Logout"),
            //   onTap: () {
            //     logout();
            //     // Navigator.pop(context);
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(builder: (context) => LoginPage()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
