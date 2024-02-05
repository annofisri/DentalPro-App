import 'package:dental/components/drawer.dart';
import 'package:dental/services/appointment.service.dart';
import 'package:dental/services/calendar.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String eventName;

  Event(this.eventName);
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var monthAppointmentData = [];
  var fromDate = '';
  var toDate = '';
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {};

  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  // Map<DateTime, List<Event>> events = {
  //   DateTime.parse('2024-02-17 00:00:00.000Z').toUtc(): [
  //     Event("Meeting 1"),
  //     Event("Meeting 2")
  //   ],
  //   DateTime.parse('2024-02-18 00:00:00.000Z').toUtc(): [Event("Meeting 3")],
  // };
  TextEditingController dateInput = TextEditingController();
  @override
  void initState() {
    super.initState();
    fromDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1));

    toDate = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0));

    getMonthAppointmentData();
  }

  getMonthAppointmentData() async {
    var data = await CalendarService().getAppointmentData(fromDate, toDate);
    if (data != null) {
      setState(() {
        monthAppointmentData = data['content'];
        getEvents();
      });
    }
  }

  getEvents() {
    this.monthAppointmentData.forEach((appointment) {
      DateTime date =
          DateTime.parse('${appointment['appointment_date']} 00:00:00.000Z')
              .toUtc();
      events[date] = [Event("${appointment['appointment_status']}")];
    });
  }

  getAppointmentsForTheDay() async {
    var tempDay = DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(_selectedDay.toString()));
    var data = await AppointmentService().getAppointmentData(tempDay);
    print(data);
  }

  List<Event> _getEventsForDay(DateTime day) {
    // print("Events for $day: ${events[day]}");
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(54, 135, 147, 1),
        title: Text(
          'Calendar',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
                color: Color.fromRGBO(54, 135, 147, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: TableCalendar(
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.black),
                weekNumberTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                    color: Colors
                        .white70, // Set the color of the today date background
                    shape: BoxShape
                        .circle // You can use other shapes like BoxShape.rectangle
                    ),
                selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  // or use any shape you prefer
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Colors.white, // Set the color of the month text
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white)),
              selectedDayPredicate: (DateTime date) {
                return isSameDay(_selectedDay, date);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  getAppointmentsForTheDay();
                });
              },
            ),
          ),
        ],
      ),
      drawer: NavDrawer(),
    );
  }
}
