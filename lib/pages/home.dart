// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dental/components/drawer.dart';
import 'package:dental/services/dashboard.service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dashboardData;
  final DashboardService dashboardService = DashboardService();

  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  getDashboardData() async {
    var data = await dashboardService.getDashboardData() ?? {};
    setState(() {
      dashboardData = data;
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
      body: Container(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
                color: Colors.orange,
                width: 100,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '2024-2-2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Container(
                color: Colors.black,
                width: 100,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '2024-2-2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Container(
                color: Colors.black,
                width: 100,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '2024-2-2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Container(
                color: Colors.black,
                width: 100,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '2024-2-2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Container(
                color: Colors.black,
                width: 100,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '2024-2-2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Container(
                color: Colors.black,
                width: 100,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '2024-2-2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            Container(
                color: Colors.black,
                width: 100,
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '2024-2-2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
