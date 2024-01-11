// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dental/components/drawer.dart';
import 'package:dental/services/dashboard.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dashboardData;
  List<String> next7Days = [];
  String selectedDay = '';

  @override
  void initState() {
    super.initState();

    getNext7DaysFormatted();
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
    print(next7Days);
    print('7days');
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
        child: next7Days.length > 0
            ? ListView.builder(
                itemCount: next7Days.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      color: selectedDay == next7Days[index]
                          ? Colors.orange
                          : Colors.black,
                      width: 100,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          next7Days[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                })
            : Text('Something went wrong!'),
      ),
      drawer: NavDrawer(),
    );
  }
}
