import 'package:dental/components/drawer.dart';
import 'package:dental/services/notification.service.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notificationData = [];

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  void getNotifications() async {
    var data = await Notificationservice().getNotifications() ?? {};
    setState(() {
      notificationData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: const Text(
          'Dashboard',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: notificationData.length == 0
            ? Text('No New Notification')
            : Text('data'),
      ),
      drawer: NavDrawer(),
    );
  }
}
